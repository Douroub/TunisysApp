import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:tunisys_app/screens/client/home_client.dart';

class VisitorPage extends StatefulWidget {
  const VisitorPage({Key? key}) : super(key: key);

  @override
  _VisitorPageState createState() => _VisitorPageState();
}

class _VisitorPageState extends State<VisitorPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  String? selectedBank;

  final List<String> banks = [
    'BCT',
    'Amen',
    'ATB',
    'BH',
    'BIAT',
    'BNA',
    'BTK',
    'BTL',
    'Zitouna',
    'Citibank',
    'STB',
    'UBCI',
    'UIB',
    'Attijari',
    'Banque de Tunisie',
    'BTK',
    'QNB Tunisia',
    'Wifak',
    'Al Baraka',
  ];

  Future<void> saveDataToTextFile() async {
    try {
      // Get the current directory of the project
      Directory projectDirectory = Directory.current;
      String outputFilePath = '${projectDirectory.path}/visitor_data.txt';

      String dataToSave =
          'Email: ${emailController.text}, Numéro téléphone: ${phoneNumberController.text}, Banque: ${selectedBank ?? ''}\n';

      File file = File(outputFilePath);
      await file.writeAsString(dataToSave, mode: FileMode.append);

      print('Data saved to $outputFilePath');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade50,
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/tunisys.png',
                  height: 100,
                ),
                SizedBox(height: 40),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.red.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Numéro téléphone',
                    filled: true,
                    fillColor: Colors.red.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un numéro de téléphone';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedBank,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedBank = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.red.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: banks.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: Text('Sélectionner votre Banque'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner une banque';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await saveDataToTextFile();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeClient(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.red.shade50,
                    backgroundColor: Color.fromARGB(255, 214, 11, 11),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Suivant',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
