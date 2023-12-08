import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'item_review.dart';
class ForYouPage extends StatefulWidget {
  const ForYouPage({
    Key? key,
  }) : super(key: key);

  @override
  _ForYouPageState createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage> {
  int _selectedTabIndex = 0;

  final List<Tab> tabs = <Tab>[
    Tab(text: 'Trending'),
  ];
List<dynamic> _trending =[];

  @override
  void initState() {
    super.initState();
    _fetchTrending();
  }


  Future<void> _fetchTrending() async {
    final String apiUrl = 'https://10.0.0.201:5050/trending'; // Replace with your actual backend URL
    final client = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    try {
      final request = await client.getUrl(Uri.parse(apiUrl));
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        setState(() {
          _trending = jsonDecode(responseBody);
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
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: TabBar(
              tabs: tabs,
              onTap: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              labelStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Trending Screen
            SingleChildScrollView(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trending Near You',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Check if _trending is empty
                  if (_trending.isEmpty)
                    Center(child: Text("No trending restaurants available"))
                  else
                    ..._trending.map((item) {
                      return RestaurantCard(
                        name: item['name'], // Make sure these keys match your JSON structure
                        rating: double.tryParse(item['avg_rating']) ?? 0.0,
                        imageUrl: item['imageUrl'] ?? 'assets/0.png',
                        onPressed: () {
                          _showBusinessPopup(
                            item['name'] ?? 'Unknown',
                            double.tryParse(item['avg_rating']) ?? 0.0,
                            item['imageUrl'] ?? 'assets/0.png',
                          );                        },
                      );
                    }).toList(),
                ],
              ),
            ),
            // Add other tabs if needed
          ],
        ),
      ),
    );
  }


  void _showBusinessPopup(String businessName, double rating, String imageUrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(            mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 24, // Adjust font size as needed
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
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
                  style: TextStyle(
                    fontSize: 24, // Adjust font size as needed
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
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
                  'Location:',
                  style: TextStyle(
                    fontSize: 18, // Adjust font size as needed
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  '1555 Banks Rd, Kelowna, BC V1X 7Y8',
                  style: TextStyle(
                    fontSize: 16, // Adjust font size as needed
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ItemReviewScreen(companyName: businessName),
                      ));
                    },
                    child: Text(
                      'View Reviews',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4, // Add elevation for a shadow effect
                    ),
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

class RestaurantCard extends StatelessWidget {
  final String name;
  final double rating;
  final String imageUrl;
  final VoidCallback onPressed;

  const RestaurantCard({
    required this.name,
    required this.rating,
    required this.imageUrl,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 4,
        margin: EdgeInsets.only(bottom: 16),
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
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String restaurantName;
  final String userName;
  final double rating;
  final String reviewText;
  final VoidCallback onPressed;

  const ReviewCard({
    required this.restaurantName,
    required this.userName,
    required this.rating,
    required this.reviewText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 4,
        margin: EdgeInsets.only(bottom: 16),
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
                  SizedBox(height: 8),
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
      ),
    );
  }
}
