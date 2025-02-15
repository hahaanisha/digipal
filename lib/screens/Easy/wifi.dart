import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class wifi extends StatefulWidget {
  const wifi({Key? key}) : super(key: key);

  @override
  _wifiState createState() => _wifiState();
}

class _wifiState extends State<wifi> {
  final List<bool> _isOpen = List.generate(5, (index) => false);

  final List<String> steps = [
    "Open Settings App",
    "Tap on Network & Internet",
    "Click on the wifi toggle ",
    "Select your desired WIFI",
    "Enter Password and press connect"
  ];

  final List<String> stepImages = [
    "assets/Wifistep1.png",
    "assets/Wifistep2.png",
    "assets/Wifistep3.png",
    "assets/Wifistep4.png",
    "assets/Wifistep5.png"
  ];

  /// Opens the contacts app (or dialer if direct opening is restricted)
  void _launchContactsApp() async {
    final Uri uri = Uri(scheme: "tel", path: ""); // Opens dialer/contacts
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open contacts app")),
      );
    }
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
              "Lets Get you Connected to a WIFI",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Follow these simple steps to connect your phone to a secure network",
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
                onPressed: _launchContactsApp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Try Now",
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
