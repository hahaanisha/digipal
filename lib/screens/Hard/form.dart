import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';



class form extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FormQuestScreen(),
    );
  }
}

class FormQuestScreen extends StatefulWidget {
  @override
  _FormQuestScreenState createState() => _FormQuestScreenState();
}

class _FormQuestScreenState extends State<FormQuestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController panController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  late ConfettiController _confettiController;
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() => _progress = 100);
      _confettiController.play();
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("🎉 Congratulations!"),
        content: Text("You've successfully completed the form!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Awesome!"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Form Quest: Learn by Doing 📜")),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("👋 Meet FormBuddy: Your Guide"),
                  Text("Let's fill a simulated government form!"),
                  SizedBox(height: 10),

                  _buildField("Full Name", "Enter your name as per official ID", nameController, (value) {
                    if (value!.isEmpty) return "Name can't be empty!";
                    return null;
                  }),

                  _buildField("Date of Birth", "DD/MM/YYYY", dobController, (value) {
                    if (!RegExp(r"^\d{2}/\d{2}/\d{4}$").hasMatch(value!)) {
                      return "Use format: DD/MM/YYYY";
                    }
                    return null;
                  }),

                  _buildField("PAN Number", "ABCDE1234F", panController, (value) {
                    if (!RegExp(r"^[A-Z]{5}[0-9]{4}[A-Z]$").hasMatch(value!)) {
                      return "Invalid PAN format!";
                    }
                    return null;
                  }),

                  _buildField("Phone Number", "10-digit number", phoneController, (value) {
                    if (!RegExp(r"^\d{10}$").hasMatch(value!)) {
                      return "Enter a valid 10-digit number!";
                    }
                    return null;
                  }),

                  SizedBox(height: 20),
                  LinearProgressIndicator(value: _progress / 100),
                  SizedBox(height: 20),

                  Center(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: Text("Submit Form ✅"),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Confetti 🎉 on success
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3.14 / 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, String hint, TextEditingController controller, String? Function(String?) validator) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          TextFormField(
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }
}
