class Review {
  final String itemID; // Common ID for both movie and TV show
  final String review;
  final double rating;
  final String title; // Title of the movie or TV show
  final String posterUrl; // Poster URL of the movie or TV show
  final bool
      isMovie; // Flag to indicate if the review is for a movie or a TV show

  Review({
    required this.itemID,
    required this.review,
    required this.rating,
    required this.title,
    required this.posterUrl,
    required this.isMovie,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      itemID: json['itemID'],
      review: json['review'],
      rating: (json['rating'] as num).toDouble(),
      title: json['title'],
      posterUrl: json['posterUrl'],
      isMovie: json['isMovie'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemID': itemID,
      'review': review,
      'rating': rating,
      'title': title,
      'posterUrl': posterUrl,
      'isMovie': isMovie,
    };
  }
}
