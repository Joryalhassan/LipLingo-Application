import 'package:flutter/material.dart';
import '../utils/reusableWidgets.dart';

class EditTextScreen extends StatefulWidget {
  final String initialText;
  final Function(String) onSave;

  const EditTextScreen(
      {Key? key, required this.initialText, required this.onSave})
      : super(key: key);

  @override
  State<EditTextScreen> createState() => _EditTextScreenState();
}

class _EditTextScreenState extends State<EditTextScreen> {
  //Initialize form controller
  late TextEditingController _textEditingController;
  final _formKeyEditText = GlobalKey<FormState>();

  //Set edit form with text
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.initialText);
  }

  //Dispose controller after edit completed
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Top App Bar
      appBar: topBar(context, "Lip Reading"),

      //Main Body - Edit Form
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                //Back Button
                Align(
                  alignment: Alignment.topLeft,
                  child: backButton(context),
                ),
                //Title
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Edit Text: ",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ),

                //Spacing
                const SizedBox(height: 15),

                //Edit Text Form
                Form(
                  key: _formKeyEditText,
                  //Edit Form Field
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _textEditingController,
                        maxLines: 10,
                        keyboardType: TextInputType.multiline,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // Validate while typing
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Text is required';
                          }
                          return null;
                        },

                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                      //Spacing
                      const SizedBox(height: 20),

                      //Confirm Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 35.0,
                            vertical: 13.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        child: Text("Confirm Edit",
                            style: TextStyle(
                              fontSize: 17,
                            )),
                        onPressed: () {
                          if (_formKeyEditText.currentState!.validate()) {
                            widget.onSave(_textEditingController.text);
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
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
