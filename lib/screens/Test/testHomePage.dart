import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'FinalLevel.dart';
import 'easyLevelPage.dart';
import 'hardLevel.dart';
import 'mediumPage.dart';

class Testhomepage extends StatefulWidget {
  const Testhomepage({super.key});

  @override
  State<Testhomepage> createState() => _TesthomepageState();
}

class _TesthomepageState extends State<Testhomepage> {
  Map<String, bool> levelCompletion = {
    "Easy": false,
    "Medium": false,
    "Hard": false,
    "Final": false,
  };

  @override
  void initState() {
    super.initState();
    fetchProgress();
  }

  Future<void> fetchProgress() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref("progress/${user.uid}");
      DatabaseEvent event = await ref.once();

      if (event.snapshot.value != null) {
        Map<String, dynamic> progress = Map<String, dynamic>.from(event.snapshot.value as Map);
        setState(() {
          levelCompletion["Easy"] = (progress["easy_score"] ?? 0) > 7;
          levelCompletion["Medium"] = (progress["medium_score"] ?? 0) > 7;
          levelCompletion["Hard"] = (progress["hard_score"] ?? 0) > 7;
          levelCompletion["Final"] = (progress["final_score"] ?? 0) > 7;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("Test Your Skills!",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Your Challenge Level",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  levelCard("Easy", Colors.green, Icons.star, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EasyPage()),
                    );
                  }, levelCompletion["Easy"]!),
                  levelCard("Medium", Colors.orange, Icons.flash_on, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MediumPage()),
                    );
                  }, levelCompletion["Medium"]!),
                  levelCard("Hard", Colors.red, Icons.whatshot, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HardLevel()),
                    );
                  }, levelCompletion["Hard"]!),
                  levelCard("Final", Colors.purple, Icons.flag, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FinalLevel()),
                    );
                  }, levelCompletion["Final"]!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget levelCard(String title, Color color, IconData icon, VoidCallback onTap, bool isCompleted) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (isCompleted)
              const Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  "Completed",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
