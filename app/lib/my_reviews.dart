import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import 'auth_provider.dart';

class MyReviewsScreen extends StatelessWidget {
  MyReviewsScreen({Key? key}) : super(key: key);

  Future<List<dynamic>> fetchReviews(String userId) async {
    final client = createHttpClient();
    final uri = Uri.parse('https://10.0.0.201:5050/reviews/user/$userId');

    try {
      final response = await client.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      throw e;
    }
  }

  http.Client createHttpClient() {
    final ioClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return IOClient(ioClient);
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context, listen: false).getCurrentUserID();

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('My Reviews'),
          centerTitle: true, // Center-align the title
          backgroundColor: Colors.blue, // Customize the background color
          elevation: 0, // Remove the shadow effect
        ),
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Reviews',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Set text color to white
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 4,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchReviews(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No reviews found"));
          } else {
            List<dynamic> reviews = snapshot.data!;
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                var review = reviews[index];
                return ReviewCard(
                  title: review['title'] ?? 'Title not available',
                  comment: review['comment'] ?? 'Content not available',
                  rating: review['rating'] ?? 'Rating not available',
                  date: review['created_at'] ?? 'Date not available',
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String title;
  final String comment;
  final String rating;
  final String date;

  ReviewCard({
    required this.title,
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
            Text(
              'Title: $title',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Content: $comment'),
            SizedBox(height: 8),
            Text('Rating: $rating'),
            SizedBox(height: 8),
            Text('Date: $date'),
          ],
        ),
      ),
    );
  }
}