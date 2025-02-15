import 'package:flutter/material.dart';

import 'EmailPage.dart';

class MediumLevelPage extends StatelessWidget {
  const MediumLevelPage({Key? key}) : super(key: key);

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("About Medium Level"),
        content: const Text(
          "The Medium Level helps you build confidence with everyday digital tasks. "
              "Learn how to browse safely, use online banking, and manage emails effectively.",
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
          color: Colors.amber.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 80,
                height: 80,
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Welcome to the Medium Level 🚀",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "Gain Confidence with Everyday Digital Skills",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              _buildModuleCard(
                title: "Module 1: Safe Browsing",
                description:
                "Learn how to navigate the internet safely, avoid scams, and protect your privacy online.",
                imagePath: "assets/browsing.png",
                onTap: () {
                  Navigator.pushNamed(context, '/safeBrowsing');
                },
              ),
              _buildModuleCard(
                title: "Module 2: Emails and Communication",
                description:
                "Understand digital payments, secure transactions, and how to manage your money online.",
                imagePath: "assets/banking.png",
                onTap: () {
                  Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmailPage(),
                  ),
                );
                },
              ),
              // _buildModuleCard(
              //   title: "Module 3: Emails & Communication",
              //   description:
              //   "Master emails, organize your inbox, and learn to communicate professionally online.",
              //   imagePath: "assets/email.png",
              //   onTap: () {
              //     Navigator.pushNamed(context, '/emailCommunication');
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
