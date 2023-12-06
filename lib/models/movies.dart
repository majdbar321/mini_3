class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterUrl;
  final String backdropUrl;
  final DateTime? releaseDate;
  final double rating;
  final List<String> genres; // New field for genres
  final int duration; // New field for duration
  final String director; // New field for director

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterUrl,
    required this.backdropUrl,
    this.releaseDate,
    required this.rating,
    required this.genres, // Initialize in constructor
    required this.duration,
    required this.director,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? date) {
      if (date == null || date.isEmpty) return null;
      try {
        return DateTime.parse(date);
      } catch (_) {
        // If the date format is invalid, return null
        return null;
      }
    }

    return Movie(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Unknown',
      overview: json['overview'] as String? ?? 'No description available.',
      posterUrl: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
          : 'https://via.placeholder.com/500x750?text=No+Image', // Placeholder image URL
      backdropUrl: json['backdrop_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['backdrop_path']}'
          : 'https://via.placeholder.com/300x450?text=Movie', // Placeholder image URL
      releaseDate: parseDate(json['release_date'] as String?),
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      genres: (json['genres'] as List)
          .map((g) => g['name'] as String)
          .toList(), // Initialize in constructor
      duration: json['runtime'] as int? ?? 0, // Initialize in constructor
      director:
          json['director'] as String? ?? 'Unknown', // Initialize in constructor
    );
  }
}
