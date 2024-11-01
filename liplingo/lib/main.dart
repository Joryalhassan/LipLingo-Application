import 'package:flutter/material.dart';
import 'package:liplingo/view/signIn.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure plugins are initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of our application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      //Remove Debug Banner
        debugShowCheckedModeBanner: false,
        home: SignInScreen(),
    );
  }
}

