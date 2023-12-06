import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'reviews.dart'; // Import the reviews.dart file

class ReviewDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'Leave a Review',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.lightBlue,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select an option below to leave a review:',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          _reviewButton(context, 'Leave a Review for a Business', Icons.business, Colors.lightBlue, 'business'), // Updated
          SizedBox(height: 12),
          _reviewButton(context, 'Leave a Review for a Restaurant', Icons.restaurant, Colors.lightBlue[200]!, 'restaurant'), // Updated

        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(fontSize: 16, color: Colors.redAccent),
          ),
        ),
      ],
    );
  }

  Widget _reviewButton(BuildContext context, String text, IconData icon, Color color, String reviewType) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ReviewsPage(reviewType: reviewType)),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        shadowColor: Colors.black45,
        elevation: 5,
      ),
    );
  }
}
