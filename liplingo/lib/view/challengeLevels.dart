import 'package:flutter/material.dart';
import '../utils/reusableWidgets.dart';
import 'academy.dart';
import 'level.dart';
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
      final docRef = FirebaseFirestore.instance
          .collection('Completed_Challenges')
          .doc(user.email);
      final docSnapshot = await docRef.get();

      List<bool> tempLevelLockStatus =
          List.filled(12, true); // Start with all levels locked
      List<int> tempLevelStars =
          List.filled(12, 0); // Start with 0 stars for all levels

      tempLevelLockStatus[0] = false; // Unlock the first level by default

      if (docSnapshot.exists) {
        Map<String, dynamic> levels = docSnapshot.data()?['levels'] ?? {};
        for (int i = 0; i < 12; i++) {
          // Assuming level numbers start from 1 to 12
          String levelKey = 'level${i + 1}';
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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AcademyScreen()));
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.fromLTRB(
                  16.0, MediaQuery.of(context).padding.top, 16.0, 16.0),
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
            if (isLocked) Icon(Icons.lock, color: Colors.black, size: 24),
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
    List<Map<String, dynamic>> _questionsData;

    switch (levelNumber) {
      case 1:
        _questionsData = [
          {
            'videoAsset': 'assets/Q1-ball.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Ball', 'Bag', 'Hole'],
            'correctChoice': 'Ball',
          },
          {
            'videoAsset': 'assets/Q2-dad.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Doll', 'Dad', 'Sad'],
            'correctChoice': 'Dad',
          },
          {
            'videoAsset': 'assets/Q3-blue.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Puzzle', 'Cow', 'Blue'],
            'correctChoice': 'Blue',
          },
        ];
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Level(questionsData: _questionsData,)));
        break;
      case 2:
        _questionsData = [
          {
            'videoAsset': 'assets/Q4-the.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Tall', 'That', 'The'],
            'correctChoice': 'The',
          },
          {
            'videoAsset': 'assets/Q5-three.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Three', 'Tree', 'Me'],
            'correctChoice': 'Three',
          },
          {
            'videoAsset': 'assets/Q6-bus.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Sun', 'Bus', 'Mug'],
            'correctChoice': 'Bus',
          },
        ];
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Level(questionsData: _questionsData,)));
        break;
      case 3:
        _questionsData = [
          {
          'videoAsset': 'assets/Q7-will.mp4',
          'questionText': 'Select what did she say?',
          'choices': ['Wish', 'Was', 'Will'],
          'correctChoice': 'Will',
          },
          {
          'videoAsset': 'assets/Q8-mom.mp4',
          'questionText': 'Select what did she say?',
          'choices': ['Mom', 'Mouse', 'Maximum'],
          'correctChoice': 'Mom',
          },
          {
          'videoAsset': 'assets/Q9-fast.mp4',
          'questionText': 'Select what did she say?',
          'choices': ['Vast', 'Flat', 'Fast'],
          'correctChoice': 'Fast',
          },
        ];
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Level(questionsData: _questionsData,)));
        break;
      case 4:
        _questionsData = [
          {
            'videoAsset': 'assets/Q10-five.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Fight', 'Live', 'Five'],
            'correctChoice': 'Five',
          },
          {
            'videoAsset': 'assets/Q11-laugh.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Laugh', 'Life', 'South'],
            'correctChoice': 'Laugh',
          },
          {
            'videoAsset': 'assets/Q12-ten.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Men', 'Ten', 'Tan'],
            'correctChoice': 'Ten',
          },
        ];
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Level(questionsData: _questionsData,)));
        break;
      case 5:
        _questionsData = [
          {
            'videoAsset': 'assets/Q13-me.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Me', 'May', 'She'],
            'correctChoice': 'Me',
          },
          {
            'videoAsset': 'assets/Q14-two.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Tooth', 'Two', 'Tea'],
            'correctChoice': 'Two',
          },
          {
            'videoAsset': 'assets/Q15-you.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Youth', 'Mou', 'You'],
            'correctChoice': 'You',
          },
        ];
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Level(questionsData: _questionsData,)));
        break;
      case 6:
        _questionsData = [
          {
            'videoAsset': 'assets/Q16-please.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Peace', 'Please', 'Keys'],
            'correctChoice': 'Please',
          },
          {
            'videoAsset': 'assets/Q17-tall.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Tall', 'Mall', 'Call'],
            'correctChoice': 'Tall',
          },
          {
            'videoAsset': 'assets/Q18-four.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Clour', 'Flour', 'Four'],
            'correctChoice': 'Four',
          },
        ];
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Level(questionsData: _questionsData,)));
        break;
      case 7:
        _questionsData = [
          {
            'videoAsset': 'assets/Q19-not.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Cut', 'Not', 'Shut'],
            'correctChoice': 'Not',
          },
          {
            'videoAsset': 'assets/Q20-mall.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Hall', 'Call', 'Mall'],
            'correctChoice': 'Mall',
          },
          {
            'videoAsset': 'assets/Q21-fly.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Fly', 'Cry', 'Fry'],
            'correctChoice': 'Fly',
          },
        ];
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Level(questionsData: _questionsData,)));
        break;
      case 8:
        _questionsData = [
          {
            'videoAsset': 'assets/Q22-thought.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['That', 'Thought', 'Through'],
            'correctChoice': 'Thought',
          },
          {
            'videoAsset': 'assets/Q23-find.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Find', 'Mind', 'Kind'],
            'correctChoice': 'Find',
          },
          {
            'videoAsset': 'assets/Q24-full.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Fall', 'Mall', 'Full'],
            'correctChoice': 'Full',
          },
        ];
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Level(questionsData: _questionsData,)));
        break;
      case 9:
        _questionsData = [
          {
            'videoAsset': 'assets/Q25-top.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Top', 'Hup', 'Tip'],
            'correctChoice': 'Top',
          },
          {
            'videoAsset': 'assets/Q26-stop.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Slop', 'Cop', 'Stop'],
            'correctChoice': 'Stop',
          },
          {
            'videoAsset': 'assets/Q27-fall.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Call', 'Fall', 'Fail'],
            'correctChoice': 'Fall',
          },
        ];
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Level(questionsData: _questionsData,)));
        break;
      case 10:
        _questionsData = [
          {
            'videoAsset': 'assets/Q28-IgotBananas.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['I got\n bananas', 'I love bananas', 'I got\nbotatoes'],
            'correctChoice': 'I got\n bananas',
          },
          {
            'videoAsset': 'assets/Q29-Igotmilk.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['I like\n milk', 'I got\n milk', 'I grap\n milk'],
            'correctChoice': 'I got\n milk',
          },
          {
            'videoAsset': 'assets/Q30-Igotpork.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['I ate\n pork', 'I am\n bold', 'I got\n pork'],
            'correctChoice': 'I got\n pork',
          },
        ];
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Level(questionsData: _questionsData,)));
        break;
      case 11:
        _questionsData = [
          {
            'videoAsset': 'assets/Q31-Igotvegetables.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['I got\nvegetables', 'I have vertebrae', 'I grab\nvegetables'],
            'correctChoice': 'I got\nvegetables',
          },
          {
            'videoAsset': 'assets/Q32-Igotfruit.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['I like fruit', 'I got fruit', 'I got flour'],
            'correctChoice': 'I got fruit',
          },
          {
            'videoAsset': 'assets/Q33-himynameisjessica.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['My mom\nis Jessy', 'Hi Jessy', 'Hi my name\nis jessica'],
            'correctChoice': 'Hi my name\nis jessica',
          },
        ];
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Level(questionsData: _questionsData,)));
        break;
      case 12:
        _questionsData = [
          {
            'videoAsset': 'assets/Q34-whatweekend.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['What will\nyou do at\nthe weekend', 'when is the weekend', 'where to\ngo at the\nweekend'],
            'correctChoice': 'What will\nyou do at\nthe weekend',
          },
          {
            'videoAsset': 'assets/Q35-whatholiday.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['Where is \n your holiday', 'What will you \n do on holiday', 'When is\nyour\nholiday'],
            'correctChoice': 'What will you \n do on holiday',
          },
          {
            'videoAsset': 'assets/Q36-where.mp4',
            'questionText': 'Select what did she say?',
            'choices': ['To where\nare you\ntravelling', 'When are you travelling', 'Where are\nyou\ntravelling'],
            'correctChoice': 'Where are\nyou\ntravelling',
          },
        ];
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Level(questionsData: _questionsData,)));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Level $levelNumber is under construction')));
    }
  }
}
