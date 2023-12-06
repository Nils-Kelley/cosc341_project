import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final Color primaryColor = Color(0xFF3F51B5);
  final Color accentColor = Color(0xFFFFC107);
  final TextTheme appTextTheme = TextTheme(
    headline1: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    headline6: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    bodyText1: TextStyle(fontSize: 16),
    bodyText2: TextStyle(fontSize: 14),
  );

  late TabController _tabController; // Declare a TabController

  int _selectedTabIndex = 0; // Index of the selected tab
  List<dynamic> _reviews = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Initialize TabController
    _fetchReviews('business'); // Fetch initial reviews for the 'Business' tab
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of the TabController
    super.dispose();
  }

  Future<void> _fetchReviews(String reviewType) async {
    final String apiUrl = 'https://192.168.1.253:5050/reviews?type=$reviewType'; // Include selected tab in the URL
    final client = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    try {
      final request = await client.getUrl(Uri.parse(apiUrl));
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        setState(() {
          _reviews = jsonDecode(responseBody);
        });
      } else {
        print('Failed to load reviews');
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      print('An error occurred: $e');
      throw Exception('Failed to load reviews');
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: appTextTheme,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          shadowColor: Colors.blue[900],
          title: TabBar(
            controller: _tabController, // Assign TabController to the TabBar
            onTap: (index) {
              setState(() {
                _selectedTabIndex = index;
                // Fetch reviews based on the selected tab
                switch (index) {
                  case 0:
                    _fetchReviews('business');
                    break;
                  case 1:
                    _fetchReviews('restaurant');
                    break;
                }
              });
            },
            tabs: [
              Tab(text: 'Business'),
              Tab(text: 'Restaurant'),
            ],
          ),
        ),
        body: TabBarView( // Add a TabBarView
          controller: _tabController, // Assign TabController to the TabBarView
          children: [
            _buildReviewsTab('business'),
            _buildReviewsTab('restaurant'),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsTab(String reviewType) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var review in _reviews)
            _buildReviewCard(
              review['name'] ?? 'Unknown Business',
              (review['rating'] ?? 0.0).toDouble(),
              review['imageUrl'] ?? 'assets/2.png',
            ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String businessName, double rating, String imageUrl) {
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
                      color: primaryColor,
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
}
