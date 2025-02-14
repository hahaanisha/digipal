import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TypingBasicsScreen(),
    );
  }
}

class TypingBasicsScreen extends StatefulWidget {
  const TypingBasicsScreen({super.key});

  @override
  State<TypingBasicsScreen> createState() => _TypingBasicsScreenState();
}

class _TypingBasicsScreenState extends State<TypingBasicsScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://www.edclub.com/library/typing-basics"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Typing Basics", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.purple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
