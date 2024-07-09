import 'package:flutter/material.dart';
import 'package:tunisys_app/screens/admin/home_admin.dart';
import 'package:tunisys_app/screens/login.dart';

class DabDetails extends StatefulWidget {
  const DabDetails({Key? key}) : super(key: key);

  @override
  _DabDetailsState createState() => _DabDetailsState();
}

class _DabDetailsState extends State<DabDetails> {
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
                builder: (context) => HomeAdmin(),
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
              height: 330, // Set your desired height
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
                            'Terminal Id : 002080',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Adresse: Ariana, Ville',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Cassettes Id: ----D',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Type: 200',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Currency: TND',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Loaded: 1000',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Remaining Notes : 937',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Total Notes : 937',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Remaining Cassette Cash TND  : 1874000',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Total Current Cash Amount TND : 1874000',
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
          ],
        ),
      ),
    );
  }
}
