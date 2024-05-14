import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoController {
  final ImagePicker _picker = ImagePicker();

  void recordVideo(){
    //Must be separated from view
    //Tried to separate but performance was severely affected (It took 2 seconds to start recording after pressing record button)
    //Will return after report is complete
  }

  Future<String> uploadVideo(BuildContext context) async {
    String _feedback = "";
    try {
      final XFile? pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 1),
      );
      if (pickedFile != null) {
        final video = VideoPlayerController.file(File(pickedFile.path));
        await video.initialize();
        final Duration duration = video.value.duration;
        await video.dispose();

        if (duration.inSeconds > 60) {
          _feedback = "Exceeds duration";
        } else {
          _feedback = pickedFile.path;
        }
      } else {
        _feedback = 'No Video Selected';
      }
    } on PlatformException {
      throw PlatformException;
    }
    return _feedback;
  }

}
