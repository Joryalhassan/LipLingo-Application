import 'package:flutter/material.dart';
import 'package:liplingo/view/accountSettings.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTitle("Frequently Asked Questions: "),
            _buildQuestion(
              '1. How do I edit my profile information?',
              'Navigate to the "Edit Profile" section in the app, where you can modify your first name and last name.',
            ),
            _buildQuestion(
              '2. What should I do if I forget my password?',
              'you can reset your password by providing your email. A password reset link will be sent to the provided email address.',
            ),
            _buildQuestion(
              '3. How do I edit my profile information?',
              'Navigate to the "Edit Profile" section in the app, where you can modify your first name, last name, and email.',
            ),
            _buildQuestion(
              '4. Is it possible for a user to upload a video from their devices album?',
              'Yes, users can upload videos from their devices album.',
            ),
            _buildQuestion(
              '5. How does the video recording feature work?',
              'Users can record a 1-minute video of their face by starting and stopping the recording using the applications video recording feature.',
            ),
            _buildQuestion(
              '6. What is the purpose of interpreting lip movements into text?',
              'The system interprets lip movements into text to assist users in understanding spoken words through visual cues.',
            ),
            _buildQuestion(
              '7. How can a user view the interpreted text?',
              'Users can view the interpreted text within the application.',
            ),
            _buildQuestion(
              '8.Can a user edit the interpreted text?',
              'Yes, users have the option to edit the interpreted text if needed.',
            ),
            _buildQuestion(
              '9. How can a user save the interpreted text?',
              'Users can save the interpreted text using the save functionality..',
            ),

            _buildQuestion(
              '10. can a user view all of saved interpreted texts?',
              'Users can view the list of saved interpreted texts in the application.',
            ),
            _buildQuestion(
              '11. How can a user delete a specific saved text??',
              'Users can delete a specific saved text through the application'
                  's delete functionality.',
            ),
            _buildQuestion(
              '12. How can a user search for a specific saved interpreted text?',
              'Users can search for a specific saved interpreted text using the search feature within the application. ',
            ),
            _buildQuestion(
              '13. How does the lip reading lessons and challenges work?',
              'Users can learn lip reading through lessons and challenges, viewing videos, answering questions, and progressing through levels.',
            ),
            _buildQuestion(
              '14. How can a user search for a specific saved interpreted text?',
              'Users can search for a specific saved interpreted text using the search feature within the application. ',
            ),
            _buildQuestion(
              '15. can a user track their progress in lessons and challenges?',
              'Yes, users can view their lessons and challenges progress within the application. ',
            ),
            _buildQuestion(
              '16. How can a user log out of the application?',
              'Users can log out using the logout icon provided in the top of their screen. ',
            ),
            _buildQuestion(
              '17. What is the process for deleting a user account?',
              'Users can delete their account through the account deletion functionality. in account settings ',
            ),
            _buildQuestion(
              '18. How can a user clear the data of the saved text?',
              'Users can clear the data of the saved text using the "Clear Data" feature. ',
            ),

            // Add more questions and answers as needed
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(answer),
        ],
      ),
    );
  }
  Widget _buildTitle(String _title){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        _title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
