import 'package:flutter/material.dart';
import 'package:tunisys_app/screens/admin/dab_ad_info.dart';
import 'package:tunisys_app/screens/admin/dab_details.dart';
import 'package:tunisys_app/screens/client/dab_info.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  @override
  __HomeAdminState createState() => __HomeAdminState();
}

class __HomeAdminState extends State<HomeAdmin> {
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
    'Monastir,Nabeul',
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
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              // Handle logout action, navigate to login page
              Navigator.pushReplacementNamed(context, '/login');
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DabAdInfo(),
                      ),
                    );
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
              onTap: () {
                // Handle automatic location
                setState(() {
                  selectedLocation = "Localisation automatique";
                });
                Navigator.of(context).pop();
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
