/*import 'package:flutter/material.dart';
import 'package:tunisys_app/screens/client/dab_clt_details.dart';
import 'package:tunisys_app/screens/client/home_client.dart';
import 'package:tunisys_app/screens/login.dart';
import 'dart:convert';

class DabCltInfo extends StatefulWidget {
  final String dabsData;

  const DabCltInfo({Key? key, required this.dabsData}) : super(key: key);

  @override
  _DabCltInfoState createState() => _DabCltInfoState();
}

class _DabCltInfoState extends State<DabCltInfo> {
  late List<dynamic> dabs;

  @override
  void initState() {
    super.initState();
    dabs = json.decode(widget.dabsData)['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF2D5D5),
        title: Text('DAB Information'),
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
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeClient(),
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
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DabCltDetails(dab: dab),
                  ),
                );
              },
              child: Container(
                width: 400, // Set your desired width
                height: 150, // Set your desired height
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
                              'DAB name: ${dab['deviceInfo']['termName']}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Distance: --km', // You might want to calculate this if you have the user's location
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Adresse: ${dab['deviceInfo']['deptName']}, ${dab['deviceInfo']['location']}',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Ouvert: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: dab['deviceStatus']['isOpen']
                                        ? 'Toujours ouvert - 24h'
                                        : 'Ferme à 23h',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: dab['deviceStatus']['isOpen']
                                          ? Colors.green
                                          : Colors.red,
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
            );
          },
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:tunisys_app/screens/client/dab_clt_details.dart';
import 'package:tunisys_app/screens/client/home_client.dart';
import 'package:tunisys_app/screens/login.dart';

class DabCltInfo extends StatefulWidget {
  const DabCltInfo({Key? key}) : super(key: key);

  @override
  _DabCltInfoState createState() => _DabCltInfoState();
}

class _DabCltInfoState extends State<DabCltInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF2D5D5),
        title: Text('DAB Information'),
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
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeClient(),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DabCltDetails(
                  dab: null,
                ),
              ),
            );
          },
          child: Container(
            width: 400, // Set your desired width
            height: 150, // Set your desired height
            child: Card(
              color: Color(0xFFF2D5D5), // Set the background color of the card
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
                          'DAB name: -----',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Distance: --km',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Adresse: Ariana, Ville',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Ouvert: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: 'Ferme à 23h',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
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
        ),
      ),
    );
  }
}
