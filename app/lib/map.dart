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
      _updateCircle(); // Update circle with the default location
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

  Widget _buildCategoryButton(String category) {
    bool isSelected = _selectedCategory == category;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              isSelected ? Colors.white : Colors.blue,
            ),
            elevation: MaterialStateProperty.all<double>(0.0),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
            ),
          ),
          onPressed: () => setState(() {
            _selectedCategory = category.toLowerCase();
            print('Button Press - Selected Category: $_selectedCategory');
            _loadMarkersByCategory(_selectedCategory);
          }),
          child: RichText(
            text: TextSpan(
              text: category,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue : Colors.white,
                decoration: isSelected ? TextDecoration.underline : TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }





  Future<void> _loadMarkersByCategory(String? category) async {
    _markers.clear(); // Clear existing markers
    if (category == null) {
      return; // If no category is selected, do not load any markers
    }

    try {
      final client = createHttpClient();
      String apiUrl = 'https://10.0.0.201:5050/reviews/locations/$category';
      print('API Request URL: $apiUrl');
      final response = await client.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> locations = json.decode(response.body);
        print('Received locations: $locations');

        final Set<Marker> newMarkers = locations.map<Marker?>((location) {
          final double latitude = location['latitude'] != null
              ? double.tryParse(location['latitude']) ?? 0.0
              : 0.0;
          final double longitude = location['longitude'] != null
              ? double.tryParse(location['longitude']) ?? 0.0
              : 0.0;

          // Skip marker creation if coordinates are invalid
          if (latitude == 0.0 || longitude == 0.0) return null;

          final LatLng latLng = LatLng(latitude, longitude);
          final String name = location['name'] ?? 'Unknown'; // Fallback for 'name'
          final double averageRating = location['rating'] != null
              ? double.tryParse(location['rating'].toString()) ?? 0.0
              : 0.0; // Parse rating and provide a fallback

          return Marker(
            markerId: MarkerId('marker_${location['review_id']}'),
            position: latLng,
            infoWindow: InfoWindow(
              title: name != 'Unknown' ? name : 'Rating: $averageRating', // Display name if available, otherwise show rating
              snippet: name != 'Unknown' ? 'Rating: $averageRating' : null, // Show rating snippet if name is available
            ),
          );
        }).whereType<Marker>().toSet(); // Filter out null markers

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
        backgroundColor: Colors.blue, // Set background color to blue
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
}
