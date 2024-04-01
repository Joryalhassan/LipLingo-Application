import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liplingo/screens/lipReading.dart';
import 'package:liplingo/screens/savedTextList.dart';
import '../reusable_widget/reusableWidgets.dart';
import 'editText.dart';

class ViewTextScreen extends StatefulWidget {
  const ViewTextScreen({super.key});

  @override
  State<ViewTextScreen> createState() => _ViewTextScreenState();
}

class _ViewTextScreenState extends State<ViewTextScreen> {
  //Logged In user's information
  final user = FirebaseAuth.instance.currentUser;
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
              child: backButton(context),
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
                SizedBox(
                  height: 200,
                  child: TextField(
                    readOnly: true,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                    ),
                    style: TextStyle(fontSize: 15),
                  ),
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SavedTextListScreen()));

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
