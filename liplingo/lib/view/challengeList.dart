import 'package:flutter/material.dart';
import 'package:liplingo/controller/challengeController.dart';
import '../utils/reusableWidgets.dart';

class ChallengeListScreen extends StatefulWidget {
  @override
  _ChallengeListState createState() => _ChallengeListState();
}

class _ChallengeListState extends State<ChallengeListScreen> {
  List<bool> levelLockStatus = List.filled(12, false);
  List<int> levelStars = List.filled(12, 0);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChallengeProgress();

    Future.delayed(Duration(milliseconds: 600), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _loadChallengeProgress() async {
    final _challengeController = ChallengeController();
    final levels = await _challengeController.getChallengeList();

    List<bool> tempLevelLockStatus = List.filled(12, true);
    List<int> tempLevelStars = List.filled(12, 0);

    tempLevelLockStatus[0] = false; // Unlock the first level by default

    for (int i = 0; i < 12; i++) {
      String levelKey = 'level${i + 1}';
      if (levels.containsKey(levelKey)) {
        tempLevelLockStatus[i] = levels[levelKey]['isLocked'] ?? true;
        tempLevelStars[i] = levels[levelKey]['numberOfStars'] ?? 0;
      }
    }

    setState(() {
      levelLockStatus = tempLevelLockStatus;
      levelStars = tempLevelStars;
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
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
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
                        levelNumber: (index + 1),
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
    ChallengeController _challengeController = new ChallengeController();

    return GestureDetector(
      onTap: isLocked
          ? null
          : () => _challengeController.navigateToLevel(context, levelNumber),
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
}
