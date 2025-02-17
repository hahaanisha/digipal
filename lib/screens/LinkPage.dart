import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

class FormHomePage extends StatefulWidget {
  final dynamic UID;

  const FormHomePage({super.key, required this.UID});

  @override
  _FormHomePageState createState() => _FormHomePageState();
}

class _FormHomePageState extends State<FormHomePage> {
  TextEditingController urlController = TextEditingController();
  List<Map<String, dynamic>> formFields = [];
  int currentStep = 0;
  Map<String, String> userInputs = {};
  static const apiKey = '';
  String userLanguage = "English";

  @override
  void initState() {
    super.initState();
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

  Future<void> getGeminiResponse(String apiResponse) async {
    Gemini.init(apiKey: apiKey, enableDebugging: true);

    final geminiResponse = await Gemini.instance.prompt(parts: [
      Part.text(
          "Below is my web scraping API response:${apiResponse} Now add an additional field named 'description' in the above JSON format, which will explain instructions about how to fill that text field in ${userLanguage} and give me a full final JSON as output."
      ),
    ]);

    if (geminiResponse?.output != null) {
      try {
        String cleanedResponse = geminiResponse!.output!.replaceAll(RegExp(r'```json\n|\n```'), '');
        List<dynamic> enhancedFields = jsonDecode(cleanedResponse);

        setState(() {
          formFields = List<Map<String, dynamic>>.from(enhancedFields.map((field) {
            if (field['description'] == null || field['description'].isEmpty) {
              field['description'] = 'Please fill in the required information for this field.';
            }
            return field;
          }));
          currentStep = 0;
        });
      } catch (e) {
        print("Error parsing Gemini response: $e");
      }
    }
  }

  Future<void> fetchFormFields() async {
    final response = await http.post(
      Uri.parse('https://webscrapeapi.onrender.com/scrape'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"url": urlController.text}),
    );

    if (response.statusCode == 200) {
      getGeminiResponse(response.body);
    } else {
      print("Failed to load form fields");
    }
  }

  void nextStep() {
    if (currentStep < formFields.length - 1) {
      setState(() {
        currentStep++;
      });
    } else {
      print("Form completed: $userInputs");
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "DigiPal",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Form Auto-Filler",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: urlController,
                decoration: InputDecoration(labelText: 'Enter Form URL'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: fetchFormFields,
                child: Text('Fetch Form'),
              ),
              SizedBox(height: 20),
              formFields.isEmpty
                  ? Text("Enter a URL and fetch the form")
                  : Column(
                children: [
                  Text(
                    "Step ${currentStep + 1}/${formFields.length}",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    formFields[currentStep]['description'] ?? "No description available",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    onChanged: (value) {
                      userInputs[formFields[currentStep]['name']] = value;
                    },
                    decoration: InputDecoration(
                      labelText: formFields[currentStep]['name'],
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: previousStep,
                        child: Text("Back"),
                      ),
                      ElevatedButton(
                        onPressed: nextStep,
                        child: Text(currentStep == formFields.length - 1
                            ? "Finish"
                            : "Next"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
