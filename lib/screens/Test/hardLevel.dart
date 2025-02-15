import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class HardLevel extends StatefulWidget {
  const HardLevel({super.key});

  @override
  State<HardLevel> createState() => _HardLevelState();
}

class _HardLevelState extends State<HardLevel> {
  int currentQuestionIndex = 0;
  int score = 0;

  final List<Map<String, dynamic>> questions = [
    {"question": "What does CPU stand for?", "options": ["Central Processing Unit", "Computer Personal Unit", "Central Process Unit"], "answer": "Central Processing Unit"},
    {"question": "Which key is used to enter a new line in a text document?", "options": ["Shift", "Enter", "Backspace"], "answer": "Enter"},
    {"question": "Which device is used to type on a computer?", "options": ["Mouse", "Keyboard", "Monitor"], "answer": "Keyboard"},
    {"question": "What is the main function of an operating system?", "options": ["Manage hardware and software", "Run applications", "Connect to the internet"], "answer": "Manage hardware and software"},
    {"question": "Which storage device is non-volatile?", "options": ["RAM", "Hard Drive", "Cache"], "answer": "Hard Drive"},
    {"question": "Which programming language is used to build websites?", "options": ["Python", "HTML", "Java"], "answer": "HTML"},
    {"question": "Which of these is an output device?", "options": ["Keyboard", "Printer", "Scanner"], "answer": "Printer"},
    {"question": "What does URL stand for?", "options": ["Uniform Resource Locator", "Universal Remote Link", "User Referenced Link"], "answer": "Uniform Resource Locator"},
    {"question": "Which key is used to delete a character in text?", "options": ["Shift", "Delete", "Tab"], "answer": "Delete"},
    {"question": "What does HTTP stand for?", "options": ["HyperText Transfer Protocol", "HyperText Transmission Process", "Hyperlink Transfer Program"], "answer": "HyperText Transfer Protocol"},
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
      existingData['hard_score'] = score;
      await ref.set(existingData);
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Quiz Completed!"),
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
        title: const Text("Hard Level Quiz",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${currentQuestionIndex + 1}/${questions.length}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              questions[currentQuestionIndex]["question"],
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            ...questions[currentQuestionIndex]["options"].map<Widget>((option) {
              return ElevatedButton(
                onPressed: () => checkAnswer(option),
                child: Text(option),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
