import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/reusableWidgets.dart';
import 'package:liplingo/screens/level1.dart';
import 'package:liplingo/screens/level2.dart';

class ChallengeLevels extends StatefulWidget {
  @override
  _ChallengeLevelsState createState() => _ChallengeLevelsState();
}

class _ChallengeLevelsState extends State<ChallengeLevels> {
  List<bool> levelLockStatus = List.filled(12, false);
  List<int> levelStars = List.filled(12, 0);

  @override
  void initState() {
    super.initState();
    _loadLevelStatus();
  }

  Future<void> _loadLevelStatus() async {
    final prefs = await SharedPreferences.getInstance();
    List<bool> tempLockStatus = [true]; // First level unlocked by default
    List<int> tempStars = [0]; // No stars by default
    for (int i = 1; i < 12; i++) {
      bool isUnlocked = prefs.getBool('level_${i + 1}_unlocked') ?? false;
      int stars = prefs.getInt('level_${i + 1}_stars') ?? 0;
      tempLockStatus.add(isUnlocked);
      tempStars.add(stars);
    }
    setState(() {
      levelLockStatus = tempLockStatus;
      levelStars = tempStars;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(context, "Challenges"),
      body: Column(
        children: [
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: backButton(context),
          ),
          Expanded( // Use Expanded to fill the remaining space with GridView
            child: GridView.builder(
              // Adjust padding as needed for your design
              padding: EdgeInsets.fromLTRB(16.0, MediaQuery.of(context).padding.top, 16.0, 16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                return ChallengeCard(
                  levelNumber: index + 1,
                  isLocked: !levelLockStatus[index],
                  stars: levelStars[index],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomBar(context, 1),
    );
  }
}

class ChallengeCard extends StatelessWidget {
  final int levelNumber;
  final bool isLocked;
  final int stars; // Initialize with the value loaded from SharedPreferences

  const ChallengeCard({
    Key? key,
    required this.levelNumber,
    required this.isLocked,
    required this.stars, // Initialize with the value loaded from SharedPreferences
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use a ternary operator to determine the color based on isLocked
    Color cardColor = isLocked ? Colors.grey : Colors.white;
    return GestureDetector(
      onTap: isLocked ? null : () {
        navigateToLevel(context, levelNumber);
      },
      child: Card(
        color: cardColor, // Apply the color to the Card widget
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLocked ? Icon(Icons.lock, color: Colors.black) : Text('$levelNumber', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), ),
            if (!isLocked) // Only show stars if the level is unlocked
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) => Icon(
                  index < stars ? Icons.star : Icons.star_border,
                  color: index < stars ? Colors.yellow[600]! : Colors.grey,
                )),
              ),
          ],
        ),
      ),
    );
  }

  void navigateToLevel(BuildContext context, int levelNumber) {
    switch (levelNumber) {
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Level1()));
        break;

      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Level2()));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Level $levelNumber is under construction')),
        );
        break;
    }
  }
}