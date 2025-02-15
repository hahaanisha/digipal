import 'package:flutter/material.dart';

class ReachOutPage extends StatelessWidget {
  const ReachOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🐣',style: TextStyle(fontSize: 55),),
            Text('I am Under Construction',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
          ],
        ),
      ),
    );
  }
}
