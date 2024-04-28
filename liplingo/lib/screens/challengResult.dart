import 'package:flutter/material.dart';
import '../reusable_widget/reusable_widget.dart'; 
import 'package:liplingo/screens/challengeLevels.dart';
import 'package:liplingo/screens/level1.dart';
import 'package:liplingo/screens/level2.dart';
import 'package:liplingo/screens/FirestoreService.dart'; // Ensure FirestoreService is imported

class ChallengeResult extends StatelessWidget {
  final int levelNumber;
  final int numberOfStars;


  ChallengeResult({
    Key? key,
    required this.levelNumber,
    required this.numberOfStars,
    
  }) : super(key: key);

  // The method that uses FirestoreService to update the level progress
  Future<void> saveResultAndUnlockNextLevel(BuildContext context) async {
    await FirestoreService.updateLevelProgress(levelNumber, numberOfStars);
    // Determine the next level dynamically based on the current level number
   
    int nextLevelNumber = levelNumber + 1;
    Widget nextLevelWidget;

    switch (nextLevelNumber) {
      case 2:
        nextLevelWidget = Level2();
        break;
      // Add cases for more levels as implemented.
      default:
        // If the next level doesn't exist, return to the main menu or show a completion message
        nextLevelWidget = ChallengeLevels();
        break;
    }

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => nextLevelWidget));
  
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = List.generate(3, (index) => Icon(
      Icons.star,
      color: index < numberOfStars ? Colors.yellow[600]! : Colors.grey,
      size: MediaQuery.of(context).size.width * 0.2, // responsive size for the stars
    ));

    String message = numberOfStars >= 2 ? (numberOfStars == 3 ? 'Excellent!' : 'Good Job!') : 'Try Again!';

    return Scaffold(
      appBar: topBar(context, "Challenge Results"),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(message, style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.1, fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: stars),
              SizedBox(height: 30),
              ElevatedButton.icon(
                label: Text('Replay'),
                icon: Icon(Icons.replay),
                onPressed: () {
                 Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => getLevelWidget(levelNumber, context)) );
                },
                style: buttonStyle,
              ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                label: Text('Menu'),
                icon: Icon(Icons.menu),
                onPressed: () {
                  // Save the result and go back to the menu
                    saveResultAndUnlockNextLevel(context); // Save and unlock next level
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ChallengeLevels()));
                },
                style: buttonStyle,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                label: Text('Next'),
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  // Save the result and go to the next challenge
                  saveResultAndUnlockNextLevel(context);
                    // Determine the next level dynamically based on the current level number
  int nextLevel = levelNumber + 1;

  // Navigate to the next level screen based on the next level number
  switch (nextLevel) {
    case 2:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Level2()));
      break;
    case 3:
    //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Level3()));
      break;
    // Add cases for more levels as you implement them
    default:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Level $nextLevel is under construction')),
      );
      break;
  }
                },
                style: buttonStyle,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomBar(context, 1),
    );
  }
Widget getLevelWidget(int level, BuildContext context) {
  switch (level) {
    case 1:
      return Level1();
    case 2:
      return Level2();
    // Add more cases as you implement more levels.
    default:
      return ChallengeLevels(); // Assuming this is a fallback or completion page.
  }
}

  final buttonStyle = ElevatedButton.styleFrom(
    primary: Colors.blue,
    onPrimary: Colors.white,
    textStyle: TextStyle(fontSize: 18),
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  );
}
