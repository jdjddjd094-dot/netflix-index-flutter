class TvShow {
  final int id;
  final String name;
  final String originalName;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String firstAirDate;
  final double voteAverage;
  final int voteCount;
  final bool adult;
  final List<int> genreIds;
  final List<String> originCountry;
  final String originalLanguage;
  final double popularity;

  TvShow({
    required this.id,
    required this.name,
    required this.originalName,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
    required this.adult,
    required this.genreIds,
    required this.originCountry,
    required this.originalLanguage,
    required this.popularity,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      originalName: json['original_name'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      firstAirDate: json['first_air_date'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      adult: json['adult'] ?? false,
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      originCountry: List<String>.from(json['origin_country'] ?? []),
      originalLanguage: json['original_language'] ?? '',
      popularity: (json['popularity'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'original_name': originalName,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'first_air_date': firstAirDate,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'adult': adult,
      'genre_ids': genreIds,
      'origin_country': originCountry,
      'original_language': originalLanguage,
      'popularity': popularity,
    };
  }

  String get fullPosterPath {
    if (posterPath == null) return '';
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String get fullBackdropPath {
    if (backdropPath == null) return '';
    return 'https://image.tmdb.org/t/p/original$backdropPath';
  }

  String get year {
    if (firstAirDate.isEmpty) return '';
    return firstAirDate.split('-')[0];
  }

  String get formattedRating {
    return voteAverage.toStringAsFixed(1);
  }
}