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
  String _userEmail = '';
  late String _originalFirstName;
  late String _originalLastName;
  Color _fieldBackgroundColor = Colors.white;
  bool _changesMade = false;

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

        _originalFirstName = _fnameTextController.text;
        _originalLastName = _lnameTextController.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.8,
        toolbarHeight: 60,
        leadingWidth: 75,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.blue),
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[200]!,
              Colors.grey[200]!,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/AppBar_Profile.png'),
                ),
                _buildEditableField('First Name', _fnameTextController),
                _buildEditableField('Last Name', _lnameTextController),
                _buildNonEditableField('Email', _userEmail),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_changesMade) {
                          _showDiscardChangesDialog();
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
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
                        backgroundColor: Colors.blue,
                        minimumSize: Size(150, 50),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _cancelChanges() {
    setState(() {
      _fnameTextController.text = _originalFirstName;
      _lnameTextController.text = _originalLastName;
      _fieldBackgroundColor = Colors.white;
      _changesMade = false;
    });
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: _fieldBackgroundColor,
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16.0),
          ),
          onChanged: (_) {
            setState(() {
              _fieldBackgroundColor = Colors.white;
              _changesMade = true;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              setState(() {
                _fieldBackgroundColor =
                const Color.fromARGB(255, 208, 207, 204);
              });
              return '$label is required';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildNonEditableField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: _fieldBackgroundColor,
        ),
        child: TextFormField(
          initialValue: value,
          enabled: false,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16.0),
          ),
        ),
      ),
    );
  }

  void _showDiscardChangesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Discard Changes?'),
          content: Text('Are you sure you want to discard changes?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {},
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _cancelChanges();
                Navigator.pop(context);
              },
              child: Text('Discard'),
            ),
          ],
        );
      },
    );
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
          'first_name': _fnameTextController.text.trim(),
          'last_name': _lnameTextController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.blue,
          ),
        );

        setState(() {
          _originalFirstName = _fnameTextController.text;
          _originalLastName = _lnameTextController.text;
          _changesMade = false;
        });
      }
    }
  }
}