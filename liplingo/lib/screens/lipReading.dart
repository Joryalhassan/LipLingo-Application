import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../reusable_widget/reusable_widget.dart';

class LipReadingScreen extends StatefulWidget {
  const LipReadingScreen({Key? key}) : super(key: key);

  @override
  LipReadingScreenState createState() => LipReadingScreenState();
}

class LipReadingScreenState extends State<LipReadingScreen> {
  @override
  Widget build(BuildContext context) {
    //Logged In user's infromation
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      //Top App Bar
      appBar: topBar(context, "Lip Reading"),

      //Main Body - Test text
      body: Align(
          alignment: Alignment.center,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("LipReading Screen"),
            Text('Signed in as: ${user?.email}')
          ])),

      //Bottom nav Bar
      bottomNavigationBar: bottomBar(context, 0),
    );
  }

}
