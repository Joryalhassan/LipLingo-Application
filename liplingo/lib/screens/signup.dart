import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
 late Size mediaSize;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _FnameTextController = TextEditingController();
  final TextEditingController _LnameTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();
  //For password list
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
 String? _emailErrorMessage;
 String ? _usrnameErrorMessage;

   Future<bool> _checkEmailUniqueness(String email) async {
    try {
      final List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      // If the list is empty, the email is not in use
      return signInMethods.isEmpty;
    } catch (e) {
      print(e.toString());
      return false; // Assuming not unique on error
    }
  }

  Future<bool> _checkUsernameUniqueness(String username) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('users') // Ensure this matches your collection name
      .where('username', isEqualTo: username)
      .limit(1)
      .get();

    // If the query returns no documents, the username is unique
    return result.docs.isEmpty;
  }


  @override
  Widget build(BuildContext context) {
    mediaSize= MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(bottom: 0, child: _buildBottom()),// to make it int hte bottom
        ]),
      ),
    );
}
//Card shape
Widget _buildBottom(){
return SizedBox(
  width: mediaSize.width,
  child: Card(
   shape: const RoundedRectangleBorder(
       borderRadius: BorderRadius.only(
     topLeft: Radius.circular(30),
     topRight: Radius.circular(30),
       )),
       child: Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 0.2, 32.0, 5.0),
       child: _buildForm(), // to make it inside the card
       ),
  ),
);
}

//form 
Widget _buildForm() {
  return SingleChildScrollView( // Ensures the form is scrollable on smaller devices
    child: Padding(
      padding: const EdgeInsets.all(32.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.2, bottom: 0.0, right: 50),
              child: Text(
                "Register",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
              ),
            ),
            _buildGreyText("Fill the following form to create your account:"),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildLabeledInputField(
                    label: "First Name",
                    controller: _FnameTextController,
                    hintText: "ex: Sara",
                    icon: Icons.person,
                  ),
                ),
                SizedBox(width: 10), // Space between the fields
                Expanded(
                  child: _buildLabeledInputField(
                    label: "Last Name",
                    controller: _LnameTextController,
                    hintText: "ex: Alfattah",
                    icon: Icons.person,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            _buildLabeledInputField(
              label: "Username",
              controller: _usernamecontroller,
              hintText: "ex: Sara.23",
              icon: Icons.alternate_email,
            ),
            SizedBox(height: 10),
            _buildLabeledInputField(
              label: "Email",
              controller: _emailTextController,
              hintText: "example@example.com",
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
    if(value!.isEmpty){
      return 'Email is required';
    }
  
    if(_emailErrorMessage != null){
      return _emailErrorMessage;
    }
    return null;
  },
            ),
            SizedBox(height: 10),
            _buildPasswordField(), // Modified to handle password field and conditions
            SizedBox(height: 10),
            _buildLabeledInputField(
              label: "Confirm Password",
              controller: _confirmPasswordTextController,
              hintText: "******",
              icon: Icons.lock,
              isPassword: true,
            ),
            SizedBox(height: 20),
            _buildRegisterButton(),
          ],
        ),
      ),
    ),
  );
}


Widget _buildLabeledInputField({
  required String label,
  required TextEditingController controller,
  required String hintText,
  required IconData icon,
  TextInputType keyboardType = TextInputType.text,
  bool isPassword = false,
  String? Function(String?)? validator,
  void Function(String)? onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          children: <TextSpan>[
            TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ),
      ),
      SizedBox(height: 8),
      _buildTextInput(
         label: label,
        controller: controller,
        hintText: hintText,
        icon: icon,
        isPassword: isPassword,
        keyboardType: keyboardType,
        isRequired: true,
        onChanged: onChanged,
      ),
    ],
  );
}


Widget _buildRegisterButton() {
  return Center(
    child: ElevatedButton(
      onPressed: () async {
        // Clear previous error messages
        setState(() {
          _emailErrorMessage = null;
          _usrnameErrorMessage = null;
         
        });

        // Perform synchronous validation first
        if (_formKey.currentState!.validate()) {
          // Perform asynchronous checks for email and username uniqueness
          bool isEmailUnique = await _checkEmailUniqueness(_emailTextController.text);
          bool isUsernameUnique = await _checkUsernameUniqueness(_usernamecontroller.text);
          
          // Act based on the results of the asynchronous checks
          if (!isEmailUnique || !isUsernameUnique) {
            
            if (!isEmailUnique) {
              setState(() {
                _emailErrorMessage = "Email has been used";
              });
            }
            // For username
            if (!isUsernameUnique) {
              _usrnameErrorMessage = "Username has been used";
            }
          } else {
            // If both email and username are unique, proceed with the registration
            try {
               UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _emailTextController.text.trim(),
              password: _passwordTextController.text.trim(),
            );

            String uid = userCredential.user!.uid;

            await FirebaseFirestore.instance.collection('Users').doc(uid).set({
              'first_name': _FnameTextController.text.trim(),
              'last_name': _LnameTextController.text.trim(),
              'username': _usernamecontroller.text.trim(),
              'email': _emailTextController.text.trim(),
            });

            //  success dialog
            showDialog(
              context: context,
              barrierDismissible: false, // prevent dialog to close by tapping outside of it
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Success"),
                  content: Text("You have signed up successfully!"),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Okay"),
                      onPressed: () {
                       
                        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SigIn()), (Route<dynamic> route) => false);
                      },
                    ),
                  ],
                );
              },
            );
            } on FirebaseAuthException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "An error occurred")));
          }
          }
        }
      },
      child: Text(
        "Register",
        style: TextStyle(fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 90),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
  );
}


Widget _buildPasswordField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildLabeledInputField(
        label: "Password",
        controller: _passwordTextController,
        hintText: "******",
        icon: Icons.lock,
        isPassword: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password is required';
          }
          if (!_hasMinLength || !_hasUppercase || !_hasLowercase || !_hasNumber) {
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
      ),
      Padding(
        padding: const EdgeInsets.only(left: 40),
        child: _buildPasswordConditions(),
      ),
    ],
  );
}



Widget _buildPasswordConditions() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _passwordConditionWidget("At least one lowercase letter", _hasLowercase),
      _passwordConditionWidget("At least one uppercase letter", _hasUppercase),
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




Widget _buildTextInput({
  required String label,
  required TextEditingController controller,
  required String hintText,
  required IconData icon,
  bool isPassword = false,
  bool isRequired = false,
  TextInputType keyboardType = TextInputType.text,
  void Function(String)? onChanged,
}) {
  return TextFormField(
    controller: controller,
    obscureText: isPassword,
    keyboardType: keyboardType,
    autovalidateMode: AutovalidateMode.onUserInteraction, // Validate while typing
    decoration: InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey[200],
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      errorStyle: TextStyle(color: Colors.red), 
    ),
    validator: (value) {
      
      if (isRequired && (value == null || value.isEmpty)) {
        return '$label is required';
      }
      switch(label) {
        case 'First Name':
        case 'Last Name':
          if (value!.length < 2 || value.length > 10) {
            return '$label must be \n between 2 and 10 \n characters';
          }
          if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
            return '$label must contain only letters';
          }
     
    break;
        case 'Username':
          if (value!.length < 5 || value.length > 12) {
            return 'Username must be between 5 and 12 \n characters';
          }
          if(_usrnameErrorMessage != null){
            return _usrnameErrorMessage;
          }
          break;
        case 'Email':
          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value!)) {
            return 'Enter a valid email address';
          }
          if(_emailErrorMessage != null){
            return _emailErrorMessage;
          }
          break;
        case 'Password':
          if (value!.length < 8 || value.length > 15) {
            return 'Password must be between 8 and \n 15 characters';
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
          break;
        default:
          return null;
      }
      return null;
    },
    onChanged: onChanged,
  );
}


Widget _buildGreyText(String text) {
  return Text(
    text,
    style: TextStyle(color: Colors.grey),
  );
}

}