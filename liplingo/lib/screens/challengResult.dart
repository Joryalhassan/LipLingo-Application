import 'package:flutter/material.dart';
import '../reusable_widget/reusable_widget.dart'; 
import 'package:liplingo/screens/challengeLevels.dart';
import 'package:liplingo/screens/level1.dart';
import 'package:liplingo/screens/level2.dart';
import 'package:liplingo/screens/level3.dart';
import 'package:liplingo/screens/level4.dart';
import 'package:liplingo/screens/level5.dart';
import 'package:liplingo/screens/level6.dart';
import 'package:liplingo/screens/level7.dart';
import 'package:liplingo/screens/level8.dart';
import 'package:liplingo/screens/level9.dart';
import 'package:liplingo/screens/level10.dart';
import 'package:liplingo/screens/level11.dart';
import 'package:liplingo/screens/level12.dart';
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    label: Text('Replay'),
                    icon: Icon(Icons.replay),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => getLevelWidget(levelNumber, context))
                      );
                    },
                    style: buttonStyle,
                  ),
                  ElevatedButton.icon(
                    label: Text('Next'),
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      saveResultAndUnlockNextLevel(context);
                         // Determine the next level dynamically based on the current level number
  int nextLevel = levelNumber + 1;

  // Navigate to the next level screen based on the next level number
  switch (nextLevel) {
    case 2:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Level2()));
      break;
    case 3:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Level3()));
      break;
   case 4:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Level4()));
      break;
    case 5:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Level5()));
      break;
    case 6:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Level6()));
      break;
    case 7:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Level7()));
      break;
    case 8:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Level8()));
      break;
    case 9:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Level9()));
      break;
    case 10:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Level10()));
      break;
    case 11:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Level11()));
      break;
    case 12:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Level12()));
      break;
    case 13:
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChallengeLevels()));
      break;
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
              SizedBox(height: 20),
              ElevatedButton.icon(
                label: Text('Menu'),
                icon: Icon(Icons.menu),
                onPressed: () {
                 saveResultAndUnlockNextLevel(context);
                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => ChallengeLevels()));
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
    case 3:
      return Level3();
    case 4:
      return Level4();
    case 5:
      return Level5();
    case 6:
      return Level6();
    case 7:
      return Level7();
    case 8:
      return Level8();
    case 9:
      return Level9();
    case 10:
      return Level10();
    case 11:
      return Level11();
    case 12:
      return Level12();
 
    default:
      return ChallengeLevels(); // Assuming this is a fallback or completion page.
  }
}

  final buttonStyle = ElevatedButton.styleFrom(
    primary: Colors.blue,
    onPrimary: Colors.white,
    textStyle: TextStyle(fontSize: 17),
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );
}
