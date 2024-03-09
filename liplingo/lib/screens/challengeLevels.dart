import 'package:flutter/material.dart';
import '../reusable_widget/reusable_widget.dart'; 

class challengeLevels extends StatefulWidget {
  @override
  _challengeLevelsState createState() => _challengeLevelsState();
}

class _challengeLevelsState extends State<challengeLevels> {
  List<bool> levelLockStatus = List.generate(12, (index) => index != 0);

  void unlockNextLevel(int levelIndex) {
    if (levelIndex < levelLockStatus.length - 1) {
      setState(() {
        levelLockStatus[levelIndex + 1] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(context, "Challenges"), // Custom topBar
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: levelLockStatus.length,
        itemBuilder: (context, index) {
          return LevelItem(
            index: index,
            isLocked: levelLockStatus[index],
            onTap: () {
              if (!levelLockStatus[index]) {
                unlockNextLevel(index);
              }
            },
          );
        },
      ),
      bottomNavigationBar: bottomBar(context, 1), // Custom bottomBar
    );
  }
}

class LevelItem extends StatelessWidget {
  final int index;
  final bool isLocked;
  final VoidCallback onTap;

  const LevelItem({
    Key? key,
    required this.index,
    required this.isLocked,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLocked ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isLocked ? Colors.grey[350] : Colors.lightBlue[100],
          border: Border.all(color: Colors.black38),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isLocked ? Icons.lock : Icons.lock_open,
              color: isLocked ? Colors.grey : Colors.blue,
              size: 24,
            ),
            Text(
              'Level ${index + 1}',
              style: TextStyle(
                fontSize: 16,
                color: isLocked ? Colors.black38 : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
