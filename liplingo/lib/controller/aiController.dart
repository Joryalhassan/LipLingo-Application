import 'dart:io';
import 'package:http/http.dart' as http;

class AIController {

  //Implementation and intergration not complete on this version of the app
  Future<String> interpretToText(File videoFile) async {
    try {
      var uri = Uri.parse('http://your-api-url.com/predict');
      var request = http.MultipartRequest('POST', uri);
      var response = await request.send();

      if (response.statusCode == 200) {
        // Video successfully uploaded to the server
        final respStr = await response.stream.bytesToString();
        print('Video uploaded successfully');
        return respStr;
      } else {
        // Error uploading the video
        throw Exception('Error uploading video: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error sending request: $e');
    }
  }

}