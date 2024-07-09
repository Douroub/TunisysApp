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
  bool showAmountField = false;
  TextEditingController amountController = TextEditingController();

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

  get addressController => null;

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
                        builder: (context) => DabInfo(),
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
                // Handle manual address input
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
