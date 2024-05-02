import 'package:flutter/material.dart';
import 'package:liplingo/controller/interpretedTextController.dart';
import 'package:liplingo/view/lipReading.dart';
import 'package:liplingo/view/savedTextList.dart';
import '../model/interpretedTextModel.dart';
import '../utils/reusableWidgets.dart';
import 'editText.dart';

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
  interpretedTextController _controller = new interpretedTextController();

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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LipReadingScreen()),
                  );
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
                    //Edit Buttons
                    _buildButton('Edit Text'),
                    _buildButton('Save Text'),
                  ],
                ),
                //Spacing
                const SizedBox(height: 10),
                //Build Record Button
                _buildButton('Record'),
              ],
            ),
          ],
        ),
      ),

      //Bottom nav Bar
      bottomNavigationBar: bottomBar(context, 0),
    );
  }

  Widget _buildButton(String _label) {
    return ElevatedButton(
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
      child: Text(_label,
          style: TextStyle(
            fontSize: 17,
          )),
      onPressed: () {
        switch (_label) {
          case 'Edit Text':
            //Call edit page
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    EditTextScreen(initialText: _textPassageController.text)));
            break;
          case 'Save Text':
            //Save Text Function from controller
            displaySavedTextForm(context, _textPassageController.text);
            break;
          case 'Record':
          default:
            //Navigate back to the Lip Reading Page
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => LipReadingScreen()));
            break;
        }
      },
    );
  }

//Display Save Text Form Widget - ViewText Screen
  void displaySavedTextForm(BuildContext context, String _interpretedText) {
    //Form Key
    final _formKeySavedText = GlobalKey<FormState>();

    //Title Form Controlelr
    TextEditingController _titleController = TextEditingController();

    //Dialog Form
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20.0), // Adjust the value as needed
            ),
            child: Form(
              key: _formKeySavedText,
              child: Container(
                padding: EdgeInsets.fromLTRB(30, 35, 30, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Title
                    Text(
                      "Save Text",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    //Spacing
                    const SizedBox(height: 15),

                    //Title Form Title
                    Text(
                      "Title:",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                      ),
                    ),

                    //Spacing
                    const SizedBox(height: 3),

                    //Title Form Field
                    TextFormField(
                      maxLength: 64,
                      controller: _titleController,
                      maxLines: 1,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // Validate while typing
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        counter: Text(
                          '',
                          style: TextStyle(
                            fontSize: 3,
                          ),
                        ),
                        hintText: 'Enter title',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      ),
                      style: TextStyle(fontSize: 15),
                    ),

                    //Spacing
                    const SizedBox(height: 10),

                    //Text Passage Form Title
                    Text(
                      "Text:",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                      ),
                    ),

                    //Spacing
                    const SizedBox(height: 3),

                    //Text Passage Form field
                    TextFormField(
                      initialValue: _interpretedText,
                      maxLines: 5,
                      enabled: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      ),
                      style: TextStyle(fontSize: 15),
                    ),

                    //Spacing
                    const SizedBox(height: 20),

                    //Button List
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Cancel Button
                        OutlinedButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 17,
                            ),
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
                              color: Colors.blue,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),

                        //Save Text Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 25.0,
                              vertical: 10.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                          child: Text(
                            "Save Text",
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          onPressed: () {
                            if (_formKeySavedText.currentState!.validate()) {
                              //Dismiss dialog
                              Navigator.pop(context);

                              try {
                                //Create Text object
                                InterpretedText _savedText = InterpretedText(
                                    '',
                                    _titleController.text.trim(),
                                    _interpretedText);

                                //Save Text
                                _controller.saveText(_savedText);

                                //Navigate to Saved Text Page
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        SavedTextListScreen()));
                              } catch (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Error: unable to save text.'),
                                    backgroundColor: Colors.green,
                                    duration: Duration(
                                        seconds:
                                            2), // Adjust the duration as needed
                                  ),
                                );
                              }
                            }
                            ;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
