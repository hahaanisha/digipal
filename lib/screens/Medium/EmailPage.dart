import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  final String senderEmail = "teaminspire2226@gmail.com";
  final String senderPassword = "xdrc zrav loyu yvsf";

  bool _isSending = false;

  Future<void> _sendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);

    final smtpServer = gmail(senderEmail, senderPassword);
    final message = Message()
      ..from = Address(senderEmail, "Team Inspire")
      ..recipients.add(_toController.text)
      ..subject = "Message from Team Inspire"
      ..text = _bodyController.text;

    try {
      await send(message, smtpServer);
      _showSnackbar("✅ Email sent successfully!");
    } catch (e) {
      _showSnackbar("❌ Failed to send email: $e");
    } finally {
      setState(() => _isSending = false);
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: const Text("DigiPal", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInstructions(),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("From:"),
                  _buildSenderCard(),
                  const SizedBox(height: 16),
                  _buildLabel("To:"),
                  _buildTextField(_toController, "Recipient Email", Icons.email, TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _buildLabel("Message:"),
                  _buildTextField(_bodyController, "Enter your message", Icons.message, TextInputType.text, maxLines: 5),
                  const SizedBox(height: 24),
                  _buildSendButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Card(
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("📌 How to Use:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple)),
            SizedBox(height: 8),
            Text("1️⃣ Enter the recipient's email in the 'To' field.", style: TextStyle(fontSize: 16)),
            Text("2️⃣ Type your message in the 'Message' box.", style: TextStyle(fontSize: 16)),
            Text("3️⃣ Tap 'Send Email' to send your message.", style: TextStyle(fontSize: 16)),
            Text("✅ A success message will appear once sent.", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple),
    );
  }

  Widget _buildSenderCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.person, color: Colors.purple),
        title: Text(senderEmail, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String hintText,
      IconData icon,
      TextInputType keyboardType, {
        int maxLines = 1,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.purple),
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return "⚠️ This field is required";
        if (keyboardType == TextInputType.emailAddress &&
            !RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(value)) {
          return "⚠️ Enter a valid email";
        }
        return null;
      },
    );
  }

  Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSending ? null : _sendEmail,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: Colors.purple,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _isSending
            ? const SizedBox(
          width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        )
            : const Text("📨 Send Email", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}
