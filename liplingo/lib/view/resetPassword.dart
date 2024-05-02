import 'package:flutter/material.dart';
import '../controller/userController.dart';

class resetPassword extends StatefulWidget {
  const resetPassword({super.key});

  @override
  State<resetPassword> createState() => _resetPasswordState();
}

class _resetPasswordState extends State<resetPassword> {

  //Initialize controller
  UserController _userController = new UserController();

  // Initialize the form key for both forms
  final _formKeyResetPassword = GlobalKey<FormState>();

  // Text Editing Controllers for Reset Password email
  final TextEditingController _resetPasswordEmailController =
      TextEditingController();

  // Error message variable
  String? _errorMessage;

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
                      return 'Enter a valid email';
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
                const SizedBox(height: 10),
                if (_errorMessage != null)
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 230,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKeyResetPassword.currentState!.validate()) {
                          String? _message = await _userController.resetPassword(_resetPasswordEmailController.text.trim());

                          if (_message != null) {
                            setState(() {
                              // Handle different types of FirebaseAuth errors
                              _errorMessage = _message;
                            }); } else {

                            // Close bottom drawer if no error encountered
                            Navigator.pop(context);

                            // Show Success Message Snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                    'Password reset email sent successfully!'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                      },
                      // Disable the button if _isSendingEmail is true
                      child: Text(
                        "Send Email",
                        style: TextStyle(fontSize: 17),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                    ),
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
