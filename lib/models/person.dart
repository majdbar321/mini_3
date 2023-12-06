class Person {
  final int id;
  final String name;
  final int age;
  final List<String>? directedMovies;
  final String pictureUrl;
  final List<String> filmography; // List of media item IDs
  Person(
      {required this.id,
      required this.name,
      required this.age,
      required this.pictureUrl,
      required this.filmography,
      this.directedMovies});

// Factory method for JSON conversion if needed
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown',
      age: json['age'] as int? ?? 0,
      pictureUrl: json['profile_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['profile_path']}'
          : 'https://via.placeholder.com/500?text=No+Profile+Image',
      filmography: (json['filmography'] as List)
          .map((g) => g['name'] as String)
          .toList(),
      // Online placeholder URL
    );
  }
}
