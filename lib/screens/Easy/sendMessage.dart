import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppSenderPage extends StatefulWidget {
  const WhatsAppSenderPage({Key? key}) : super(key: key);

  @override
  _WhatsAppSenderPageState createState() => _WhatsAppSenderPageState();
}

class _WhatsAppSenderPageState extends State<WhatsAppSenderPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  /// Opens WhatsApp chat with the provided phone number and message
  Future<void> _sendMessage() async {
    String phone = _phoneController.text.trim();
    String message = _messageController.text.trim();

    if (phone.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please enter both phone number and message.")),
      );
      return;
    }

    String formattedPhone = phone.replaceAll(RegExp(r'[^0-9]'), ''); // Remove non-numeric chars

    // Check if phone number is valid
    if (formattedPhone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please enter a valid 10-digit phone number with country code.")),
      );
      return;
    }

    String url = "https://wa.me/$formattedPhone?text=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ WhatsApp is not installed on your device.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "DigiPal",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "📩 Send a WhatsApp Message",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Follow the steps below to send a message via WhatsApp.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // Step 1: Enter Phone Number
            const Text(
              "Step 1️⃣: Enter the phone number of the person you want to message.",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            // const Text(
            //   "👉 Make sure to include the country code (e.g., for India, type 91 before the number). Do NOT use spaces or special characters.",
            //   style: TextStyle(color: Colors.black87),
            // ),
            const SizedBox(height: 6),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number (e.g., 919876543210)",
                hintText: "Enter phone number with country code",
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 20),

            // Step 2: Enter Message
            const Text(
              "Step 2️⃣: Type your message",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            // const Text(
            //   "👉 This message will be sent to the person you entered above. Make sure it's correct!",
            //   style: TextStyle(color: Colors.black87),
            // ),
            const SizedBox(height: 6),
            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Message",
                hintText: "Type your message here...",
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.message),
              ),
            ),
            const SizedBox(height: 20),

            // Step 3: Send Button
            const Text(
              "Step 3️⃣: Press the button below to send your message",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            // const Text(
            //   "👉 This will open WhatsApp with your message pre-filled. Just press the send button in WhatsApp.",
            //   style: TextStyle(color: Colors.black87),
            // ),
            const SizedBox(height: 14),

            // Send Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "📤 Send via WhatsApp",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
