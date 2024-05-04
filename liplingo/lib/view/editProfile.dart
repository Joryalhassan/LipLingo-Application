import 'package:flutter/material.dart';
import '../controller/userController.dart';
import '../view/accountSettings.dart';
import '../model/userModel.dart';

class EditProfileScreen extends StatefulWidget {
  final Users userData;

  const EditProfileScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  UserController _userController = new UserController();
  late Size mediaSize;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fnameTextController = TextEditingController();
  final TextEditingController _lnameTextController = TextEditingController();
  late String _userEmail;
  late String _originalFirstName;
  late String _originalLastName;
  bool _changesMade = false;

  @override
  void initState() {
    super.initState();
    _setUserData();
  }

  void _setUserData() {
    setState(() {
      _userEmail = widget.userData.email;
      _fnameTextController.text = widget.userData.firstName;
      _lnameTextController.text = widget.userData.lastName;

      _originalFirstName = _fnameTextController.text;
      _originalLastName = _lnameTextController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 38, vertical: 45),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 15),
                  _buildEditableFormField('First Name', _fnameTextController),
                  _buildEditableFormField('Last Name', _lnameTextController),
                  _buildNonEditableFormField('Email', _userEmail),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 145,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_changesMade) {
                              _showDiscardChangesDialog();
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      SizedBox(
                        width: 145,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _checkEditProfile,
                          child: Text(
                            "Save Changes",
                            style: TextStyle(fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableFormField(
      String _label, TextEditingController _controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _label + ': ',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 3),
        TextFormField(
          maxLength: 32,
          controller: _controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,

          // Validate while typing
          validator: (value) {
            if (value!.isEmpty) {
              return '$_label is required';
            } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
              return 'Please enter a valid ' + _label.toLowerCase();
            }
            return null;
          },
          onChanged: (_) {
            setState(() {
              _changesMade = true;
            });
          },
          decoration: InputDecoration(
            counter: Text(
              '',
              style: TextStyle(
                fontSize: 3,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            hintText: 'Enter your $_label',
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          ),
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildNonEditableFormField(String _label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _label + ':',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 3),
        TextFormField(
          initialValue: value,
          enabled: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          ),
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }


  _showDiscardChangesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20.0), // Adjust the value as needed
          ),
          child: Container(
              padding: EdgeInsets.fromLTRB(40, 35, 40, 30),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Discard Changes?",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                        )),
                    const SizedBox(height: 10),
                    Text("Are you sure you want to discard changes?",
                        style: TextStyle(
                          fontSize: 17,
                        )),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          child: Text("Cancel",
                              style: TextStyle(
                                fontSize: 17,
                              )),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 25.0,
                              vertical: 10.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            side: BorderSide(width: 1, color: Colors.blue),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 27.0,
                              vertical: 10.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                          child: Text("Discard",
                              style: TextStyle(
                                fontSize: 17,
                              )),
                          onPressed: () {
                            _cancelChanges();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AccountSettingsScreen()),
                            );
                          },
                        ),
                      ],
                    )
                  ])),
        );
      },
    );
  }

  void _cancelChanges() {
    setState(() {
      _fnameTextController.text = _originalFirstName;
      _lnameTextController.text = _originalLastName;
      _changesMade = false;
    });
  }

  void _checkEditProfile() {
    if (_formKey.currentState!.validate()) {
      try {
        Users _userData = new Users('', _fnameTextController.text.trim(),
            _lnameTextController.text.trim(), '', '');
        _userController.editProfile(_userData);

        setState(() {
          _originalFirstName = _fnameTextController.text;
          _originalLastName = _lnameTextController.text;
          _changesMade = false;
        });

        //Success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Profile edited successfully!"),
            backgroundColor: Colors.green,
          ),
        );

        // Ensure correct path when user navigates back - prevents back button from going back and display old account information
        Navigator.pop(context);
        // Navigate back
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AccountSettingsScreen()),
        );
      } catch (error) {
        //Success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Unable to edit profile."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
