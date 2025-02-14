import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SaveContactPage extends StatefulWidget {
  const SaveContactPage({Key? key}) : super(key: key);

  @override
  _SaveContactPageState createState() => _SaveContactPageState();
}

class _SaveContactPageState extends State<SaveContactPage> {
  final List<bool> _isOpen = List.generate(5, (index) => false);

  final List<String> steps = [
    "Open Phones App",
    "Tap on Contacts",
    "Click on 'Create new contacts' ",
    "Add neccessary details",
    "Save the Contact"
  ];

  final List<String> stepImages = [
    "assets/SCstep1.png",
    "assets/SCstep2.png",
    "assets/SCstep3.png",
    "assets/SCstep4.png",
    "assets/SCstep5.png"
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
              "How to Save a Contact 📞",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Follow these simple steps to save a contact on your phone.",
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
