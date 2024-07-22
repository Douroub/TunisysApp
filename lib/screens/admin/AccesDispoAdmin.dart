import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:tunisys_app/screens/admin/accesAdmin.dart';
import 'package:tunisys_app/screens/admin/dab_ad_details.dart';
import 'package:tunisys_app/screens/admin/home_admin.dart';
import 'package:tunisys_app/screens/login.dart';
import 'package:tunisys_app/screens/pre_login.dart';

class AccesDispoAdmin extends StatefulWidget {
  final List<dynamic> dabsData;
  const AccesDispoAdmin({Key? key, required this.dabsData}) : super(key: key);

  @override
  _AccesDispoAdminState createState() => _AccesDispoAdminState();
}

class _AccesDispoAdminState extends State<AccesDispoAdmin> {
  late List<dynamic> dabs;
  late double userLatitude = 0.0;
  late double userLongitude = 0.0;

  @override
  void initState() {
    super.initState();
    dabs = widget.dabsData;
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
    // Obtenir les heures de début et de fin d'ouverture
    String beginTimeStr = dab['deviceInfo']['businessBegintime'] ?? '00:00:00';
    String endTimeStr = dab['deviceInfo']['businessEndtime'] ?? '23:59:59';

    // Obtenir l'heure actuelle
    DateTime now = DateTime.now();
    DateTime beginTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(beginTimeStr.split(":")[0]),
      int.parse(beginTimeStr.split(":")[1]),
    );
    DateTime endTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(endTimeStr.split(":")[0]),
      int.parse(endTimeStr.split(":")[1]),
    );

    // Calculer le nombre d'heures jusqu'à la fermeture
    int hoursUntilClose = endTime.difference(now).inHours;
    bool isOpen = hoursUntilClose > 0;

    if (isOpen) {
      if (now.isBefore(endTime) && beginTime.isBefore(now)) {
        return 'Ouvert - ferme à ${endTimeStr.substring(0, 5)} h';
      } else if (endTime.difference(beginTime).inHours == 24) {
        return 'Toujours ouvert - 24h';
      }
    } else {
      return 'Fermé - ouvre à ${beginTimeStr.substring(0, 5)} h';
    }

    return 'Statut inconnu';
  }

  Color getOpenStatusColor(dynamic dab) {
    // Obtenir les heures de début et de fin d'ouverture
    String beginTimeStr = dab['deviceInfo']['businessBegintime'] ?? '00:00:00';
    String endTimeStr = dab['deviceInfo']['businessEndtime'] ?? '23:59:59';

    // Obtenir l'heure actuelle
    DateTime now = DateTime.now();
    DateTime beginTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(beginTimeStr.split(":")[0]),
      int.parse(beginTimeStr.split(":")[1]),
    );
    DateTime endTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(endTimeStr.split(":")[0]),
      int.parse(endTimeStr.split(":")[1]),
    );

    // Calculer le nombre d'heures jusqu'à la fermeture
    int hoursUntilClose = endTime.difference(now).inHours;

    return hoursUntilClose > 0 ? Colors.green : Colors.red;
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

  @override
  Widget build(BuildContext context) {
    print('Building widget');
    print('Dabs data: ${dabs.length} items');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF2D5D5),
        title: Text('DABs List'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              // Navigate to LoginScreen or perform logout action
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
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AccesAdmin(
                  dabsData: [],
                ),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: dabs.length,
          itemBuilder: (context, index) {
            var dab = dabs[index];
            print('Processing DAB: ${dab['deviceInfo']['termName']}');

            double latitude =
                double.tryParse(dab['deviceInfo']['latitude']) ?? 0.0;
            double longitude =
                double.tryParse(dab['deviceInfo']['longitude']) ?? 0.0;

            double distance = _calculateDistance(
              userLatitude,
              userLongitude,
              latitude,
              longitude,
            );
            int statusId =
                int.tryParse(dab['deviceStatus']['deviceStatusId']) ?? -1;
            Map<String, String> status = getDabStatus(statusId);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DabAdDetails(dab: dab),
                  ),
                );
              },
              child: Container(
                width: 400, // Set your desired width
                height: 180, // Set your desired height
                child: Card(
                  color:
                      Color(0xFFF2D5D5), // Set the background color of the card
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
                              'DAB name: ${dab['deviceInfo']['termName'] ?? 'N/A'}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Distance: ${distance.toStringAsFixed(2)} km', // Display calculated distance
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
                            SizedBox(height: 8),
                            Text(
                              'Etat: ${status['text']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: getStatusColor(status['color']!),
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
            );
          },
        ),
      ),
    );
  }
}
