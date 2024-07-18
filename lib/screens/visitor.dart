import 'package:flutter/material.dart';

class VisitorPage extends StatefulWidget {
  const VisitorPage({Key? key}) : super(key: key);

  @override
  _VisitorPageState createState() => _VisitorPageState();
}

class _VisitorPageState extends State<VisitorPage> {
  final TextEditingController emailController = TextEditingController();
  String? selectedBank;

  final List<String> banks = [
    'Banque Centrale de Tunisie (BCT)',
    'Amen Bank',
    'Arab Tunisian Bank (ATB)',
    'Banque de l\'Habitat (BH)',
    'Banque Internationale Arabe de Tunisie (BIAT)',
    'Banque Nationale Agricole (BNA)',
    'Banque Tuniso-Koweitienne (BTK)',
    'Banque Tuniso-Libyenne (BTL)',
    'Banque Zitouna',
    'Citibank',
    'Société Tunisienne de Banque (STB)',
    'Union Bancaire pour le Commerce et l\'Industrie (UBCI)',
    'Union Internationale de Banques (UIB)',
    'Attijari Bank',
    'Banque de Tunisie',
    'BTK Bank',
    'QNB Tunisia (Qatar National Bank)',
    'Wifak Bank',
    'Al Baraka Bank Tunisia',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/tunisys.png',
                height: 100,
              ),
              SizedBox(height: 40),
              TextField(
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
                  fillColor: Color.fromRGBO(120, 163, 195, 0.652),
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
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Handle start button press
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red.shade50,
                  backgroundColor:
                      Color.fromARGB(255, 214, 11, 11), // foreground
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Suivant ',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
