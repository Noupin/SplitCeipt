import 'package:flutter/material.dart';
import 'package:split_shit/Helpers/Texting.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'SplitCeipt'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _text = "";
  TextEditingController _controller = TextEditingController();
  final ValueNotifier<CameraImage> _image = ValueNotifier<CameraImage>(null!);
  // Declare a camera controller and a text detector
  late CameraController _cameraController;
  late TextRecognizer _textDetector;

  // Declare a variable to store the recognized text
  String _cameraText = '';

  @override
  void initState() {
    super.initState();
    _image.addListener(_recognizeText);
    // Initialize the camera controller and the text detector
    _initializeCamera();
    _textDetector = GoogleMlKit.vision.textRecognizer();
  }

  @override
  void dispose() {
    // Dispose the camera controller and the text detector
    _cameraController.dispose();
    _textDetector.close();
    super.dispose();
  }

  // Initialize the camera controller with the first available camera
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21 // for Android
          : ImageFormatGroup.bgra8888, // for iOS
    );
    await _cameraController.initialize();
    setState(() {});
  }

  void _getPicture() async {
    await _cameraController
        .startImageStream((CameraImage camImage) => {_image.value = camImage});
  }

  // Recognize text from the camera image stream
  Future<void> _recognizeText() async {
    // Get the next camera image
    await _cameraController
        .startImageStream((CameraImage camImage) => {_image.value = camImage});
    // Create an input image from the camera image
    final inputImage = InputImage.fromBytes(
      bytes: _image.value.planes[0].bytes,
      metadata: InputImageMetadata(
        size:
            Size(_image.value.width.toDouble(), _image.value.height.toDouble()),
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormatValue.fromRawValue(_image.value.format.raw)!,
        bytesPerRow: _image.value.planes.first.bytesPerRow,
      ),
    );
    // Process the input image with the text detector
    final RecognizedText recognizedText =
        await _textDetector.processImage(inputImage);
    // Concatenate all the text lines into a single string
    String text = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        text += line.text + '\n';
      }
    }
    // Update the state with the recognized text
    setState(() {
      _cameraText = text;
    });
    await _cameraController.stopImageStream();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    sendTextMessage("Hi from flutter", ["+1-614-580-4679"]);
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display the camera preview if initialized
                if (_cameraController.value.isInitialized)
                  AspectRatio(
                    aspectRatio: _cameraController.value.aspectRatio,
                    child: CameraPreview(_cameraController),
                  )
                else
                  CircularProgressIndicator(),
                SizedBox(height: 20),
                // Display the recognized text if any
                if (_text.isNotEmpty)
                  Text(
                    'Recognized text:\n$_text',
                    style: TextStyle(fontSize: 18),
                  )
                else
                  Text('No text recognized'),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _getPicture();
              },
              child: Text('Getpicture'),
            )
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
