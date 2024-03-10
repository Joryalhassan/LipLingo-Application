import 'package:flutter/material.dart';
import '../reusable_widget/reusable_widget.dart';
import 'package:liplingo/screens/challengeLevels.dart';
//import 'package:liplingo/screens/lessonScreen.dart';

class AcademyScreen extends StatelessWidget {
  const AcademyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top App Bar
      appBar: topBar(context, "Academy"),
      // Main Body UI
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Here you can find lessons and challenges to help you get the hang of lip reading.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16, // Adjust font size to match design
                  color: Colors.grey[600], // Adjust color to match design
                ),
              ),
            ),
            SizedBox(height: 32), // Adjust spacing to match design
            // For Lessons Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
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
                      builder: (context) => ChallengeLevels()));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
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
