import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../screens/BottomNavbar.dart';
import 'signup.dart';

class LoginPager extends StatefulWidget {
  const LoginPager({Key? key}) : super(key: key);

  @override
  _LoginPagerState createState() => _LoginPagerState();
}

class _LoginPagerState extends State<LoginPager> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    _initializeTTS();
  }

  Future<void> _initializeTTS() async {
    _flutterTts = FlutterTts();

    await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.setLanguage("hi-IN");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  /// ✅ Speak after successful login
  Future<void> _speakWelcome() async {
    await _flutterTts.speak("डिजीपलमध्ये आपले स्वागत आहे");
  }

  /// ✅ Login Function
  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        String userUID = user.uid;

        // 🎤 Speak Welcome Message After Login
        _speakWelcome();

        // Navigate to Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavBarR(companyUID: userUID),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 10),
              const Text(
                'Sign in to access your account',
                style: TextStyle(fontSize: 16, color: Colors.black45),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  hintText: 'Enter your email',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(value: false, onChanged: (value) {}),
                      const Text('Remember me', style: TextStyle(color: Colors.black45)),
                    ],
                  ),
                  TextButton(
                    onPressed: () {}, // Add password reset logic here
                    child: const Text('Forget password?', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New Member?', style: TextStyle(color: Colors.black54)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPager()),
                      );
                    },
                    child: const Text('Register now', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
