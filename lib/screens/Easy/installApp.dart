import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'securesetting.dart';
import 'wifi.dart';

class AppSearchPage extends StatefulWidget {
  const AppSearchPage({Key? key}) : super(key: key);

  @override
  _AppSearchPageState createState() => _AppSearchPageState();
}

class _AppSearchPageState extends State<AppSearchPage> {
  final TextEditingController _appController = TextEditingController();

  /// Opens the Play Store with the entered app name
  Future<void> _openPlayStore() async {
    String appName = _appController.text.trim();
    if (appName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please enter an app name!")),
      );
      return;
    }

    String playStoreUrl = "https://play.google.com/store/search?q=$appName&c=apps";

    if (await canLaunchUrl(Uri.parse(playStoreUrl))) {
      await launchUrl(Uri.parse(playStoreUrl), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Could not open Play Store.")),
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
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🔍 Search & Open Apps on Play Store",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Enter the app name below and open its Play Store page instantly!",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _appController,
              decoration: InputDecoration(
                labelText: "Enter App Name",
                hintText: "e.g., WhatsApp, Instagram",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.search, color: Colors.purple),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openPlayStore,
                icon: const Icon(Icons.open_in_new, color: Colors.white),
                label: const Text(
                  "🔗 Open Play Store",
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

