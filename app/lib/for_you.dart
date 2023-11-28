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
    Tab(text: 'Most Recent'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0), // Adjust the height as needed
          child: AppBar(
            elevation: 0, // Remove the shadow
            backgroundColor: Colors.white, // Set background color
            bottom: TabBar(
              tabs: tabs,
              onTap: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 4.0, // Set the indicator thickness
                  color: Colors.blue, // Set the indicator color
                ),
              ),
              labelStyle: TextStyle(
                fontSize: 16, // Set tab text font size
                fontWeight: FontWeight.bold, // Add font weight
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 16, // Set tab text font size
                fontWeight: FontWeight.normal, // Remove font weight
              ),
              labelColor: Colors.blue, // Set the text color of the selected tab
              unselectedLabelColor: Colors.grey, // Set the text color of unselected tabs
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Trending Screen
            Center(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                color: _selectedTabIndex == 0 ? Colors.blue : Colors.transparent,
                child: Text(
                  'Trending Content',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            // Most Recent Screen
            Center(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                color: _selectedTabIndex == 1 ? Colors.blue : Colors.transparent,
                child: Text(
                  'Most Recent Content',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
