import 'package:flutter/material.dart';
import 'package:tunisys_app/components/text_field.dart';
import 'package:tunisys_app/screens/admin/home_admin.dart';
import 'package:tunisys_app/screens/client/home_client.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required String title}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? errorMessage;

  void login() {
    String username = userController.text.trim();
    String password = passwordController.text.trim();

    // Check credentials
    if (username == "nizar" && password == "admin") {
      // Navigate to HomeAdmin
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeAdmin(),
        ),
      );
    } else if (username == "douroub" && password == "client") {
      // Navigate to HomeClient
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeClient(),
        ),
      );
    } else {
      setState(() {
        errorMessage = "Nom d’utilisateur ou mot de passe non valide";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 100.0),
                child: Image.asset(
                  'assets/tunisys.png',
                  width: 220,
                  height: 150,
                ),
              ),
              const SizedBox(height: 100),
              TextInput(
                controller: userController,
                label: "Nom d’utilisateur ",
              ),
              TextInput(
                controller: passwordController,
                label: "mot de passe",
                isPass: true,
              ),
              ElevatedButton(
                onPressed: login,
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 214, 11, 11),
                  ),
                ),
              ),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
