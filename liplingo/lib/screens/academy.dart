import 'package:flutter/material.dart';
import '../reusable_widget/reusable_widget.dart';

class AcademyScreen extends StatelessWidget {
  const AcademyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Top App Bar
      appBar: topBar(context, "Academy"),

      //Main Body UI
      body: Align(
          alignment: Alignment.center,
          child: Text(
            "Academy Screen",
          )
      ),

      //Bottom Nav Bar
      bottomNavigationBar: bottomBar(context, 1),
    );
  }
}