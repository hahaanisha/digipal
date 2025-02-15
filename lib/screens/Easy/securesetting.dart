import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'wifi.dart';

class SafetyGuidePage extends StatelessWidget {
   SafetyGuidePage({Key? key}) : super(key: key);

  final List<String> safetySteps = [
    "🔒 Set a Strong Screen Lock",
    "🔍 Enable Find My Device",
    "📵 Avoid Public WiFi for Sensitive Tasks",
    "📲 Keep Software & Apps Updated",
    "🚫 Restrict App Permissions",
    "🔑 Use Two-Factor Authentication",
    "🚨 Be Aware of Phishing & Scams"
  ];

  final List<String> stepDetails = [
    "Use a PIN, pattern, or biometric lock (fingerprint/face unlock) to secure your phone from unauthorized access.",
    "Activate Find My Device (Android) or Find My iPhone (iOS) to locate your phone in case it's lost or stolen.",
    "Avoid using public WiFi for banking or sensitive transactions. Use a VPN for secure browsing.",
    "Keep your phone's software and apps updated to patch security vulnerabilities.",
    "Check app permissions regularly. Disable unnecessary access to your location, contacts, or camera.",
    "Enable 2FA on important accounts like Google, WhatsApp, and banking apps for added security.",
    "Never click on unknown links in emails/SMS. Avoid downloading apps from untrusted sources."
  ];

  /// Opens a YouTube tutorial for additional learning
  void _openTutorial() async {
    final Uri url = Uri.parse("https://youtu.be/PXJ3NxUoaLg?feature=shared");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("⚠️ Could not open tutorial.");
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
          "DigiPal - Phone Security Guide",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      drawer: const DigiPalNavBar(), // Custom navigation bar
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🛡️ Secure Your Phone Like a Pro!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Follow these essential security steps to keep your phone safe from threats.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: safetySteps.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ExpansionTile(
                      title: Text(
                        safetySteps[index],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            stepDetails[index],
                            style: const TextStyle(fontSize: 16),
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
              child: ElevatedButton.icon(
                onPressed: _openTutorial,
                icon: const Icon(Icons.play_circle_fill, color: Colors.white),
                label: const Text(
                  "📺 Watch Video Tutorial",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Navigation Drawer for DigiPal
class DigiPalNavBar extends StatelessWidget {
  const DigiPalNavBar({Key? key}) : super(key: key);

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.purple),
            child: Text(
              "📱 DigiPal",
              style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.wifi, color: Colors.purple),
            title: const Text("WiFi Connection Guide"),
            onTap: () {
              _navigateTo(context, const Wifi()); // Replace with actual WiFi page
            },
          ),
          ListTile(
            leading: const Icon(Icons.security, color: Colors.purple),
            title: const Text("Phone Security Guide"),
            onTap: () {
              Navigator.pop(context); // Stay on the same page
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.purple),
            title: const Text("Settings"),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text("Logout"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
