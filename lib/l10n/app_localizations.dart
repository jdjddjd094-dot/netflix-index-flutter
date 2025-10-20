import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('ar'),
    Locale('en'),
  ];

  // App Name
  String get appName => locale.languageCode == 'ar' ? 'نتفليكس' : 'Netflix';

  // Authentication
  String get signInWithGoogle => locale.languageCode == 'ar' ? 'تسجيل الدخول بـ Google' : 'Sign in with Google';
  String get continueAsGuest => locale.languageCode == 'ar' ? 'المتابعة كضيف' : 'Continue as Guest';
  String get signOut => locale.languageCode == 'ar' ? 'تسجيل الخروج' : 'Sign Out';
  String get welcome => locale.languageCode == 'ar' ? 'مرحباً' : 'Welcome';

  // Navigation
  String get home => locale.languageCode == 'ar' ? 'الرئيسية' : 'Home';
  String get search => locale.languageCode == 'ar' ? 'البحث' : 'Search';
  String get myList => locale.languageCode == 'ar' ? 'قائمتي' : 'My List';
  String get profile => locale.languageCode == 'ar' ? 'الملف الشخصي' : 'Profile';
  String get settings => locale.languageCode == 'ar' ? 'الإعدادات' : 'Settings';

  // Content Categories
  String get popularMovies => locale.languageCode == 'ar' ? 'الأفلام الشائعة' : 'Popular Movies';
  String get topRatedMovies => locale.languageCode == 'ar' ? 'الأفلام الأعلى تقييماً' : 'Top Rated Movies';
  String get nowPlayingMovies => locale.languageCode == 'ar' ? 'الأفلام الحالية' : 'Now Playing Movies';
  String get upcomingMovies => locale.languageCode == 'ar' ? 'الأفلام القادمة' : 'Upcoming Movies';
  String get trendingMovies => locale.languageCode == 'ar' ? 'الأفلام الرائجة' : 'Trending Movies';

  String get popularTvShows => locale.languageCode == 'ar' ? 'المسلسلات الشائعة' : 'Popular TV Shows';
  String get topRatedTvShows => locale.languageCode == 'ar' ? 'المسلسلات الأعلى تقييماً' : 'Top Rated TV Shows';
  String get onTheAirTvShows => locale.languageCode == 'ar' ? 'المسلسلات المعروضة' : 'On The Air TV Shows';
  String get airingTodayTvShows => locale.languageCode == 'ar' ? 'المسلسلات اليوم' : 'Airing Today TV Shows';
  String get trendingTvShows => locale.languageCode == 'ar' ? 'المسلسلات الرائجة' : 'Trending TV Shows';

  String get continueWatching => locale.languageCode == 'ar' ? 'متابعة المشاهدة' : 'Continue Watching';
  String get watchHistory => locale.languageCode == 'ar' ? 'سجل المشاهدة' : 'Watch History';
  String get favorites => locale.languageCode == 'ar' ? 'المفضلة' : 'Favorites';

  // Actions
  String get play => locale.languageCode == 'ar' ? 'تشغيل' : 'Play';
  String get addToList => locale.languageCode == 'ar' ? 'إضافة للقائمة' : 'Add to List';
  String get removeFromList => locale.languageCode == 'ar' ? 'إزالة من القائمة' : 'Remove from List';
  String get share => locale.languageCode == 'ar' ? 'مشاركة' : 'Share';
  String get download => locale.languageCode == 'ar' ? 'تحميل' : 'Download';
  String get watchTrailer => locale.languageCode == 'ar' ? 'مشاهدة الإعلان' : 'Watch Trailer';

  // Search
  String get searchHint => locale.languageCode == 'ar' ? 'البحث عن الأفلام والمسلسلات...' : 'Search movies and TV shows...';
  String get noResults => locale.languageCode == 'ar' ? 'لا توجد نتائج' : 'No results found';
  String get searchResults => locale.languageCode == 'ar' ? 'نتائج البحث' : 'Search Results';

  // Details
  String get overview => locale.languageCode == 'ar' ? 'نظرة عامة' : 'Overview';
  String get cast => locale.languageCode == 'ar' ? 'طاقم التمثيل' : 'Cast';
  String get director => locale.languageCode == 'ar' ? 'المخرج' : 'Director';
  String get genre => locale.languageCode == 'ar' ? 'النوع' : 'Genre';
  String get releaseDate => locale.languageCode == 'ar' ? 'تاريخ الإصدار' : 'Release Date';
  String get runtime => locale.languageCode == 'ar' ? 'مدة العرض' : 'Runtime';
  String get rating => locale.languageCode == 'ar' ? 'التقييم' : 'Rating';
  String get seasons => locale.languageCode == 'ar' ? 'المواسم' : 'Seasons';
  String get episodes => locale.languageCode == 'ar' ? 'الحلقات' : 'Episodes';

  // Settings
  String get language => locale.languageCode == 'ar' ? 'اللغة' : 'Language';
  String get arabic => locale.languageCode == 'ar' ? 'العربية' : 'Arabic';
  String get english => locale.languageCode == 'ar' ? 'الإنجليزية' : 'English';
  String get notifications => locale.languageCode == 'ar' ? 'الإشعارات' : 'Notifications';
  String get privacy => locale.languageCode == 'ar' ? 'الخصوصية' : 'Privacy';
  String get about => locale.languageCode == 'ar' ? 'حول التطبيق' : 'About';

  // Messages
  String get loading => locale.languageCode == 'ar' ? 'جاري التحميل...' : 'Loading...';
  String get error => locale.languageCode == 'ar' ? 'حدث خطأ' : 'An error occurred';
  String get retry => locale.languageCode == 'ar' ? 'إعادة المحاولة' : 'Retry';
  String get noInternetConnection => locale.languageCode == 'ar' ? 'لا يوجد اتصال بالإنترنت' : 'No internet connection';
  String get addedToFavorites => locale.languageCode == 'ar' ? 'تمت الإضافة للمفضلة' : 'Added to favorites';
  String get removedFromFavorites => locale.languageCode == 'ar' ? 'تمت الإزالة من المفضلة' : 'Removed from favorites';

  // Time
  String get minutes => locale.languageCode == 'ar' ? 'دقيقة' : 'minutes';
  String get hours => locale.languageCode == 'ar' ? 'ساعة' : 'hours';
  String get year => locale.languageCode == 'ar' ? 'سنة' : 'year';

  // Quality
  String get quality => locale.languageCode == 'ar' ? 'الجودة' : 'Quality';
  String get hd => locale.languageCode == 'ar' ? 'عالية الدقة' : 'HD';
  String get fullHd => locale.languageCode == 'ar' ? 'فائقة الدقة' : 'Full HD';
  String get fourK => locale.languageCode == 'ar' ? '4K' : '4K';

  // Player
  String get pause => locale.languageCode == 'ar' ? 'إيقاف مؤقت' : 'Pause';
  String get resume => locale.languageCode == 'ar' ? 'استئناف' : 'Resume';
  String get fullscreen => locale.languageCode == 'ar' ? 'ملء الشاشة' : 'Fullscreen';
  String get exitFullscreen => locale.languageCode == 'ar' ? 'إغلاق ملء الشاشة' : 'Exit Fullscreen';
  String get volume => locale.languageCode == 'ar' ? 'الصوت' : 'Volume';
  String get subtitles => locale.languageCode == 'ar' ? 'الترجمة' : 'Subtitles';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}