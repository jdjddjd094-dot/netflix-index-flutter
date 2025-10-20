class WatchHistory {
  final String id;
  final String userId;
  final int contentId;
  final String contentType; // 'movie' or 'tv'
  final String title;
  final String? posterPath;
  final int watchedDuration; // in seconds
  final int totalDuration; // in seconds
  final DateTime lastWatchedAt;
  final int? seasonNumber; // for TV shows
  final int? episodeNumber; // for TV shows

  WatchHistory({
    required this.id,
    required this.userId,
    required this.contentId,
    required this.contentType,
    required this.title,
    this.posterPath,
    required this.watchedDuration,
    required this.totalDuration,
    required this.lastWatchedAt,
    this.seasonNumber,
    this.episodeNumber,
  });

  factory WatchHistory.fromJson(Map<String, dynamic> json) {
    return WatchHistory(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      contentId: json['contentId'] ?? 0,
      contentType: json['contentType'] ?? '',
      title: json['title'] ?? '',
      posterPath: json['posterPath'],
      watchedDuration: json['watchedDuration'] ?? 0,
      totalDuration: json['totalDuration'] ?? 0,
      lastWatchedAt: DateTime.parse(json['lastWatchedAt'] ?? DateTime.now().toIso8601String()),
      seasonNumber: json['seasonNumber'],
      episodeNumber: json['episodeNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'contentId': contentId,
      'contentType': contentType,
      'title': title,
      'posterPath': posterPath,
      'watchedDuration': watchedDuration,
      'totalDuration': totalDuration,
      'lastWatchedAt': lastWatchedAt.toIso8601String(),
      'seasonNumber': seasonNumber,
      'episodeNumber': episodeNumber,
    };
  }

  double get watchProgress {
    if (totalDuration == 0) return 0.0;
    return (watchedDuration / totalDuration).clamp(0.0, 1.0);
  }

  String get watchProgressPercentage {
    return '${(watchProgress * 100).round()}%';
  }

  bool get isCompleted {
    return watchProgress >= 0.9; // Consider 90% as completed
  }

  String get fullPosterPath {
    if (posterPath == null) return '';
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String get displayTitle {
    if (contentType == 'tv' && seasonNumber != null && episodeNumber != null) {
      return '$title S${seasonNumber}E${episodeNumber}';
    }
    return title;
  }

  WatchHistory copyWith({
    String? id,
    String? userId,
    int? contentId,
    String? contentType,
    String? title,
    String? posterPath,
    int? watchedDuration,
    int? totalDuration,
    DateTime? lastWatchedAt,
    int? seasonNumber,
    int? episodeNumber,
  }) {
    return WatchHistory(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      contentId: contentId ?? this.contentId,
      contentType: contentType ?? this.contentType,
      title: title ?? this.title,
      posterPath: posterPath ?? this.posterPath,
      watchedDuration: watchedDuration ?? this.watchedDuration,
      totalDuration: totalDuration ?? this.totalDuration,
      lastWatchedAt: lastWatchedAt ?? this.lastWatchedAt,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      episodeNumber: episodeNumber ?? this.episodeNumber,
    );
  }
}