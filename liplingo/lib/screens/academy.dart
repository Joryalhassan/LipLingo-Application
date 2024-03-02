import 'package:flutter/material.dart';
import '../reusable_widget/reusable_widget.dart';
import 'package:liplingo/screens/challengeLevels.dart';
class AcademyScreen extends StatelessWidget {
  const AcademyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top App Bar
      appBar: topBar(context, "Academy"),

      // Main Body UI
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the column
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch buttons to full width
          children: <Widget>[
            Text(
              'Here you can find lessons and challenges to help you get the hang of lip reading.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              child: Text('Lessons'),
              onPressed: () {
                // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LessonsScreen()),
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
               child: Text('Challenges'),
               onPressed: () {
               Navigator.of(context).push(MaterialPageRoute(builder: (context) => challengeLevels()),);
                       },
               style: ElevatedButton.styleFrom(
              primary: Colors.blue,
                onPrimary: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
               ),

          ],
        ),
      ),

      // Bottom Nav Bar
      bottomNavigationBar: bottomBar(context, 1),
    );
  }
}
