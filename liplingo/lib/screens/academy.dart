// import 'package:flutter/material.dart';
// import '../reusable_widget/reusable_widget.dart';

// class AcademyScreen extends StatelessWidget {
//   const AcademyScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //Top App Bar
//       appBar: topBar(context, "Academy"),

//       //Main Body UI
//       body: Align(
//           alignment: Alignment.center,
//           child: Text(
//             "Academy Screen",
//           )),

//       //Bottom Nav Bar
//       bottomNavigationBar: bottomBar(context, 1),
//     );
//   }
// }

//----
// import 'package:flutter/material.dart';
// import '../reusable_widget/reusable_widget.dart';

// class AcademyScreen extends StatelessWidget {
//   const AcademyScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Top App Bar
//       appBar: topBar(context, "Academy"),

//       // Main Body UI
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               'Here you can find lessons and challenges to help you get the hang of lip reading.',
//               textAlign: TextAlign.center,
//             ),
//           ),
//           // Use a Column for clear vertical placement with specific heights
//           Column(
//             children: [
//               // "Academy" button with fixed height and reusable builder
//               _buildButton(context, 'Academy', Icons.book, height: 50.0),
//               // "Challenges" button with spacing and same style
//               SizedBox(height: 20.0), // Add spacing between buttons
//               _buildButton(context, 'Challenges', Icons.star, height: 50.0),
//             ],
//           ),
//           // Add more widgets for other UI elements as needed
//         ],
//       ),

//       // Bottom Nav Bar
//       bottomNavigationBar: bottomBar(context, 1),
//     );
//   }

//   Widget _buildButton(BuildContext context, String text, IconData icon,
//       {double height = 50.0}) {
//     return SizedBox(
//       height: height, // Set fixed height
//       child: ElevatedButton.icon(
//         onPressed: () {}, // Handle button press events
//         icon: Icon(icon),
//         label: Text(text),
//         style: ElevatedButton.styleFrom(
//           primary: Colors.blue, // Set your desired button color
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//         ),
//       ),
//     );
//   }
// }

//----

// import 'package:flutter/material.dart';
// import '../reusable_widget/reusable_widget.dart'; // Assuming path to your reusables

// class AcademyScreen extends StatelessWidget {
//   const AcademyScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Top App Bar
//       appBar: topBar(context, "Academy"),

//       // Main Body UI
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               'Here you can find lessons and challenges to help you get the hang of lip reading.',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
//             ),
//           ),
//           SizedBox(height: 20.0),
//           // Use a Column and fixed size for each button
//           Column(
//             children: [
//               _buildButton(context, 'Academy', Icons.book_sharp, size: 220.0),
//               SizedBox(height: 30.0), // Add spacing between buttons
//               _buildButton(context, 'Challenges', Icons.star, size: 220.0),
//             ],
//           ),
//           // Add more widgets for other UI elements as needed
//         ],
//       ),

//       // Bottom Nav Bar
//       bottomNavigationBar: bottomBar(context, 1),
//     );
//   }

//   Widget _buildButton(BuildContext context, String text, IconData icon,
//       {double size = 150.0}) {
//     return SizedBox(
//       height: size,
//       width: size, // Set the same width as the height for a square
//       child: ElevatedButton.icon(
//         onPressed: () {}, // Handle button press events
//         icon: Icon(icon),
//         label: Text(text),
//         style: ElevatedButton.styleFrom(
//           primary: Colors.blue, // Set your desired button color
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//         ),
//       ),
//     );
//   }
// }

//---ddd
// import 'package:flutter/material.dart';
// import '../reusable_widget/reusable_widget.dart'; // Assuming path to your reusables

// class AcademyScreen extends StatelessWidget {
//   const AcademyScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Top App Bar
//       appBar: topBar(context, "Academy"),

//       // Main Body UI
//       body: Center(
//         // Center the layout
//         child: Column(
//           mainAxisAlignment:
//               MainAxisAlignment.center, // Center widgets vertically
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 'Here you can find lessons and challenges to help you get the hang of lip reading.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
//               ),
//             ),
//             // Use separate GestureDetector widgets for each image
//             GestureDetector(
//               onTap: () {
//                 // Handle click event for the first image
//                 print(
//                     'First image clicked!'); // Example action, replace with your logic
//               },
//               child: ClipRRect(
//                 // Add ClipRRect to create rounded corners
//                 borderRadius: BorderRadius.circular(10.0),
//                 child: Image.asset(
//                   'assets/books.png',
//                   fit: BoxFit.cover, // Cover the entire image area
//                   width: 220.0, // Set image width
//                   height: 220.0, // Set image height
//                 ),
//               ),
//             ),
//             SizedBox(height: 20.0), // Add spacing between images
//             GestureDetector(
//               onTap: () {
//                 // Handle click event for the second image
//                 print(
//                     'Second image clicked!'); // Example action, replace with your logic
//               },
//               child: ClipRRect(
//                 // Add ClipRRect to create rounded corners
//                 borderRadius: BorderRadius.circular(10.0),
//                 child: Image.asset(
//                   'assets/books.png',
//                   fit: BoxFit.cover, // Cover the entire image area
//                   width: 220.0, // Set image width
//                   height: 220.0, // Set image height
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),

//       // Bottom Nav Bar
//       bottomNavigationBar: bottomBar(context, 1),
//     );
//   }
// }
//-fff
import 'package:flutter/material.dart';
import '../reusable_widget/reusable_widget.dart'; // Assuming path to your reusables
import 'package:liplingo/screens/lesson.dart';

class AcademyScreen extends StatelessWidget {
  const AcademyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top App Bar
      appBar: topBar(context, "Academy"),

      // Main Body UI
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10.0), // Adjust top padding
        child: Center(
          // Center the layout
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center widgets vertically
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  'Here you can find lessons and challenges to help you get the hang of lip reading.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
                ),
              ),
              SizedBox(height: 30.0),
              // Use separate GestureDetector widgets for each image
              GestureDetector(
                onTap: () {
                  // Navigate to lesson.dart screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LessonScreen()),
                  );
                },
                child: ClipRRect(
                  // Add ClipRRect to create rounded corners
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    'assets/book.png', // Replace with your image path
                    fit: BoxFit.cover, // Cover the entire image area
                    width: 220.0, // Set image width
                    height: 220.0, // Set image height
                  ),
                ),
              ),
              SizedBox(height: 20.0), // Add spacing between images
              GestureDetector(
                onTap: () {
                  // Navigate to lesson.dart screen (modify this for second image action if needed)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LessonScreen()),
                  );
                },
                child: ClipRRect(
                  // Add ClipRRect to create rounded corners
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    'assets/challenge.png', // Replace with your image path
                    fit: BoxFit.cover, // Cover the entire image area
                    width: 220.0, // Set image width
                    height: 220.0, // Set image height
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom Nav Bar
      bottomNavigationBar: bottomBar(context, 1),
    );
  }
}
