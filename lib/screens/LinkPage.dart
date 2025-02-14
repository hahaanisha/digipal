import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FormHomePage extends StatefulWidget {
  @override
  _FormHomePageState createState() => _FormHomePageState();
}

class _FormHomePageState extends State<FormHomePage> {
  TextEditingController urlController = TextEditingController();
  List<Map<String, dynamic>> formFields = [];
  int currentStep = 0;
  Map<String, String> userInputs = {};
  static const apiKey = 'AIzaSyA7LxDBz3bEPP1JkFjfbzdry5UIpu81H-A';

  Future<void> getGeminiResponse(String apiResponse) async {
    Gemini.init(apiKey: apiKey, enableDebugging: true);

    final geminiResponse = await Gemini.instance.prompt(parts: [
      Part.text(
          "Below is my web scraping API response:${apiResponse} Now add an additional field named 'description' in the above JSON format, which will explain instructions about how to fill that text field in Hindi and give me a full final JSON as output."
      ),
    ]);

    if (geminiResponse?.output != null) {
      try {
        // Clean up the response string by removing unnecessary markdown or code block formatting
        String cleanedResponse = geminiResponse!.output!.replaceAll(RegExp(r'```json\n|\n```'), '');

        // Now decode the cleaned response
        List<dynamic> enhancedFields = jsonDecode(cleanedResponse);

        setState(() {
          formFields = List<Map<String, dynamic>>.from(enhancedFields.map((field) {
            // Add a fallback description if it's not available
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
      appBar: AppBar(title: Text('Form Auto-Filler')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                  // SizedBox(height: 10),
                  // Text(
                  //   "Only Enter your ${formFields[currentStep]['name']}",
                  //   style: TextStyle(fontWeight: FontWeight.bold),
                  // ),
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
