import 'dart:io';
import 'package:flutter/material.dart';
import 'package:liplingo/screens/viewText.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

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

              //Send Video to server
              //_sendVideoToServer(File(widget.filePath));

              _videoPlayerController.pause();
              String translatedText = await _sendVideoToServer(File(widget.filePath));
              //String translatedText = "Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. Test Text. ";
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ViewTextScreen(translatedText: translatedText)));
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
      body: FutureBuilder(
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
    );
  }
}

Future<String> _sendVideoToServer(File videoFile) async {
  try {
    var uri = Uri.parse('http://your-api-url.com/predict'); // Replace with your API URL
    var request = http.MultipartRequest('POST', uri);
    var response = await request.send();

    if (response.statusCode == 200) {
      // Video successfully uploaded to the server
      final respStr = await response.stream.bytesToString();
      print('Video uploaded successfully');
      return respStr;
    } else {
      // Error uploading the video
      print('Error uploading video: ${response.reasonPhrase}');
      throw Exception('Error uploading video: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error sending request: $e');
    throw Exception('Error sending request: $e');
  }
}