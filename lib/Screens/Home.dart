import 'package:flutter/material.dart';
import 'package:split_shit/Helpers/Texting.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;
  //Text box stuff
  String _text = "";
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextField(
              controller: _controller,
              onChanged: (value) {
                // Call setState to update the text input value
                setState(() {
                  _text = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                sendTextMessage("Hello from flutter!", [_text]);
              },
              child: Text('Send Text'),
            ),
            ElevatedButton(
              child: Text('Go to next screen'),
              onPressed: () {
                // Navigate to the third screen using a named route.
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
