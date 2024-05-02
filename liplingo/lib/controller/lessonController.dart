import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/lessonModel.dart';

class LessonController {

  //Initialize Firebase
  FirebaseFirestore _database = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance.currentUser;


  //Retrieve list of lessons - LessonListScreen
  Future<List<Lesson>> getLessonList() async {

    List<Lesson> lessons = [];

    try {
      // Retrieve the list of lessons
      List<DocumentReference> completedLessons = await getCompletedLessons();
      QuerySnapshot<Map<String, dynamic>> lessonSnapshot = await FirebaseFirestore.instance.collection('Lessons').orderBy('level').get();

      lessonSnapshot.docs.forEach((doc) {

        // Check if lesson is completed or not
        bool isCompleted = completedLessons.any((ref) => ref.path == doc.reference.path);

        Lesson lesson = Lesson(
          doc.reference.path,
          doc['level'],
          doc['title'],
          doc['videoPath'],
          isCompleted,
        );
        lessons.add(lesson);
      });

      return lessons;
    } catch (e) {
      return [];
    }
  }

  //Get the list of Completed Lessons
  Future<List<DocumentReference>> getCompletedLessons() async {
    try {
      var userDoc = await _database.collection("Users").doc(_user?.uid).get();

      if (userDoc.exists) {
        List<DocumentReference> compLessons = List<DocumentReference>.from(userDoc['completedLessons'] ?? []);
        return compLessons;
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  //Mark a lesson as complete or incomplete - LessonVideoScreen
  Future<bool> markLessonComplete(String _lessonID) async {

    try {

      DocumentReference userDoc = await _database.collection("Users").doc(_user?.uid);
      DocumentReference lessonDoc = await _database.doc(_lessonID);

      DocumentSnapshot userDocSnapshot = await userDoc.get();
      List<DocumentReference> compLessonArray = List<DocumentReference>.from(userDocSnapshot['completedLessons'] ?? []);

      bool isPresent = compLessonArray.contains(lessonDoc);

      if (isPresent) {
        await userDoc.update(
            {'completedLessons': FieldValue.arrayRemove([lessonDoc])});
        return false;
      } else {
        await userDoc.update({'completedLessons': FieldValue.arrayUnion([lessonDoc])});
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  //Return User progress - LessonListScreen and LessonVideoScreen
  Future<List<int>> getUserProgress() async {

    try {
      List<Lesson> allLessons = await getLessonList();
      List<DocumentReference> completedLessons = await getCompletedLessons();

      var userProgress = [completedLessons.length, allLessons.length];
      return userProgress;
    } catch(error)
    {
      return [];
    }
  }


}