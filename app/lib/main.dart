import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'profile_screen.dart';
import 'home_screen.dart';
import 'for_you.dart';
import 'review_dialog.dart';
import 'signup_method.dart';
import 'settings_page.dart';
import 'map.dart';
import 'forum.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import the flutter_svg package
import 'chat_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'RateIt',
        theme: ThemeData(
          primaryColor: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue,
            centerTitle: true,
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
          useMaterial3: true,
        ),
        home: SignupMethod(),
      ),
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
    MapScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _showReviewDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReviewDialog();
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back button

        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0), // Adjust padding as needed
              child: SvgPicture.asset(
                'assets/logo.svg', // Path to your logo.svg image
                width: 40, // Adjust the width as needed
                height: 40, // Adjust the height as needed
                // You can also use other properties like color, alignment, etc. to style your logo.
              ),
            ),
            Text(
              'RateIt',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        actions: [
          _buildChatIcon(),
          _buildSettingsIcon(),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildReviewButton(),
      // Use a custom button
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildReviewButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            _showReviewDialog(context);
          },
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget _buildChatIcon() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ChatPage()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.message,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildSettingsIcon() {
    return IconButton(
      icon: Icon(
        Icons.settings,
        color: Colors.white,
        size: 30,
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 100,
      color: Colors.blue, // Set the background color to blue
// Set the desired height for the bottom navigation bar
      child: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavBarItem(
              icon: Icons.home,
              text: 'Home',
              index: 0,
            ),
            _buildNavBarItem(
              icon: Icons.star,
              text: 'Favorites',
              index: 1,
            ),
            SizedBox(width: 60), // Empty space for the FAB
            _buildNavBarItem(
              icon: Icons.map,
              text: 'Map',
              index: 2,
            ),
            _buildNavBarItem(
              icon: Icons.person,
              text: 'Profile',
              index: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem(
      {required IconData icon, required String text, required int index}) {
    return IconButton(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: _selectedIndex == index ? Colors.blue : Colors
                .grey, // Highlight the selected icon
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: _selectedIndex == index ? Colors.blue : Colors
                  .grey, // Highlight the selected text
            ),
          ),
        ],
      ),
      onPressed: () {
        _onItemTapped(index);
      },
    );
  }
}
