import 'package:flutter/material.dart';
import 'package:digipal/auth/login.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  bool _showHomeScreen = false;

  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showHomeScreen = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showHomeScreen) {
      return const LoginPager();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          // width: MediaQuery.of(context).size.width * 0.5,  // 50% of screen width
          height: MediaQuery.of(context).size.height * 0.5, // 30% of screen height
          child: Image.asset(
            'assets/VESHACKIT.gif',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}