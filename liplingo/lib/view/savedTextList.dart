import 'package:flutter/material.dart';
import 'package:liplingo/model/interpretedtTextModel.dart';
import '../controller/interpretedTextController.dart';
import '../utils/reusableWidgets.dart';

class SavedTextListScreen extends StatefulWidget {
  @override
  _SavedTextListScreenState createState() => _SavedTextListScreenState();
}

class _SavedTextListScreenState extends State<SavedTextListScreen> {
  // Initialize list variable
  late Future<List<InterpretedText>> _saveTextListFuture;

  // Initialize controller
  interpretedTextController _textController = interpretedTextController();

  // Initialize saved text list future
  @override
  void initState() {
    _saveTextListFuture = _textController.getSavedTextList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: topBar(context, "Saved Text List"),

      // Body
      body: Padding(
        padding: EdgeInsets.fromLTRB(40, 40, 40, 0),
        child: Column(
          children: [
            // Back Button
            Align(
              alignment: Alignment.topLeft,
              child: backButton(context),
            ),

            // Search Text Field
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              ),
              style: TextStyle(fontSize: 15),
            ),

            // Spacing
            const SizedBox(height: 15),

            // List of Texts - Realtime
            FutureBuilder<List<InterpretedText>>(
              future: _saveTextListFuture,
              builder: (context, snapshot) {

                // Loading State
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                // Display Text List State
                else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var interpretedText = snapshot.data![index];
                        return Card(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            child: Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        interpretedText.title,
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Text(
                                        interpretedText.interpretedText,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      confirmDeletion(context, interpretedText);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  // Empty Text List State
                  return emptySavedTextList();
                }
              },
            ),
          ],
        ),
      ),

      // Bottom NavBar
      bottomNavigationBar: bottomBar(context, 0),
    );
  }

  //Display Confirm Deletion Widget - SavedTextList Screen
  void confirmDeletion(BuildContext context, InterpretedText interpretedText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20.0), // Adjust the value as needed
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 35, 40, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Delete Text?",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Are you sure you would like to delete the \"${interpretedText.title}\" text?",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                        side: BorderSide(width: 1, color: Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25.0,
                          vertical: 10.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.red[700],
                      ),
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      onPressed: () {
                        _textController.deleteSpecificText(
                            context, interpretedText);

                        setState(() {
                          _saveTextListFuture =
                              _textController.getSavedTextList();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
