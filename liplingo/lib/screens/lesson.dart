// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../reusable_widget/reusable_widget.dart';

// class LessonScreen extends StatelessWidget {
//   const LessonScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     //Logged In user's infromation
//     final user = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       //Top App Bar
//       appBar: topBar(context, "Lesson"),

//       //Bottom nav Bar
//       bottomNavigationBar: bottomBar(context, 0),
//     );
//   }
// }

//dddddddd

import 'package:flutter/material.dart';
import '../reusable_widget/reusable_widget.dart'; // Assuming path to your reusables
import 'package:liplingo/screens/VideoPage.dart';
import 'package:liplingo/screens/VideoPage2.dart';
import 'package:liplingo/screens/VideoPage3.dart';
import 'package:liplingo/screens/VideoPage4.dart';
import 'package:liplingo/screens/VideoPage5.dart';

class LessonScreen extends StatelessWidget {
  const LessonScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(context, "Lesson"),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center the column vertically
            children: [
              // White rectangle card with progress counter and text
              SizedBox(height: 20.0),
              Container(
                width: 300.0, // Adjust width as needed
                height: 120.0, // Adjust height as needed
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Align rows horizontally
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
                            "2 out of 5 lessons \ncomplete",
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
                                value: 1.0, // Full circle
                                strokeWidth:
                                    9.0, // Adjust stroke width as needed
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
                                    value: 0.4, // Adjust based on progress
                                    strokeWidth:
                                        9.0, // Keep the stroke width the same
                                    color:
                                        Colors.blue, // Maintain the blue color
                                  ),
                                ),

                                // Positioned fraction text
                                Positioned(
                                  top:
                                      22.0, // Adjust vertical position as needed
                                  left:
                                      17.0, // Adjust horizontal position as needed
                                  child: Text(
                                    "2/5", // Replace with dynamic fraction
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          25.0, // Adjust font size as needed
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
              SizedBox(height: 20.0), // Add spacing between card and lessons
              Container(
                alignment: Alignment.centerLeft, // Align content to the left
                padding: const EdgeInsets.only(left: 50.0), // Add left padding
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
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: LessonCard(
                      title: "Lesson 1",
                      subtitle: "Lesson1: Alphabet letters",
                      onTap: () {
                        // Navigate to the respective lesson page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VideoPage()),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: LessonCard(
                      title: "Lesson 2",
                      subtitle: "Lesson2: Numbers",
                      onTap: () {
                        // Navigate to the respective lesson page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VideoPage2()),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: LessonCard(
                      title: "Lesson 3",
                      subtitle: "Lesson3: Colors",
                      onTap: () {
                        // Navigate to the respective lesson page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VideoPage3()),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: LessonCard(
                      title: "Lesson 4",
                      subtitle: "Lesson4: Words",
                      onTap: () {
                        // Navigate to the respective lesson page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VideoPage4()),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: LessonCard(
                      title: "Lesson 5",
                      subtitle: "Lesson5: Phrases",
                      onTap: () {
                        // Navigate to the respective lesson page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VideoPage5()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomBar(context, 1),
    );
  }
}

class LessonCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final void Function() onTap; // Callback function for navigation

  const LessonCard({
    required this.title,
    required this.subtitle,
    required this.onTap, // Pass the onTap callback as a parameter
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Wrap the card in an InkWell for click feedback and navigation
      onTap: onTap,
      child: Container(
        height: 100,
        width: 300.0, // Adjust width as needed
        decoration: BoxDecoration(
          color: Colors.grey[200], // Use a light grey color
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align content to start
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                  height:
                      0.0), // Add some vertical spacing between title and subtitle
              Row(
                children: [
                  Expanded(
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color:
                            Colors.grey[600], // Use a darker grey for subtitle
                      ),
                    ),
                  ),
                  SizedBox(
                      width: 5.0), // Add some spacing between text and icon
                  Icon(
                    Icons.arrow_circle_right_outlined,
                    color: Colors.blue,
                    size: 40.0, // Increased size from 16.0 to 20.0
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


//dddd


