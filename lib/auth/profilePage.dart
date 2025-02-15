import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('users');

  String uid = '';
  String name = '';
  String email = '';
  String phone = '';
  String selectedLanguage = 'English';

  int easyScore = 0;
  int mediumScore = 0;
  int hardScore = 0;
  int finalScore = 0;

  bool isEditing = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final List<String> indianLanguages = [
    'English', 'Hindi', 'Marathi', 'Gujarati', 'Tamil', 'Telugu', 'Kannada',
    'Malayalam', 'Bengali', 'Punjabi', 'Urdu', 'Odia', 'Assamese', 'Sanskrit'
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      uid = user.uid;
      DatabaseReference userRef = _database.child(uid);
      DatabaseReference progressRef = FirebaseDatabase.instance.ref().child('progress/$uid');

      userRef.once().then((DatabaseEvent event) {
        if (event.snapshot.exists) {
          Map<dynamic, dynamic>? data = event.snapshot.value as Map?;
          setState(() {
            name = data?['name'] ?? 'No Name';
            email = data?['email'] ?? 'No Email';
            phone = data?['phone'] ?? 'No Phone';
            selectedLanguage = data?['language'] ?? 'English';

            nameController.text = name;
            phoneController.text = phone;
          });
        }
      });

      progressRef.once().then((DatabaseEvent event) {
        if (event.snapshot.exists) {
          Map<dynamic, dynamic>? progressData = event.snapshot.value as Map?;
          setState(() {
            easyScore = progressData?['easy_score'] ?? 0;
            mediumScore = progressData?['medium_score'] ?? 0;
            hardScore = progressData?['hard_score'] ?? 0;
            finalScore = progressData?['final_score'] ?? 0;
          });
        }
      });
    }
  }

  void _updateUserData() {
    _database.child(uid).update({
      'name': nameController.text,
      'phone': phoneController.text,
      'language': selectedLanguage,
    }).then((_) {
      setState(() {
        name = nameController.text;
        phone = phoneController.text;
        isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile Updated Successfully!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            ),
            SizedBox(height: 20),
            Text('Email:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(email),
            SizedBox(height: 10),
            Text('Name:', style: TextStyle(fontWeight: FontWeight.bold)),
            isEditing
                ? TextField(controller: nameController)
                : Text(name),
            SizedBox(height: 10),
            Text('Phone:', style: TextStyle(fontWeight: FontWeight.bold)),
            isEditing
                ? TextField(controller: phoneController, keyboardType: TextInputType.phone)
                : Text(phone),
            SizedBox(height: 10),
            Text('Preferred Language:', style: TextStyle(fontWeight: FontWeight.bold)),
            isEditing
                ? DropdownButton<String>(
              value: selectedLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  selectedLanguage = newValue!;
                });
              },
              items: indianLanguages.map<DropdownMenuItem<String>>((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
            )
                : Text(selectedLanguage),
            SizedBox(height: 20),
            Text('Badges:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                if (easyScore > 7) Image.asset('assets/easybadge.png', width: 50, height: 50),
                if (mediumScore > 7) Image.asset('assets/mediumbadge.png', width: 50, height: 50),
                if (hardScore > 7) Image.asset('assets/hardbadge.png', width: 50, height: 50),
                if (finalScore > 7) Image.asset('assets/black.png', width: 50, height: 50),
              ],
            ),
            SizedBox(height: 20),
            isEditing
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _updateUserData,
                  child: Text('Save'),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => isEditing = false),
                  child: Text('Cancel'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            )
                : Center(
              child: ElevatedButton(
                onPressed: () => setState(() => isEditing = true),
                child: Text('Edit Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
