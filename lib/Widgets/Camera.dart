import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

// Define a custom widget that contains the camera preview and the text.
class CameraWidget extends StatelessWidget {
  final CameraController _cameraController;
  final String _cameraText;

  CameraWidget(this._cameraController, this._cameraText);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        ),
      ],
    );
  }
}
