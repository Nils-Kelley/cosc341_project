import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'home_screen.dart';
import 'for_you.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RateIt', // Set the app title to "RateIt"
      theme: ThemeData(
        primaryColor: Colors.blue, // Set the primary color to blue
        scaffoldBackgroundColor: Colors.white, // Set the background color to white
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue, // Set the app bar background color to blue
          centerTitle: true, // Center-align the title
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue), // Use blue as the primary color
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ForYouPage(),
    ProfileScreen(),


  // Add the "For You" page here
    // Add other screens here as needed
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Set the app bar background color to blue
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0), // Add left padding to "RateIt"
              child: Text(
                'RateIt', // Set the app title to "RateIt"
                style: TextStyle(
                  color: Colors.white, // Set title text color to white
                  fontSize: 20,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add horizontal padding to search bar
                child: Container(
                  height: 40, // Set the search bar's height
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20), // Make the search bar rounded
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.search,
                            color: Colors.grey, // Set the search icon color
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            style: TextStyle(color: Colors.black), // Set text color to black
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              hintStyle: TextStyle(color: Colors.grey), // Set hint text color
                              border: InputBorder.none, // Remove border
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem( // Add the "For You" page entry
            icon: Icon(Icons.star),
            label: 'For You',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),

          // Add other navigation bar items here as needed
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // Set the selected item color to blue
        onTap: _onItemTapped,
      ),
    );
  }
}


