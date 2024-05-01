import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/userModel.dart';
import '../view/SignIn.dart';
import '../view/lipReading.dart';

class UserController {

  //Initialize Firebase
  FirebaseFirestore _database = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance.currentUser;
  final _auth = FirebaseAuth.instance;

  //Retrieve user information - AccountSettingScreen
  Future<Users?> getProfile() async {
    try {
      if (_user != null) {
        final userData =
            await _database.collection('Users').doc(_user?.uid).get();

        if (userData.exists) {
          final data = userData.data()!;
          return Users(userData.reference.path, data['first_name'],
              data['last_name'], data['email'], '');
        } else {
          throw Exception('User data not found');
        }
      } else {
        throw Exception('User not logged in');
      }
    } catch (error) {
      throw error;
    }
  }

  //Edit profile information - EditProfileScreen
  Future<void> editProfile(Users user) async {
    try {
      if (_user != null) {
        await _database.collection('Users').doc(_user?.uid).update({
          'first_name': user.firstName,
          'last_name': user.lastName,
        });
      }
    } catch (error) {
      throw error;
    }
  }

  //Function to check if email exists
  Future<bool> _checkEmailUnique(String email) async {
    try {
      final List<String> signInMethods =
          await _auth.fetchSignInMethodsForEmail(email);
      // If the list is empty, the email is not in use
      return signInMethods.isEmpty;
    } catch (e) {
      return false;
    }
  }

  //Sign in - SignInScreen
  Future<String?> signIn(BuildContext context, String _email, String _password) async {

    String? _message = null;

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
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        // Update error message for incorrect login
        _message = "Invalid Email or Password";
      } else if (e.code == 'network-request-failed') {
        // Update error message for no internet connection
        _message = "No internet connection";
      } else {
        // Handle other types of FirebaseAuthException errors
        _message = "There's been an error. Try again later";
      }
    }
    return _message;
  }

  //Reset password - ResetPasswordScreen
  Future<String?> resetPassword(String email) async {

    String? _message = null;

    try {
      // Check if the email exists
      bool emailExists = await _checkEmailUnique(email);

      if (emailExists) {
        // If the email exists, proceed to send the reset password email
        await _auth.sendPasswordResetEmail(
          email: email,
        );
      } else {
        // If the email does not exist, display an error message
        _message = 'Email not found. Please enter a valid email.';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        _message = 'Invalid email address.';
      } else if (e.code == 'requires-recent-login') {
        _message =
            'You must have logged in recently to reset your password. Log in and try again';
      } else if (e.code == 'network-request-failed') {
        _message = 'No internet connection';
      } else {
        // Handle other types of FirebaseAuthException errors
        _message = 'There\'s been an error. Try again later';
      }
    }
    return _message;
  }

  //Register new account - Sign Up Page
  Future<String?> signUp(BuildContext context, Users _userInfo) async {

    //Return Message
    String? _message = null;

    // If both email and username are unique, proceed with the registration
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _userInfo.email,
        password: _userInfo.password,
      );

      // Save user data to Firestore
      await _database.collection('Users').doc(userCredential.user!.uid).set({
        'first_name': _userInfo.firstName,
        'last_name': _userInfo.lastName,
        'email': _userInfo.email,
        'completedLessons': [],
      });

      //Navigate to Sign In page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SignInScreen()), // Navigate to your SignIn screen
      );

      //Success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("New account created successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _message = 'Email has already been taken.';
      } else if (e.code == 'network-request-failed') {
        _message = 'No internet connection';
      } else {
        // Handle other types of FirebaseAuthException errors
        _message = 'There\'s been an error. Try again later';
      }
    }
    return _message;
  }

  void deleteAccount() async {
    try {
      if (_user != null) {
        // Delete 'savedText' subcollection
        QuerySnapshot savedTextSnapshot = await _database
            .collection('Users')
            .doc(_user?.uid)
            .collection('savedText')
            .get();
        for (QueryDocumentSnapshot document in savedTextSnapshot.docs) {
          await document.reference.delete();
        }

        //Delete user document
        await _database.collection('Users').doc(_user?.uid).delete();

        // Delete the user account from firebase auth
        await _user!.delete();
      }
    } catch (error) {
      throw error;
    }
  }

  //Delete all saved texts - AccountSetttingScreen
  void clearSavedTextList() async {
    try {
      await _database
          .collection("Users")
          .doc(_user?.uid)
          .collection('savedText')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    } catch (error) {
      throw error;
    }
  }

  //Signout Function called by confirmLogOutDialog- topBar in resuableWidgets and AccountSettings
  Future<void> signOut(context) async {
    try {
      await _auth.signOut();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SignInScreen()),
          (Route<dynamic> route) => false);
    } catch (error) {
      throw error;
    }
  }
}
