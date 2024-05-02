import 'package:flutter/material.dart';
import 'package:liplingo/view/resetPassword.dart';
import 'package:liplingo/view/signUp.dart';
import '../controller/userController.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  //Initialize controller
  UserController _userController = new UserController();

  // Initialize the form key for both forms
  final _formKeySignIn = GlobalKey<FormState>();

  //Text Editing Controllers for email and password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //Error message variable
  String? _errorMessage;

  //Password eye visibility variable
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_clearError);
    _passwordController.addListener(_clearError);
  }

  //Reset error message
  void _clearError() {
    setState(() {
      _errorMessage = null;
    });
  }

  //UI Components
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blue Eclipse Image
              Image.asset(
                'assets/LogIn_EclipseDesign.png',
              ),

              // Welcome and Log In Text
              Container(
                padding: EdgeInsets.fromLTRB(35, 35, 35, 0),
                child: Text(
                  "Welcome Back!",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
                ),
              ),
              const SizedBox(height: 7),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Text(
                  "Log In:",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 22),
                ),
              ),

              // Sign In Form
              Form(
                key: _formKeySignIn,
                child: Container(
                  padding: EdgeInsets.fromLTRB(45, 15, 45, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Email Field
                      Text(
                        "Email:",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 3),
                      TextFormField(
                        controller: _emailController,
                        // Validate while typing
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email is required';
                          } else if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                        ),
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 12),

                      //Password Field
                      Text(
                        "Password:",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 17),
                      ),
                      const SizedBox(height: 3),
                      TextFormField(
                        controller: _passwordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // Validate while typing
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: 'Enter your password',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        style: TextStyle(fontSize: 15),
                      ),
                      // Error message
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                showDragHandle: true,
                                useSafeArea: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15)),
                                ),
                                builder: (context) {
                                  return resetPassword();
                                });
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ]),
                      if (_errorMessage != null)
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 5),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 230,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKeySignIn.currentState!.validate()) {

                                  String? _message = await _userController.signIn(context, _emailController.text.trim(), _passwordController.text.trim());

                                  if(_message != null) {
                                    setState(() {
                                        _errorMessage = _message;
                                      });
                                  }
                                }
                              },
                            child: Text(
                              "Log In",
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
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SignUpScreen(),
                                  ),
                                );
                              },
                              child: Text("Register Now"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
