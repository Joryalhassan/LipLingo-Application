import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liplingo/screens/savedTextList.dart';
import 'package:liplingo/screens/videoPreview.dart';
import 'package:video_player/video_player.dart';
import '../utils/reusableWidgets.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class LipReadingScreen extends StatefulWidget {
  @override
  _LipReadingScreenState createState() => _LipReadingScreenState();
}

class _LipReadingScreenState extends State<LipReadingScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = true;
  bool _isRecording = false;
  bool _isFrontCamera = true;
  late CameraController _cameraController;
  static const _minSeconds = 0;
  int _seconds = _minSeconds;
  Timer? _timer;

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
    final camera = _isFrontCamera
        ? cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front)
        : cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(camera, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    final timerCompleted = _seconds == 60;

    if (_isRecording || timerCompleted) {
      final file = await _cameraController.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoPreviewScreen(filePath: file.path),
      );
      stopTimer();
      Navigator.push(context, route);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
      startTimer(); // Start timer when recording starts
    }
  }

  void startTimer({bool reset = true}) {
    if (reset) {
      _seconds = _minSeconds;
    }

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (_seconds < 60) {
        setState(() => _seconds++);
      } else {
        setState(() => _timer?.cancel());
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    // Reset Timer
    _seconds = _minSeconds;
  }

  void toggleCamera() {
    setState(() {
      _isFrontCamera = !_isFrontCamera;
      _initCamera();
    });
  }

  Future<void> _pickVideo() async {
    try {
      final XFile? pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 1),
      );
      if (pickedFile != null) {
        final video = VideoPlayerController.file(File(pickedFile.path));
        await video.initialize();
        final Duration duration = video.value.duration;
        await video.dispose();

        if (duration.inSeconds > 60) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // Adjust the value as needed
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(40, 35, 40, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Video Upload Error",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "The video you have tried to upload is longer than one minute.",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 27.0,
                              vertical: 10.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                          child: Text(
                            "Ok",
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          final route = MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => VideoPreviewScreen(filePath: pickedFile.path),
          );
          Navigator.push(context, route);
        }
      }
    } on PlatformException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20.0), // Adjust the value as needed
            ),
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 35, 40, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Video Upload Error",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "There has been an error in uploading the video. Please ensure that you have given permission to the app to access your camera roll.",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 27.0,
                          vertical: 10.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      child: Text(
                        "Ok",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
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
    } else if (_isRecording) {
      return Scaffold(
        appBar: AppBar(
          leading: null,
          backgroundColor: Colors.white,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          alignment: Alignment.center,
          children: [
            CameraPreview(_cameraController),
            // Oval-shaped face fitting widget
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Colors.grey.withOpacity(0.2), BlendMode.srcOut),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        backgroundBlendMode: BlendMode.dstOut),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.only(top: 80),
                      height: 350,
                      width: 275,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(
                          Radius.elliptical(300, 400),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$_seconds',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 75,
                    width: 75,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: _seconds / 60,
                          strokeWidth: 10,
                          valueColor: AlwaysStoppedAnimation(Colors.red),
                          backgroundColor: Colors.grey,
                        ),
                        FloatingActionButton(
                          backgroundColor: Colors.white,
                          onPressed: () => _recordVideo(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 70),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
        ),
      );
    } else {
      return Scaffold(
        // Top App Bar
        appBar: topBar(context, "Lip Reading"),
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              CameraPreview(_cameraController),
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Colors.grey.withOpacity(0.2), BlendMode.srcOut), // This one will create the magic
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          backgroundBlendMode: BlendMode.dstOut), // This one will handle background + difference out
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: const EdgeInsets.only(top: 80),
                        height: 350,
                        width: 275,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(
                              Radius.elliptical(300, 400),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Positioned(
                      top: 20,
                      right: 20,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        child: Icon(
                          Icons.flip_camera_android,
                          size: 30,
                        ),
                        onPressed: () => toggleCamera(),
                      ),
                    ),
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
                          onPressed: () {
                            _pickVideo();
                          },
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
                                builder: (context) => SavedTextListScreen()));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 35),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: bottomBar(context, 0),
      );
    }
  }
}
