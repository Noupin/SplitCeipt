//Third Party Imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//First Party Imports
import 'Screens/Home.dart';
import 'Screens/Receipt.dart';
import 'Screens/Settings.dart';
import 'State.dart';

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
      ),
    );
  }
}
