import 'package:flutter/material.dart';
import 'package:tunisys_app/screens/client/home_client.dart';
import 'package:tunisys_app/screens/login.dart';

class DabCltDetails extends StatefulWidget {
  const DabCltDetails({Key? key}) : super(key: key);

  @override
  _DabCltDetailsState createState() => _DabCltDetailsState();
}

class _DabCltDetailsState extends State<DabCltDetails> {
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
