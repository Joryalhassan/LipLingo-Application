import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class resetPassword extends StatefulWidget {
  const resetPassword({super.key});

  @override
  State<resetPassword> createState() => _resetPasswordState();
}

class _resetPasswordState extends State<resetPassword> {
  // Initialize Firebase Authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Initialize the form key for both forms
  final _formKeyResetPassword = GlobalKey<FormState>();

  // Text Editing Controllers for Reset Password email
  final TextEditingController _resetPasswordEmailController =
      TextEditingController();

  // Error message variable
  String? _errorMessage;

  // Boolean variable to track if the reset password function is running
  bool _isSendingEmail = false;

  @override
  void initState() {
    super.initState();
    _resetPasswordEmailController.addListener(_clearError);
  }

  // Reset error message
  void _clearError() {
    setState(() {
      _errorMessage = null;
    });
  }

  // Send reset password email through Firebase Auth
  Future<void> _sendResetPasswordEmail() async {
    // Set _isSendingEmail to true when the function starts running
    setState(() {
      _isSendingEmail = true;
    });

    try {
      // Log user in through firebase auth function.
      await _auth.sendPasswordResetEmail(
        email: _resetPasswordEmailController.text.trim(),
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
    } on FirebaseAuthException catch (e) {
      // Handle errors
      setState(() {
        // Handle different types of FirebaseAuth errors
        if (e.code == 'user-not-found' || e.code == 'invalid-email') {
          _errorMessage = "Invalid email address.";
        } else if (e.code == 'requires-recent-login') {
          _errorMessage =
          "You must have logged in recently to reset your password. Log in and try again";
        } else if (e.code == 'network-request-failed') {
          _errorMessage = "No internet connection";
        } else {
          // Handle other types of FirebaseAuthException errors
          _errorMessage = "There's been an error. Try again later";
        }
      });
    } finally {
      // Set _isSendingEmail to false after the function finishes running
      setState(() {
        _isSendingEmail = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKeyResetPassword,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.35,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Forgot Password?",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
                const SizedBox(height: 5),
                Text(
                  "Enter your email to receive a link to reset your password.",
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _resetPasswordEmailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // Validate while typing
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email is required';
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  ),
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 230,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSendingEmail
                          ? null
                          : () {
                              if (_formKeyResetPassword.currentState!
                                  .validate()) {
                                _sendResetPasswordEmail();
                              }
                            },
                      // Disable the button if _isSendingEmail is true
                      // and show "Sending Email..." text
                      child: _isSendingEmail
                          ? Text(
                              'Sending Email...',
                              style: TextStyle(fontSize: 17),
                            )
                          : Text(
                              "Send Email",
                              style: TextStyle(fontSize: 17),
                            ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (_errorMessage != null)
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
