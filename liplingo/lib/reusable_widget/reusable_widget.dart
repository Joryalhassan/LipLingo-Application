//this page to help us to  make the design consistent between pages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liplingo/screens/academy.dart';
import 'package:liplingo/screens/lipReading.dart';
import 'package:liplingo/screens/signIn.dart';
import 'package:liplingo/screens/AccountSettings.dart';

// Text field
TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: Colors.white70),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

//sign up+in buttons
Container signInSignUpButton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap(); // Corrected from 'onTap()' to 'onTap()'
      },
      child: Text(
        isLogin ? 'LOG IN' : 'SIGN UP',
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.blue.shade50;
          }
          return Colors.blue;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    ),
  );
}

//Top App Bar - Receives the name of the current screen and displays it along with the profile button and logout button.
AppBar topBar(BuildContext context, String screenName) {
  return AppBar(
    elevation: 0.8,
    toolbarHeight: 60,
    leadingWidth: 75,
    backgroundColor: Colors.white,
    centerTitle: true,
    title: Text(screenName,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        )),
    leading: IconButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => (AccountSettingsScreen()),
          ),
        );
        // Redirect to user profile page.
      },
      icon: ImageIcon(
        AssetImage('assets/AppBar_Profile.png'),
        color: Colors.blue,
        size: 30,
      ),
    ),
    actions: [
      Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: IconButton(
          icon: Icon(
            Icons.logout,
            color: Colors.blue,
            size: 30,
          ),
          onPressed: () {
            showLogoutConfirmation(context);
          },
        ),
      )
    ],
  );
}

void showLogoutConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Adjust the value as needed
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(40,35,40,30),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  "Logout?",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,

                  )
              ),
              const SizedBox(height: 10),
              Text(
                  "Are you sure you would like to logout?",
                  style: TextStyle(
                    fontSize: 17,
                  )
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 17,
                        )
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 10.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      side: BorderSide(
                          width: 1,
                          color: Colors.blue
                      ),
                    ),
                    onPressed: () {
                        Navigator.of(context).pop();
                        },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 10.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Colors.red[700],
                    ),
                      child: Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 17,
                          )
                      ),
                    onPressed: () {
                        _signOut(context);
                        },
                  ),
                ],
              )

            ]
          )
        ),
      );
    },
  );
}


//Signout Function
Future<void> _signOut(context) async {
  await FirebaseAuth.instance.signOut();

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => SignInScreen()),
  );
}

//Bottom page navigation bar
BottomNavigationBar bottomBar(BuildContext context, int index) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    currentIndex: index,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: ImageIcon(
          AssetImage('assets/NavBar_LipReading.png'), // Corrected usage
        ),
        label: 'LipReading',
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(
          AssetImage('assets/NavBar_Academy.png'), // Corrected usage
        ),
        label: 'Academy',
      ),
    ],
    onTap: (int index) {
      // Handle onTap event for each item
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LipReadingScreen()),
        );
      } else if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AcademyScreen()),
        );
      }
    },
  );
}

IconButton backButton(BuildContext context) {
  return IconButton(
    icon: Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.blue,
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
      // Navigate back when the button is pressed
      Navigator.pop(context);
    },
  );
}