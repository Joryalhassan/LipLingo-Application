import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ChallengeController {

  static Future<void> initializeUserLevels(String userEmail) async {
    final docRef = FirebaseFirestore.instance
        .collection('Completed_Challenges')
        .doc(userEmail);

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

  static Future<void> updateLevelProgress(int completedLevelNumber, int starsEarned) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('Completed_Challenges')
        .doc(user.email);

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
