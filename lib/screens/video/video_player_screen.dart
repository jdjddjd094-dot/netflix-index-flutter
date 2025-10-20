import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../services/video_service.dart';
import '../../providers/auth_provider.dart';
import '../../providers/content_provider.dart';
import '../../models/watch_history.dart';
import '../../services/firestore_service.dart';

class VideoPlayerScreen extends StatefulWidget {
  final int contentId;
  final String contentType;
  final String? title;
  final int? seasonNumber;
  final int? episodeNumber;

  const VideoPlayerScreen({
    super.key,
    required this.contentId,
    required this.contentType,
    this.title,
    this.seasonNumber,
    this.episodeNumber,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late WebViewController _webViewController;
  bool _isLoading = true;
  bool _hasError = false;
  String _streamUrl = '';
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _startTime = DateTime.now();
  }

  Future<void> _initializePlayer() async {
    try {
      if (widget.contentType == 'tv' && 
          widget.seasonNumber != null && 
          widget.episodeNumber != null) {
        _streamUrl = await VideoService.getBestStreamUrl(
          widget.contentId,
          season: widget.seasonNumber,
          episode: widget.episodeNumber,
        );
      } else {
        _streamUrl = await VideoService.getBestStreamUrl(widget.contentId);
      }

      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
            },
            onPageFinished: (String url) {
              setState(() {
                _isLoading = false;
              });
            },
            onWebResourceError: (WebResourceError error) {
              setState(() {
                _hasError = true;
                _isLoading = false;
              });
            },
          ),
        )
        ..loadRequest(Uri.parse(_streamUrl));

    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _updateWatchHistory();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  Future<void> _updateWatchHistory() async {
    if (_startTime == null) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    
    if (user == null || user.isGuest) return;

    try {
      final watchDuration = DateTime.now().difference(_startTime!).inSeconds;
      
      if (watchDuration < 30) return; // Don't save if watched less than 30 seconds

      final historyId = FirestoreService.createWatchHistoryId(
        user.id,
        widget.contentId,
        widget.contentType,
        seasonNumber: widget.seasonNumber,
        episodeNumber: widget.episodeNumber,
      );

      final watchHistory = WatchHistory(
        id: historyId,
        userId: user.id,
        contentId: widget.contentId,
        contentType: widget.contentType,
        title: widget.title ?? '',
        posterPath: null, // Would need to get this from content details
        watchedDuration: watchDuration,
        totalDuration: 7200, // Default 2 hours, would need actual duration
        lastWatchedAt: DateTime.now(),
        seasonNumber: widget.seasonNumber,
        episodeNumber: widget.episodeNumber,
      );

      final contentProvider = Provider.of<ContentProvider>(context, listen: false);
      await contentProvider.updateWatchHistory(watchHistory);
    } catch (e) {
      print('Error updating watch history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.netflixBlack,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(localizations),
            
            // Video Player
            Expanded(
              child: _buildVideoPlayer(localizations),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.netflixWhite,
            ),
          ),
          Expanded(
            child: Text(
              widget.title ?? localizations.play,
              style: const TextStyle(
                color: AppColors.netflixWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: _toggleFullscreen,
            icon: const Icon(
              Icons.fullscreen,
              color: AppColors.netflixWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer(AppLocalizations localizations) {
    if (_hasError) {
      return _buildErrorWidget(localizations);
    }

    return Stack(
      children: [
        // WebView Player
        WebViewWidget(controller: _webViewController),
        
        // Loading Indicator
        if (_isLoading)
          Container(
            color: AppColors.netflixBlack,
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.netflixRed,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildErrorWidget(AppLocalizations localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 80,
            color: AppColors.netflixGray,
          ),
          const SizedBox(height: 16),
          Text(
            localizations.error,
            style: const TextStyle(
              color: AppColors.netflixWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Failed to load video content',
            style: const TextStyle(
              color: AppColors.netflixGray,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _hasError = false;
                _isLoading = true;
              });
              _initializePlayer();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.netflixRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              localizations.retry,
              style: const TextStyle(
                color: AppColors.netflixWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFullscreen() {
    // Toggle orientation for fullscreen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}