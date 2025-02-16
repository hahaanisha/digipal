import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class EasyPage extends StatefulWidget {
  const EasyPage({super.key});

  @override
  State<EasyPage> createState() => _EasyPageState();
}

class _EasyPageState extends State<EasyPage> {
  int currentQuestionIndex = 0;
  int score = 0;

  final List<Map<String, dynamic>> questions = [
    {"question": "What does Wi-Fi stand for?", "options": ["Wireless Fidelity", "Wired Fidelity", "Wide Frequency"], "answer": "Wireless Fidelity"},
    {"question": "Where can you adjust screen brightness on a smartphone?", "options": ["Settings", "Contacts", "Messages"], "answer": "Settings"},
    {"question": "What is the purpose of Airplane Mode?", "options": ["Disable wireless connections", "Turn off the phone", "Speed up the device"], "answer": "Disable wireless connections"},
    {"question": "Which app is commonly used for sending text messages?", "options": ["Messages", "Gallery", "Calculator"], "answer": "Messages"},
    {"question": "How do you silence incoming calls?", "options": ["Press the volume down button", "Open Camera", "Uninstall the phone app"], "answer": "Press the volume down button"},
    {"question": "Where can you find Wi-Fi settings?", "options": ["Settings -> Wi-Fi", "Clock app", "Gallery"], "answer": "Settings -> Wi-Fi"},
    {"question": "What icon represents mobile network signal?", "options": ["Bars icon", "Music note", "Battery icon"], "answer": "Bars icon"},
    {"question": "What do you need to make a phone call?", "options": ["SIM card", "Headphones", "Flashlight"], "answer": "SIM card"},
    {"question": "Where do you change the phone’s wallpaper?", "options": ["Settings -> Display", "Calculator", "Messages"], "answer": "Settings -> Display"},
    {"question": "What does the Bluetooth feature do?", "options": ["Connects wireless devices", "Turns on flashlight", "Takes screenshots"], "answer": "Connects wireless devices"},
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
      await ref.set({
        'easy_score': score,
      });
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
        title: const Text("Smartphone Basics Quiz", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
