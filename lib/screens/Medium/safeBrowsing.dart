import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class SafeBrowsingGuide extends StatefulWidget {
  @override
  _SafeBrowsingGuideState createState() => _SafeBrowsingGuideState();
}

class _SafeBrowsingGuideState extends State<SafeBrowsingGuide> {
  final List<Map<String, dynamic>> _safetyTips = [
    {
      'title': 'Strong Passwords',
      'description': 'Use a mix of letters, numbers, and symbols. Never share your password.',
      'icon': Icons.lock,
      'examples': [
        'Good: Mix@2024User',
        'Bad: password123'
      ]
    },
    {
      'title': 'Suspicious Links',
      'description': 'Don\'t click on links from unknown sources or suspicious messages.',
      'icon': Icons.link_off,
      'examples': [
        'Avoid: "Click here to win money!"',
        'Avoid: "Your account is blocked, click here"'
      ]
    },
    {
      'title': 'Personal Information',
      'description': 'Never share personal details like bank info or OTP with anyone.',
      'icon': Icons.security,
      'examples': [
        'Never share: OTP, CVV, PIN',
        'Never share: Bank account details'
      ]
    },
    {
      'title': 'Safe Websites',
      'description': 'Look for the lock symbol (🔒) before entering any information.',
      'icon': Icons.verified_user,
      'examples': [
        'Safe: https:// with lock symbol',
        'Unsafe: No lock symbol'
      ]
    },
  ];

  /// **Fix: Add `_launchURL` inside `_SafeBrowsingGuideState`**
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Could not open $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "DigiPal",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
        leading: const Icon(Icons.account_circle, color: Colors.white),

      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.purple[50],
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🛡️ Basic Safety Rules',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[900],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Follow these simple rules to stay safe while using the internet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          ...buildSafetyTipCards(),
          SizedBox(height: 16),
          buildEmergencyCard(),
        ],
      ),
    );
  }

  List<Widget> buildSafetyTipCards() {
    return _safetyTips.map((tip) {
      return Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Card(
          elevation: 2,
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple,
              child: Icon(tip['icon'], color: Colors.white),
            ),
            title: Text(
              tip['title'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              tip['description'],
              style: TextStyle(fontSize: 14),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Examples:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 8),
                    ...tip['examples'].map<Widget>((example) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              example.startsWith('Good') || example.startsWith('Safe')
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: example.startsWith('Good') || example.startsWith('Safe')
                                  ? Colors.green
                                  : Colors.red,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(example),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget buildEmergencyCard() {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🚨 If Something Goes Wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 12),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.red),
              title: Text('Call Cyber Crime Helpline'),
              subtitle: Text('1930'),
              onTap: () {
                // Implement phone call functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.report, color: Colors.red),
              title: Text('Report on Cyber Crime Portal'),
              subtitle: Text('cybercrime.gov.in'),
              onTap: () => _launchURL('https://cybercrime.gov.in'), // ✅ Now it works!
            ),
          ],
        ),
      ),
    );
  }
}
