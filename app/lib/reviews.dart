import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'package:http/http.dart' as http;

class ReviewsPage extends StatefulWidget {
  final String reviewType;

  const ReviewsPage({Key? key, required this.reviewType}) : super(key: key);

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0.0;

  @override
  void dispose() {
    _businessNameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitReview(BuildContext context) async {
    final String apiUrl = 'https://10.0.0.201:5050/submit-review'; // Replace with your server's URL
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String? token = authProvider.token; // Get token from AuthProvider
    print('Retrieved token: $token');

    if (token == null) {
      print('No token found');
      // Handle the case where there is no token (user not logged in)
      return;
    }

    final client = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true; // Bypass handshake error

    try {
      final request = await client.postUrl(Uri.parse(apiUrl));
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json; charset=UTF-8');
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
      request.write(jsonEncode({
        'reviewType': widget.reviewType,
        'name': _businessNameController.text,
        'rating': _rating,
        'comment': _reviewController.text,
      }));

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: $responseBody'); // Debugging line

      if (response.statusCode == 200) {
        print('Review submitted successfully');
        // Additional logic for success (e.g., showing a confirmation dialog)
      } else {
        print('Failed to submit review');
        // Handle submission failure, show an alert dialog or a snackbar
      }
    } catch (e) {
      print('An error occurred: $e');
      // Handle exceptions, show an alert dialog or a snackbar
    } finally {
      client.close();
    }
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.blue[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave a Review', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        elevation: 10,
        shadowColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Enter the ${widget.reviewType} name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[800]),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _businessNameController,
              decoration: _inputDecoration('Enter name here'),
            ),
            SizedBox(height: 20),
            Text(
              'Your Rating',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[800]),
            ),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 0.5,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Your Feedback',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[800]),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _reviewController,
              maxLines: 5,
              decoration: _inputDecoration('Write your review here'),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _submitReview(context);
                },
                child: Text('Submit Review'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[800],
                  onPrimary: Colors.white,
                  shadowColor: Colors.blue[900],
                  elevation: 8,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

            ),
          ],
        ),
      ),
    );
  }
}
