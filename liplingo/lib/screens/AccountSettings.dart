import 'package:flutter/material.dart';
import 'EditProfile.dart'; // Import your EditProfileScreen file

class AccountSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User Photo, Username, and Edit Profile Button
            _buildUserProfileSection(context),

            // Space
            SizedBox(height: 16),

            // Clickable Options - Clear Text Data, Contact Us, Help
            _buildClickableOption(
                context, 'Clear Text Data', Icons.clear, '/clearTextData'),
            _buildClickableOption(
                context, 'Contact Us', Icons.mail, '/contactUs'),
            _buildClickableOption(context, 'Help', Icons.help, '/help'),

            // Space
            SizedBox(height: 16),

            // Clickable Options - Log Out, Delete Account
            _buildClickableOption(context, 'Log Out', Icons.logout, '/logOut'),
            _buildClickableOption(
                context, 'Delete Account', Icons.delete, '/deleteAccount'),
          ],
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
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
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

  Widget _buildClickableOption(
      BuildContext context, String text, IconData icon, String route) {
    return GestureDetector(
      onTap: () {
        // Navigate to the respective page (Replace with actual navigation logic)
        Navigator.pushNamed(context, route);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
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
}
