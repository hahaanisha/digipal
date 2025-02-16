import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MediumPage extends StatefulWidget {
  const MediumPage({super.key});

  @override
  State<MediumPage> createState() => _MediumPageState();
}

class _MediumPageState extends State<MediumPage> {
  int currentQuestionIndex = 0;
  int score = 0;

  final List<Map<String, dynamic>> questions = [
    {"question": "What should you check before clicking on a link in an email?", "options": ["Sender's name", "URL preview", "Both"], "answer": "Both"},
    {"question": "Which of the following is a strong password?", "options": ["123456", "MyDog2024", "Xy&9d@!L"], "answer": "Xy&9d@!L"},
    {"question": "What is phishing?", "options": ["A type of cyber attack", "A browser extension", "A way to speed up internet"], "answer": "A type of cyber attack"},
    {"question": "What does HTTPS stand for?", "options": ["HyperText Transfer Protocol Secure", "Highly Trusted Transfer Protocol System", "Hyperlink Tracking and Security"], "answer": "HyperText Transfer Protocol Secure"},
    {"question": "Which action keeps your email secure?", "options": ["Using two-factor authentication", "Disabling spam filters", "Sharing passwords"], "answer": "Using two-factor authentication"},
    {"question": "Which email attachment is likely unsafe?", "options": [".pdf", ".exe", ".jpg"], "answer": ".exe"},
    {"question": "What is a common sign of a phishing email?", "options": ["Urgency & threats", "Correct grammar & official logo", "Friendly tone"], "answer": "Urgency & threats"},
    {"question": "How can you recognize a secure website?", "options": ["It has 'https' in the URL", "It has a padlock icon", "Both"], "answer": "Both"},
    {"question": "What should you do if you receive a suspicious email?", "options": ["Click on links to check", "Ignore & delete", "Reply for confirmation"], "answer": "Ignore & delete"},
    {"question": "Which browser feature helps prevent malicious websites?", "options": ["Incognito mode", "Safe browsing", "Dark mode"], "answer": "Safe browsing"},
  ];

  void checkAnswer(String selectedAnswer) {
    if (selectedAnswer == questions[currentQuestionIndex]["answer"]) {
      score++;
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      submitScore();
    }
  }

  Future<void> submitScore() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref("progress/${user.uid}");
      DatabaseEvent event = await ref.once();
      Map<String, dynamic> existingData = {};
      if (event.snapshot.value != null) {
        existingData = Map<String, dynamic>.from(event.snapshot.value as Map);
      }
      existingData['medium_score'] = score;
      await ref.set(existingData);
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Quiz Completed!", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text("Your score: $score/${questions.length}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("OK", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("Safe Browsing & Email Quiz", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Question ${currentQuestionIndex + 1}/${questions.length}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              questions[currentQuestionIndex]["question"],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...questions[currentQuestionIndex]["options"].map<Widget>((option) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => checkAnswer(option),
                  child: Text(
                    option,
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}