import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

void main() {
  runApp(const FeedbackApp());
}

class FeedbackApp extends StatelessWidget {
  const FeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FeedbackScreen(),
    );
  }
}

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _dbRef = FirebaseDatabase.instance.ref(); // Using Realtime Database
  String userType = 'Super User';
  String name = '';
  String feedbackType = '';
  String organization = '';
  String helpType = '';
  String email = '';
  String additionalInfo = '';
  TextEditingController feedbackController = TextEditingController();

  final List<String> superUserOptions = [
    "Problem with the App",
    "New Feature Suggestion",
    "I Like This App"
  ];

  final List<String> allyOptions = [
    "Contribute a Module",
    "Funding Support",
    "Other"
  ];

  void submitData() {
    Map<String, dynamic> data = {
      'userType': userType,
      'name': name,
      if (userType == 'Super User') 'feedbackType': feedbackType,
      if (userType == 'Innovation Ally') 'organization': organization,
      if (userType == 'Innovation Ally') 'helpType': helpType,
      if (userType == 'Innovation Ally') 'email': email,
      'additionalInfo': additionalInfo,
    };

    _dbRef.child("user_feedback").push().set(data);

    // Show popup & reset fields
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thank You!"),
        content: const Text("Your response has been recorded."),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                name = '';
                feedbackType = '';
                organization = '';
                helpType = '';
                email = '';
                additionalInfo = '';
                feedbackController.clear();
              });
              Navigator.of(context).pop();
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
        title: const Text("Reach out to us", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.purple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Your Voice, Our Growth",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  "Share your feedback, ask questions, or collaborate with us to bridge the digital divide.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),

              // User Type Dropdown
              DropdownButtonFormField<String>(
                value: userType,
                decoration: const InputDecoration(labelText: "Who are you? *"),
                items: ['Super User', 'Innovation Ally']
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) => setState(() => userType = value!),
              ),
              const SizedBox(height: 10),

              // Common Name Field
              TextFormField(
                decoration: const InputDecoration(labelText: "Name *"),
                onChanged: (value) => setState(() => name = value),
              ),
              const SizedBox(height: 10),

              // Super User Fields
              if (userType == 'Super User') ...[
                DropdownButtonFormField<String>(
                  value: feedbackType.isNotEmpty ? feedbackType : null,
                  decoration: const InputDecoration(labelText: "Feedback Type *"),
                  items: superUserOptions
                      .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) => setState(() => feedbackType = value!),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: feedbackController,
                  decoration: const InputDecoration(labelText: "Speak your heart out!"),
                  maxLines: 3,
                  onChanged: (value) => setState(() => additionalInfo = value),
                ),
              ],

              // Innovation Ally Fields
              if (userType == 'Innovation Ally') ...[
                TextFormField(
                  decoration: const InputDecoration(labelText: "Your Organization *"),
                  onChanged: (value) => setState(() => organization = value),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: helpType.isNotEmpty ? helpType : null,
                  decoration: const InputDecoration(labelText: "How Can You Help? *"),
                  items: allyOptions
                      .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) => setState(() => helpType = value!),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Email (We won't spam you, promise!) *"),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => setState(() => email = value),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Got ideas? Upload your proposal"),
                  onChanged: (value) => setState(() => additionalInfo = value),
                ),
              ],

              const SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitData,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  child: const Text("Submit", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
