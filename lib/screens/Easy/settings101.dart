import 'package:digipal/auth/profilePage.dart';
import 'package:flutter/material.dart';

import '../Hard/HardHome.dart';
import '../Medium/mediumHome.dart';
import 'EasyHome.dart';
import 'securesetting.dart';
import 'wifi.dart';


class setting101 extends StatelessWidget {
  const setting101({super.key});

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Practice Challenges"),
        content: const Text(
          "This page lets you practice digital skills at your own pace.\n\n"
              "🔹 Getting Started – Learn the basics step by step.\n"
              "🔹 Level Up – Try everyday digital tasks.\n"
              "🔹 Challenge Mode – Master advanced skills.\n"
              "🔹 Test Yourself – Take a quiz to check your progress.\n\n"
              "Tap a level to begin! 🚀",
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

  Widget _buildChallengeCard({
    required Color color,
    required String level,
    required String title,
    required String subtitle,
    required String emoji,
    required VoidCallback onTap, // Navigation function
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
            Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DigiPal", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.purple,
        leading: InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
            },
            child: const Icon(Icons.account_circle, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      "Settings 101⚙️",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Everything you need to know about settings app",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildChallengeCard(
                color: Colors.purple.shade100,
                level: "WIFI",
                title: "How to get connected to a wifi?",
                subtitle: "Click here to know more",
                emoji: "🛜",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Wifi()),
                  );
                },
              ),
        _buildChallengeCard(
          color: Colors.purple.shade100,
          level: "SECURITY",
          title: "How can I make my mobile more secure?",
          subtitle: "Click here to know more",
          emoji: "🛡️",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SafetyGuidePage()),
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
