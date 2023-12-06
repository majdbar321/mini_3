import 'package:flutter/material.dart';
import '/models/media_item.dart';
import '/models/person.dart';
import '/models/genre.dart';
import '/service/tmdb_service.dart';
import '/models/review.dart';
import '/models/movies.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserSessionData with ChangeNotifier {
  TMDBService _tmdbService = TMDBService();
  List<int> watchlist = []; // List of movie/TV show IDs in the user's watchlist
  Map<int, Review> reviews = {};
  List<Movie> movies = []; // Assuming this is your list of movies
  List<MediaItem> tvShows = [];
  List<Movie> searchedMovies = [];
  List<MediaItem> searchedTVShows = [];
  List<Person> searchedActors = [];
  List<dynamic> searchMultiResults = [];
  List<int> getWatchlist() {
    return watchlist;
  }

  List<int> getRatedItemsIds() {
    return reviews.keys.toList();
  }

  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }
  // Fetch trending movies

  void addMovies(List<Movie> newMovies) {
    for (var movie in newMovies) {
      if (!movies.any((m) => m.id == movie.id)) {
        movies.add(movie);
      }
    }
    notifyListeners();
  }

  void addTVShows(List<MediaItem> newTVShows) {
    for (var tvShow in newTVShows) {
      if (!tvShows.any((tv) => tv.id == tvShow.id)) {
        tvShows.add(tvShow);
      }
    }
    notifyListeners();
  }

  void removeReview(int itemId) {
    if (reviews.containsKey(itemId)) {
      reviews.remove(itemId);
      _saveToPrefs();
      notifyListeners();
    }
  }

  Movie? getMovieById(int id) {
    try {
      return movies.firstWhere((movie) => movie.id == id);
    } catch (e) {
      // Handle the case where the movie is not found
      return null;
    }
  }

  MediaItem? getTVShowById(int id) {
    try {
      return tvShows.firstWhere((tvShow) => tvShow.id == id);
    } catch (e) {
      // Handle the case where the TV show is not found
      return null;
    }
  }

  Review? getReviewForItem(int itemId) {
    return reviews[itemId];
  }

  void addToWatchlist(int itemId) {
    if (!watchlist.contains(itemId)) {
      watchlist.add(itemId);
      notifyListeners();
    }
  }

  void removeFromWatchlist(int itemId) {
    if (watchlist.contains(itemId)) {
      watchlist.remove(itemId);
      notifyListeners();
    }
  }

  void addReview(int itemId, Review review) {
    reviews[itemId] = review;
    _saveToPrefs();
    notifyListeners();
  }

  void _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    // Convert your reviews to a JSON string
    final String reviewsJson = jsonEncode(
        reviews.map((key, value) => MapEntry(key.toString(), value.toJson())));
    await prefs.setString('reviews', reviewsJson);
  }

  void loadReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final String? reviewsJson = prefs.getString('reviews');
    if (reviewsJson != null) {
      Map<String, dynamic> reviewsMap = jsonDecode(reviewsJson);
      reviews.clear();
      reviewsMap.forEach((key, reviewJson) {
        int id = int.parse(key);
        Review review = Review.fromJson(reviewJson as Map<String, dynamic>);
        reviews[id] = review;
      });
      notifyListeners();
    }
  }

  Future<MediaItem> fetchMediaItemById(int itemId) async {
    try {
      MediaItem mediaItem = await _tmdbService.getTVShowDetailsById(itemId);
      return mediaItem;
    } catch (e) {
      print('Error fetching media item details: $e');
      throw e;
    }
  }

  Future<Movie> fetchMovieItemById(int itemId) async {
    try {
      Movie mediaItem = await _tmdbService.getMovieDetailsById(itemId);
      return mediaItem;
    } catch (e) {
      print('Error fetching media item details: $e');
      throw e;
    }
  }

  // Search for actors
  Future<void> loadTVShows() async {
    try {
      tvShows = await _tmdbService
          .getTrendingTVShows(); // Assuming this method fetches trending TV shows
      notifyListeners();
    } catch (e) {
      print('Error loading TV shows: $e');
    }
  }

  Future<void> searchForActors(String query) async {
    try {
      searchedActors = await _tmdbService.searchActors(query);
      notifyListeners();
    } catch (e) {
      print('Error searching for actors: $e');
    }
  }

  // Search for movies
  Future<void> searchForMovies(String query) async {
    try {
      searchedMovies = await _tmdbService.searchMovies(query);
      notifyListeners();
    } catch (e) {
      print('Error searching for movies: $e');
    }
  }

  // Search for TV shows
  Future<void> searchForTVShows(String query) async {
    try {
      searchedTVShows = await _tmdbService.searchTVShows(query);
      notifyListeners();
    } catch (e) {
      print('Error searching for TV shows: $e');
    }
  }

  // Multi-search
  Future<void> searchMulti(String query) async {
    try {
      searchMultiResults = await _tmdbService.searchMulti(query);
      notifyListeners();
    } catch (e) {
      print('Error in multi-search: $e');
    }
  }

  // Additional methods for fetching movie and TV show details, cast, genres, etc., can be added here
  bool isInWatchlist(int itemId) {
    return watchlist.contains(itemId);
  }

  // Example: Fetch movie details by ID
  Future<Movie> fetchMovieDetailsById(int movieId) async {
    try {
      return await _tmdbService.getMovieDetailsById(movieId);
      // Optionally notify listeners if you need to update UI based on this data
    } catch (e) {
      print('Error fetching movie details: $e');
      throw e; // Consider how you want to handle errors in your UI
    }
  }

  // Example: Fetch TV show details by ID
  Future<MediaItem> fetchTVShowDetailsById(int tvShowId) async {
    try {
      return await _tmdbService.getTVShowDetailsById(tvShowId);
      // Optionally notify listeners if you need to update UI based on this data
    } catch (e) {
      print('Error fetching TV show details: $e');
      throw e; // Consider how you want to handle errors in your UI
    }
  }

  // ...other methods for handling cast members, genres, etc.
}
