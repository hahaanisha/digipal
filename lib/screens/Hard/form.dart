import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

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
  int _quizScore = 0;
  bool _showQuiz = false;

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
      setState(() {
        _progress = 100;
        _showQuiz = true;
      });
      _confettiController.play();
    }
  }

  void _checkQuizAnswers(bool isCorrect) {
    if (isCorrect) _quizScore++;
    if (_quizScore == 2) _confettiController.play(); // 🎉
  }

  void _showTooltip(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final tooltip = OverlayEntry(
      builder: (context) => Positioned(
        top: 100,
        left: 50,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(10)),
            child: Text(message, style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );

    overlay.insert(tooltip);
    Future.delayed(Duration(seconds: 2), () => tooltip.remove());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("📜 Form Quest: Learn by Doing")),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormBuddy(),

                    _buildField(
                      label: "Full Name",
                      hint: "Enter your name (e.g., Raj Sharma)",
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) return "Name can't be empty!";
                        return null;
                      },
                      infoText: "Your full name as per official government ID.",
                    ),

                    _buildField(
                      label: "Date of Birth",
                      hint: "DD/MM/YYYY (e.g., 12/05/1995)",
                      controller: dobController,
                      validator: (value) {
                        if (!RegExp(r"^\d{2}/\d{2}/\d{4}$").hasMatch(value!)) {
                          return "Use format: DD/MM/YYYY";
                        }
                        return null;
                      },
                      infoText: "Your birth date, must match official records.",
                    ),

                    _buildField(
                      label: "PAN Number",
                      hint: "ABCDE1234F",
                      controller: panController,
                      validator: (value) {
                        if (!RegExp(r"^[A-Z]{5}[0-9]{4}[A-Z]$").hasMatch(value!)) {
                          return "Invalid PAN format!";
                        }
                        return null;
                      },
                      infoText: "Permanent Account Number (PAN) for tax purposes.",
                    ),

                    _buildField(
                      label: "Phone Number",
                      hint: "10-digit number (e.g., 9876543210)",
                      controller: phoneController,
                      validator: (value) {
                        if (!RegExp(r"^\d{10}$").hasMatch(value!)) {
                          return "Enter a valid 10-digit number!";
                        }
                        return null;
                      },
                      infoText: "Mobile number for OTP verification.",
                    ),

                    SizedBox(height: 20),
                    LinearProgressIndicator(value: _progress / 100),
                    SizedBox(height: 20),

                    Center(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: Text("Submit Form ✅"),
                      ),
                    ),

                    if (_showQuiz) _buildQuiz(),
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
      ),
    );
  }

  Widget _buildFormBuddy() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.help_outline, color: Colors.blue),
          SizedBox(width: 10),
          Expanded(child: Text("Hello! I'm FormBuddy. I'll guide you through this form. Tap ⓘ for help!")),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required String infoText,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(Icons.info_outline, color: Colors.blue),
                onPressed: () => _showTooltip(context, infoText),
              ),
            ],
          ),
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

  Widget _buildQuiz() {
    return Column(
      children: [
        Text("Quiz Time! 🎓", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text("Why is PAN important?"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: () => _checkQuizAnswers(true), child: Text("Tax Identification")),
            ElevatedButton(onPressed: () => _checkQuizAnswers(false), child: Text("Driving License")),
          ],
        ),
      ],
    );
  }
}
