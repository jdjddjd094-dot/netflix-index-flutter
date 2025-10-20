class AppConstants {
  // TMDB API
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String tmdbOriginalImageBaseUrl = 'https://image.tmdb.org/t/p/original';
  static const String tmdbAccessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjYTc2MDk3MTlhNTYxYjM0MWM4MDYyYzMzN2FiZTM5NyIsIm5iZiI6MTc0NDI5MzUwOC4xMDQsInN1YiI6IjY3ZjdjZTg0MzE3NzUyNzZkNmQ5OTM4OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.jB-LdCFKnX7xETXv3UgAHXffgoCOFK9wfyr6Z8y4AzI';
  
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