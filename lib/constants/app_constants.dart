class AppConstants {
  // TMDB API
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String tmdbOriginalImageBaseUrl = 'https://image.tmdb.org/t/p/original';
  static const String tmdbAccessToken = 'YOUR_TMDB_ACCESS_TOKEN_HEAR';
  
  // SuperEmbed
  static const String superEmbedBaseUrl = 'https://multiembed.mov';
  static const String superEmbedVipUrl = 'https://multiembed.mov/directstream.php';
  
  // Netflix Colors
  static const int netflixRedValue = 0xFFE50914;
  static const int netflixBlackValue = 0xFF000000;
  static const int netflixDarkGrayValue = 0xFF141414;
  static const int netflixGrayValue = 0xFF564D4D;
  static const int netflixLightGrayValue = 0xFF808080;
  static const int netflixWhiteValue = 0xFFFFFFFF;
  
  // App Info
  static const String appName = 'Netflix';
  static const String appVersion = '1.0.0';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String favoritesCollection = 'favorites';
  static const String watchHistoryCollection = 'watch_history';
  static const String continueWatchingCollection = 'continue_watching';
  
  // Shared Preferences Keys
  static const String languageKey = 'language';
  static const String isGuestKey = 'is_guest';
  static const String userIdKey = 'user_id';
  
  // Languages
  static const String arabicLanguageCode = 'ar';
  static const String englishLanguageCode = 'en';
  
  // Movie Categories
  static const String popularMovies = 'popular';
  static const String topRatedMovies = 'top_rated';
  static const String nowPlayingMovies = 'now_playing';
  static const String upcomingMovies = 'upcoming';
  
  // TV Categories
  static const String popularTv = 'popular';
  static const String topRatedTv = 'top_rated';
  static const String onTheAirTv = 'on_the_air';
  static const String airingTodayTv = 'airing_today';
}
