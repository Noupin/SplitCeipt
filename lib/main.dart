import 'package:flutter/material.dart';
import 'package:split_shit/Screens/Home.dart';
import 'package:split_shit/Screens/Receipt.dart';
import 'package:split_shit/Screens/Settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SplitCeipt',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromRGBO(1, 129, 128, 1.0)),
        useMaterial3: true,
      ),
      home: const HomeScreen(title: 'SplitCeipt'),
      routes: {
        '/receipt': (context) => ReceiptScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
