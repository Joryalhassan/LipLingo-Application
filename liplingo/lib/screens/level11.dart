import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:liplingo/screens/checkpage.dart'; 
import 'package:liplingo/screens/challengResult.dart';
class Level11 extends StatefulWidget {
  @override
  _Level11State createState() => _Level11State();
}

class _Level11State extends State<Level11> {
  late VideoPlayerController _videoController;
  bool _isPlaying = false;
  bool _hasMadeChoice = false;
  String? _selectedChoice;
  int _currentQuestionIndex = 0;
  int _correctAnswersCount = 0; // Counter for the number of correct answers
  List<Map<String, dynamic>> _questionsData = [
    {
      'videoAsset': 'assets/Q31-Igotvegetables.mp4',
      'questionText': 'Select what did she say?',
      'choices': ['I got\nvegetables', 'I have vertebrae', 'I grab\nvegetables'],
      'correctChoice': 'I got\nvegetables',
    },
    {
      'videoAsset': 'assets/Q32-Igotfruit.mp4',
      'questionText': 'Select what did she say?',
      'choices': ['I like fruit', 'I got fruit', 'I got flour'],
      'correctChoice': 'I got fruit',
    },
    {
      'videoAsset': 'assets/Q33-himynameisjessica.mp4',
      'questionText': 'Select what did she say?',
      'choices': ['My mom\nis Jessy', 'Hi Jessy', 'Hi my name\nis jessica'],
      'correctChoice': 'Hi my name\nis jessica',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  void _initVideoPlayer() {
    _videoController = VideoPlayerController.asset(_questionsData[_currentQuestionIndex]['videoAsset'])
      ..initialize().then((_) {
        setState(() {});
      });
    _videoController.setLooping(true);
    _videoController.setVolume(1.0);
    _videoController.addListener(_videoPlayerListener);
  }

  void _videoPlayerListener() {
    final bool isCurrentlyPlaying = _videoController.value.isPlaying;
    if (isCurrentlyPlaying != _isPlaying) {
      setState(() {
        _isPlaying = isCurrentlyPlaying;
      });
    }
  }
void replayLevel() {
 if (mounted) {
    Navigator.pop(context); // Ensure context is still available when popping
    resetQuiz(); // Reset the quiz
  }
}
  void resetQuiz() {
  if (mounted) {
    setState(() {
      _currentQuestionIndex = 0;
      _correctAnswersCount = 0;
      _hasMadeChoice = false;
      _selectedChoice = null;
      _videoController.dispose();
      _initVideoPlayer();
    });
  }
}

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  double get _progressValue {
    // Adjust the formula to match the custom progression logic
    switch (_currentQuestionIndex) {
      case 0:
        return 0; // For the first question, 0%
      case 1:
        return 1 / 3; // For the second question, 33%
      default:
        return 2 / 3; // For the third question, 66%
    }
  }

  List<Widget> _buildStars(BuildContext context) {
    // Determine how many stars should be colored based on _correctAnswersCount
    List<Widget> stars = [];
    for (int i = 0; i < 3; i++) {
      stars.add(
        Icon(
          Icons.star,
          color: i < _correctAnswersCount ? Colors.yellow[600] : Colors.grey,
          size: MediaQuery.of(context).size.height * 0.04,
        ),
      );
      if (i < 2) { // Add spacing between stars, but not after the last one
        stars.add(SizedBox(width: MediaQuery.of(context).size.width * 0.01));
      }
    }
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.blue, size: screenHeight * 0.04),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: ClipRRect(
          borderRadius: BorderRadius.circular(45),
          child: SizedBox(
            height: screenHeight * 0.01,
            width: screenWidth * 1.0,
            child: LinearProgressIndicator(
              value: _progressValue, // Use the calculated progress value here
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
        ),
        actions: _buildStars(context),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    VideoPlayer(_videoController),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_videoController.value.isPlaying) {
                            _videoController.pause();
                          } else {
                            _videoController.play();
                          }
                        });
                      },
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: !_isPlaying
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 100.0,
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              _questionsData[_currentQuestionIndex]['questionText'],
              style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.04),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _choiceButton(_questionsData[_currentQuestionIndex]['choices'][0], screenWidth),
                      _choiceButton(_questionsData[_currentQuestionIndex]['choices'][2], screenWidth),
                    ],
                  ),
                   SizedBox(height: 10),
                  _choiceButton(_questionsData[_currentQuestionIndex]['choices'][1], screenWidth),
                ],
              ),
            ),
            _checkAnswerButton(screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }

  ButtonStyle _commonButtonStyle({required Color backgroundColor, required Color textColor, Color? borderColor}) {
  return ElevatedButton.styleFrom(
    primary: backgroundColor,
    onPrimary: textColor,
    textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    side: borderColor != null ? BorderSide(color: borderColor, width: 2) : BorderSide.none,
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 60),
  );
}

  Widget _choiceButton(String choice, double screenWidth) {
  bool isSelected = _selectedChoice == choice;
  return ElevatedButton(
    style: _commonButtonStyle(
      backgroundColor: isSelected ? Colors.blue : Colors.grey[300]!,
      textColor: isSelected ? Colors.white: Colors.black,
      borderColor: Colors.blue, // Always blue border for choice buttons
    ),
    onPressed: () {
      setState(() {
        _hasMadeChoice = true;
        _selectedChoice = choice;
      });
    },
    child: Text(choice),
  );
}

Widget _checkAnswerButton(double screenWidth, double screenHeight) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
    child: ElevatedButton(
      style: _commonButtonStyle(
        backgroundColor: _hasMadeChoice ? Colors.green : Colors.grey,
        textColor: Colors.white,
        borderColor: null, // No border for the check button
      ),
      onPressed: _hasMadeChoice ? _checkAnswer : null,
      child: Text('Check', style: TextStyle(fontSize: screenWidth * 0.045)),
    ),
  );
}
  void _checkAnswer() {
  bool isCorrect = _selectedChoice == _questionsData[_currentQuestionIndex]['correctChoice'];
  if (isCorrect) {
    _correctAnswersCount++;
  }

  void navigateToResult() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChallengeResult(
          levelNumber:11,
          numberOfStars: _correctAnswersCount,
        
        ),
      ),
    );
  }

  void goToNextOrResult() {
    if (_currentQuestionIndex == _questionsData.length - 1) {
      // After the third question, show the ChallengeResult
      navigateToResult();
    } else {
      // Move to the next question
      setState(() {
        _currentQuestionIndex++;
        _hasMadeChoice = false;
        _selectedChoice = null;
        _videoController.dispose();
        _initVideoPlayer();
      });
    }
  }

  // Navigate to the CorrectPage or WrongPage based on the current question's answer
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => isCorrect ? CorrectPage() : WrongPage()),
  ).then((_) {
    if (mounted) {
      goToNextOrResult();
    }
  });
}
}