import 'package:flutter/material.dart';
import '../reusable_widget/reusable_widget.dart'; 
import 'package:liplingo/screens/academy.dart';
import 'package:liplingo/screens/level1.dart';
import 'package:liplingo/screens/level2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = FirebaseFirestore.instance.collection('Completed_Challenges').doc(user.email);
      final docSnapshot = await docRef.get();

      List<bool> tempLevelLockStatus = List.filled(12, true); // Start with all levels locked
      List<int> tempLevelStars = List.filled(12, 0); // Start with 0 stars for all levels

      tempLevelLockStatus[0] = false; // Unlock the first level by default

     if (docSnapshot.exists) {
  Map<String, dynamic> levels = docSnapshot.data()?['levels'] ?? {};
  for (int i = 0; i < 12; i++) {  // Assuming level numbers start from 1 to 12
    String levelKey = 'level${i+1}';
    if (levels.containsKey(levelKey)) {
      tempLevelLockStatus[i] = levels[levelKey]['isLocked'] ?? true;
      tempLevelStars[i] = levels[levelKey]['numberOfStars'] ?? 0;
    }
  }
} else {
        // If the document doesn't exist, initialize it with the first level unlocked
        await docRef.set({
          'levels': {
            for (int i = 1; i <= 12; i++) 
              'level$i': {
                'isLocked': i != 1, // Unlock first level only
                'numberOfStars': 0
              }
          }
        });
      }

      setState(() {
        levelLockStatus = tempLevelLockStatus;
        levelStars = tempLevelStars;
      });
    }
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
            child: IconButton(
              icon: Icon(Icons.arrow_back, size: 45, color: Colors.blue),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AcademyScreen()));
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
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
                  isLocked: levelLockStatus[index],
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
  final int stars;

  const ChallengeCard({
    Key? key,
    required this.levelNumber,
    required this.isLocked,
    required this.stars,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The card color is grey if the level is locked, otherwise white.
    Color cardColor = isLocked ? Colors.grey : Colors.white;

    return GestureDetector(
      onTap: isLocked ? null : () => navigateToLevel(context, levelNumber),
      child: Card(
        color: cardColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show lock icon if the level is locked
            if (isLocked)
              Icon(Icons.lock, color: Colors.black, size: 24),
            // Show level number only if unlocked
            if (!isLocked)
              Text(
                '$levelNumber',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            // Show stars only if unlocked
            if (!isLocked)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int index = 0; index < 3; index++)
                    Icon(
                      index < stars ? Icons.star : Icons.star_border,
                      color: index < stars ? Colors.yellow[600]! : Colors.grey,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void navigateToLevel(BuildContext context, int levelNumber) {
    switch (levelNumber) {
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Level1()));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Level2()));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Level $levelNumber is under construction')));
    }
  }
}
