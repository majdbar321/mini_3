import 'package:flutter/material.dart';
import '../models/person.dart';

class PersonCard extends StatelessWidget {
  final Person person;

  PersonCard({required this.person});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(4.0)),
            child: Image.network(
              person.pictureUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  person.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                // Age
                Text(
                  'Age: ${person.age}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                // Filmography
                Text(
                  'Filmography:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  children: person.filmography
                      .map((movie) => Chip(label: Text(movie)))
                      .toList(),
                ),
                // Directed Movies (if any)
                if (person.directedMovies != null) ...[
                  SizedBox(height: 8),
                  Text(
                    'Directed:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    children: person.directedMovies!
                        .map((movie) => Chip(label: Text(movie)))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
