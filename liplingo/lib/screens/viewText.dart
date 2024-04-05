import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liplingo/screens/lipReading.dart';
import 'package:liplingo/screens/savedTextList.dart';
import '../reusable_widget/reusableWidgets.dart';
import 'editText.dart';

class ViewTextScreen extends StatefulWidget {
  final String translatedText;

  const ViewTextScreen({Key? key, required this.translatedText})
      : super(key: key);

  @override
  State<ViewTextScreen> createState() => _ViewTextScreenState();
}

class _ViewTextScreenState extends State<ViewTextScreen> {

  final _formKeySavedText = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _textPassageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set the initial value of the text field
    _textPassageController.text = widget.translatedText;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textPassageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Top App Bar
      appBar: topBar(context, "Lip Reading"),
      //Main Body - Test text
      body: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                onPressed: () {
                  // Navigate back when the button is pressed
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LipReadingScreen()));
                },
              ),
            ),
            Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Interpreted To Text: ",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                    controller: _textPassageController,
                    readOnly: true,
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 27.0,
                          vertical: 13.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      child: Text("Edit Text",
                          style: TextStyle(
                            fontSize: 17,
                          )),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditTextScreen()));
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 27.0,
                          vertical: 13.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      child: Text("Save Text",
                          style: TextStyle(
                            fontSize: 17,
                          )),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Adjust the value as needed
                              ),
                              child: Form(
                                key: _formKeySavedText,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(30, 35, 30, 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Save Text",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        "Title:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      TextFormField(
                                        controller: _titleController,
                                        maxLines: 1,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                        ),
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        "Text:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      TextFormField(
                                        controller: _textPassageController,
                                        maxLines: null,
                                        enabled: false,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        // Validate while typing
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Text is required';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                        ),
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
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
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
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
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 25.0,
                                                vertical: 10.0,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
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
                                              if (_formKeySavedText
                                                  .currentState!
                                                  .validate()) {
                                                addSavedText(
                                                    _titleController.text
                                                        .trim(),
                                                    _textPassageController.text
                                                        .trim());
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SavedTextListScreen()));
                                              }
                                              ;
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 27.0,
                      vertical: 13.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text("Record",
                      style: TextStyle(
                        fontSize: 17,
                      )),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LipReadingScreen()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      //Bottom nav Bar
      bottomNavigationBar: bottomBar(context, 0),
    );
  }
}

Future<DocumentReference?> addSavedText(String title, String text) async {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    CollectionReference<Map<String, dynamic>> database =
        firestore.collection("Users");

    DocumentReference<Map<String, dynamic>> result =
        await database.doc(user?.uid).collection('savedText').add({
      'title': title,
      'text': text,
    });

    return result;
  } catch (error) {
    return null;
  }
}
