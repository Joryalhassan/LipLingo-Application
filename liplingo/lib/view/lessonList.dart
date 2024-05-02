import 'package:flutter/material.dart';
import 'package:liplingo/view/lessonVideo.dart';
import '../controller/lessonController.dart';
import '../model/lessonModel.dart';
import '../utils/reusableWidgets.dart';

class LessonListScreen extends StatefulWidget {
  const LessonListScreen({Key? key}) : super(key: key);

  @override
  State<LessonListScreen> createState() => _LessonListScreen();
}

class _LessonListScreen extends State<LessonListScreen> {
  LessonController _lessonController = new LessonController();

  @override
  void initState() {
    super.initState();
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
        // Wrap with Container
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: backButton(context),
                  ),
                  // White rectangle card with progress counter and text
                  FutureBuilder(
                    future: _lessonController.getUserProgress(),
                    builder: (_, userProgressSnapshot) {
                      if (userProgressSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      var userProgress = userProgressSnapshot.data ?? [0, 0];

                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // Align rows horizontally
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, // Align left
                                    children: [
                                      Text(
                                        "Progress:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22.0, // Larger font size
                                        ),
                                      ),
                                      SizedBox(height: 6.0),
                                      Text(
                                        userProgress[0].toString() +
                                            " out of " +
                                            userProgress[1].toString() +
                                            " lessons \ncomplete",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 17.0,
                                        ),
                                      ),
                                    ],
                                  ),
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
                                            color: Colors.grey[
                                                400], // Set background color to grey
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
                                                value: userProgress[0] /
                                                    userProgress[1],
                                                // Adjust based on progress
                                                strokeWidth: 9.0,
                                                // Keep the stroke width the same
                                                color: Colors
                                                    .blue, // Maintain the blue color
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
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Column(
                    children: [
                      SizedBox(height: 20.0),
                      // Add spacing between card and lessons
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 5, bottom: 5),
                        child: Text(
                          "Lessons:",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // List of clickable lesson cards
                      FutureBuilder<List<Lesson>>(
                          future: _lessonController.getLessonList(),
                          builder: (context, lessonSnapshot) {
                            if (lessonSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (lessonSnapshot.hasError ||
                                lessonSnapshot.data == null) {
                              return Center(
                                  child: Text('Error: Cannot load lessons.'));
                            }

                            final lessons = lessonSnapshot.data;
                            //final compLesson = compLessonSnapshot.data;

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: lessons?.length,
                              itemBuilder: (context, index) {

                                final lesson = lessons?[index];

                                return Padding(
                                  padding: EdgeInsets.only(bottom: 7),
                                  child: LessonCard(
                                    level: lesson!.level,
                                    title: lesson.title,
                                    isCompleted: lesson.status,
                                    onTap: () {
                                      // Navigate to the respective lesson page
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LessonVideoScreen(
                                                  lessonData: lesson)),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: bottomBar(context, 1),
    );
  }
}

class LessonCard extends StatelessWidget {
  final String level;
  final String title;
  final bool isCompleted;
  final void Function() onTap;

  const LessonCard({
    required this.level,
    required this.title,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? cardColor = isCompleted ? (Colors.lightGreen[100]) : Colors.white;
    Icon icon = isCompleted
        ? Icon(
            Icons.check_circle,
            color: Colors.green[300],
            size: 40.0,
          )
        : Icon(
            Icons.arrow_circle_right_outlined,
            color: Colors.blue,
            size: 40.0,
          );

    return InkWell(
      // Wrap the card in an InkWell for click feedback and navigation
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Lesson " + level,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Lesson " + level + ": " + title,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 5.0),
                  icon,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
