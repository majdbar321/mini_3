import 'package:flutter/material.dart';
import 'package:mini_3/models/media_item.dart';
import '../models/movies.dart';
import '../models/review.dart';
import '../provider/session_data_provider.dart';
import 'package:provider/provider.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  MovieDetailsScreen({required this.movie});

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool isAddedToWatchlist = false;
  double userRating = 0.0;
  TextEditingController reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadExistingReview();
    checkIfMovieIsInWatchlist();
  }

  void checkIfMovieIsInWatchlist() {
    isAddedToWatchlist = Provider.of<UserSessionData>(context, listen: false)
        .isInWatchlist(widget.movie.id);
  }

  void loadExistingReview() {
    final existingReview = Provider.of<UserSessionData>(context, listen: false)
        .getReviewForItem(widget.movie.id);
    if (existingReview != null && existingReview.isMovie) {
      setState(() {
        reviewController.text = existingReview.review;
        userRating = existingReview.rating;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.movie.posterUrl,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Rating: ${widget.movie.rating.toStringAsFixed(1)}/10',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Overview:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.movie.overview,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add to Watchlist:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                    isAddedToWatchlist ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isAddedToWatchlist) {
                        Provider.of<UserSessionData>(context, listen: false)
                            .removeFromWatchlist(widget.movie.id);
                      } else {
                        Provider.of<UserSessionData>(context, listen: false)
                            .addToWatchlist(widget.movie.id);
                      }
                      isAddedToWatchlist = !isAddedToWatchlist;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Your Rating:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                // Rating stars
                ...List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(Icons.star),
                    color: userRating > index ? Colors.amber : Colors.grey,
                    onPressed: () {
                      _setUserRating(index + 1);
                    },
                  );
                }),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Your Review:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write your review here',
                border: OutlineInputBorder(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Save review
                    _saveReview(context);
                  },
                  child: Text('Submit Review'),
                ),
                if (Provider.of<UserSessionData>(context)
                        .getReviewForItem(widget.movie.id) !=
                    null)
                  ElevatedButton(
                    onPressed: () => _removeReview(context, widget.movie.id),
                    child: Text('Remove Review'),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveReview(BuildContext context) {
    final review = Review(
      itemID: widget.movie.id.toString(),
      review: reviewController.text,
      rating: userRating,
      title: widget.movie.title,
      posterUrl: widget.movie.posterUrl,
      isMovie: true,
    );

    Provider.of<UserSessionData>(context, listen: false)
        .addReview(widget.movie.id, review);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Review added!')));
  }

  void _removeReview(BuildContext context, int movieId) {
    Provider.of<UserSessionData>(context, listen: false).removeReview(movieId);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Review removed!')));
    reviewController.clear();
    setState(() {
      userRating = 0.0;
    });
  }

  String _formatDate(DateTime? date) {
    if (date != null) {
      return date.toLocal().toString().split(' ')[0];
    }
    return 'Unknown';
  }

  void _setUserRating(double rating) {
    setState(() {
      userRating = rating;
    });
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }
}
