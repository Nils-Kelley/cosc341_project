import 'package:flutter/material.dart';

class ForYouPage extends StatefulWidget {
  const ForYouPage({Key? key}) : super(key: key);

  @override
  _ForYouPageState createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage> {
  int _selectedTabIndex = 0;

  final List<Tab> tabs = <Tab>[
    Tab(text: 'Trending'),
    Tab(text: 'Best Reviews'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0), // Reduced the height
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: TabBar(
              tabs: tabs,
              onTap: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.8),
                    Colors.blue.withOpacity(0.5),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              labelStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Trending Screen
            SingleChildScrollView(
              padding: EdgeInsets.all(12), // Reduced padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trending Restaurants',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8), // Reduced spacing
                  RestaurantCard(
                    name: 'Restaurant 1',
                    rating: 4.5,
                    imageUrl: 'assets/1.png',
                  ),
                  RestaurantCard(
                    name: 'Restaurant 2',
                    rating: 4.2,
                    imageUrl: 'assets/2.png',
                  ),
                ],
              ),
            ),
            // Most Recent Screen
            SingleChildScrollView(
              padding: EdgeInsets.all(12), // Reduced padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Most Recent Reviews',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8), // Reduced spacing
                  ReviewCard(
                    restaurantName: 'Restaurant 1',
                    userName: 'User 1',
                    rating: 4.5,
                    reviewText: 'Great food and service!',
                  ),
                  ReviewCard(
                    restaurantName: 'Restaurant 2',
                    userName: 'User 2',
                    rating: 4.2,
                    reviewText: 'Awesome experience!',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final String name;
  final double rating;
  final String imageUrl;

  const RestaurantCard({
    required this.name,
    required this.rating,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16), // Reduced spacing
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
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String restaurantName;
  final String userName;
  final double rating;
  final String reviewText;

  const ReviewCard({
    required this.restaurantName,
    required this.userName,
    required this.rating,
    required this.reviewText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16), // Reduced spacing
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Review for $restaurantName',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
                SizedBox(height: 8), // Reduced spacing
                Text(
                  'Description:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  reviewText,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
