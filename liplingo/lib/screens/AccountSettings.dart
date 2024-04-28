import 'package:flutter/material.dart';
import 'EditProfile.dart'; // Import your EditProfileScreen file
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:liplingo/screens/SignIn.dart';
import 'package:liplingo/screens/Help.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
        centerTitle: true, // Center the title
        backgroundColor: Colors.white, // Set background color for the app bar
      ),
      body: Container(
        color: Colors.grey[200], // Set background color for the body
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // User Photo, Username, and Edit Profile Button
                _buildUserProfileSection(context),

                // Space
                SizedBox(height: 60),

                // Clickable Options - Clear Text Data, Contact Us, Help
                _buildClickableOption(
                    context, 'Clear Text Data', Icons.clear, _onClearTextData),
                SizedBox(height: 16), // Add space between options
                _buildClickableOption(
                    context, 'Contact Us', Icons.mail, _onContactUs),
                SizedBox(height: 16), // Add space between options
                _buildClickableOption(
                    context, 'Help', Icons.help, () => _onHelp(context)),

                // Space
                SizedBox(height: 60),

                // Clickable Options - Log Out, Delete Account
                _buildClickableOption(
                    context, 'Log Out', Icons.logout, () => _onLogOut(context)),

                SizedBox(height: 16), // Add space between options
                _buildClickableOption(context, 'Delete Account', Icons.delete,
                        () => _onDeleteAccount(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileSection(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Placeholder for loading state
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var userData = snapshot.data?.data();
          String username = userData?['username'] ?? 'Username';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.0),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/AppBar_Profile.png'),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Edit Profile',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
    } else {
      throw Exception('User not found');
    }
  }

  Widget _buildClickableOption(BuildContext context, String text, IconData icon,
      VoidCallback onTapCallback) {
    Color textColor = Colors.black; // Default text color
    Color iconColor = Colors.black; // Default icon color

    // Customize text and icon colors for "Delete Account" and "Log Out"
    if (text == 'Delete Account' || text == 'Log Out') {
      textColor = Colors.red;
      iconColor = Colors.red;
    }

    return GestureDetector(
      onTap: onTapCallback,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.0),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor, // Set icon color
            ),
            SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: textColor, // Set text color
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Placeholder functions for option callbacks

  void _onClearTextData() {
    // Replace with the logic to clear text data
    print('Clear Text Data');
  }

  void _onContactUs() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'lipLingo@gmail.com',
      queryParameters: {'subject': 'Contact Us'},
    );

    final String emailUri = emailLaunchUri.toString();

    try {
      await launch(emailUri);
    } catch (e) {
      print('Error launching email client: $e');
    }
  } // remove try-catch if it workes on physical emulator

  void _onHelp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HelpScreen()),
    );
  }

  void _onLogOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SignInScreen()), // Navigate to your SignIn screen
      );
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  void _onDeleteAccount(BuildContext context) async {
    // Show a confirmation dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete your account?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // No
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Yes
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
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
  }
}