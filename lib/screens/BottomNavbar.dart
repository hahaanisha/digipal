import 'package:digipal/screens/BotPage.dart';
import 'package:digipal/screens/LinkPage.dart';
import 'package:digipal/screens/feedback.dart';
import 'package:flutter/material.dart';

import 'Practice.dart';
import 'ReachOutPage.dart';



class BottomNavBarR extends StatefulWidget {
  final dynamic companyUID;

  const BottomNavBarR({super.key, required this.companyUID});

  @override
  _BottomNavBarRState createState() => _BottomNavBarRState();
}

class _BottomNavBarRState extends State<BottomNavBarR> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define _pages here so it can access widget.companyUID
    final List<Widget> _pages = [
      // Homepager(UID: widget.companyUID,),
      // CompanyJobsPage(companyUID: widget.companyUID), // Pass companyUID here
      // DisplayJobsR(UID: widget.companyUID,),
      // // const ProfileScreen(),
      // CandidatesListPage(jobUID: '-OHJ2Hf-h5MXugJqBQtV',),
      // SignUpPageI(),

      ChallengePage(),
      FormHomePage(UID: widget.companyUID,),
      // ReachOutPage(),
      TestModel(UID: widget.companyUID,),
      FeedbackScreen(),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add_chart_outlined), label: 'Challange Page'),
          BottomNavigationBarItem(icon: Icon(Icons.link_rounded), label: 'Link'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: 'Talk2Bot'),
          BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: 'Reach Out'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Candidate Homepage'),
      ),
      body: Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
    );
  }
}