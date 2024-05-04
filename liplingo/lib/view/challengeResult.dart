import 'package:flutter/material.dart';
import 'package:liplingo/controller/challengeController.dart';
import '../utils/reusableWidgets.dart';
import '../view/challengeList.dart';

class ChallengeResultScreen extends StatelessWidget {
  final int levelNumber;
  final int numberOfStars;

  ChallengeResultScreen({
    Key? key,
    required this.levelNumber,
    required this.numberOfStars,
  }) : super(key: key);

  ChallengeController _challengeController = new ChallengeController();

  Future<void> saveResultAndUnlockNextLevel(BuildContext context) async {
    await _challengeController.updateLevelProgress(levelNumber, numberOfStars);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = List.generate(
        3,
        (index) => Icon(
              Icons.star,
              color: index < numberOfStars ? Colors.yellow[600]! : Colors.grey,
              size: MediaQuery.of(context).size.width *
                  0.2, // responsive size for the stars
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
              Text(message,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.1,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: stars),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    label: Text('Replay'),
                    icon: Icon(Icons.replay),
                    onPressed: () async {
                      _challengeController.navigateToLevel(context, levelNumber);
                    },
                    style: buttonStyle,
                  ),
                  ElevatedButton.icon(
                    label: Text('Next'),
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () async {

                      saveResultAndUnlockNextLevel(context);
                      // Determine the next level dynamically based on the current level number
                      int nextLevel = levelNumber + 1;
                      print(nextLevel);
                      _challengeController.navigateToLevel(context, nextLevel);

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
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChallengeListScreen()));
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

  final buttonStyle = ElevatedButton.styleFrom(
    primary: Colors.blue,
    onPrimary: Colors.white,
    textStyle: TextStyle(fontSize: 17),
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );
}
