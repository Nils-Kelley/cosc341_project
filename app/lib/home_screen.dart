import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  // Define your custom colors and typography
  final Color primaryColor = Color(0xFF3F51B5);
  final Color accentColor = Color(0xFFFFC107);
  final TextTheme appTextTheme = TextTheme(
    headline1: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    headline6: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    bodyText1: TextStyle(fontSize: 16),
    bodyText2: TextStyle(fontSize: 14),
  );


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: appTextTheme,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            String businessName = 'Restaurant Name $index';
            double rating = 4.8;
            String imageUrl = 'assets/$index.png';

            return GestureDetector(
              onTap: () {
                showBusinessPopup(context, businessName, rating, imageUrl);
              },
              child: Card(
                elevation: 4,
                margin: EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                      ),
                      child: Image.asset(
                        imageUrl,
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            businessName,
                            style: appTextTheme.headline6!.copyWith(
                              color: primaryColor, // Use your custom color
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                              Text(
                                ' $rating',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void showBusinessPopup(BuildContext context, String businessName, double rating, String imageUrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.9, // Adjust the height factor as needed
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Details',
                      style: appTextTheme.headline6!.copyWith(
                        color: primaryColor, // Use your custom color
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    imageUrl,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  businessName,
                  style: appTextTheme.headline6!.copyWith(
                    color: primaryColor, // Use your custom color
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 14,
                    ),
                    Text(
                      ' $rating',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Description:',
                  style: appTextTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: primaryColor, // Use your custom color
                  ),
                ),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed eget pulvinar leo. Fusce tincidunt mi sit amet orci vehicula, in tempor erat fringilla. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla facilisi. Vestibulum luctus urna sit amet sem hendrerit, in facilisis nisi consectetur.',
                  style: appTextTheme.bodyText2!.copyWith(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildDetailsTab(String businessName, double rating, String imageUrl) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            child: Image.asset(
              imageUrl,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 16),
          Text(
            businessName,
            style: appTextTheme.headline6!.copyWith(
              color: primaryColor, // Use your custom color
            ),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 14,
              ),
              Text(
                ' $rating',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Description:',
            style: appTextTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryColor, // Use your custom color
            ),
          ),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed eget pulvinar leo. Fusce tincidunt mi sit amet orci vehicula, in tempor erat fringilla. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla facilisi. Vestibulum luctus urna sit amet sem hendrerit, in facilisis nisi consectetur.',
            style: appTextTheme.bodyText2!.copyWith(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildReviewItem('John Doe', 4.5, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
          Divider(),
          _buildReviewItem('Jane Smith', 5.0, 'Excellent restaurant! I highly recommend it.'),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String name, double rating, String review) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: primaryColor, // Use your custom color
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(
        name,
        style: appTextTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 14,
              ),
              Text(
                ' $rating',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            review,
            style: appTextTheme.bodyText2!.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
