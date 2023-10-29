import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:split_shit/Widgets/Camera.dart';

class ReceiptScreen extends StatefulWidget {
  // This widget is the first screen of the application.
  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen>
    with SingleTickerProviderStateMixin {
  // This state object manages the animation controller and the camera controller.
  late AnimationController _animationController;
  // Declare a camera controller and a text detector
  late CameraImage _image;
  late bool _isDetecting = false;
  late TextRecognizer _textRecognizer;
  late CameraController _cameraController;

  // Declare a variable to store the recognized text
  String _cameraText = '';

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller with a duration of one second.
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    // Initialize the camera with the first available camera
    _requestCameraPermission();
    // Initialize the text detector
    _textRecognizer = GoogleMlKit.vision.textRecognizer();
    _animationController.reverse();
  }

  @override
  void dispose() {
    // Dispose the animation controller and the camera controller when not needed.
    _animationController.dispose();
    _cameraController.dispose();
    _textRecognizer.close();
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
              'This is the receipt screen.',
            ),
            ElevatedButton(
              child: Text('Go to settings screen'),
              onPressed: () {
                // Navigate to the third screen using a named route.
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ElevatedButton(
              child: Text('Slide up/down'),
              onPressed: () {
                // Toggle the animation controller between forward and reverse states.
                if (_animationController.isCompleted) {
                  _animationController.reverse();
                } else {
                  _animationController.forward();
                }
              },
            ),
            // Use an animated builder to create a sliding animation for the camera widget.
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                      0,
                      -_animationController.value *
                          MediaQuery.of(context).size.height /
                          2),
                  child: child,
                );
              },
              // Use the custom widget to display the camera preview and the text.
              child: CameraWidget(_cameraController, _cameraText),
            ),
          ],
        ),
      ),
    );
  }
}
