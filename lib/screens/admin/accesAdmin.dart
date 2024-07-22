import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tunisys_app/screens/admin/AccesCashAdmin.dart';
import 'package:tunisys_app/screens/admin/AccesDispoAdmin.dart';

class AccesAdmin extends StatefulWidget {
  final List<dynamic> dabsData;
  const AccesAdmin({Key? key, required this.dabsData}) : super(key: key);

  @override
  _AccesAdminState createState() => _AccesAdminState();
}

class _AccesAdminState extends State<AccesAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade50,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              // Handle logout action, navigate to login page
              Navigator.pushReplacementNamed(context, '/prelogin');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      List<dynamic> dabsData = await _fetchNearestDabs();
                      // Handle navigation to Cash Disponibilité
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccescashAdmin(
                            dabsData: dabsData,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.monetization_on,
                            size: 60,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Cash Disponibilité',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () async {
                      List<dynamic> dabsData = await _fetchNearestDabs();
                      // Handle navigation to ATM Status
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccesDispoAdmin(
                            dabsData: dabsData,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.trending_up,
                            size: 60,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'ATM Status',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
}
