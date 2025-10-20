class AppUser {
  final String id;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final bool isGuest;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final String preferredLanguage;
  final List<int> favoriteMovies;
  final List<int> favoriteTvShows;

  AppUser({
    required this.id,
    this.email,
    this.displayName,
    this.photoURL,
    required this.isGuest,
    required this.createdAt,
    required this.lastLoginAt,
    required this.preferredLanguage,
    required this.favoriteMovies,
    required this.favoriteTvShows,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? '',
      email: json['email'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      isGuest: json['isGuest'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      lastLoginAt: DateTime.parse(json['lastLoginAt'] ?? DateTime.now().toIso8601String()),
      preferredLanguage: json['preferredLanguage'] ?? 'ar',
      favoriteMovies: List<int>.from(json['favoriteMovies'] ?? []),
      favoriteTvShows: List<int>.from(json['favoriteTvShows'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'isGuest': isGuest,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'preferredLanguage': preferredLanguage,
      'favoriteMovies': favoriteMovies,
      'favoriteTvShows': favoriteTvShows,
    };
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    bool? isGuest,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? preferredLanguage,
    List<int>? favoriteMovies,
    List<int>? favoriteTvShows,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      isGuest: isGuest ?? this.isGuest,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      favoriteMovies: favoriteMovies ?? this.favoriteMovies,
      favoriteTvShows: favoriteTvShows ?? this.favoriteTvShows,
    );
  }

  static AppUser createGuest() {
    final now = DateTime.now();
    return AppUser(
      id: 'guest_${now.millisecondsSinceEpoch}',
      isGuest: true,
      createdAt: now,
      lastLoginAt: now,
      preferredLanguage: 'ar',
      favoriteMovies: [],
      favoriteTvShows: [],
    );
  }
}