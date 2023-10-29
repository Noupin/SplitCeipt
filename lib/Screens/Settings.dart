import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  // This widget is the second screen of the application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This is the settings screen.',
            ),
            ElevatedButton(
              child: Text('Go to home screen'),
              onPressed: () {
                // Navigate to the third screen using a named route.
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
