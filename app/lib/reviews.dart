import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:io';
import 'auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';

class ReviewsPage extends StatefulWidget {
  final String reviewType;

  const ReviewsPage({Key? key, required this.reviewType}) : super(key: key);

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  double _rating = 0.0;
  List<String> _existingLocations = [];
  String? _selectedLocation;

  bool _showAdditionalFields = false;

  http.Client createHttpClient() {
    final ioClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return IOClient(ioClient);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _fetchExistingLocations(String name) async {
    final apiUrl = 'https://10.0.0.201:5050/reviews/existing-locations?name=$name';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final locations = jsonDecode(response.body);
        setState(() {
          _existingLocations = List<String>.from(locations);
        });
      } else {
        // Handle the case where fetching existing locations fails
        // Show an error message to the user

      }
    } catch (e) {
      // Handle network errors
      // Show an error message to the user
    }
  }

  Future<void> _submitReview(BuildContext context) async {
    final String apiUrl = 'https://10.0.0.201:5050/submit-review';
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      final customClient = createHttpClient();
      final request = http.Request('POST', Uri.parse(apiUrl));
      request.headers['Content-Type'] = 'application/json';

      final String? token = authProvider.token;
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      final reviewData = {
        'reviewType': widget.reviewType,
        'name': _nameController.text,
        'rating': _rating,
        'comment': _reviewController.text,
        'location': _selectedLocation,
      };

      if (_showAdditionalFields) {
        List<Location> locations = await locationFromAddress(
            '${_addressController.text}, ${_cityController.text}, ${_stateController.text}, ${_postalCodeController.text}, ${_countryController.text}'
        );
        double latitude = locations.first.latitude;
        double longitude = locations.first.longitude;

        reviewData.addAll({
          'address': _addressController.text,
          'postalCode': _postalCodeController.text,
          'city': _cityController.text,
          'state': _stateController.text,
          'country': _countryController.text,
          'latitude': latitude,
          'longitude': longitude
        });
      }

      request.body = jsonEncode(reviewData);
      final response = await customClient.send(request);
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        Navigator.pop(context); // Navigate back on success
      } else {
        // Handle failure case
      }
    } catch (e) {
      // Handle exceptions
    }
  }


  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.blue[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave a Review', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        elevation: 10,
        shadowColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Enter the ${widget.reviewType} name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[800]),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _nameController,
              onChanged: (name) {
                _fetchExistingLocations(name);
              },
              decoration: _inputDecoration('Enter name here'),
            ),
            SizedBox(height: 20),
            Text(
              'Select a Location (or Add a New One)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[800]),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedLocation,
              onChanged: (location) {
                setState(() {
                  _selectedLocation = location;
                  _showAdditionalFields = location == 'Add New Location';
                });
              },
              items: [
                for (String location in _existingLocations)
                  DropdownMenuItem<String>(
                    value: location,
                    child: Text(location),
                  ),
                DropdownMenuItem<String>(
                  value: 'Add New Location',
                  child: Text('Add New Location'),
                ),
              ],
            ),
            if (_showAdditionalFields) ...[
              SizedBox(height: 20),
              Text(
                'Address',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[800]),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _addressController,
                decoration: _inputDecoration('Enter address here'),
              ),
              SizedBox(height: 20),
              Text(
                'Postal Code',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[800]),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _postalCodeController,
                decoration: _inputDecoration('Enter postal code here'),
              ),
              SizedBox(height: 20),
              Text(
                'City',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[800]),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _cityController,
                decoration: _inputDecoration('Enter city here'),
              ),
              SizedBox(height: 20),
              Text(
                'State',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[800]),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _stateController,
                decoration: _inputDecoration('Enter state here'),
              ),
              SizedBox(height: 20),
              Text(
                'Country',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[800]),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _countryController,
                decoration: _inputDecoration('Enter country here'),
              ),
            ],
            SizedBox(height: 20),
            Text(
              'Your Rating',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[800]),
            ),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 0.5,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Your Feedback',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[800]),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _reviewController,
              maxLines: 5,
              decoration: _inputDecoration('Write your review here'),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _submitReview(context);
                },
                child: Text('Submit Review'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[800],
                  onPrimary: Colors.white,
                  shadowColor: Colors.blue[900],
                  elevation: 8,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}