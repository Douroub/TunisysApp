import 'package:flutter/material.dart';
import 'package:tunisys_app/screens/client/dab_clt_details.dart';
import 'package:tunisys_app/screens/client/home_client.dart';
import 'package:tunisys_app/screens/login.dart';
import 'package:tunisys_app/screens/pre_login.dart';

class DabCltInfo extends StatefulWidget {
  final List<dynamic> dabsData;

  const DabCltInfo({Key? key, required this.dabsData}) : super(key: key);

  @override
  _DabCltInfoState createState() => _DabCltInfoState();
}

class _DabCltInfoState extends State<DabCltInfo> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> dabs = widget.dabsData;
    print('Rendering DABs: $dabs'); // Log to check if dabs are being passed

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF2D5D5),
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
            var deviceInfo = dab['deviceInfo'];
            var deviceStatus = dab['deviceStatus'];

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
                              'DAB name: ${deviceInfo['termName'] ?? 'N/A'}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Distance: -- km', // You can calculate and pass the distance here if needed
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Adresse: ${deviceInfo['deptName'] ?? 'N/A'}, ${deviceInfo['termAddr'] ?? 'N/A'}',
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
            );
          },
        ),
      ),
    );
  }

  String getOpenStatus(dynamic dab) {
    String beginTimeStr = dab['deviceInfo']['businessBegintime'] ?? '00:00:00';
    String endTimeStr = dab['deviceInfo']['businessEndtime'] ?? '23:59:59';
    bool isOpen = dab['deviceStatus']['isOpen'] ?? false;

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

    if (isOpen) {
      if (now.isBefore(endTime)) {
        int hoursUntilClose = endTime.difference(now).inHours;
        return 'Ouvert - ferme à ${endTimeStr.substring(0, 5)} h';
      } else if (endTime.difference(beginTime).inHours == 24) {
        return 'Toujours ouvert - 24h';
      }
    } else {
      return 'Fermé - ferme à ${endTimeStr.substring(0, 5)} h';
    }

    return 'Statut inconnu';
  }

  Color getOpenStatusColor(dynamic dab) {
    bool isOpen = dab['deviceStatus']['isOpen'] ?? false;
    return isOpen ? Colors.green : Colors.red;
  }
}
