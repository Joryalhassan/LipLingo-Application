import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../reusable_widget/reusableWidgets.dart';

class SavedTextListScreen extends StatefulWidget {
  const SavedTextListScreen({super.key});

  @override
  State<SavedTextListScreen> createState() => _SavedTextListScreenState();
}

class _SavedTextListScreenState extends State<SavedTextListScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final _itemCount = 10;
  bool _hasItems = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Top App Bar
      appBar: topBar(context, "Saved Text List"),
      //Main Body - Test text
      body: Padding(
        padding: EdgeInsets.fromLTRB(40, 40, 40, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: backButton(context),
            ),
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
                contentPadding: EdgeInsets.symmetric(
                    vertical: 15, horizontal: 15),
              ),
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 15),
            _hasItems // Conditionally render either the list of cards or the "No items available" message
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _itemCount,
                      // Change itemCount to 0 for demonstration
                      itemBuilder: (context, position) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              position.toString(),
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Text(
                    'No items available',
                    style: TextStyle(fontSize: 18.0),
                  ),
          ],
        ),
      ),
      //Bottom nav Bar
      bottomNavigationBar: bottomBar(context, 0),
    );
  }
}
