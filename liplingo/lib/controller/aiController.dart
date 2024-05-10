import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AIController {
  String uploadVideoAPI = 'http://192.168.100.161:5000/predict';
  String recordVideoAPI = 'http://192.168.100.161:8080/predict';

  //Implementation and integration - not complete on this version of the app
  Future<String> interpretToText(File videoFile, bool uploaded) async {
    try {
      String apiValue = (uploaded) ? uploadVideoAPI : recordVideoAPI;
      var uri = Uri.parse(apiValue);
      var request = http.MultipartRequest('POST', uri);
      request.files
          .add(await http.MultipartFile.fromPath('file', videoFile.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();

        //Cut returned text
        Map<String, dynamic> respStrDecoded = jsonDecode(respStr);
        String prediction = respStrDecoded['prediction'];
        return prediction;
        
      } else {
        print('Error uploading video: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error sending request: $e');
    }
  }
}
