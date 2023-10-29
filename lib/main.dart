//Third Party Imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//First Party Imports
import 'Screens/Home.dart';
import 'Screens/Receipt.dart';
import 'Screens/Settings.dart';
import 'State/State.dart';
import 'Theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Create an instance of CeiptModel
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'SplitCeipt',
        theme: customThemeData,
        home: HomeScreen(),
        routes: {
          '/receipt': (context) => ReceiptScreen(),
          '/settings': (context) => SettingsScreen(),
        },
      ),
    );
  }
}
