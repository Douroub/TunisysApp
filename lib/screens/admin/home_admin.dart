import 'package:flutter/material.dart';
import 'package:tunisys_app/screens/admin/dab_ad_info.dart';
import 'package:tunisys_app/screens/admin/dab_details.dart';
import 'package:tunisys_app/screens/client/dab_info.dart';
import 'package:tunisys_app/screens/login.dart';
// Assuming DabInfo screen is imported from this file

class HomeAdmin extends StatefulWidget {
  HomeAdmin({Key? key}) : super(key: key);

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(title: 'Log'),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DabAdInfo(),
                    ),
                  );
                },
                child: const Text(
                  'DABINFO',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              // Add other widgets for your admin home screen
            ],
          ),
        ),
      ),
    );
  }
}
