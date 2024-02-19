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
  String _userEmail = '';
  Color _fieldBackgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email ?? '';
      });

      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
          .instance
          .collection('Users')
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
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 223, 223, 223),
              const Color.fromARGB(255, 223, 223, 223),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/default_profile_picture.jpg'),
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
              SizedBox(height: 16), // Add space between fields and buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _cancelChanges,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      minimumSize: Size(150, 50),
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        'Save Changes',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      minimumSize: Size(150, 50),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
              _fieldBackgroundColor = const Color.fromARGB(255, 208, 207, 204);
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
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: _fieldBackgroundColor,
        ),
      ),
    );
  }

  void _cancelChanges() {
    Navigator.pop(context);
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
          'first_name': _fnameTextController.text.trim(),
          'last_name': _lnameTextController.text.trim(),
          'username': _usernameController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      }
    }
  }
}
