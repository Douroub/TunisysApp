import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tunisys_app/screens/client/dabs_clt_info.dart';

class HomeClient extends StatefulWidget {
  const HomeClient({Key? key}) : super(key: key);

  @override
  _HomeClientState createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
  String? selectedCity;
  String? selectedOperation;
  String? selectedLocation;
  bool showAmountField = false;
  TextEditingController amountController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final List<String> cities = [
    'Ariana',
    'Béja',
    'Ben Arous',
    'Bizerte',
    'Gabès',
    'Gafsa',
    'Jendouba',
    'Kairouan',
    'Kasserine',
    'Kebili',
    'Kef',
    'Mahdia',
    'Manouba',
    'Médenine',
    'Monastir',
    'Nabeul',
    'Sfax',
    'Sidi Bouzid',
    'Siliana',
    'Sousse',
    'Tataouine',
    'Tozeur',
    'Tunis',
    'Zaghouan'
  ]; // Add your cities here
  final List<String> operations = ['Retrais', 'Change', 'Dépôt'];

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/map.png', // Ensure you have this image in your assets folder
                height: 150,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    _showCitySelectionDialog(context);
                  },
                  child: Text(selectedCity ?? 'Ville'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(120, 163, 195, 0.652),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    _showLocationOptions(context);
                  },
                  child: Text(selectedLocation ?? 'Localisation'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(120, 163, 195, 0.652),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    _showOperationSelectionDialog(context);
                  },
                  child: Text(selectedOperation ?? "Type d'opération"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(120, 163, 195, 0.652),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              if (showAmountField) ...[
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: TextField(
                    controller: amountController,
                    decoration: InputDecoration(
                      labelText: 'Montant',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      filled: true,
                      fillColor: Color.fromRGBO(120, 163, 195, 0.652),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    _navigateToDabInfo(context);
                  },
                  child: Text('Valider'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCitySelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sélectionner une ville'),
          content: Container(
            width: double.minPositive,
            height: 300, // Ajustez la hauteur selon vos besoins
            child: ListView(
              children: cities.map((city) {
                return ListTile(
                  title: Text(city),
                  onTap: () {
                    setState(() {
                      selectedCity = city;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showOperationSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Sélectionner le type d'opération"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: operations.map((operation) {
              return ListTile(
                title: Text(operation),
                onTap: () {
                  setState(() {
                    selectedOperation = operation;
                    showAmountField = operation == 'Retrais';
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showLocationOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Utiliser la localisation automatique'),
              onTap: () async {
                Navigator.of(context)
                    .pop(); // Fermer le modal avant de commencer à obtenir la localisation
                await _determinePosition();
              },
            ),
            ListTile(
              leading: Icon(Icons.edit_location),
              title: Text('Entrer une adresse manuellement'),
              onTap: () {
                Navigator.of(context).pop();
                _showManualAddressDialog(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, don't continue.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, don't continue.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks[0];

    setState(() {
      selectedLocation =
          "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
    });

    // Print latitude and longitude in console
    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
  }

  Future<List<dynamic>> _fetchNearestDabs(double amount) async {
    try {
      //Ma position actuelle
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print(
          'User Position: Latitude - ${position.latitude}, Longitude - ${position.longitude}');

      //Client HTTP
      var client = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      var url =
          Uri.parse('https://172.28.3.163:8443/feelview/map/getNearestDevice');

      //Requete
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
      print('Response Data: $jsonData');

      if (jsonData == null || jsonData['data'] == null) {
        print('No data received from server.');
        return [];
      }
      // Filtrer les DABs pour l'opération de retrait
      List<dynamic> filteredDabs = jsonData['data'];
      if (selectedOperation == 'Retrais') {
        filteredDabs = jsonData['data'].where((dab) {
          try {
            var boxStatusDetail =
                json.decode(dab['deviceStatus']['boxStatusDetail']);
            for (var boxStatus in boxStatusDetail) {
              if (boxStatus['bd'] != null &&
                  boxStatus['bd'].isNotEmpty &&
                  boxStatus['bd'] != '-') {
                double dabAmount =
                    double.tryParse(boxStatus['blmc'].toString()) ?? 0.0;
                if (dabAmount >= amount) {
                  return true;
                }
              }
            }
          } catch (e) {
            print('Error parsing boxStatusDetail: $e');
            return false;
          }
          return false;
        }).toList();
      }
      print('Filtered and Sorted DABs: $filteredDabs');
      return filteredDabs;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  void _navigateToDabInfo(BuildContext context) async {
    double amount = double.tryParse(amountController.text) ?? 0.0;
    List<dynamic> dabsData = await _fetchNearestDabs(amount);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DabCltInfo(
          dabsData: dabsData,
        ),
      ),
    );
  }

  void _showManualAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Entrer une adresse'),
          content: TextField(
            controller: addressController,
            decoration: InputDecoration(
              hintText: 'Adresse',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedLocation = addressController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
