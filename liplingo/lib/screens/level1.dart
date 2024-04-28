import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:liplingo/screens/checkpage.dart'; 
import 'package:liplingo/screens/challengResult.dart';
import 'package:liplingo/screens/FirestoreService.dart';

class Level1 extends StatefulWidget {
  @override
  _Level1State createState() => _Level1State();
}

class _Level1State extends State<Level1> {
  late VideoPlayerController _videoController;
  bool _isPlaying = false;
  bool _hasMadeChoice = false;
  String? _selectedChoice;
  int _currentQuestionIndex = 0;
  int _correctAnswersCount = 0; // Counter for the number of correct answers
  List<Map<String, dynamic>> _questionsData = [
    {
      'videoAsset': 'assets/Q1-ball.mp4',
      'questionText': 'Select what did she say?',
      'choices': ['Ball', 'Bag', 'Hole'],
      'correctChoice': 'Ball',
    },
    {
      'videoAsset': 'assets/Q2-dad.mp4',
      'questionText': 'Select what did she say?',
      'choices': ['Doll', 'Dad', 'Sad'],
      'correctChoice': 'Dad',
    },
    {
      'videoAsset': 'assets/Q3-blue.mp4',
      'questionText': 'Select what did she say?',
      'choices': ['Puzzle', 'Cow', 'Blue'],
      'correctChoice': 'Blue',
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

  void navigateToResult() async {
    // Call the update progress method before navigating to the result screen
    await FirestoreService.updateLevelProgress(1, _correctAnswersCount);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChallengeResult(
          levelNumber: 1,
          numberOfStars: _correctAnswersCount,
         
        ),
      ),
    );
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

  Widget _choiceButton(String choice, double screenWidth) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: _selectedChoice == choice ? Colors.blue : Colors.grey[300]!,
        onPrimary: Colors.black,
        textStyle: TextStyle(fontSize: screenWidth * 0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        side: BorderSide(color: Colors.blue, width: 2),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 60),
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
        style: ElevatedButton.styleFrom(
          primary: _hasMadeChoice ? Colors.green : Colors.grey,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
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
          levelNumber:1,
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