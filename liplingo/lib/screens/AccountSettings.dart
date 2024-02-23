import 'package:flutter/material.dart';
import 'EditProfile.dart'; // Import your EditProfileScreen file

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
                _buildClickableOption(context, 'Help', Icons.help, _onHelp),

                // Space
                SizedBox(height: 60),

                // Clickable Options - Log Out, Delete Account
                _buildClickableOption(
                    context, 'Log Out', Icons.logout, _onLogOut),
                SizedBox(height: 16), // Add space between options
                _buildClickableOption(
                    context, 'Delete Account', Icons.delete, _onDeleteAccount),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EditProfileScreen()));
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
              backgroundImage: AssetImage('assets/default_profile_picture.jpg'),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Username', // Replace with actual username
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildClickableOption(BuildContext context, String text, IconData icon,
      VoidCallback onTapCallback) {
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
            Icon(icon),
            SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(fontSize: 18),
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

  void _onContactUs() {
    // Replace with the logic to navigate to Contact Us page
    print('Contact Us');
  }

  void _onHelp() {
    // Replace with the logic to navigate to Help page
    print('Help');
  }

  void _onLogOut() {
    // Replace with the logic to handle logout
    print('Log Out');
  }

  void _onDeleteAccount() {
    // Replace with the logic to handle account deletion
    print('Delete Account');
  }
}
