import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../controller/textController.dart';
import '../utils/reusableWidgets.dart';

class SavedTextListScreen extends StatefulWidget {
  @override
  _SavedTextListScreenState createState() => _SavedTextListScreenState();
}

class _SavedTextListScreenState extends State<SavedTextListScreen> {

  //Initialize list variable
  late Stream<QuerySnapshot<Map<String, dynamic>>> _saveTextListStream;

  //Initialize controller
  TextController _textController = new TextController();

  //Initialize saved text list stream
  @override
  void initState() {
    _saveTextListStream = _textController.getSavedTextList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //AppBar
      appBar: topBar(context, "Saved Text List"),

      //Body
      body: Padding(
        padding: EdgeInsets.fromLTRB(40, 40, 40, 0),
        child: Column(
          children: [

            //Back Button
            Align(
              alignment: Alignment.topLeft,
              child: backButton(context),
            ),

            //Search Text Field
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

            //Spacing
            const SizedBox(height: 15),

            //List of Texts - Realtime
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _saveTextListStream,
              builder: (context, snapshot) {

                //Loading State
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();

                  //Display Text List State
                } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var _textItem = snapshot.data!.docs[index];
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
                                        _textItem['title'],
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Text(
                                        _textItem['text'],
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
                                      _textController.confirmDeletion(
                                          context,
                                          _textItem.reference,
                                          _textItem['title']);
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

                  //Empty Text List State
                  return emptySavedTextList();

                }
              },
            ),
          ],
        ),
      ),

      //Bottom NavBar
      bottomNavigationBar: bottomBar(context, 0),

    );
  }
}

