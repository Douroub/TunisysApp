import 'package:flutter/material.dart';
import 'package:tunisys_app/screens/login.dart';
import 'package:tunisys_app/screens/visitor.dart';

class PreLoginPage extends StatefulWidget {
  const PreLoginPage({Key? key}) : super(key: key);

  @override
  _PreLoginPageState createState() => _PreLoginPageState();
}

class _PreLoginPageState extends State<PreLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/tunisys.png',
              height: 100,
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OptionButton(
                  icon: Icons.account_balance,
                  label: 'Utilisateur',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(
                          title: '',
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(width: 20),
                OptionButton(
                  icon: Icons.person,
                  label: 'Visiteur',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VisitorPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  OptionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 214, 11, 11),
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(20),
            child: Icon(
              icon,
              size: 50,
              color: Color.fromARGB(255, 214, 11, 11),
            ),
          ),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 214, 11, 11),
            ),
          ),
        ],
      ),
    );
  }
}
