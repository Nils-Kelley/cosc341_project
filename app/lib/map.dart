import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';

class MapScreen extends StatefulWidget {
  final String? selectedCategory;

  MapScreen({this.selectedCategory});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Location location = new Location();
  LatLng _currentLocation = LatLng(49.8863, -119.4966);
  Set<Circle> _circles = Set<Circle>();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationData currentLocation;
    try {
      currentLocation = await location.getLocation();
      setState(() {
        _currentLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
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
      fillColor: Colors.blue.withOpacity(0.5),
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
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: _currentLocation,
          zoom: 11.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        circles: _circles, // Add the circles set here
      ),
    );
  }
}
