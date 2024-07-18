import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tunisys_app/screens/admin/dabs_ad_info.dart';
import 'package:tunisys_app/screens/login.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class DabAdDetails extends StatefulWidget {
  final dynamic dab;

  const DabAdDetails({Key? key, required this.dab}) : super(key: key);

  @override
  _DabAdDetailsState createState() => _DabAdDetailsState();
}

class _DabAdDetailsState extends State<DabAdDetails> {
  late double userLatitude = 0.0;
  late double userLongitude = 0.0;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      userLatitude = position.latitude;
      userLongitude = position.longitude;
    });
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Radius of the Earth in km
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  String getOpenStatus(dynamic dab) {
    String beginTimeStr = dab['deviceInfo']['businessBegintime'] ?? '00:00:00';
    String endTimeStr = dab['deviceInfo']['businessEndtime'] ?? '23:59:59';
    bool isOpen = false;

    DateTime now = DateTime.now();
    DateTime beginTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(beginTimeStr.split(":")[0]),
        int.parse(beginTimeStr.split(":")[1]));
    DateTime endTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(endTimeStr.split(":")[0]),
        int.parse(endTimeStr.split(":")[1]));

    int hoursUntilClose = endTime.difference(now).inHours;
    if (hoursUntilClose > 0) {
      isOpen = true;
    }

    if (endTime.difference(beginTime).inHours == 24) {
      return 'Toujours ouvert - 24h';
    } else if (isOpen) {
      return 'Ouvert - ferme à ${endTimeStr.substring(0, 5)}';
    } else {
      return 'Fermé - ferme à ${endTimeStr.substring(0, 5)}';
    }
  }

  Color getOpenStatusColor(dynamic dab) {
    String beginTimeStr = dab['deviceInfo']['businessBegintime'] ?? '00:00:00';
    String endTimeStr = dab['deviceInfo']['businessEndtime'] ?? '23:59:59';

    DateTime now = DateTime.now();
    DateTime beginTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(beginTimeStr.split(":")[0]),
        int.parse(beginTimeStr.split(":")[1]));
    DateTime endTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(endTimeStr.split(":")[0]),
        int.parse(endTimeStr.split(":")[1]));

    int hoursUntilClose = endTime.difference(now).inHours;

    if (hoursUntilClose > 0 || endTime.difference(beginTime).inHours == 24) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  Future<List<dynamic>> _fetchNearestDabs() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      var client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      var url =
          Uri.parse('https://172.28.3.163:8443/feelview/map/getNearestDevice');
      var request = await client.postUrl(url);
      request.headers.set('Content-Type', 'application/json');
      request.headers
          .set('Referer', 'https://172.28.3.163:8443/feelview/map/demo');
      request.add(utf8.encode(json.encode({
        'longitude': position.longitude.toString(),
        'latitude': position.latitude.toString(),
      })));
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();
      var jsonData = json.decode(responseBody);
      print(jsonData);

      return jsonData['data'];
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    var dab = widget.dab;

    // Calculer la distance entre l'utilisateur et le DAB
    double latitude = double.tryParse(dab['deviceInfo']['latitude']) ?? 0.0;
    double longitude = double.tryParse(dab['deviceInfo']['longitude']) ?? 0.0;
    double distance = _calculateDistance(
      userLatitude,
      userLongitude,
      latitude,
      longitude,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF2D5D5),
        title: Text('DAB Informations'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              // Navigate to LoginScreen or perform logout action
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(title: 'Log'),
                ),
              );
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () async {
            List<dynamic> dabsData = await _fetchNearestDabs();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DabAdInfo(
                  dabsData: dabsData,
                ),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: 400, // Set your desired width
              height: 150, // Set your desired height
              child: Card(
                color:
                    Color(0xFFF2D5D5), // Set the background color of the card
                elevation: 4, // Add elevation for shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Add border radius
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DAB name: ${dab['deviceInfo']['termName'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Distance: ${distance.toStringAsFixed(2)} km',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Adresse: ${dab['deviceInfo']['deptName'] ?? 'N/A'}, ${dab['deviceInfo']['location'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: getOpenStatus(dab),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: getOpenStatusColor(dab),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Icon(
                          Icons.location_on,
                          size: 30,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16), // Space between card and button
            SizedBox(
              width: 400, // Match the width of the card
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red, // Text and icon color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Add border radius
                  ),
                ),
                icon: Icon(Icons.map),
                label: Text("Lineariser"),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(title: 'Log'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Image.asset(
                'assets/maps.png', // Ensure you have this image in your assets folder
                height: 170,
                width: 330),
          ],
        ),
      ),
    );
  }
}
