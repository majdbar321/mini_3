class MediaItem {
  final int id;
  final String name;
  final String overview;
  final String posterUrl;
  final String backdropUrl;
  final DateTime? firstAirDate;
  final double rating;
  final List<String> genres;
  final int numberOfSeasons;
  final int numberOfEpisodes;

  MediaItem({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterUrl,
    required this.backdropUrl,
    this.firstAirDate,
    required this.rating,
    required this.genres,
    required this.numberOfSeasons,
    required this.numberOfEpisodes,
  });

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    List<String> genres = (json['genres'] as List<dynamic>?)
            ?.map((genre) => genre['name'] as String? ?? 'Unknown')
            .toList() ??
        [];

    DateTime? parseDate(String? date) {
      if (date == null || date.isEmpty) return null;
      try {
        return DateTime.parse(date);
      } catch (_) {
        return null; // Log the error or handle it as needed
      }
    }

    return MediaItem(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown',
      overview: json['overview'] as String? ?? 'No description available.',
      posterUrl: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
          : 'https://via.placeholder.com/500x750?text=No+Image',
      backdropUrl:
          'https://image.tmdb.org/t/p/w500${json['backdrop_path'] as String? ?? '/placeholder.png'}',
      firstAirDate: parseDate(json['first_air_date'] as String?),
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      genres: genres,
      numberOfSeasons: json['number_of_seasons'] as int? ?? 0,
      numberOfEpisodes: json['number_of_episodes'] as int? ?? 0,
    );
  }
}
