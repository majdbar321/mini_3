import 'package:flutter/material.dart';
import '../models/media_item.dart';
import '../screens/media_detail_screen.dart';
import '../screens/tvshow_detail_screen.dart';

class MediaItemCard extends StatelessWidget {
  final MediaItem tvShow;

  MediaItemCard({required this.tvShow});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          // Navigate to TVShowDetailsScreen when the card is clicked
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TVShowDetailsScreen(tvShow: tvShow),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                tvShow.posterUrl,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tvShow.name,
                    style: Theme.of(context).textTheme.headline6,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'First Air Date: ${formattedDate(tvShow.firstAirDate)}',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 20, color: Colors.amber),
                      SizedBox(width: 4),
                      Text(
                        '${tvShow.rating.toStringAsFixed(1)}/10',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.favorite_border),
                        onPressed: () {
                          // Implement logic to add to watchlist
                        },
                      ),
                      // Add more buttons or actions here
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formattedDate(DateTime? date) {
    if (date != null) {
      return date.toLocal().toString().split(' ')[0];
    } else {
      return 'Unknown';
    }
  }
}
