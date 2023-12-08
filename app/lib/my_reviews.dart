import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'review_card.dart';
import 'package:intl/intl.dart';
import 'main.dart';
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

  String formatDate(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString);
    final String month = DateFormat.MMM().format(dateTime);
    final String day = DateFormat.d().format(dateTime);
    final String year = DateFormat.y().format(dateTime);
    final String suffix = getDaySuffix(int.parse(day));
    return '$month $day$suffix, $year';
  }

  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  Card buildReviewCountCard(int reviewCount) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.blue,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Text(
                'Number of Reviews',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              reviewCount.toString(),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context, listen: false).getCurrentUserID();

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('My Reviews'),
          centerTitle: true,
          backgroundColor: Colors.blue,
          elevation: 0,
        ),
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Reviews',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 4,
        iconTheme: IconThemeData(
          color: Colors.white, // Set the color of the back button to white
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home), // Home icon
            onPressed: () {
              // Navigate to the HomeScreen class
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
        ],
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
            int reviewCount = reviews.length; // Get the number of reviews
            return Column(
              children: [
                buildReviewCountCard(reviewCount), // Add the review count card
                Expanded(
                  child: ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      var review = reviews[index];
                      final date = review['created_at'] ?? 'Date not available';
                      final formattedDate = formatDate(date); // Format the date
                      return ReviewCard(
                        comment: review['comment'] ?? 'Content not available',
                        rating: review['rating'] ?? 'Rating not available',
                        date: formattedDate, // Use the formatted date
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
