import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/editText.dart';
import '../screens/savedTextList.dart';

class TextController {
  //Initialize Firebase
  FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  //Edit Text function - ViewText Screnn
  void editText(BuildContext context, TextEditingController _textController) {
    try {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditTextScreen(
          initialText: _textController.text,
          onSave: (editedText) {
            _textController.text = editedText;

            //Show snackbar indicating successful edit
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Text edited successfully'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2), // Adjust the duration as needed
              ),
            );
          },
        ),
      ));
    } catch (error) {
      return null;
    }
  }

  //Display Save Text Form Widget - ViewText Screen
  void displaySavedTextForm(BuildContext context, TextEditingController _textPassageController) {

    //Text Controller - MVC
    TextController _controller = new TextController();
    //Form Key
    final _formKeySavedText = GlobalKey<FormState>();
    //Title Form Controlelr
    TextEditingController _titleController = TextEditingController();

    //Dialog Form
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20.0), // Adjust the value as needed
            ),
            child: Form(
              key: _formKeySavedText,
              child: Container(
                padding: EdgeInsets.fromLTRB(30, 35, 30, 30),
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    //Title
                    Text(
                      "Save Text",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    //Spacing
                    const SizedBox(height: 15),

                    //Title Form Title
                    Text(
                      "Title:",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                      ),
                    ),

                    //Spacing
                    const SizedBox(height: 3),

                    //Title Form Field
                    TextFormField(
                      controller: _titleController,
                      maxLines: 1,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // Validate while typing
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter title',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      ),
                      style: TextStyle(fontSize: 15),
                    ),

                    //Spacing
                    const SizedBox(height: 15),

                    //Text Passage Form Title
                    Text(
                      "Text:",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                      ),
                    ),

                    //Spacing
                    const SizedBox(height: 3),

                    //Text Passage Form field
                    TextFormField(
                      controller: _textPassageController,
                      maxLines: 5,
                      enabled: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      ),
                      style: TextStyle(fontSize: 15),
                    ),

                    //Spacing
                    const SizedBox(height: 20),

                    //Button List
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        //Cancel Button
                        OutlinedButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 25.0,
                              vertical: 10.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            side: BorderSide(
                              width: 1,
                              color: Colors.blue,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),

                        //Save Text Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 25.0,
                              vertical: 10.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                          child: Text(
                            "Save Text",
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          onPressed: () {
                            if (_formKeySavedText.currentState!.validate()) {

                              //Dismiss dialog
                              Navigator.pop(context);

                              //Save Text
                              _controller.saveText(_titleController.text.trim(), _textPassageController.text.trim());

                              //Navigate to Saved Text Page
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SavedTextListScreen()));
                            };
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  //Save Text Function called by the displaySavedTextForm widget
  void saveText(String title, String text) async {
    try {
      CollectionReference<Map<String, dynamic>> database =
          firestoreDB.collection("Users");

      DocumentReference<Map<String, dynamic>> result =
          await database.doc(user?.uid).collection('savedText').add({
        'title': title,
        'text': text,
      });
    } catch (error) {
      return null;
    }
  }

  //Get Saved Text List Function - SavedTextList Screen
  Stream<QuerySnapshot<Map<String, dynamic>>> getSavedTextList() {
    return firestoreDB
        .collection("Users")
        .doc(user?.uid)
        .collection('savedText')
        .snapshots();
  }

  //Delete Specific Text Item - SavedTextList Screen
  void _deleteSpecificText(BuildContext context, DocumentReference docRef) {
    Navigator.pop(context);
    try {
      docRef.delete();
    } catch (error) {
      return null;
    }
  }

  //Display Confirm Deletion Widget - SavedTextList Screen
  void confirmDeletion(
      BuildContext context, DocumentReference docRef, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20.0), // Adjust the value as needed
          ),
          child: Container(
              padding: EdgeInsets.fromLTRB(40, 35, 40, 30),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Delete Text?",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        )),
                    const SizedBox(height: 10),
                    Text(
                        "Are you sure you would like to delete the \"" +
                            title +
                            "\" text?",
                        style: TextStyle(
                          fontSize: 17,
                        )),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          child: Text("Cancel",
                              style: TextStyle(
                                fontSize: 17,
                              )),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 25.0,
                              vertical: 10.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            side: BorderSide(width: 1, color: Colors.blue),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 25.0,
                              vertical: 10.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: Colors.red[700],
                          ),
                          child: Text("Delete",
                              style: TextStyle(
                                fontSize: 17,
                              )),
                          onPressed: () {
                            _deleteSpecificText(context, docRef);
                          },
                        ),
                      ],
                    )
                  ]
              )
          ),
        );
      },
    );
  }
}
