import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:liplingo/view/lessonList.dart';
import 'package:video_player/video_player.dart';
import '../controller/lessonController.dart';
import '../model/lessonModel.dart';
import '../utils/reusableWidgets.dart';

class LessonVideoScreen extends StatefulWidget {
  final Lesson lessonData;

  const LessonVideoScreen({Key? key, required this.lessonData})
      : super(key: key);

  @override
  State<LessonVideoScreen> createState() => _LessonVideState();
}

class _LessonVideState extends State<LessonVideoScreen> {

  LessonController _lessonController = new LessonController();
  late bool _isCompleted = widget.lessonData.status;
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();

    //Video player
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(
            Uri.parse(widget.lessonData.videoPath)));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(context, "Lessons"),
      body: Container(
        child: Stack(children: [
          Positioned(
            top: 30,
            left: 25,
            child: IconButton(
              icon: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LessonListScreen()));
              },
            ),
          ),
          Positioned(
            top: 25,
            right: 25,
            child: FutureBuilder(
              future: _lessonController.getUserProgress(),
              builder: (_, userProgressSnapshot) {
                if (userProgressSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                var userProgress = userProgressSnapshot.data ?? [0, 0];

                return Column(
                  children: [
                    // Circular progress indicator with fraction text overlay
                    Stack(
                      children: [
                        // Background circle (grey) - centered with size
                        Center(
                          child: SizedBox(
                            width: 70.0,
                            height: 70.0,
                            child: CircularProgressIndicator(
                              value: 1.0,
                              // Full circle
                              strokeWidth: 9.0,
                              // Adjust stroke width as needed
                              color: Colors
                                  .grey[400], // Set background color to grey
                            ),
                          ),
                        ),

                        // Foreground circle (blue) - centered and same size
                        Center(
                          child: Stack(
                            children: [
                              // Unchanged blue progress indicator
                              SizedBox(
                                width: 70.0,
                                height: 70.0,
                                child: CircularProgressIndicator(
                                  value: userProgress[0] / userProgress[1],
                                  // Adjust based on progress
                                  strokeWidth: 9.0,
                                  // Keep the stroke width the same
                                  color: Colors.blue, // Maintain the blue color
                                ),
                              ),

                              // Positioned fraction text
                              Positioned(
                                top: 22.0,
                                // Adjust vertical position as needed
                                left: 17.0,
                                // Adjust horizontal position as needed
                                child: Text(
                                  userProgress[0].toString() +
                                      "/" +
                                      userProgress[1].toString(),
                                  // Replace with dynamic fraction
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25.0,
                                    // Adjust font size as needed
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //DELETE
                  ],
                );
              },
            ),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Lesson ${widget.lessonData.level}: ${widget.lessonData.title}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: FlickVideoPlayer(flickManager: flickManager)),
                const SizedBox(height: 15),
                _isCompleted
                    ? ElevatedButton.icon(
                        onPressed: () {
                          markLessonComplete();
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: 11, horizontal: 35)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                        ),
                        label: Text(
                          "Completed",
                          style: TextStyle(fontSize: 18),
                        ),
                        icon: Icon(
                          Icons.check_circle_outline,
                          size: 20.0,
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          markLessonComplete();
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: 11, horizontal: 35)),
                          // Adjust padding for size
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
              ]),
        ]),
      ),
      bottomNavigationBar: bottomBar(context, 1),
    );
  }

  void markLessonComplete() {

    setState(() {
      print(_isCompleted);
      // Handle marking complete
      _lessonController.updateLessonStatus((widget.lessonData.lessonID));
      _isCompleted = !_isCompleted;
    });
  }

}
