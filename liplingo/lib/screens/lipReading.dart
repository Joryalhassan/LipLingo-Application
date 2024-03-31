import 'package:flutter/material.dart';
import 'package:liplingo/screens/videoPreview.dart';
import 'package:liplingo/screens/viewText.dart';
import '../reusable_widget/reusableWidgets.dart';
import 'package:camera/camera.dart';

class LipReadingScreen extends StatefulWidget {
  @override
  _LipReadingScreenState createState() => _LipReadingScreenState();
}

class _LipReadingScreenState extends State<LipReadingScreen> {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoPreviewScreen(filePath: file.path),
      );
      Navigator.push(context, route);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        // Top App Bar
        appBar: topBar(context, "Academy"),
        body: Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        bottomNavigationBar: bottomBar(context, 0),
      );
    } else {
      return Scaffold(
        // Top App Bar
        appBar: topBar(context, "Academy"),
        body: Center(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CameraPreview(_cameraController),
              Padding(
                padding: const EdgeInsets.all(25),
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: Icon(_isRecording ? Icons.stop : Icons.circle),
                  onPressed: () => _recordVideo(),
                ),
              ),
              ElevatedButton(
                child: Text(
                    "ViewTextPage",
                    style: TextStyle(
                      fontSize: 17,
                    )
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ViewTextScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: bottomBar(context, 0),
      );
    }
  }
}
