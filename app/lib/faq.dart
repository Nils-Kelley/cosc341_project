import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FAQ's",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(
          color: Colors.white, // Set the color of the back button to white
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: faqList.length,
          itemBuilder: (BuildContext context, int index) {
            // Using the null-aware operators `?` and `??` to handle potential nulls
            String question = faqList[index]['question'] ??
                'No question available';
            String answer = faqList[index]['answer'] ?? 'No answer available';

            return ExpansionTile(
              title: Text(
                question,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    answer,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }


  final List<Map<String, String?>> faqList = [
    {
      'question': 'Are there any user guidelines for writing reviews?',
      'answer': 'Yes, when writing reviews, we ask users to be honest, respectful, and provide constructive feedback. Avoid offensive language and personal information.'
    },
    {
      'question': 'How do I navigate to different sections of the app?',
      'answer': 'To access various sections of the app, you have two main options. Firstly, you can utilize the bottom navigation bar, which features sections such as Home, Map, Reviews, and Profile. Alternatively, you can navigate by interacting with the icons positioned at the Appbar, located at the top of the screen. These icons are thoughtfully designed to assist you in easily exploring different parts of the app.'
    },
    {
      'question': 'How can I add a review for an item?',
      'answer': 'To add a review, navigate to the item you want to review and tap on the "Add Review" button (blue with a plus sign in it).  Choose between a Business or Restaurant, and fill out the form in the review dialog and submit.'
    },
    {
      'question': 'How do I view my reviews?',
      'answer': 'Your reviews can be viewed in the "My Reviews" section, accessible from the Profile screen.'
    },
    {
      'question': 'What is the "For You" section and how does it work?',
      'answer': 'The "For You" section provides you a place to find all of the best reviewed items!'
    },
    {
      'question': 'Can I edit or delete my reviews?',
      'answer': 'No, unfortunately you cannot edit or delete your reviews. This is why we ask you to leave honest and respectful reviews.'
    },
    {
      'question': 'Is there a way to chat with other users?',
      'answer': 'Yes, our app includes a chat feature. You can access it from the Chat button located at the top right of your home, map, profile, and for you screens in the app and start conversations with other users.'
    },
    {
      'question': 'How do I log-out of the app?',
      'answer': 'You can log out at any point by pressing on the settings icon located at the top right of most screens and pressing on the log out button'
    },
    // Add more FAQs here
  ];
}
