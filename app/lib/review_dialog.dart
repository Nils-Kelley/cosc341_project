import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ReviewDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white, // Set the background color to white
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
              color: Colors.black87, // Adjust text color for readability
            ),
          ),
          SizedBox(height: 20),
          _reviewButton(context, 'Leave a Review for a Business', Icons.business, Colors.lightBlue),
          SizedBox(height: 12),
          _reviewButton(context, 'Leave a Review for a Restaurant', Icons.restaurant, Colors.lightBlue[200]!), // Lighter shade for variation
          SizedBox(height: 12),
          _reviewButton(context, 'Leave a Review for an Item', Icons.shopping_cart, Colors.lightBlue[300]!), // Even lighter shade
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(fontSize: 16, color: Colors.redAccent), // Keep for emphasis on the cancellation action
          ),
        ),
      ],
    );
  }

  Widget _reviewButton(BuildContext context, String text, IconData icon, Color color) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      onPressed: () {
        // Implement functionality here
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
