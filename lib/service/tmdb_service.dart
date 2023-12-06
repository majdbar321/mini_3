import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mini_3/models/media_item.dart';
import 'package:mini_3/models/movies.dart';
import 'package:mini_3/models/person.dart';
import 'package:mini_3/models/genre.dart';

class TMDBService {
  final String apiKey = '283c70a38b876989887a6c530e535799';
  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> getTrendingMovies() async {
    try {
      // Replace 'week' with 'day' if you want daily trends
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/trending/movie/week?api_key=283c70a38b876989887a6c530e535799'));

      if (response.statusCode == 200 && response.body != null) {
        var decodedResponse = json.decode(response.body);

        if (decodedResponse['results'] != null &&
            decodedResponse['results'] is List) {
          List<dynamic> results = decodedResponse['results'];
          return results.map((json) => Movie.fromJson(json)).toList();
        } else {
          print('Error: Missing or invalid "results" key in response.');
          return [];
        }
      } else {
        print(
            'Error fetching movies: Status Code ${response.statusCode}, Response Body: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error during API call: $e');
      return [];
    }
  }

  Future<List<Person>> searchActors(String query) async {
    final response = await http
        .get(Uri.parse('$baseUrl/search/person?api_key=$apiKey&query=$query'));
    return _processResponse(response, (json) => Person.fromJson(json));
  }

  Future<Movie> getMovieDetails(int movieId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey'));
    return _processResponseSingle(response, (json) => Movie.fromJson(json));
  }

  Future<List<Person>> getCastMembers(int movieId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/movie/$movieId/credits?api_key=$apiKey'));
    if (response.statusCode == 200) {
      List<dynamic> cast = json.decode(response.body)['cast'];
      return cast.map((json) => Person.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cast members');
    }
  }

  Future<MediaItem> getTVShowDetails(int tvShowId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/tv/$tvShowId?api_key=$apiKey'));
    return _processResponseSingle(response, (json) => MediaItem.fromJson(json));
  }

  Future<List<MediaItem>> getTrendingTVShows() async {
    final response =
        await http.get(Uri.parse('$baseUrl/trending/tv/day?api_key=$apiKey'));
    return _processResponse(response, (json) => MediaItem.fromJson(json));
  }

  Future<Movie> getMovieDetailsById(int movieId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey'));
    if (response.statusCode == 200) {
      return Movie.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<List<Genre>> getMovieGenres(int movieId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey'));
    if (response.statusCode == 200) {
      List<dynamic> genres = json.decode(response.body)['genres'];
      return genres.map((json) => Genre.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movie genres');
    }
  }

  Future<List<Genre>> getTVShowGenres(int tvShowId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/tv/$tvShowId?api_key=$apiKey'));
    if (response.statusCode == 200) {
      List<dynamic> genres = json.decode(response.body)['genres'];
      return genres.map((json) => Genre.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load TV show genres');
    }
  }

  Future<Map<String, dynamic>> getTVShowSeasonsAndEpisodes(int tvShowId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/tv/$tvShowId?api_key=$apiKey'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      int numberOfSeasons = data['number_of_seasons'];
      int numberOfEpisodes = data['number_of_episodes'];
      return {'seasons': numberOfSeasons, 'episodes': numberOfEpisodes};
    } else {
      throw Exception('Failed to load TV show seasons and episodes');
    }
  }

  Future<List<dynamic>> searchMulti(String query) async {
    final response = await http
        .get(Uri.parse('$baseUrl/search/multi?api_key=$apiKey&query=$query'));
    if (response.statusCode == 200) {
      var results = json.decode(response.body)['results'] as List;
      return results
          .map((result) {
            if (result['media_type'] == 'movie') {
              return MediaItem.fromJson(result);
            } else if (result['media_type'] == 'tv') {
              return MediaItem.fromJson(result);
            } else if (result['media_type'] == 'person') {
              return Person.fromJson(result);
            }
            return null; // or throw an error if you encounter an unsupported type
          })
          .where((item) => item != null)
          .toList(); // Remove nulls from the list
    } else {
      throw Exception('Failed to load search results');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http
        .get(Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query'));
    if (response.statusCode == 200) {
      List<dynamic> results = json.decode(response.body)['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load search results for movies');
    }
  }

  Future<List<MediaItem>> searchTVShows(String query) async {
    final response = await http
        .get(Uri.parse('$baseUrl/search/tv?api_key=$apiKey&query=$query'));
    if (response.statusCode == 200) {
      List<dynamic> results = json.decode(response.body)['results'];
      return results.map((json) => MediaItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load search results for TV shows');
    }
  }

  // Utility method to process list responses
  List<T> _processResponse<T>(
      http.Response response, T Function(Map<String, dynamic>) fromJson) {
    if (response.statusCode == 200) {
      List<dynamic> results = json.decode(response.body)['results'];
      return results.map((json) => fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Utility method to process single item responses
  T _processResponseSingle<T>(
      http.Response response, T Function(Map<String, dynamic>) fromJson) {
    if (response.statusCode == 200) {
      return fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Method to get details of a specific movie by ID

  // Method to get details of a specific TV show by ID
  Future<MediaItem> getTVShowDetailsById(int tvShowId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/tv/$tvShowId?api_key=$apiKey'));
    if (response.statusCode == 200) {
      return MediaItem.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load TV show details');
    }
  }
}
