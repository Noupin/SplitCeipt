import 'package:flutter/material.dart';
import 'package:split_shit/Helpers/Texting.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:permission_handler/permission_handler.dart';

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
  //Text box stuff
  String _text = "";
  TextEditingController _controller = TextEditingController();
  // Declare a camera controller and a text detector
  late CameraImage _image;
  late bool _isDetecting = false;
  late TextRecognizer _textRecognizer;
  late CameraController _cameraController;

  // Declare a variable to store the recognized text
  String _cameraText = '';
  Widget cameraWidget = Column();

  @override
  void initState() {
    super.initState();

    // Initialize the camera with the first available camera
    _requestCameraPermission();
    // Initialize the text detector
    _textRecognizer = GoogleMlKit.vision.textRecognizer();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _textRecognizer.close();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _requestCameraPermission() async {
    bool agreed = true;
    // Request camera permission
    List<Permission> permissions = [
      Permission.camera,
      // Permission.microphone,
      // Permission.contacts,
      // Permission.sms,
      // Permission.systemAlertWindow,
      // Permission.videos
    ];
    try {
      for (var permission in permissions) {
        // Check if the permission is already granted or denied
        if (await permission.status.isDenied ||
            await permission.status.isPermanentlyDenied) {
          // Request the permission if it is not granted
          await permission.request();
        }
      }
    } catch (e) {
      agreed = false;
      debugPrint('$e');
    }

    // Check if camera permission is granted
    if (agreed) {
      // Camera permission is granted, initialize the camera
      _initializeCamera();
      cameraWidget = Column(
        children: [
          // Display the camera preview
          Expanded(
            child: Container(
              constraints: const BoxConstraints.expand(),
              child: CameraPreview(_cameraController),
            ),
          ),
          // Display the detected text
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _text,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ),
          Text(_cameraText),
        ],
      );
    } else {
      // Camera permission is not granted, show a message
      setState(() {
        _cameraText = 'Camera permission is required to use this feature.';
      });
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController.initialize();

    // Start streaming images from the camera
    _cameraController.startImageStream((image) {
      if (!_isDetecting) {
        setState(() {
          _image = image;
          _isDetecting = true;
        });

        // Detect text from the image
        _detectText();
      }
    });
  }

  Future<void> _detectText() async {
    // Convert the camera image to input image format
    final inputImage = InputImage.fromBytes(
      bytes: _image.planes[0].bytes,
      metadata: InputImageMetadata(
        size: Size(_image.width.toDouble(), _image.height.toDouble()),
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormat.yuv420,
        bytesPerRow: _image.planes[0].bytesPerRow,
      ),
    );

    // Process the input image with the text detector
    final RecognizedText recognizedText =
        await _textRecognizer.processImage(inputImage);

    // Extract the text from the recognised text
    String text = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        text += line.text + '\n';
      }
      text += '\n';
    }

    // Update the state with the detected text
    setState(() {
      _cameraText = text;
      _isDetecting = false;
    });
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
            Container(
              child: AspectRatio(
                aspectRatio: _cameraController.value.aspectRatio,
                child: CameraPreview(_cameraController),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _cameraText,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
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
