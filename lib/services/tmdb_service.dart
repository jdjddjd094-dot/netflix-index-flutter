import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/movie.dart';
import '../models/tv_show.dart';

class TMDBService {
  static const String _baseUrl = AppConstants.tmdbBaseUrl;
  static const String _accessToken = AppConstants.tmdbAccessToken;

  static Map<String, String> get _headers => {
    'Authorization': 'Bearer $_accessToken',
    'Content-Type': 'application/json',
  };

  // Movies
  static Future<List<Movie>> getPopularMovies({String language = 'ar', int page = 1}) async {
    return _getMovies('movie/popular', language: language, page: page);
  }

  static Future<List<Movie>> getTopRatedMovies({String language = 'ar', int page = 1}) async {
    return _getMovies('movie/top_rated', language: language, page: page);
  }

  static Future<List<Movie>> getNowPlayingMovies({String language = 'ar', int page = 1}) async {
    return _getMovies('movie/now_playing', language: language, page: page);
  }

  static Future<List<Movie>> getUpcomingMovies({String language = 'ar', int page = 1}) async {
    return _getMovies('movie/upcoming', language: language, page: page);
  }

  static Future<List<Movie>> searchMovies(String query, {String language = 'ar', int page = 1}) async {
    return _getMovies('search/movie', language: language, page: page, query: query);
  }

  static Future<Movie?> getMovieDetails(int movieId, {String language = 'ar'}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/$movieId?language=$language'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Movie.fromJson(data);
      }
    } catch (e) {
      print('Error getting movie details: $e');
    }
    return null;
  }

  // TV Shows
  static Future<List<TvShow>> getPopularTvShows({String language = 'ar', int page = 1}) async {
    return _getTvShows('tv/popular', language: language, page: page);
  }

  static Future<List<TvShow>> getTopRatedTvShows({String language = 'ar', int page = 1}) async {
    return _getTvShows('tv/top_rated', language: language, page: page);
  }

  static Future<List<TvShow>> getOnTheAirTvShows({String language = 'ar', int page = 1}) async {
    return _getTvShows('tv/on_the_air', language: language, page: page);
  }

  static Future<List<TvShow>> getAiringTodayTvShows({String language = 'ar', int page = 1}) async {
    return _getTvShows('tv/airing_today', language: language, page: page);
  }

  static Future<List<TvShow>> searchTvShows(String query, {String language = 'ar', int page = 1}) async {
    return _getTvShows('search/tv', language: language, page: page, query: query);
  }

  static Future<TvShow?> getTvShowDetails(int tvId, {String language = 'ar'}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/tv/$tvId?language=$language'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return TvShow.fromJson(data);
      }
    } catch (e) {
      print('Error getting TV show details: $e');
    }
    return null;
  }

  // Trending
  static Future<List<Movie>> getTrendingMovies({String language = 'ar', String timeWindow = 'day'}) async {
    return _getMovies('trending/movie/$timeWindow', language: language);
  }

  static Future<List<TvShow>> getTrendingTvShows({String language = 'ar', String timeWindow = 'day'}) async {
    return _getTvShows('trending/tv/$timeWindow', language: language);
  }

  // Private helper methods
  static Future<List<Movie>> _getMovies(String endpoint, {String language = 'ar', int page = 1, String? query}) async {
    try {
      String url = '$_baseUrl/$endpoint?language=$language&page=$page';
      if (query != null && query.isNotEmpty) {
        url += '&query=${Uri.encodeComponent(query)}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        return results.map((json) => Movie.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error getting movies from $endpoint: $e');
    }
    return [];
  }

  static Future<List<TvShow>> _getTvShows(String endpoint, {String language = 'ar', int page = 1, String? query}) async {
    try {
      String url = '$_baseUrl/$endpoint?language=$language&page=$page';
      if (query != null && query.isNotEmpty) {
        url += '&query=${Uri.encodeComponent(query)}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        return results.map((json) => TvShow.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error getting TV shows from $endpoint: $e');
    }
    return [];
  }

  // Get fallback data in English if Arabic is not available
  static Future<List<Movie>> getMoviesWithFallback(String endpoint, {String primaryLanguage = 'ar', int page = 1}) async {
    List<Movie> movies = await _getMovies(endpoint, language: primaryLanguage, page: page);
    
    // If no results in primary language, try English
    if (movies.isEmpty && primaryLanguage != 'en') {
      movies = await _getMovies(endpoint, language: 'en', page: page);
    }
    
    return movies;
  }

  static Future<List<TvShow>> getTvShowsWithFallback(String endpoint, {String primaryLanguage = 'ar', int page = 1}) async {
    List<TvShow> tvShows = await _getTvShows(endpoint, language: primaryLanguage, page: page);
    
    // If no results in primary language, try English
    if (tvShows.isEmpty && primaryLanguage != 'en') {
      tvShows = await _getTvShows(endpoint, language: 'en', page: page);
    }
    
    return tvShows;
  }
}