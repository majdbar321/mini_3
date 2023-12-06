import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/session_data_provider.dart'; // Ensure the path is correct
import '/widgets/media_item_card.dart';
import '/models/media_item.dart'; // Ensure the path is correct

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userSessionData = Provider.of<UserSessionData>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: ListView(
        children: [
          SectionTitle(title: "My Watchlist"),
          MediaItemList(mediaItemIds: userSessionData.getWatchlist()),
          SectionTitle(title: "My Rated Movies/TV Shows"),
          RatedMediaItemList(
              mediaItemIds: userSessionData.getRatedItemsIds(),
              userSessionData:
                  userSessionData), // Fixed parameter name to camelCase
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class MediaItemList extends StatelessWidget {
  final List<int> mediaItemIds;

  MediaItemList({required this.mediaItemIds});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: mediaItemIds
          .map((id) => FutureBuilder<MediaItem>(
                future: Provider.of<UserSessionData>(context, listen: false)
                    .fetchMediaItemById(id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return MediaItemCard(tvShow: snapshot.data!);
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ))
          .toList(),
    );
  }
}

class RatedMediaItemList extends StatelessWidget {
  final List<int> mediaItemIds;
  final UserSessionData userSessionData; // Fixed parameter name to camelCase

  RatedMediaItemList(
      {required this.mediaItemIds, required this.userSessionData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: mediaItemIds
          .map((id) => FutureBuilder<MediaItem>(
                future: userSessionData
                    .fetchMediaItemById(id), // Use camelCase variable
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return ListTile(
                      leading: Image.network(snapshot.data!.posterUrl),
                      title: Text(snapshot.data!.name),
                      subtitle: Text(
                          'Rating: ${userSessionData.getReviewForItem(id)?.rating ?? 'Not Rated'}'),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ))
          .toList(),
    );
  }
}
