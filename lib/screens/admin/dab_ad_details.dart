import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tunisys_app/screens/login.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tunisys_app/screens/pre_login.dart';

class DabAdDetails extends StatefulWidget {
  final dynamic dab;

  const DabAdDetails({Key? key, required this.dab}) : super(key: key);

  @override
  _DabAdDetailsState createState() => _DabAdDetailsState();
}

class _DabAdDetailsState extends State<DabAdDetails> {
  double? userLatitude;
  double? userLongitude;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        userLatitude = position.latitude;
        userLongitude = position.longitude;
        isLoading = false; // Location has been obtained
      });
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        isLoading = false; // Even if there's an error, stop loading
      });
    }
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
    String beginTimeStr = dab['deviceInfo']?['businessBegintime'] ?? '00:00:00';
    String endTimeStr = dab['deviceInfo']?['businessEndtime'] ?? '23:59:59';
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
    String beginTimeStr = dab['deviceInfo']?['businessBegintime'] ?? '00:00:00';
    String endTimeStr = dab['deviceInfo']?['businessEndtime'] ?? '23:59:59';

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

  Map<String, String> getDabStatus(int statusId) {
    switch (statusId) {
      case 0:
        return {'text': 'Normal', 'color': 'green'};
      case 1:
        return {'text': 'UNKNOWN', 'color': 'gray'};
      case 2:
        return {'text': 'PARTIAL FAULT', 'color': 'orange'};
      case 3:
        return {'text': 'WARNING', 'color': 'yellow'};
      case 4:
        return {'text': 'MAINTENANCE', 'color': 'blue'};
      case 6:
        return {'text': 'FAULT', 'color': 'red'};
      default:
        return {'text': 'UNKNOWN', 'color': 'gray'};
    }
  }

  Color getStatusColor(String color) {
    switch (color) {
      case 'green':
        return Colors.green;
      case 'gray':
        return Colors.grey;
      case 'orange':
        return Colors.orange;
      case 'yellow':
        return Colors.yellow;
      case 'blue':
        return Colors.blue;
      case 'red':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getCashAvailable(dynamic dab) {
    List<dynamic> boxStatusDetails =
        dab['deviceStatus']['boxStatusDetail'] != null
            ? jsonDecode(dab['deviceStatus']['boxStatusDetail'])
            : [];

    for (var boxStatus in boxStatusDetails) {
      // Debug print for bd and blmc
      print('bd: ${boxStatus['bd']}, blmc: ${boxStatus['blmc']}');

      // Check if bd is not empty and not equal to '-'
      if (boxStatus['bd'] != null &&
          boxStatus['bd'].isNotEmpty &&
          boxStatus['bd'] != '-') {
        return boxStatus['blmc'] ?? '0';
      }
    }
    return '0';
  }

  @override
  Widget build(BuildContext context) {
    var dab = widget.dab;

    double latitude =
        double.tryParse(dab['deviceInfo']?['latitude'] ?? '0.0') ?? 0.0;
    double longitude =
        double.tryParse(dab['deviceInfo']?['longitude'] ?? '0.0') ?? 0.0;

    double distance = userLatitude != null && userLongitude != null
        ? _calculateDistance(userLatitude!, userLongitude!, latitude, longitude)
        : 0.0;

    int statusId = int.tryParse(dab['deviceStatus']['deviceStatusId']) ?? -1;
    Map<String, String> status = getDabStatus(statusId);

    String cashAvailable = getCashAvailable(dab);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF2D5D5),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PreLoginPage(),
                ),
              );
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    width: 400, // Set your desired width
                    height: 220, // Set your desired height
                    child: Card(
                      color: Color(
                          0xFFF2D5D5), // Set the background color of the card
                      elevation: 4, // Add elevation for shadow
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Add border radius
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'DAB name: ${dab['deviceInfo']?['termName'] ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  userLatitude != null && userLongitude != null
                                      ? 'Distance: ${distance.toStringAsFixed(2)} km'
                                      : 'Calcul de la distance...',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Adresse: ${dab['deviceInfo']?['deptName'] ?? 'N/A'}, ${dab['deviceInfo']?['location'] ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Etat: ${status['text']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: getStatusColor(status['color']!),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Cash disponible: $cashAvailable DT',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
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
