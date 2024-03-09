import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:liplingo/screens/checkpage.dart'; // Ensure you have these screens set up

class Questions extends StatefulWidget {
  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  late VideoPlayerController _videoController;
  bool _isPlaying = false;
  bool _hasMadeChoice = false;
  String? _selectedChoice;
  int _currentQuestionIndex = 0;
  List<Map<String, dynamic>> _questionsData = [
    {
      'videoAsset': 'assets/Q1-ball.mp4',
      'questionText': 'Select what did she say?',
      'choices': ['Ball', 'Bag', 'Hole'],
      'correctChoice': 'Ball',
      'starsColor': Colors.grey,
    },
    {
      'videoAsset': 'assets/Q2-dad.mp4',
      'questionText': 'Select what did she say?',
      'choices': ['Doll', 'Dad', 'Sad'],
      'correctChoice': 'Dad',
      'starsColor': Colors.yellow[600],
    },
    {
      'videoAsset': 'assets/Q3-blue.mp4',
      'questionText': 'Select what did she say?',
      'choices': ['Puzzle', 'Cow', 'Blue'],
      'correctChoice': 'Blue',
      'starsColor': Colors.yellow[600],
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

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
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
            height: screenHeight * 0.025,
            child: LinearProgressIndicator(
              value: 0.7, // Example progress value
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
        ),
        actions: [
          Icon(Icons.star, color: _questionsData[_currentQuestionIndex]['starsColor'], size: screenHeight * 0.04),
          SizedBox(width: screenWidth * 0.01),
          Icon(Icons.star, color: _questionsData[_currentQuestionIndex]['starsColor'], size: screenHeight * 0.04),
          SizedBox(width: screenWidth * 0.01),
          Icon(Icons.star, color: _questionsData[_currentQuestionIndex]['starsColor'], size: screenHeight * 0.04),
          SizedBox(width: screenWidth * 0.01),
        ],
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
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => isCorrect ? CorrectPage() : WrongPage()),
  ).then((_) {
    // This callback is called after CorrectPage or WrongPage pops back
    if (mounted) {
      setState(() {
        _currentQuestionIndex = (_currentQuestionIndex + 1) % _questionsData.length;
        _hasMadeChoice = false;
        _selectedChoice = null;
        _videoController.dispose(); // Dispose the current controller
        // Initialize the video player for the next question
        _initVideoPlayer();
      });
    }
  });
}
}