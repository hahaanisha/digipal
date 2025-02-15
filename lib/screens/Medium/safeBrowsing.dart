import 'package:flutter/material.dart';

void main() {
  runApp(const SafeBrowsingPage());
}

class SafeBrowsingPage extends StatelessWidget {
  const SafeBrowsingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Internet Jungle',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const JungleStoryPage(),
    );
  }
}

class JungleStoryPage extends StatefulWidget {
  const JungleStoryPage({super.key});

  @override
  State<JungleStoryPage> createState() => _JungleStoryPageState();
}

class _JungleStoryPageState extends State<JungleStoryPage> {
  int shieldPoints = 3; // Represents safe browsing knowledge
  int storyIndex = 0;

  final List<Map<String, dynamic>> storySteps = [
    {
      'text': "You enter the Internet Jungle 🌴. A bright pop-up appears saying 'Win a Free iPhone!'. What do you do?",
      'choices': [
        {'text': 'Click on it 🚨', 'correct': false},
        {'text': 'Ignore and move on ✅', 'correct': true},
      ]
    },
    {
      'text': "You find a signpost offering a 'Bank Login Bonus'. The website link looks suspicious. What's your move?",
      'choices': [
        {'text': 'Enter login details 🔑', 'correct': false},
        {'text': 'Verify URL before proceeding 🛡️', 'correct': true},
      ]
    },
    {
      'text': "A jungle villager asks for your password to 'help' you. What do you do?",
      'choices': [
        {'text': 'Share it openly 🗣️', 'correct': false},
        {'text': 'Keep it secret & use strong passwords 🔐', 'correct': true},
      ]
    },
  ];

  void _chooseOption(bool isCorrect) {
    setState(() {
      if (isCorrect) {
        shieldPoints++;
      } else {
        shieldPoints--;
      }

      if (storyIndex < storySteps.length - 1) {
        storyIndex++;
      } else {
        _showGameOverDialog();
      }
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Game Over!"),
        content: Text(shieldPoints > 2
            ? "🎉 Congrats! You've mastered safe browsing!"
            : "⚠️ Be careful online! Always double-check links and never share passwords."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                shieldPoints = 3;
                storyIndex = 0;
              });
            },
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Internet Jungle"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              storySteps[storyIndex]['text'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ...List.generate(storySteps[storyIndex]['choices'].length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: storySteps[storyIndex]['choices'][index]['correct']
                        ? Colors.green
                        : Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => _chooseOption(storySteps[storyIndex]['choices'][index]['correct']),
                  child: Text(
                    storySteps[storyIndex]['choices'][index]['text'],
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            Text("🛡️ Shield Points: $shieldPoints", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
