import 'package:flutter/material.dart';
import 'package:liplingo/screens/Academy.dart';
import 'package:liplingo/screens/signIn.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure plugins are initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      //Remove Debug Banner
      debugShowCheckedModeBanner: false,

      home: SignInScreen(),
    );
  }
}

