import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/tv_show.dart';
import '../models/watch_history.dart';
import '../services/tmdb_service.dart';
import '../services/firestore_service.dart';

class ContentProvider with ChangeNotifier {
  // Movies
  List<Movie> _popularMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _nowPlayingMovies = [];
  List<Movie> _upcomingMovies = [];
  List<Movie> _trendingMovies = [];

  // TV Shows
  List<TvShow> _popularTvShows = [];
  List<TvShow> _topRatedTvShows = [];
  List<TvShow> _onTheAirTvShows = [];
  List<TvShow> _airingTodayTvShows = [];
  List<TvShow> _trendingTvShows = [];

  // Search
  List<Movie> _searchMovieResults = [];
  List<TvShow> _searchTvResults = [];

  // Watch History
  List<WatchHistory> _continueWatching = [];
  List<WatchHistory> _watchHistory = [];

  // Favorites
  List<int> _favoriteMovies = [];
  List<int> _favoriteTvShows = [];

  // Loading states
  bool _isLoadingMovies = false;
  bool _isLoadingTvShows = false;
  bool _isLoadingSearch = false;
  bool _isLoadingWatchHistory = false;
  bool _isLoadingFavorites = false;

  // Getters
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get topRatedMovies => _topRatedMovies;
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;
  List<Movie> get upcomingMovies => _upcomingMovies;
  List<Movie> get trendingMovies => _trendingMovies;

  List<TvShow> get popularTvShows => _popularTvShows;
  List<TvShow> get topRatedTvShows => _topRatedTvShows;
  List<TvShow> get onTheAirTvShows => _onTheAirTvShows;
  List<TvShow> get airingTodayTvShows => _airingTodayTvShows;
  List<TvShow> get trendingTvShows => _trendingTvShows;

  List<Movie> get searchMovieResults => _searchMovieResults;
  List<TvShow> get searchTvResults => _searchTvResults;

  List<WatchHistory> get continueWatching => _continueWatching;
  List<WatchHistory> get watchHistory => _watchHistory;

  List<int> get favoriteMovies => _favoriteMovies;
  List<int> get favoriteTvShows => _favoriteTvShows;

  bool get isLoadingMovies => _isLoadingMovies;
  bool get isLoadingTvShows => _isLoadingTvShows;
  bool get isLoadingSearch => _isLoadingSearch;
  bool get isLoadingWatchHistory => _isLoadingWatchHistory;
  bool get isLoadingFavorites => _isLoadingFavorites;

  // Load all content
  Future<void> loadAllContent({String language = 'ar'}) async {
    await Future.wait([
      loadMovies(language: language),
      loadTvShows(language: language),
    ]);
  }

  // Load movies
  Future<void> loadMovies({String language = 'ar'}) async {
    _isLoadingMovies = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        TMDBService.getMoviesWithFallback('movie/popular', primaryLanguage: language),
        TMDBService.getMoviesWithFallback('movie/top_rated', primaryLanguage: language),
        TMDBService.getMoviesWithFallback('movie/now_playing', primaryLanguage: language),
        TMDBService.getMoviesWithFallback('movie/upcoming', primaryLanguage: language),
        TMDBService.getTrendingMovies(language: language),
      ]);

      _popularMovies = results[0];
      _topRatedMovies = results[1];
      _nowPlayingMovies = results[2];
      _upcomingMovies = results[3];
      _trendingMovies = results[4];
    } catch (e) {
      print('Error loading movies: $e');
    }

    _isLoadingMovies = false;
    notifyListeners();
  }

  // Load TV shows
  Future<void> loadTvShows({String language = 'ar'}) async {
    _isLoadingTvShows = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        TMDBService.getTvShowsWithFallback('tv/popular', primaryLanguage: language),
        TMDBService.getTvShowsWithFallback('tv/top_rated', primaryLanguage: language),
        TMDBService.getTvShowsWithFallback('tv/on_the_air', primaryLanguage: language),
        TMDBService.getTvShowsWithFallback('tv/airing_today', primaryLanguage: language),
        TMDBService.getTrendingTvShows(language: language),
      ]);

      _popularTvShows = results[0];
      _topRatedTvShows = results[1];
      _onTheAirTvShows = results[2];
      _airingTodayTvShows = results[3];
      _trendingTvShows = results[4];
    } catch (e) {
      print('Error loading TV shows: $e');
    }

    _isLoadingTvShows = false;
    notifyListeners();
  }

  // Search content
  Future<void> searchContent(String query, {String language = 'ar'}) async {
    if (query.trim().isEmpty) {
      _searchMovieResults = [];
      _searchTvResults = [];
      notifyListeners();
      return;
    }

    _isLoadingSearch = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        TMDBService.searchMovies(query, language: language),
        TMDBService.searchTvShows(query, language: language),
      ]);

      _searchMovieResults = results[0] as List<Movie>;
      _searchTvResults = results[1] as List<TvShow>;
    } catch (e) {
      print('Error searching content: $e');
    }

    _isLoadingSearch = false;
    notifyListeners();
  }

  // Clear search results
  void clearSearchResults() {
    _searchMovieResults = [];
    _searchTvResults = [];
    notifyListeners();
  }

  // Load user-specific data
  Future<void> loadUserData(String userId) async {
    await Future.wait([
      loadWatchHistory(userId),
      loadFavorites(userId),
    ]);
  }

  // Load watch history
  Future<void> loadWatchHistory(String userId) async {
    _isLoadingWatchHistory = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        FirestoreService.getContinueWatching(userId),
        FirestoreService.getWatchHistory(userId),
      ]);

      _continueWatching = results[0];
      _watchHistory = results[1];
    } catch (e) {
      print('Error loading watch history: $e');
    }

    _isLoadingWatchHistory = false;
    notifyListeners();
  }

  // Load favorites
  Future<void> loadFavorites(String userId) async {
    _isLoadingFavorites = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        FirestoreService.getFavoriteMovies(userId),
        FirestoreService.getFavoriteTvShows(userId),
      ]);

      _favoriteMovies = results[0];
      _favoriteTvShows = results[1];
    } catch (e) {
      print('Error loading favorites: $e');
    }

    _isLoadingFavorites = false;
    notifyListeners();
  }

  // Add to favorites
  Future<void> addToFavorites(String userId, int contentId, String contentType) async {
    try {
      await FirestoreService.addToFavorites(userId, contentId, contentType);
      
      if (contentType == 'movie') {
        _favoriteMovies.add(contentId);
      } else if (contentType == 'tv') {
        _favoriteTvShows.add(contentId);
      }
      
      notifyListeners();
    } catch (e) {
      print('Error adding to favorites: $e');
    }
  }

  // Remove from favorites
  Future<void> removeFromFavorites(String userId, int contentId, String contentType) async {
    try {
      await FirestoreService.removeFromFavorites(userId, contentId, contentType);
      
      if (contentType == 'movie') {
        _favoriteMovies.remove(contentId);
      } else if (contentType == 'tv') {
        _favoriteTvShows.remove(contentId);
      }
      
      notifyListeners();
    } catch (e) {
      print('Error removing from favorites: $e');
    }
  }

  // Check if content is favorite
  bool isFavorite(int contentId, String contentType) {
    if (contentType == 'movie') {
      return _favoriteMovies.contains(contentId);
    } else if (contentType == 'tv') {
      return _favoriteTvShows.contains(contentId);
    }
    return false;
  }

  // Update watch history
  Future<void> updateWatchHistory(WatchHistory watchHistory) async {
    try {
      await FirestoreService.updateWatchHistory(watchHistory);
      
      // Update local lists
      final existingIndex = _continueWatching.indexWhere((item) => item.id == watchHistory.id);
      if (existingIndex != -1) {
        _continueWatching[existingIndex] = watchHistory;
      } else {
        _continueWatching.insert(0, watchHistory);
      }

      final historyIndex = _watchHistory.indexWhere((item) => item.id == watchHistory.id);
      if (historyIndex != -1) {
        _watchHistory[historyIndex] = watchHistory;
      } else {
        _watchHistory.insert(0, watchHistory);
      }

      notifyListeners();
    } catch (e) {
      print('Error updating watch history: $e');
    }
  }

  // Get featured content (trending movies and TV shows combined)
  List<dynamic> get featuredContent {
    final List<dynamic> featured = [];
    featured.addAll(_trendingMovies.take(5));
    featured.addAll(_trendingTvShows.take(5));
    featured.shuffle();
    return featured.take(10).toList();
  }
}