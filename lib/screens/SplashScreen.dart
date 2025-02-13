import 'package:digipal/auth/login.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  bool _showHomeScreen = false; // Boolean to toggle between Splash and Home

  @override
  void initState() {
    super.initState();

    // Delay for 3 seconds then show the HomeScreen
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _showHomeScreen = true; // Set to true after delay
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showHomeScreen ? LoginPager() : buildSplashScreen(); // Show Home or Splash
  }

  Widget buildSplashScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/Logo.png', width: 400, height: 400), // Replace with your image
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}