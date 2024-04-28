import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:liplingo/screens/lipReading.dart';
import 'package:liplingo/screens/resetPassword.dart';
import 'package:liplingo/screens/signup.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Initialize Firebase Authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  //Check of successful Sign In using Firebase Auth
  Future<void> _signInWithEmailAndPassword() async {
    try {
      // Log user in through firebase auth function.
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      //Redirect to LipReading screen if no error encountered
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LipReadingScreen()));
    } on FirebaseAuthException catch (e) {
      // Handle errors
      setState(() {
        // Handle different types of FirebaseAuth errors
        if (e.code == 'user-not-found' ||
            e.code == 'wrong-password' ||
            e.code == 'invalid-credential') {
          // Update error message for incorrect login
          _errorMessage = "Invalid Email or Password";
        } else if(e.code == 'network-request-failed' ) {
          // Update error message for no internet connection
          _errorMessage = "No internet connection";
        } else {
        // Handle other types of FirebaseAuthException errors
        _errorMessage = "There's been an error. Try again later";
        }
      });
    }
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
                  padding: EdgeInsets.fromLTRB(45, 20, 45, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // Validate while typing
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
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 230,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKeySignIn.currentState!.validate()) {
                                _signInWithEmailAndPassword();
                              }
                            },
                            child: Text(
                              "Log In",
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