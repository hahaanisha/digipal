import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FinalLevel extends StatefulWidget {
  const FinalLevel({super.key});

  @override
  State<FinalLevel> createState() => _FinalLevelState();
}

class _FinalLevelState extends State<FinalLevel> {
  int currentQuestionIndex = 0;
  int score = 0;

  final List<Map<String, dynamic>> questions = [
    {"question": "What is phishing?", "options": ["A cyber-attack using fake emails", "A type of malware", "A secure encryption method"], "answer": "A cyber-attack using fake emails"},
    {"question": "Which protocol encrypts website traffic?", "options": ["HTTP", "HTTPS", "FTP"], "answer": "HTTPS"},
    {"question": "What does AI stand for?", "options": ["Automated Intelligence", "Artificial Intelligence", "Advanced Internet"], "answer": "Artificial Intelligence"},
    {"question": "What is a VPN used for?", "options": ["Secure browsing", "Faster downloads", "Boosting Wi-Fi signals"], "answer": "Secure browsing"},
    {"question": "What is two-factor authentication (2FA)?", "options": ["A single password login", "Verifying identity with two methods", "An encryption technique"], "answer": "Verifying identity with two methods"},
    {"question": "Which programming language is commonly used in AI?", "options": ["Python", "HTML", "CSS"], "answer": "Python"},
    {"question": "What does a firewall do?", "options": ["Blocks unauthorized access", "Speeds up internet", "Stores passwords"], "answer": "Blocks unauthorized access"},
    {"question": "Which of these is a strong password?", "options": ["123456", "P@ssw0rd!123", "password"], "answer": "P@ssw0rd!123"},
    {"question": "What is ransomware?", "options": ["A virus that encrypts files for ransom", "A free security software", "A type of firewall"], "answer": "A virus that encrypts files for ransom"},
    {"question": "What does IoT stand for?", "options": ["Internet of Things", "Intelligent Online Tech", "Integrated Operating Technology"], "answer": "Internet of Things"},
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
      existingData['final_score'] = score;
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
            child: const Text("OK"),
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
        title: const Text("Final Level Quiz", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              color: Colors.purple[50],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Question ${currentQuestionIndex + 1}/${questions.length}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
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
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => checkAnswer(option),
                  child: Text(option, style: const TextStyle(fontSize: 18, color: Colors.white)),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
