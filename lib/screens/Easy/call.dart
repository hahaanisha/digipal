import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CallTutorialPage extends StatefulWidget {
  const CallTutorialPage({Key? key}) : super(key: key);

  @override
  State<CallTutorialPage> createState() => _CallTutorialPageState();
}

class _CallTutorialPageState extends State<CallTutorialPage> {
  bool _step1 = false;
  bool _step2 = false;
  bool _step3 = false;
  bool _showVideo = false;

  final String videoId = "hjDC9qff2Us"; // Extracted YouTube video ID
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _launchDialer() async {
    final Uri callUri = Uri(scheme: 'tel');
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone app cannot be opened.")),
      );
    }
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Making a Phone Call is Easy! ☎️",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "Follow these simple steps to call someone.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                setState(() {
                  _showVideo = !_showVideo;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Watch Video Tutorial 🎥",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      _showVideo ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),

            if (_showVideo)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: YoutubePlayerBuilder(
                  player: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                  ),
                  builder: (context, player) {
                    return Column(
                      children: [player],
                    );
                  },
                ),
              ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "✅ Steps to Make a Call",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  CheckboxListTile(
                    title: const Text("Step 1: Open the phone app 📱"),
                    value: _step1,
                    onChanged: (value) {
                      setState(() {
                        _step1 = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Step 2: Dial the number 🔢"),
                    value: _step2,
                    onChanged: (value) {
                      setState(() {
                        _step2 = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Step 3: Press the call button ☎️"),
                    value: _step3,
                    onChanged: (value) {
                      setState(() {
                        _step3 = value!;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _launchDialer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Try Now 🚀",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
