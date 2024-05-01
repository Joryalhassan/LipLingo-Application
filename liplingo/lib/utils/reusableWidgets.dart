//this page to help us to  make the design consistent between pages
import 'package:flutter/material.dart';
import 'package:liplingo/controller/userController.dart';
import 'package:liplingo/view/academy.dart';
import 'package:liplingo/view/lipReading.dart';
import 'package:liplingo/view/accountSettings.dart';

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

//Logout confirmation dialog
void showLogoutConfirmation(BuildContext context) {
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
                  Text("Logout?",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      )),
                  const SizedBox(height: 10),
                  Text("Are you sure you would like to logout?",
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
                            horizontal: 25.0,
                            vertical: 10.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: Colors.red[700],
                        ),
                        child: Text("Logout",
                            style: TextStyle(
                              fontSize: 17,
                            )),
                        onPressed: () {
                          UserController _userController = new UserController();
                          _userController.signOut(context);
                        },
                      ),
                    ],
                  )
                ])),
      );
    },
  );
}

//Bottom page navigation bar
SizedBox bottomBar(BuildContext context, int index) {
  return SizedBox(
    height: 65,
    child: BottomNavigationBar(
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
    ),
  );
}

//Back button
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
      Navigator.pop(context);
    },
  );
}

//Empty Text List Widget - SavedTextListScreen
Container emptySavedTextList() {
  return Container(
    width: 200,
    height: 150,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.list,
            color: Colors.blue,
            size: 35,
          ),
          const SizedBox(height: 5),
          Text(
            'Empty List',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'No saved texts found',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 15,
            ),
          ),
        ],
      ),
    ),
  );
}

//Result page - Challenegs Screen
class CorrectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Automatically go back after 2 seconds
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            SizedBox(height: 20),
            Text(
              'Correct!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

//Result page - Challenegs Screen
class WrongPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Automatically go back after 2 seconds
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel, color: Colors.red, size: 100),
            SizedBox(height: 20),
            Text(
              'Wrong!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
