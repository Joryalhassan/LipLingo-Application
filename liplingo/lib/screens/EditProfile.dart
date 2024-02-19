import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late Size mediaSize;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fnameTextController = TextEditingController();
  final TextEditingController _lnameTextController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  String _userEmail = ''; // To store user's email
  Color _fieldBackgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    // Fetch user data and set initial values
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    // Fetch user data from Firestore or another source
    // Example: Fetching user data using Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email ?? '';
      });

      // Fetch additional user data from Firestore based on user's UID
      DocumentSnapshot<Map<String, dynamic>> userData =
          await FirebaseFirestore.instance
              .collection('Users') // Adjust collection name as needed
              .doc(user.uid)
              .get();

      setState(() {
        _fnameTextController.text = userData['first_name'] ?? '';
        _lnameTextController.text = userData['last_name'] ?? '';
        _usernameController.text = userData['username'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.blue, // Matching the color from the second code
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(
                'assets/default_profile_picture.jpg'), // Replace with user's profile picture
          ),
          TextButton(
            onPressed: () {
              // Implement photo change functionality
            },
            child: Text(
              'Change Photo',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          _buildEditableField('First Name', _fnameTextController),
          _buildEditableField('Last Name', _lnameTextController),
          _buildNonEditableField('Email', _userEmail),
          _buildEditableField('Username', _usernameController),
          Expanded(
            child: SizedBox(),
          ), // Spacer to push Save Changes button to the bottom
          ElevatedButton(
            onPressed: _saveChanges,
            child: Text('Save Changes'),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue, // Matching the color from the second code
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: _fieldBackgroundColor,
        ),
        onChanged: (_) {
          setState(() {
            _fieldBackgroundColor = Colors.white;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            setState(() {
              _fieldBackgroundColor = const Color.fromARGB(
                  255, 208, 207, 204); // Change to desired color
            });
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildNonEditableField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: value,
        enabled: false, // Make it non-editable
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: _fieldBackgroundColor,
        ),
      ),
    );
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Update user data in Firestore or another source
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
          'first_name': _fnameTextController.text.trim(),
          'last_name': _lnameTextController.text.trim(),
          'username': _usernameController.text.trim(),
        });

        // Show success message or navigate to another screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      }
    }
  }
}
