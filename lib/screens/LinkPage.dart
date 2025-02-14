import 'package:flutter/material.dart';
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

  Future<void> fetchFormFields() async {
    final response = await http.post(
      Uri.parse('https://webscrapeapi.onrender.com/scrape'),  // Replace with your API URL
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"url": urlController.text}),
    );

    if (response.statusCode == 200) {
      List<dynamic> fields = jsonDecode(response.body);
      setState(() {
        formFields = List<Map<String, dynamic>>.from(fields);
        currentStep = 0;
      });
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text("Only Enter your ${formFields[currentStep]['name']}"),
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
                        child: Text(currentStep == formFields.length - 1 ? "Finish" : "Next"),
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
