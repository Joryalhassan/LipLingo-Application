import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../reusable_widget/reusable_widget.dart'; 
import 'package:liplingo/screens/challengeLevels.dart';
import 'package:liplingo/screens/level2.dart';

class ChallengeResult extends StatelessWidget {
  final int levelNumber;
  final int numberOfStars;
  final VoidCallback onReplay;

  ChallengeResult({
    Key? key,
    required this.levelNumber,
    required this.numberOfStars,
    required this.onReplay,
  }) : super(key: key);

  Future<void> _saveResultAndUnlockNextLevel() async {
  final prefs = await SharedPreferences.getInstance();
  
  // Save stars achieved for the current level
  await prefs.setInt('level_${levelNumber}_stars', numberOfStars);

  // Check if the conditions for unlocking the next level are met
  if (numberOfStars >= 1 && levelNumber < 12) {
    // Unlock the next level
    await prefs.setBool('level_${levelNumber + 1}_unlocked', true);
  }
}




  @override
  Widget build(BuildContext context) {
    List<Widget> stars = List.generate(3, (index) {
      return Icon(
        Icons.star,
        color: index < numberOfStars ? Colors.yellow[600]! : Colors.grey,
        size: MediaQuery.of(context).size.width * 0.2, // responsive size for the stars
      );
    });

    String message = numberOfStars >= 2 ? (numberOfStars == 3 ? 'Excellent!' : 'Good Job!') : 'Good Job!';

    List<Widget> actionButtons = [
      _buildButton(context, 'Replay', Icons.replay, () => onReplay()),
      SizedBox(width: 10), // Add space between buttons
      _buildButton(context, 'Menu',Icons.menu, () async {
       await _saveResultAndUnlockNextLevel(); // Save and unlock next level
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ChallengeLevels())); 
      }),
    ];

   Widget thirdButton = _buildButton(context, 'Next',Icons.arrow_forward, () async {
  await _saveResultAndUnlockNextLevel(); // Save and unlock next level

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
});


    return Scaffold(
      appBar: topBar(context, "Challenges"), // Use the custom topBar
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                message,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: stars,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...actionButtons,
                ],
              ),
              SizedBox(height: 20), // Add space between buttons and the Next button
              thirdButton,
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomBar(context, 1), // Use the custom bottomBar
    );
  }

  Widget _buildButton(BuildContext context, String label, IconData icon, VoidCallback onPressed) {
  return ElevatedButton.icon(
    label: Text(label),
    icon: Icon(icon),
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      primary: Colors.blue,
      onPrimary: Colors.white,
      textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.045), // responsive font size
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.015,
        horizontal: MediaQuery.of(context).size.width * 0.1,
      ), // responsive padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  );
}
}
