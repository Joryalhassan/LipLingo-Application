import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../reusable_widget/reusableWidgets.dart';

class EditTextScreen extends StatefulWidget {
  const EditTextScreen({super.key});

  @override
  State<EditTextScreen> createState() => _EditTextScreenState();
}

class _EditTextScreenState extends State<EditTextScreen> {
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
                          horizontal: 37.0,
                          vertical: 13.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      child: Text("Cancel",
                          style: TextStyle(
                            fontSize: 17,
                          )),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 35.0,
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
                        ;
                      },
                    ),
                  ],
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
