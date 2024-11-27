import 'package:flutter/material.dart';
import 'camera_controller.dart';  // Import the controller file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Camera',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CameraPage(),
    );
  }
}

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final CameraController _cameraController = CameraController();
  double _zoomLevel = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Camera Zoom')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              // You can add the camera preview here if necessary
            ),
          ),
          Slider(
            value: _zoomLevel,
            min: 1.0,
            max: 5.0,
            onChanged: (value) {
              setState(() {
                _zoomLevel = value;
              });
              _cameraController.setZoomLevel(_zoomLevel);
            },
          ),
        ],
      ),
    );
  }
}
