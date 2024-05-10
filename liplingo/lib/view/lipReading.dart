//Flutter Packages
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

//Controller
import '../controller/videoController.dart';

//Views
import '../view/savedTextList.dart';
import '../view/videoPreview.dart';
import '../utils/reusableWidgets.dart';

class LipReadingScreen extends StatefulWidget {
  @override
  _LipReadingScreenState createState() => _LipReadingScreenState();
}

class _LipReadingScreenState extends State<LipReadingScreen> {
  final _videoController = VideoController();
  late CameraController _cameraController;
  bool _isLoading = true;
  bool _isRecording = false;
  bool _isFrontCamera = true;
  static const _minSeconds = 0;
  int _seconds = _minSeconds;
  Timer? _timer;

  @override
  void initState() {
    _initializeCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Loading Screen while camera is initialized
    if (_isLoading) {
      return _loadingScreen();

      //Recording video screen
    } else if (_isRecording) {
      return _recordingScreen();

      //LipReading Page
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
              //Camera Stream
              CameraPreview(_cameraController),

              //Face frame
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Colors.grey.withOpacity(0.4), BlendMode.srcOut),
                // This one will create the magic
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          backgroundBlendMode: BlendMode
                              .dstOut), // This one will handle background + difference out
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 170),
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

              //Buttons
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
                        onPressed: () => _switchCamera(),
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
                        _buildButton("Upload Video"),
                        _buildButton("Saved Text List"),
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

  Widget _loadingScreen() {
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
  }

  Widget _recordingScreen() {
    String getFormattedTime(int seconds) {
      int minutes = seconds ~/ 60;
      int remainingSeconds = seconds % 60;
      String minutesStr = (minutes < 10) ? '$minutes' : '$minutes';
      String secondsStr =
          (remainingSeconds < 10) ? '0$remainingSeconds' : '$remainingSeconds';
      return '$minutesStr:$secondsStr';
    }

    return Scaffold(
      appBar: AppBar(
        leading: null,
        backgroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Stack(
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
                        margin: const EdgeInsets.only(bottom: 170),
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
                      getFormattedTime(_seconds),
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 15),
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
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.08,
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String _label) {
    return ElevatedButton(
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
      child: Text(_label,
          style: TextStyle(
            fontSize: 18,
          )),
      onPressed: () {
        if (_label == "Upload Video") {
          _checkUploadVideo();
        } else if (_label == "Saved Text List") {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SavedTextListScreen()));
        }
      },
    );
  }

  void _checkUploadVideo() async {
    try{
      String _feedback = await _videoController.uploadVideo(context);
      if(_feedback == "Exceeds duration"){
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
        Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => VideoPreviewScreen(filePath: _feedback, isUploaded: true),
            ));
      }
    } catch (error) {
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
                    "There has been an error in uploading the video.",
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

  _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = _isFrontCamera
          ? cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.front)
          : cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back);
      _cameraController = CameraController(camera, ResolutionPreset.max);
      await _cameraController.initialize();
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
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
                      "Camera Error",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Failed to initialize camera. Please grant camera permission.",
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
      });
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

  void _switchCamera() {
    setState(() {
      _isFrontCamera = !_isFrontCamera;
      _initializeCamera();
    });
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
        builder: (_) => VideoPreviewScreen(filePath: file.path, isUploaded: false),
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
}
