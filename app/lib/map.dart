import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http/io_client.dart';

class MapScreen extends StatefulWidget {
  final String? selectedCategory;

  MapScreen({this.selectedCategory});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Location location = Location();
  Set<Circle> _circles = Set<Circle>();

  LatLng _currentLocation = LatLng(49.8863, -119.4966);
  Set<Marker> _markers = Set<Marker>();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _selectedCategory = widget.selectedCategory;
    print('initState - Selected Category: $_selectedCategory'); // Debugging
  }

  Future<void> _getCurrentLocation() async {
    LocationData? currentLocation;
    try {
      currentLocation = await location.getLocation();
      setState(() {
        _currentLocation =
            LatLng(currentLocation!.latitude!, currentLocation.longitude!);
        _updateCircle();
      });
      _goToCurrentLocation();
    } catch (e) {
      print(e);
      _updateCircle(); // Update circle with default location
    }
  }

  void _updateCircle() {
    _circles.clear();
    _circles.add(Circle(
      circleId: CircleId("user_location"),
      center: _currentLocation,
      radius: 1000, // radius in meters (1 km)
      fillColor: Colors.blue.withOpacity(0.2), // Adjust opacity
      strokeColor: Colors.blue,
      strokeWidth: 2,
    ));
  }


  Future<void> _goToCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: _currentLocation,
        zoom: 11.0,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back button
        actions: <Widget>[
          _buildCategoryButton('Businesses'),
          _buildCategoryButton('Restaurants'),
        ],
        elevation: 0, // Remove the app bar's shadow
        backgroundColor: Colors.white, // Customize the background color
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: _currentLocation,
          zoom: 11.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          _loadMarkersByCategory(_selectedCategory); // Load markers initially
        },
        markers: _markers,
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FractionallySizedBox(
          widthFactor: 1.0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: _selectedCategory == category
                  ? Colors.blue
                  : Colors.grey.withOpacity(0.3), // Adjust opacity
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () => setState(() {
              _selectedCategory = category;
              print('Button Press - Selected Category: $_selectedCategory'); // Debugging
              _loadMarkersByCategory(_selectedCategory); // Load markers when category is changed
            }),
            child: Text(
              category,
              style: TextStyle(fontSize: 16), // Set the font size here
            ),
          ),
        ),
      ),
    );
  }


  Future<void> _loadMarkersByCategory(String? category) async {
    try {
      final client = createHttpClient();
      String apiUrl = 'https://192.168.1.253:5050/reviews/existing-locations?category=$category';
      print('API Request URL: $apiUrl');
      final response = await client.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> locations = json.decode(response.body);

        final Set<Marker> newMarkers = locations.map<Marker>((location) {
          final double latitude = double.parse(location['latitude'] ?? '0.0');
          final double longitude = double.parse(location['longitude'] ?? '0.0');
          final LatLng latLng = LatLng(latitude, longitude);
          final String name = location['address'];
          final double averageRating = double.parse(location['average_rating'] ?? '0.0');

          return Marker(
            markerId: MarkerId(name),
            position: latLng,
            infoWindow: InfoWindow(
              title: name,
              snippet: 'Average Rating: $averageRating',
            ),
          );
        }).toSet();

        setState(() {
          _markers = newMarkers;
        });

        print('Markers loaded successfully.');
      } else {
        print('Failed to load markers. Status Code: ${response.statusCode}');
        throw Exception('Failed to load markers');
      }
    } catch (err) {
      print('Error loading markers: $err');
    }
  }


  // Create a custom http client
  http.Client createHttpClient() {
    final ioClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true; // Bypass handshake error
    return IOClient(ioClient);
  }
}
