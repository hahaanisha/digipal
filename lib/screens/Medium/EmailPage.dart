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

  final String senderEmail = "teaminspire2226@gmail.com"; // Default sender email
  final String senderPassword = "xdrc zrav loyu yvsf"; // Use App Password for security

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
      _showSnackbar("Email sent successfully!");
    } catch (e) {
      _showSnackbar("Failed to send email: $e");
    } finally {
      setState(() => _isSending = false);
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Send Email",style: TextStyle(color: Colors.white),), backgroundColor: Colors.purple),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("From:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(senderEmail, style: TextStyle(fontSize: 16, color: Colors.grey,fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextFormField(
                  controller: _toController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "To",
                    hintText: "Enter recipient email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please enter an email";
                    if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _bodyController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: "Message",
                    hintText: "Enter your message",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.message),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please enter a message";
                    return null;
                  },
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSending ? null : _sendEmail,
                    icon: _isSending ? CircularProgressIndicator() : Icon(Icons.send,color: Colors.purple,),
                    label: Text("Send Email",style: TextStyle(color: Colors.purple,fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      textStyle: TextStyle(fontSize: 16),
                    ),
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
