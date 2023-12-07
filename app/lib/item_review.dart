import 'package:flutter/material.dart';

class ItemReviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mock reviews data with an average rating of 4.5
    final List<Map<String, String>> reviews = [
      {
        'review': 'Always delicious.',
        'rating': '3.5',
        'date': '2023-12-08',
      },

    ];

    // Calculate the average rating
    double averageRating = 0.0;
    for (var review in reviews) {
      averageRating += double.parse(review['rating']!);
    }
    averageRating /= reviews.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'McDonald\'s Reviews',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 4,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Text(
              'Average Rating: ${averageRating.toStringAsFixed(1)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                var review = reviews[index];
                return ReviewCard(
                  comment: review['review']!, // Updated 'comment' to 'review'
                  rating: review['rating']!,
                  date: review['date']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String comment;
  final String rating;
  final String date;

  ReviewCard({
    required this.comment,
    required this.rating,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/profile.png'), // Add your profile image asset
                radius: 24,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Content: $comment'),
                  Text('Rating: $rating'),
                  Text('Date: $date'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
