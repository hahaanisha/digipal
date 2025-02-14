import 'package:flutter/material.dart';
import '../auth/profilePage.dart';
import 'Easy/EasyHome.dart';
import 'Hard/HardHome.dart';
import 'Medium/mediumHome.dart';

class ChallengePage extends StatelessWidget {
  const ChallengePage({super.key});

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
              const Center(
                child: Column(
                  children: [
                    Text(
                      "Choose Your Challenge 🎯",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "From basics to pro—practice, progress, and power up!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildChallengeCard(
                color: Colors.green.shade100,
                level: "EASY",
                title: "Getting Started🌱",
                subtitle: "Learn the basics, step by step.",
                emoji: "🟢",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EasyLevelPage()),
                  );
                },
              ),
              _buildChallengeCard(
                color: Colors.amber.shade100,
                level: "MEDIUM",
                title: "Level Up🚀",
                subtitle: "Build confidence with everyday tasks.",
                emoji: "🟡",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MediumLevelPage()),
                  );
                },
              ),
              _buildChallengeCard(
                color: Colors.red.shade100,
                level: "HARD",
                title: "Challenge Mode🔥",
                subtitle: "Master advanced digital skills.",
                emoji: "🔴",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HardLevelPage()),
                  );
                },
              ),
              _buildChallengeCard(
                color: Colors.grey.shade200,
                level: "TEST",
                title: "Test Yourself🏆",
                subtitle: "See how much you've learned!",
                emoji: "📝",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EasyLevelPage()),
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
