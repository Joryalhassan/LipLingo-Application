import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/challengeModel.dart';
import '../model/levelModel.dart';
import '../view/challengeLevel.dart';

class ChallengeController {
  FirebaseFirestore _database = FirebaseFirestore.instance;

  //Initialize a new challenge list when a new user is created
  Future<void> createChallengeList(String userEmail) async {
    final docRef = _database.collection('Completed_Challenges').doc(userEmail);

    // Build the levels data structure with level 1 unlocked and the rest locked with 0 stars.
    Map<String, Map<String, dynamic>> levelsData = {
      for (int i = 1; i <= 12; i++)
        'level$i': {
          'isLocked': i > 1, // Only the first level is unlocked by default
          'numberOfStars': 0,
        }
    };

    // Set the levels data in Firestore for this user
    await docRef.set({'levels': levelsData});
  }

  //Get a specific challenge data
  Future<Challenge> getChallenge(int levelNumber) async {
    Challenge _challenge = new Challenge(levelNumber.toString(), []);

    try {
      // Reference to the challenge document
      DocumentSnapshot challengeDoc = await _database
          .collection('Challenges')
          .doc(levelNumber.toString())
          .get();

      if (!challengeDoc.exists) {
        return _challenge;
      }

      List<Level> levels = [];

      // Fetch levels from the subcollection 'levels' of the challenge document
      QuerySnapshot levelDocs = await FirebaseFirestore.instance
          .collection('Challenges')
          .doc(levelNumber.toString())
          .collection('levels')
          .get();

      // Iterate through level documents and construct Level objects
      levelDocs.docs.forEach((levelDoc) {
        List<String> choices = List<String>.from(levelDoc['choices']);
        Level level = Level(
          levelDoc['videoAsset'],
          choices,
          levelDoc['correctChoice'],
        );
        levels.add(level);
      });

      _challenge = Challenge(levelNumber.toString(), levels);
      return _challenge;
    } catch (error) {
      throw error;
    }
  }

  //Returns the current users challenge data
  Future<Map<String, dynamic>> getChallengeList() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = FirebaseFirestore.instance
          .collection('Completed_Challenges')
          .doc(user.email);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        return docSnapshot.data()?['levels'] ?? {};
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
        return {};
      }
    }
    return {};
  }

  //Navigate to a certain challenge
  void navigateToLevel(BuildContext context, int levelNumber) async {
    Challenge _challenge = await getChallenge(levelNumber);

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ChallengeLevelScreen(
              challengeData: _challenge,
            )));
  }

  //Update a certain level's data
  Future<void> updateLevelProgress(
      int completedLevelNumber, int starsEarned) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = _database.collection('Completed_Challenges').doc(user.email);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final docSnapshot = await transaction.get(docRef);

      if (!docSnapshot.exists) {
        throw Exception("Document does not exist!");
      }

      Map<String, dynamic> levelsData = docSnapshot.data()?['levels'] ?? {};

      // Update the stars for the completed level, assuming starsEarned is always the latest value.
      String levelKey = 'level$completedLevelNumber';
      levelsData[levelKey] = {
        'isLocked': false,
        // The current level is obviously unlocked since it's completed
        'numberOfStars': starsEarned,
        // Update the stars earned for this level
      };

      // Unlock the next level if it's not the last level.
      if (completedLevelNumber < 12) {
        String nextLevelKey = 'level${completedLevelNumber + 1}';
        Map<String, dynamic> nextLevelData = levelsData[nextLevelKey] ?? {};
        nextLevelData['isLocked'] = false; // Unlock the next level
        nextLevelData['numberOfStars'] = nextLevelData['numberOfStars'] ??
            0; // Keep stars at 0 for an unlocked level
        levelsData[nextLevelKey] = nextLevelData;
      }

      // Update the document with the new levels data.
      transaction.set(docRef, {'levels': levelsData}, SetOptions(merge: true));
    });
  }

}
