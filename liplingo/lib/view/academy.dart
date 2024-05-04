import 'package:flutter/material.dart';
import '../utils/reusableWidgets.dart';
import 'package:liplingo/view/challengeList.dart';
import 'lessonList.dart';

class AcademyScreen extends StatelessWidget {
  const AcademyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top App Bar
      appBar: topBar(context, "Academy"),
      // Main Body UI
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Here you can find lessons and \n challenges to help you get the hang \nof lip reading.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16, // Adjust font size to match design
                  color: Colors.grey[600], // Adjust color to match design
                ),
              ),
            ),
            SizedBox(height: 90), // Adjust spacing to match design
            // For Lessons Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LessonListScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  // Adjust padding to match design
                  elevation: 4,
                  // Add shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8), // Match button corner radius to design
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/Academy_LessonIcon.png',
                      width: 150, // Adjust the width as needed
                      height: 100, // Adjust the height as needed
                    ),
                    SizedBox(height: 8), // Adjust space between image and text
                    Text(
                      'Lessons',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20), // Adjust font size to match design
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32), // Adjust spacing to match design
            // For Challenges Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChallengeListScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  // Adjust padding to match design
                  elevation: 4,
                  // Add shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8), // Match button corner radius to design
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/Academy_ChallengesIcon.png',
                      width: 150, // Adjust the width as needed
                      height: 100, // Adjust the height as needed
                    ),
                    SizedBox(height: 8), // Adjust space between image and text
                    Text(
                      'Challenges',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20), // Adjust font size to match design
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
