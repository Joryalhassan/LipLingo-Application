import 'dart:io';
import 'package:flutter/material.dart';
import 'package:liplingo/controller/aiController.dart';
import 'package:liplingo/view/viewText.dart';
import 'package:video_player/video_player.dart';
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
              _processingVideoWidget();
              await sendVideo();
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
}
