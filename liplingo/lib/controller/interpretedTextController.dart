import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/interpretedtTextModel.dart';

class interpretedTextController {

  //Initialize Firebase
  FirebaseFirestore _database = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance.currentUser;


  //Save Text called by the displaySavedTextForm widget - ViewTextScreen
  void saveText(InterpretedText _text) async {
    try {
      CollectionReference<Map<String, dynamic>> database =
      _database.collection("Users");

      await database.doc(_auth?.uid).collection('savedText').add({
        'title': _text.title,
        'text': _text.interpretedText,
      });
    } catch (error) {
      throw error;
    }
  }

  //Get the list of saved text - SavedTextListScreen
  Future<List<InterpretedText>> getSavedTextList() async {
    List<InterpretedText> savedTextList = [];

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _database
          .collection("Users")
          .doc(_auth?.uid)
          .collection('savedText')
          .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
      in querySnapshot.docs) {
        String _textID = document.reference.path;
        String _title = document['title'];
        String _interpretedText = document['text'];

        InterpretedText savedTextObject = InterpretedText(
            _textID, _title, _interpretedText);
        savedTextList.add(savedTextObject);
      }
    } catch (error) {
      print(error);
      throw error;
    }
    return savedTextList;
  }

  //Delete a saved text - SavedTextListScreen
  void deleteSpecificText(BuildContext context,
      InterpretedText interpretedText) async {
    DocumentReference textDocRef = await _database.doc(interpretedText.textID);

    Navigator.pop(context);

    try {
      await textDocRef.delete();
    } catch (error) {
      throw error;
    }
  }
}
