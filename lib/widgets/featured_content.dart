import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../providers/content_provider.dart';
import '../models/movie.dart';
import '../models/tv_show.dart';
import '../screens/video/video_player_screen.dart';

class FeaturedContent extends StatelessWidget {
  const FeaturedContent({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Consumer<ContentProvider>(
      builder: (context, contentProvider, child) {
        final featuredItems = contentProvider.featuredContent;
        
        if (featuredItems.isEmpty) {
          return const SizedBox(
            height: 400,
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.netflixRed,
              ),
            ),
          );
        }

        return SizedBox(
          height: 500,
          child: PageView.builder(
            itemCount: featuredItems.length,
            itemBuilder: (context, index) {
              final item = featuredItems[index];
              return _buildFeaturedItem(context, item, localizations);
            },
          ),
        );
      },
    );
  }

  Widget _buildFeaturedItem(BuildContext context, dynamic item, AppLocalizations localizations) {
    final isMovie = item is Movie;
    final title = isMovie ? (item as Movie).title : (item as TvShow).name;
    final overview = isMovie ? (item as Movie).overview : (item as TvShow).overview;
    final backdropPath = isMovie ? (item as Movie).fullBackdropPath : (item as TvShow).fullBackdropPath;
    final id = isMovie ? (item as Movie).id : (item as TvShow).id;

    return Container(
      width: double.infinity,
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: backdropPath,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.netflixDarkGray,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.netflixRed,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.netflixDarkGray,
                child: const Icon(
                  Icons.error,
                  color: AppColors.netflixGray,
                  size: 50,
                ),
              ),
            ),
          ),
          
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Color(0x80000000),
                    Color(0xFF000000),
                  ],
                  stops: [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),
          
          // Content
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.netflixWhite,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                // Overview
                if (overview.isNotEmpty)
                  Text(
                    overview,
                    style: const TextStyle(
                      color: AppColors.netflixWhite,
                      fontSize: 14,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                
                const SizedBox(height: 20),
                
                // Action Buttons
                Row(
                  children: [
                    // Play Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _playContent(context, id, isMovie ? 'movie' : 'tv'),
                        icon: const Icon(
                          Icons.play_arrow,
                          color: AppColors.netflixBlack,
                        ),
                        label: Text(
                          localizations.play,
                          style: const TextStyle(
                            color: AppColors.netflixBlack,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.netflixWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Add to List Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _addToList(context, id, isMovie ? 'movie' : 'tv'),
                        icon: const Icon(
                          Icons.add,
                          color: AppColors.netflixWhite,
                        ),
                        label: Text(
                          localizations.addToList,
                          style: const TextStyle(
                            color: AppColors.netflixWhite,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.netflixGray,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _playContent(BuildContext context, int id, String type) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          contentId: id,
          contentType: type,
        ),
      ),
    );
  }

  void _addToList(BuildContext context, int id, String type) {
    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    // This would require auth provider to get user ID
    // For now, we'll show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.addedToFavorites),
        backgroundColor: AppColors.netflixRed,
      ),
    );
  }
}