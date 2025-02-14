import 'package:flutter/material.dart';

import 'CallHome.dart';
import 'Typing.dart';

class EasyLevelPage extends StatelessWidget {
  const EasyLevelPage({Key? key}) : super(key: key);

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
    required String imagePath,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 80,  // Increased size
                height: 80, // Increased size
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centered content
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Welcome to the Easy Level 🎉",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "Let's Get You Started with the Basics",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              _buildModuleCard(
                title: "Module 1: Basic Typing",
                description:
                "Learn to type with ease! Master the keyboard, improve speed, and gain confidence.",
                imagePath: "assets/easyTyping.png",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TypingPage()),
                  );
                },
              ),
              _buildModuleCard(
                title: "Module 2: Smartphone",
                description:
                "Get familiar with your smartphone—understand icons, navigate menus, and adjust settings.",
                imagePath: "assets/smartPhone.png",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CallsMessagesPage()),
                  );
                },
              ),
              _buildModuleCard(
                title: "Module 3: Calls & Messages",
                description:
                "Get familiar with your smartphone—understand icons, navigate menus, and adjust settings.",
                imagePath: "assets/call.png",
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
      ),

    );
  }
}
