import 'package:flutter/material.dart';
import '/models/person.dart';

class PersonDetailScreen extends StatelessWidget {
  final Person person;

  PersonDetailScreen({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(person.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              person.pictureUrl,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Age: ${person.age}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Filmography:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  ...person.filmography
                      .map((movie) => ListTile(title: Text(movie))),
                  if (person.directedMovies != null) ...[
                    SizedBox(height: 8),
                    Text(
                      'Directed Movies:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    ...person.directedMovies!
                        .map((movie) => ListTile(title: Text(movie))),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
