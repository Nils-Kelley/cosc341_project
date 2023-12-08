import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'review_card.dart';
import 'main.dart';
class ItemReviewScreen extends StatefulWidget {
  final String companyName;

  ItemReviewScreen({this.companyName = 'Test Company'});

  @override
  _ItemReviewScreenState createState() => _ItemReviewScreenState();
}

class _ItemReviewScreenState extends State<ItemReviewScreen> {
  List<Map<String, dynamic>> reviews = [];

  @override
  void initState() {
    super.initState();
    _fetchReviews(widget.companyName);
  }

  Future<void> _fetchReviews(String name) async {
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

  Card buildAverageRatingCard(double averageRating) {
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
                'Average Rating',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              averageRating.toStringAsFixed(1),
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
    double averageRating = 0.0;
    if (reviews.isNotEmpty) {
      averageRating = double.tryParse(reviews[0]['avg_rating'].toString()) ?? 0.0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.companyName,
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAverageRatingCard(averageRating), // Use the custom card here
            Expanded(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  var review = reviews[index];
                  return ReviewCard(
                    comment: review['comment'] ?? '',
                    rating: review['rating'].toString(),
                    date: _formatDate(review['created_at'].toString()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String inputDate) {
    final DateTime date = DateTime.parse(inputDate);
    final String formattedDate = DateFormat.yMMMd().format(date);

    return formattedDate;
  }
}

