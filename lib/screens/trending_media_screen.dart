import 'package:flutter/material.dart';
import 'package:mini_3/models/media_item.dart';
import '../widgets/media_item_card.dart';
import '../service/tmdb_service.dart';

class TrendingMediaScreen extends StatefulWidget {
  @override
  _TrendingMediaScreenState createState() => _TrendingMediaScreenState();
}

class _TrendingMediaScreenState extends State<TrendingMediaScreen> {
  final TMDBService _tmdbService = TMDBService();
  late Future<List<MediaItem>> _popularTVShowsFuture;

  @override
  void initState() {
    super.initState();
    _popularTVShowsFuture = _tmdbService
        .getTrendingTVShows(); // Make sure this method is defined in your TMDBService
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular TV Shows'),
      ),
      body: FutureBuilder<List<MediaItem>>(
        future: _popularTVShowsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No popular TV shows found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return MediaItemCard(tvShow: snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }
}
