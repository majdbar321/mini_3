import 'package:flutter/material.dart';
import 'package:mini_3/models/movies.dart';
import '/provider/session_data_provider.dart';
import 'package:provider/provider.dart';
import '../service/tmdb_service.dart';
import '../widgets/media_item_card.dart';
import '../widgets/person_card.dart';
import '../models/media_item.dart';
import '../models/person.dart';

class SearchResultScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchResultScreen>
    with SingleTickerProviderStateMixin {
  final TMDBService _tmdbService = TMDBService();
  final TextEditingController _searchController = TextEditingController();
  TabController? _tabController;
  Future<List<Movie>>? _searchResultsMovies;
  Future<List<MediaItem>>? _searchResultsTVShows;
  Future<List<Person>>? _searchResultsActors;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _search(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _searchResultsMovies = _tmdbService.searchMovies(query);
        _searchResultsTVShows = _tmdbService.searchTVShows(query);
        _searchResultsActors = _tmdbService.searchActors(query);
      });

      _searchResultsMovies?.then((movie) {
        if (movie != null) {
          Provider.of<UserSessionData>(context, listen: false).addMovies(movie);
        }
      });
      _searchResultsTVShows?.then((tvShows) {
        if (tvShows != null) {
          Provider.of<UserSessionData>(context, listen: false)
              .addTVShows(tvShows);
        }
      });
    }
  }

  Widget _buildSearchResults<T>(
      Future<List<T>>? searchResults, Widget Function(T) buildFunction) {
    return FutureBuilder<List<T>>(
      future: searchResults,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No results found.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) =>
                buildFunction(snapshot.data![index]),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
              kToolbarHeight + 15), // Adjust the height as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .start, // Align the tabs and search bar to the left
            children: [
              SizedBox(
                  height:
                      1), // Increase the height of the empty space above the tabs
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Movies'),
                  Tab(text: 'TV Shows'),
                  Tab(text: 'Actors'),
                ],
              ),
              SizedBox(
                  height:
                      8), // Add some space between the tabs and the search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Search movies, TV shows, actors...',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  onSubmitted: _search,
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: ScrollPhysics(), // Enable swipe behavior
        children: [
          _searchResultsMovies == null
              ? Center(
                  child: Text('Search for movies',
                      style:
                          TextStyle(color: Colors.white))) // Set the text color
              : _buildSearchResults(_searchResultsMovies,
                  (movie) => MediaItemCard(tvShow: movie as MediaItem)),
          _searchResultsTVShows == null
              ? Center(
                  child: Text('Search for TV shows',
                      style:
                          TextStyle(color: Colors.white))) // Set the text color
              : _buildSearchResults(_searchResultsTVShows,
                  (tvShow) => MediaItemCard(tvShow: tvShow as MediaItem)),
          _searchResultsActors == null
              ? Center(
                  child: Text('Search for actors',
                      style:
                          TextStyle(color: Colors.white))) // Set the text color
              : _buildSearchResults(_searchResultsActors,
                  (actor) => PersonCard(person: actor as Person)),
        ],
      ),
    );
  }
}
