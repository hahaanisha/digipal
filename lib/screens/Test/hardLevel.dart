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
    {"question": "Which document is required for filing income tax returns?", "options": ["Aadhaar Card", "PAN Card", "Voter ID"], "answer": "PAN Card"},
    {"question": "What is the full form of UPI?", "options": ["Unified Payments Interface", "Universal Payment Integration", "Unique Payment ID"], "answer": "Unified Payments Interface"},
    {"question": "Which government portal is used for GST payments?", "options": ["GSTN", "Income Tax e-Filing", "Bharat BillPay"], "answer": "GSTN"},
    {"question": "Which mobile app is launched by the Indian government for digital payments?", "options": ["Google Pay", "PhonePe", "BHIM"], "answer": "BHIM"},
    {"question": "Where can you apply for a new PAN card?", "options": ["NSDL Portal", "IRCTC", "Paytm"], "answer": "NSDL Portal"},
    {"question": "Which form is used for filing income tax returns for salaried employees?", "options": ["ITR-1", "ITR-3", "ITR-6"], "answer": "ITR-1"},
    {"question": "What is the minimum age to apply for a voter ID in India?", "options": ["16 years", "18 years", "21 years"], "answer": "18 years"},
    {"question": "Which platform allows online bill payments for electricity and water?", "options": ["Bharat BillPay", "IRCTC", "EPFO"], "answer": "Bharat BillPay"},
    {"question": "Which document is needed for opening a bank account?", "options": ["Driving License", "PAN Card", "Both"], "answer": "Both"},
    {"question": "Where can you check your income tax refund status?", "options": ["Income Tax e-Filing Portal", "GST Portal", "BHIM App"], "answer": "Income Tax e-Filing Portal"},
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
        title: const Text("Gov Forms & Payments Quiz", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
