import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;

class TestModel extends StatefulWidget {

  final dynamic UID;

  const TestModel({super.key,required this.UID});

  @override
  State<TestModel> createState() => _TestModelState();
}

class _TestModelState extends State<TestModel> {


  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool _isListening = false;
  bool _isLoadingResponse = false;
  String _spokenText = "";
  String _modelResponse = "";

  final String apiKey = 'AIzaSyBC1V1ERSRe7sXp-dDtysFu8EukQ055P-4';
  final String endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
  String userLanguage = "English";

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _speakWelcome();
    fetchUserLanguage();
  }

  Future<void> fetchUserLanguage() async {
    DatabaseReference userRef = FirebaseDatabase.instance.ref().child('users').child(widget.UID);
    DatabaseEvent event = await userRef.once();
    if (event.snapshot.exists) {
      setState(() {
        userLanguage = event.snapshot.child('language').value.toString();
      });
    }
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speechToText.initialize();
    setState(() {
      _isListening = available;
    });
  }

  Future<void> _speakWelcome() async {
    await _flutterTts.speak('Hello! Welcome to Digipal Bot. How may I help you?');
  }

  void _startListening() async {
    if (!_isListening) return;
    setState(() {
      _spokenText = "";
      _modelResponse = "";
    });

    await _speechToText.listen(onResult: (result) {
      setState(() {
        _spokenText = result.recognizedWords;
      });

      if (result.finalResult) {
        _stopListening();
        _fetchGeminiResponse(_spokenText);
      }
    });

    setState(() {
      _isListening = true;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  Future<void> _fetchGeminiResponse(String prompt) async {
    setState(() {
      _isLoadingResponse = true;
      _modelResponse = "";
    });

    final requestPayload = {
      'contents': [
        {
          'parts': [
            {
              'text': '$prompt. Provide a response in maximum 50 words in only ${userLanguage} Language',
            }
          ]
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse('$endpoint?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestPayload),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final candidate = responseBody['candidates']?[0];
        final textResponse = candidate?['content']?['parts']?[0]?['text'] ?? "No response text";

        setState(() {
          _modelResponse = textResponse;
          _isLoadingResponse = false;
        });

        await _flutterTts.speak(textResponse); // Speak the response
      } else {
        setState(() {
          _isLoadingResponse = false;
          _modelResponse = 'Error: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingResponse = false;
        _modelResponse = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Digipal Bot"),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Tap the button and start speaking",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _startListening,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.purple,
                    child: Icon(
                      _speechToText.isListening ? Icons.mic : Icons.mic_none,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_spokenText.isNotEmpty)
                  Text(
                    "You said: $_spokenText",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ),
                if (_isLoadingResponse)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                if (_modelResponse.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Response: $_modelResponse",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
