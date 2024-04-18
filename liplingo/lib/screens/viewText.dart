import 'package:flutter/material.dart';
import 'package:liplingo/controller/textController.dart';
import 'package:liplingo/screens/lipReading.dart';
import '../utils/reusableWidgets.dart';

class ViewTextScreen extends StatefulWidget {
  //Received Parameter
  final String translatedText;

  const ViewTextScreen({Key? key, required this.translatedText})
      : super(key: key);

  @override
  State<ViewTextScreen> createState() => _ViewTextScreenState();
}

class _ViewTextScreenState extends State<ViewTextScreen> {
  //Text Controller - MVC
  TextController _controller = new TextController();

  //Text Form Controller
  TextEditingController _textPassageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set the initial value of the text field
    _textPassageController.text = widget.translatedText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Top App Bar
      appBar: topBar(context, "Lip Reading"),

      //Main Body - Display Text
      body: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Custom Back button that returns user to the lipreading page.
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
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
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LipReadingScreen(),
                  ));
                },
              ),
            ),
            Column(
              children: [
                //Title
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Interpreted To Text: ",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ),

                //Spacing
                const SizedBox(height: 15),

                //Textfield displaying translated text
                TextField(
                  controller: _textPassageController,
                  readOnly: true,
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  ),
                  style: TextStyle(fontSize: 16),
                ),

                //Spacing
                const SizedBox(height: 20),

                //Button List
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Edit Text Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 27.0,
                          vertical: 13.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      child: Text("Edit Text",
                          style: TextStyle(
                            fontSize: 17,
                          )),
                      onPressed: () {

                        //Edit Text Function from Controller
                        _controller.editText(context, _textPassageController);
                      },
                    ),

                    //Save Text Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 27.0,
                          vertical: 13.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      child: Text("Save Text",
                          style: TextStyle(
                            fontSize: 17,
                          )),
                      onPressed: () {

                        //Save Text Function from controller
                        _controller.displaySavedTextForm(context, _textPassageController);
                      },
                    ),
                  ],
                ),

                //Spacing
                const SizedBox(height: 10),

                //Record Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 27.0,
                      vertical: 13.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text("Record",
                      style: TextStyle(
                        fontSize: 17,
                      )),
                  onPressed: () {

                    //Navigate back to the Lip Reading Page
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LipReadingScreen()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),

      //Bottom nav Bar
      bottomNavigationBar: bottomBar(context, 0),
    );
  }
}
