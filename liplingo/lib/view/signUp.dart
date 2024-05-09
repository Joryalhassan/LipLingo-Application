import 'package:flutter/material.dart';
import '../controller/userController.dart';
import '../model/userModel.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  //Initialize controller
  UserController _userController = new UserController();

  // Initialize the form key for both forms
  final _formKeyRegister = GlobalKey<FormState>();

  //Text Controller for user input
  TextEditingController _fNameController = TextEditingController();
  TextEditingController _lNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  //For password list
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;

  //Error message variable
  String? _errorMessage;

  //Password eye visibility variable
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  //Clear error message with new/updated input
  @override
  void initState() {
    super.initState();
    _emailController.addListener(_clearError);
    _passwordController.addListener(_clearError);
    _confirmPasswordController.addListener(_clearError);
  }

  //Reset error message
  void _clearError() {
    setState(() {
      _errorMessage = null;
    });
  }

  // UI Components
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Back Button
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 15, bottom: 85),
                  child: backButton(context),
                ),
              ),
              // Sign Up Form
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Form(
                    key: _formKeyRegister,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(45, 15, 45, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Build Descriptive Text
                          Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Fill the following form to create your account",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 20),

                          // Build First Name and Last Name fields in the same row
                          Row(
                            children: [
                              Expanded(
                                child: _buildFormField(
                                  'First Name',
                                  _fNameController,
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: _buildFormField(
                                  'Last Name',
                                  _lNameController,
                                ),
                              ),
                            ],
                          ),

                          // Build Form Fields
                          _buildFormField('Email', _emailController),
                          _buildPasswordField('Password', _passwordController),

                          // Build password requirements
                          Padding(
                            padding: EdgeInsets.fromLTRB(30, 0, 0, 8),
                            child: _buildPasswordConditions(),
                          ),

                          // Build Confirm Password Field
                          _buildConfirmPasswordField(
                            'Confirm Password',
                            _confirmPasswordController,
                          ),

                          // Build Error message
                          if (_errorMessage != null)
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          const SizedBox(height: 5),

                          // Build Button
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 230,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await checkSignUp();
                                },
                                child: Text(
                                  "Register",
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkSignUp() async {
    if (_formKeyRegister.currentState!
        .validate()) {
      // Check if passwords match
      if (_passwordController.text.trim() !=
          _confirmPasswordController.text
              .trim()) {
        setState(() {
          _errorMessage =
              "Passwords do not match";
        });
      } else {
        Users _userData = new Users(
            '',
            _fNameController.text.trim(),
            _lNameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text.trim());
        String? _message = await _userController
            .signUp(context, _userData);

        if (_message != null) {
          setState(() {
            _errorMessage = _message;
          });
        }
      }
    }
  }

  Widget _buildFormField(String _label, TextEditingController _controller) {
    late int _maxLength;
    late String _regex;

    switch (_label) {
      case 'First Name':
      case 'Last Name':
        _maxLength = 32;
        _regex = r'^[a-zA-Z]+$';
        break;
      case 'Email':
      default:
        _maxLength = 128;
        _regex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _label + ': *',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 3),
        TextFormField(
          maxLength: _maxLength,
          controller: _controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,

          // Validate while typing
          validator: (value) {
            if (value!.isEmpty) {
              return '$_label is required';
            } else if (!RegExp(_regex).hasMatch(value)) {
              return 'Please enter a valid $_label';
            }
            return null;
          },
          decoration: InputDecoration(
            counter: Text(
              '',
              style: TextStyle(
                fontSize: 3,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[200],
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

  Widget _buildPasswordField(String _label, TextEditingController _controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _label + ": *",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
        ),
        const SizedBox(height: 3),
        TextFormField(
          maxLength: 32,
          controller: _controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // Validate while typing
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            }
            if (!_hasMinLength ||
                !_hasUppercase ||
                !_hasLowercase ||
                !_hasNumber) {
              return 'Password does not meet requirements';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              _hasMinLength = value.length >= 8;
              _hasUppercase = value.contains(RegExp(r'[A-Z]'));
              _hasLowercase = value.contains(RegExp(r'[a-z]'));
              _hasNumber = value.contains(RegExp(r'\d'));
            });
          },
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            counter: Text(
              '',
              style: TextStyle(
                fontSize: 3,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            hintText: 'Enter your password',
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              ),
            ),
          ),
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField(
      String _label, TextEditingController _controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _label + ": *",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
        ),
        const SizedBox(height: 3),
        TextFormField(
          maxLength: 32,
          controller: _controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // Validate while typing
          validator: (value) {
            if (value!.isEmpty) {
              return 'Confirm password is required';
            }
            if (value.length < 8 || value.length > 15) {
              return 'Password must be between 8 and 15 characters';
            }
            if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value)) {
              return 'Password must contain at least one uppercase letter';
            }
            if (!RegExp(r'^(?=.*[a-z])').hasMatch(value)) {
              return 'Password must contain at least one lowercase letter';
            }
            if (!RegExp(r'^(?=.*\d)').hasMatch(value)) {
              return 'Password must contain at least one number';
            }
            return null;
          },
          obscureText: !_isConfirmPasswordVisible,
          decoration: InputDecoration(
            counter: Text(
              '',
              style: TextStyle(
                fontSize: 3,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            hintText: 'Re-enter your password',
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
              icon: Icon(
                _isConfirmPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
            ),
          ),
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildPasswordConditions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _passwordConditionWidget(
            "At least one lowercase letter", _hasLowercase),
        _passwordConditionWidget(
            "At least one uppercase letter", _hasUppercase),
        _passwordConditionWidget("At least one number", _hasNumber),
        _passwordConditionWidget("Minimum 8 characters", _hasMinLength),
      ],
    );
  }

  Widget _passwordConditionWidget(String text, bool conditionMet) {
    return Text(
      text,
      style: TextStyle(
        color: conditionMet ? Colors.black : Colors.grey,
        fontSize: 12,
      ),
    );
  }

  IconButton backButton(BuildContext context) {
    return IconButton(
      icon: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.blue[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
