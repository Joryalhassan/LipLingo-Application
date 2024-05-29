import 'dart:io';
import 'package:flutter/material.dart';
import 'package:liplingo/controller/aiController.dart';
import 'package:liplingo/view/viewText.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'lipReading.dart';

class VideoPreviewScreen extends StatefulWidget {
  final String filePath;
  final bool isUploaded;

  const VideoPreviewScreen(
      {Key? key, required this.filePath, required this.isUploaded})
      : super(key: key);

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends State<VideoPreviewScreen> {
  late VideoPlayerController _videoPlayerController;
  AIController _aiController = new AIController();
  final FaceDetector faceDetector = GoogleMlKit.vision.faceDetector();

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
    await _videoPlayerController.setVolume(0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.8,
        toolbarHeight: 70,
        leadingWidth: 15,
        backgroundColor: Colors.white,
        title: Text(
          "Confirm Video?",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check,
              color: Colors.lightGreenAccent,
              size: 35,
            ),
            onPressed: () async {
              _videoPlayerController.pause();
              await detectFaces(File(widget.filePath));
            },
          ),
          IconButton(
            icon: ImageIcon(
              AssetImage('assets/VideoPreview_Close.png'),
              color: Colors.red,
              size: 20,
            ),
            onPressed: () {
              _videoPlayerController.pause();
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
            future: _initVideoPlayer(),
            builder: (context, state) {
              if (state.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // Extract the first frame as an image
  Future<void> detectFaces(File videoFile) async {
    try {
      print('Starting face detection...');

      // Run ffmpeg command to extract first frame
      final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
      final Directory tempDir = Directory.systemTemp;
      final String tempImagePath = '${tempDir.path}/first_frame.jpg';

      await _flutterFFmpeg.execute(
          '-i ${videoFile.path} -vframes 1 $tempImagePath');

      print('First frame extracted successfully.');

      // Load first frame as input image
      final inputImage = InputImage.fromFilePath(tempImagePath);

      // Detect faces in the input image
      final List<Face> faces = await faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        print('Faces detected: ${faces.length}');

        // Proceed with further actions
        _processingVideoWidget();
        await sendVideo();
      } else {
        print('No faces detected.');
        _errorMessage();
      }

      // Delete temporary image file
      File(tempImagePath).deleteSync();
    } catch (e) {
      print('Error during face detection: $e');
      _errorMessage();
    }
  }

  //Send video to AI
  Future<void> sendVideo() async {
    try {
      String translatedText = await _aiController.interpretToText(
          File(widget.filePath), widget.isUploaded);
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ViewTextScreen(translatedText: translatedText)));

    } catch (error) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LipReadingScreen()));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(20.0), 
            ),
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 35, 40, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Server Error",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "There's been an error reaching the server. Please try again.",
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

  //Loading widget
  void _processingVideoWidget() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(30, 35, 30, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Processing Video...",
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue),
                ),
                const SizedBox(height: 10),
                Text(
                  "This might take a few seconds. We appreciate your patience.",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  //Error message
  void _errorMessage(){
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LipReadingScreen()));
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
                  "Interpretation Error",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Unable to detect a lip region to interpret. Please try again.",
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
