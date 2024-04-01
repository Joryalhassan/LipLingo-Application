import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends StatefulWidget {
  final String filePath;

  const VideoPreviewScreen({Key? key, required this.filePath})
      : super(key: key);

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends State<VideoPreviewScreen> {
  late VideoPlayerController _videoPlayerController;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.8,
        toolbarHeight: 70,
        leadingWidth: 15,
        backgroundColor: Colors.white,
        title: Text("Confirm Video?",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            )),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check,
              color: Colors.lightGreenAccent,
              size: 35,
            ),
            onPressed: () {
              ;
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.cancel,
              color: Colors.red,
              size: 35,
            ),
            onPressed: () {
              ;
            },
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: _initVideoPlayer(),
        builder: (context, state) {
          if (state.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return VideoPlayer(_videoPlayerController);
          }
        },
      ),
    );
  }
}
