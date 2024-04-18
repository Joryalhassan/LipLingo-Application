import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:liplingo/screens/lipReading.dart';

import '../screens/SignIn.dart';

class userController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Check of successful Sign In using Firebase Auth
  Future<void> _signInWithEmailAndPassword(
      BuildContext context, String _email, String _password) async {
    try {
      // Log user in through firebase auth function.
      await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      //Redirect to LipReading screen if no error encountered
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LipReadingScreen()));
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: 'no-account-found');
    }
  }

  Future<bool> _checkEmailUniqueness(String email) async {
    try {
      final List<String> signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      // If the list is empty, the email is not in use
      return signInMethods.isEmpty;
    } catch (e) {
      return false; // Assuming not unique on error
    }
  }

  // Send reset password email through Firebase Auth
  Future<void> _sendResetPasswordEmail(BuildContext context, String _email) async {

    try {
      // Check if the email exists
      final List<String> signInMethods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(_email);

      if (signInMethods.isNotEmpty) {
        // If the email exists, proceed to send the reset password email
        await _auth.sendPasswordResetEmail(
          email: _email,
        );

        // Close bottom drawer if no error encountered
        Navigator.pop(context);

        // Show Success Message Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text('Password reset email sent successfully!'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle other Firebase Auth exceptions
    }
  }

  void _deleteAccount(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Delete user data from Firestore
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .delete();

        // Delete the user account
        await user.delete();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SignInScreen()), // Navigate to your SignIn screen
        );
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error deleting account: $e');
    }
  }

  void _deleteSavedTextList(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestoreDB = FirebaseFirestore.instance;

    await firestoreDB
        .collection("Users")
        .doc(user?.uid)
        .collection('savedText')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete saved text list"),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}
