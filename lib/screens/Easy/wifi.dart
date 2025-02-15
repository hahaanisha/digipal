import 'dart:io'; // Import for platform detection
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

class Wifi extends StatefulWidget {
  const Wifi({Key? key}) : super(key: key);

  @override
  _WifiState createState() => _WifiState();
}

class _WifiState extends State<Wifi> {
  final List<bool> _isOpen = List.generate(5, (index) => false);

  final List<String> steps = [
    "Open Settings App",
    "Tap on Network & Internet",
    "Click on the WiFi toggle",
    "Select your desired WiFi",
    "Enter Password and press Connect"
  ];

  final List<String> stepImages = [
    "assets/Wifistep1.png",
    "assets/Wifistep2.png",
    "assets/Wifistep3.png",
    "assets/Wifistep4.png",
    "assets/Wifistep5.png"
  ];

  /// Opens the WiFi settings on Android & iOS
  Future<void> _openWifiSettings() async {
    if (Platform.isAndroid) {
      try {
        final intent = AndroidIntent(
          action: 'android.settings.WIFI_SETTINGS',
          flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
        );
        await intent.launch();
      } catch (e) {
        _showError("⚠️ Could not open WiFi settings on Android.");
      }
    } else if (Platform.isIOS) {
      // Different iOS versions require different settings URLs
      final Uri url = Uri.parse("App-Prefs:root=WIFI");
      final Uri altUrl = Uri.parse("App-Prefs:root=Settings");

      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else if (await canLaunchUrl(altUrl)) {
        await launchUrl(altUrl);
      } else {
        _showError("⚠️ Could not open WiFi settings on iOS.");
      }
    } else {
      _showError("⚠️ This feature is not supported on your device.");
    }
  }

  /// Show an error message as a Snackbar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "DigiPal",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "📡 Let's Get You Connected to WiFi",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Follow these simple steps to connect your phone to a WiFi network.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ExpansionTile(
                      title: Text(
                        steps[index],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onExpansionChanged: (isOpen) {
                        setState(() {
                          _isOpen[index] = isOpen;
                        });
                      },
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            stepImages[index],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _openWifiSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "📶 Open WiFi Settings",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
