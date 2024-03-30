import 'package:flutter/material.dart';
import '../reusable_widget/reusable_widget.dart';
import 'package:video_player/video_player.dart';

class VideoPage2 extends StatefulWidget {
  const VideoPage2({Key? key}) : super(key: key);

  @override
  _VideoPage2State createState() => _VideoPage2State();
}

class _VideoPage2State extends State<VideoPage2> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/try.mp4");
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    _controller.addListener(_onVideoStateChanged);
  }

  void _onVideoStateChanged() {
    if (_controller.value.isPlaying) {
      setState(() {
        _showControls = false;
      });
    } else {
      setState(() {
        _showControls = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoStateChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(context, "Lesson 1"),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _isPlaying = !_isPlaying;
            if (_isPlaying) {
              _controller.play();
            } else {
              _controller.pause();
            }
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Lesson 1: Title of First Lesson",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 16, 16, 0),
                  child: Container(
                    width: 350,
                    height: 220,
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 6.0,
                          ),
                        ),
                        child: FutureBuilder(
                          future: _initializeVideoPlayerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Handle marking complete
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                        vertical: 11,
                        horizontal: 35)), // Adjust padding for size
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  child: Text(
                    "Mark Complete",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: _showControls ? 1.0 : 0.0,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isPlaying = !_isPlaying;
                    if (_isPlaying) {
                      _controller.play();
                    } else {
                      _controller.pause();
                    }
                  });
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor:
                  MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all(CircleBorder()),
                  padding: MaterialStateProperty.all(EdgeInsets.all(24.0)),
                ),
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 75.0,
                ),
              ),
            ),
            Positioned(
              top: 25.0,
              left: 16.0,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  size: 50, // Increase icon size
                  color: Colors.blue, // Set icon color to blue
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Positioned(
              top: 30.0,
              right: 16.0,
              child: SizedBox(
                width: 70.0,
                height: 70.0,
                child: Stack(
                  children: [
                    // Background circle (gray)
                    SizedBox(
                      width: 60.0,
                      height: 60.0,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 9.0,
                        color: Colors.grey[400],
                      ),
                    ),
                    // Foreground circle (blue)
                    SizedBox(
                      width: 60.0,
                      height: 60.0,
                      child: CircularProgressIndicator(
                        value: 0.4, // Adjust based on progress
                        strokeWidth: 9.0,
                        color: Colors.blue,
                      ),
                    ),
                    // Positioned fraction text
                    Positioned(
                      top: 17.0,
                      left: 13.0,
                      child: Text(
                        "2/5", // Replace with dynamic fraction
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomBar(context, 1),
    );
  }
}