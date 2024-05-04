import 'package:flutter/material.dart';
import '../model/interpretedTextModel.dart';
import '../controller/interpretedTextController.dart';
import '../utils/reusableWidgets.dart';

class SavedTextListScreen extends StatefulWidget {
  @override
  _SavedTextListScreenState createState() => _SavedTextListScreenState();
}

class _SavedTextListScreenState extends State<SavedTextListScreen> {
  late Future<List<InterpretedText>> _saveTextListFuture;

  interpretedTextController _textController = interpretedTextController();

  TextEditingController _searchController = TextEditingController(); // Step 1

  @override
  void initState() {
    _saveTextListFuture = _textController.getSavedTextList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(context, "Saved Text List"),
      body: Padding(
        padding: EdgeInsets.fromLTRB(40, 40, 40, 0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: backButton(context),
            ),
            _searchFormField(),
            FutureBuilder<List<InterpretedText>>(
              future: _saveTextListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
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
                  return emptySavedTextList();
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomBar(context, 0),
    );
  }

  //Display Confirm Deletion Widget - SavedTextList Screen
  void confirmDeletion(BuildContext context, InterpretedText interpretedText) {
    DialogUtils.displayCustomDialog(
      context,
      title: 'Delete Text?',
      content: 'Are you sure you would like to delete the \"${interpretedText.title}\" text?',
      confirmButtonText: 'Delete',
      cancelButtonText: 'Cancel',
      onConfirm: () {
        _textController.deleteSpecificText(
            context, interpretedText);

        setState(() {
          _saveTextListFuture =
              _textController.getSavedTextList();
        });
      },
    );
  }

  Widget _searchFormField() {
    return Column(children: [
      TextFormField(
        controller: _searchController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) {
          setState(() {
            _saveTextListFuture = _textController.searchforSavedTexts(value);
          });
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[100],
          hintText: 'Search...',
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        ),
        style: TextStyle(fontSize: 15),
      ),
      const SizedBox(height: 15),
    ]);
  }
}
