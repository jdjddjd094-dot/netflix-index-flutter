import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/content_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/content_grid.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _currentQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.netflixBlack,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            _buildSearchBar(localizations),
            
            // Search Results
            Expanded(
              child: _buildSearchResults(localizations),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: AppColors.netflixWhite),
        decoration: InputDecoration(
          hintText: localizations.searchHint,
          hintStyle: const TextStyle(color: AppColors.netflixGray),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.netflixGray,
          ),
          suffixIcon: _currentQuery.isNotEmpty
              ? IconButton(
                  onPressed: _clearSearch,
                  icon: const Icon(
                    Icons.clear,
                    color: AppColors.netflixGray,
                  ),
                )
              : null,
          filled: true,
          fillColor: AppColors.netflixDarkGray,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: _onSearchChanged,
        onSubmitted: _onSearchSubmitted,
      ),
    );
  }

  Widget _buildSearchResults(AppLocalizations localizations) {
    return Consumer<ContentProvider>(
      builder: (context, contentProvider, child) {
        if (_currentQuery.isEmpty) {
          return _buildPopularContent(localizations, contentProvider);
        }

        if (contentProvider.isLoadingSearch) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.netflixRed,
            ),
          );
        }

        final movieResults = contentProvider.searchMovieResults;
        final tvResults = contentProvider.searchTvResults;

        if (movieResults.isEmpty && tvResults.isEmpty) {
          return _buildNoResults(localizations);
        }

        return _buildSearchResultsList(localizations, movieResults, tvResults);
      },
    );
  }

  Widget _buildPopularContent(AppLocalizations localizations, ContentProvider contentProvider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              localizations.popularMovies,
              style: const TextStyle(
                color: AppColors.netflixWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ContentGrid(
            items: contentProvider.popularMovies
                .take(20)
                .map((movie) => movie.toJson()..['type'] = 'movie')
                .toList(),
          ),
          
          const SizedBox(height: 20),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              localizations.popularTvShows,
              style: const TextStyle(
                color: AppColors.netflixWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ContentGrid(
            items: contentProvider.popularTvShows
                .take(20)
                .map((show) => show.toJson()..['type'] = 'tv')
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultsList(AppLocalizations localizations, List movieResults, List tvResults) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (movieResults.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                '${localizations.popularMovies} (${movieResults.length})',
                style: const TextStyle(
                  color: AppColors.netflixWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ContentGrid(
              items: movieResults
                  .map((movie) => movie.toJson()..['type'] = 'movie')
                  .cast<Map<String, dynamic>>()
                  .toList(),
            ),
          ],
          
          if (tvResults.isNotEmpty) ...[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                '${localizations.popularTvShows} (${tvResults.length})',
                style: const TextStyle(
                  color: AppColors.netflixWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ContentGrid(
              items: tvResults
                  .map((show) => show.toJson()..['type'] = 'tv')
                  .cast<Map<String, dynamic>>()
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNoResults(AppLocalizations localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 80,
            color: AppColors.netflixGray,
          ),
          const SizedBox(height: 16),
          Text(
            localizations.noResults,
            style: const TextStyle(
              color: AppColors.netflixGray,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching for "$_currentQuery"',
            style: const TextStyle(
              color: AppColors.netflixLightGray,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _currentQuery = query;
    });

    if (query.trim().isEmpty) {
      final contentProvider = Provider.of<ContentProvider>(context, listen: false);
      contentProvider.clearSearchResults();
      return;
    }

    // Debounce search
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_currentQuery == query && query.trim().isNotEmpty) {
        _performSearch(query);
      }
    });
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isNotEmpty) {
      _performSearch(query);
    }
  }

  void _performSearch(String query) {
    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    contentProvider.searchContent(query, language: authProvider.language);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _currentQuery = '';
    });
    
    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    contentProvider.clearSearchResults();
  }
}