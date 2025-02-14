import 'package:flutter/material.dart';

import 'CallHome.dart';
import 'call.dart';

class CallsMessagesPage extends StatelessWidget {
  const CallsMessagesPage({Key? key}) : super(key: key);

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("About Easy Level"),
        content: const Text(
          "The Easy Level introduces you to digital basics. "
              "Learn how to type, navigate a smartphone, and communicate through calls and messages.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Got it!"),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard({
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.purple.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "DigiPal",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
        leading: const Icon(Icons.account_circle, color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Module 3: Calls & Messages 🎉",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "Let's learn how to contact others",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            _buildModuleCard(
              title: "How to Make a Call?",
              description:
              "Make calls with confidence! Dial effortlessly, manage contacts, and stay connected.",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CallTutorialPage()),
                );
              },
            ),
            _buildModuleCard(
              title: "How to Save a Contact",
              description:
              "Save contacts with ease! Organize, edit, and keep your connections at your fingertips.",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CallsMessagesPage()),
                );
              },
            ),
            _buildModuleCard(
              title: "How to Send Messages",
              description:
              "Send messages effortlessly! Stay connected with quick, clear, and confident texting.",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CallsMessagesPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
