import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class ItemReviewScreen extends StatefulWidget {
  final String companyName;

  ItemReviewScreen({this.companyName = 'Test Company'});

  @override
  _ItemReviewScreenState createState() => _ItemReviewScreenState();
}

class _ItemReviewScreenState extends State<ItemReviewScreen> {
  List<Map<String, dynamic>> reviews = []; // Changed to dynamic

  @override
  void initState() {
    super.initState();
    _fetchreviews(widget.companyName);
  }

  Future<void> _fetchreviews(String name) async {
    final String apiUrl = 'https://10.0.0.201:5050/reviews/$name';
    final client = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    try {
      final request = await client.getUrl(Uri.parse(apiUrl));
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        setState(() {
          reviews = List<Map<String, dynamic>>.from(jsonDecode(responseBody));
          print('Reviews successfully loaded and state updated');
        });
      } else {
        print('Failed to load reviews. Status code: ${response.statusCode}');
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      print('An error occurred: $e');
      throw Exception('Failed to load reviews');
    } finally {
      client.close();
      print('HTTP client closed');
    }
  }

  @override
  Widget build(BuildContext context) {
    double averageRating = 0.0;
    if (reviews.isNotEmpty) {
      averageRating = double.tryParse(reviews[0]['avg_rating'].toString()) ?? 0.0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.companyName + ' Reviews',
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
                  comment: review['comment'] ?? '', // Handling null
                  rating: review['rating'].toString(), // Handling different types
                  date: review['created_at'].toString(), // Handling different types
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
                backgroundImage: AssetImage('assets/profile.png'),
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
