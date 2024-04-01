import 'package:flutter/material.dart';
import 'package:liplingo/screens/savedTextList.dart';
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
        appBar: topBar(context, "Lip Reading"),
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
        appBar: topBar(context, "Lip Reading"),
        extendBodyBehindAppBar: true,
        body: Center(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CameraPreview(_cameraController),
              _isRecording
                  ? Padding(
                      padding: const EdgeInsets.all(25),
                      child: FloatingActionButton(
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.stop,
                          size: 30,
                        ),
                        onPressed: () => _recordVideo(),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 40,
                            ),
                            onPressed: () => _recordVideo(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 13.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: Colors.blue,
                              ),
                              child: Text("Upload Video",
                                  style: TextStyle(
                                    fontSize: 18,
                                  )),
                              onPressed: () {},
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 13.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: Colors.blue,
                              ),
                              child: Text("Saved Text List",
                                  style: TextStyle(
                                    fontSize: 18,
                                  )),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        SavedTextListScreen()));
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 35),
                      ],
                    ),
            ],
          ),
        ),
        bottomNavigationBar: bottomBar(context, 0),
      );
    }
  }
}
