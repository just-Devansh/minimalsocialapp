import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minimalsocialapp/components/my_drawer.dart';
import 'package:minimalsocialapp/components/my_list_tile.dart';
import 'package:minimalsocialapp/components/my_material_button.dart';
import 'package:minimalsocialapp/components/my_post_button.dart';
import 'package:minimalsocialapp/components/my_textfield.dart';
import 'package:minimalsocialapp/database/firestore.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // firestore access
  final FirestoreDatabase database = FirestoreDatabase();

  // text controller for the posts
  final TextEditingController newPostController = TextEditingController();

  // post message
  void postMessage() {
    // only post a message if there is something in the textfield
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }

    // clear the controller
    newPostController.clear();
  }

  // T H E  U P D A T E  D I A L O G
  void edit(String postID, String currentPostText) {
    // new editController initialised with currentPostText
    TextEditingController editController =
        TextEditingController(text: currentPostText);
    // show a dialog to update
    showDialog(
      context: context,
      builder: (context) => Center(
        child: AlertDialog(
          title: Center(
            child: Text(
              'Update your post...',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          content: Container(
            height: 120,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyTextfield(
                  hintText: '.....',
                  obscureText: false,
                  controller: editController,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // two buttons
                  children: [
                    // Cancel button
                    MyMaterialButton(
                      text: 'Cancel',
                      // this is how you pop the current context in a voidCallback case
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    // Delete button
                    MyMaterialButton(
                      text: 'Update',
                      onPressed: () {
                        database.updatePost(
                          context,
                          postID,
                          editController.text,
                        );
                        // pop of the dialog box
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }

  // T H E  D E L E T E  D I A L O G
  void delete(String postID) {
    // show 'are you sure?' dialog
    showDialog(
      context: context,
      builder: (context) => Center(
        child: AlertDialog(
          title: Center(
            child: Text(
              'Are you sure?',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          content: Container(
            height: 40,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // two buttons
                children: [
                  // Cancel button
                  MyMaterialButton(
                    text: 'Cancel',
                    // this is how you pop the current context in a voidCallback case
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  // Delete button
                  MyMaterialButton(
                    text: 'Delete',
                    onPressed: () {
                      database.deletePost(context, postID);
                      // pop of the dialog box
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text(
          'W A L L',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          // TEXTFIELD BOX FOR USER TO TYPE
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                // texfield
                Expanded(
                  child: MyTextfield(
                    hintText: 'Share something...',
                    obscureText: false,
                    controller: newPostController,
                  ),
                ),

                // post button
                MyPostButton(
                  onTap: postMessage,
                )
              ],
            ),
          ),

          // POSTS
          StreamBuilder(
              stream: database.getPostsStream(),
              builder: (context, snapshot) {
                // show loading circle
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // get all posts
                final posts = snapshot.data!.docs;

                // no data?
                if (snapshot.data == null || posts.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Text('No Posts...Post something!'),
                    ),
                  );
                }

                // return as a list
                return Expanded(
                  child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        // get each individual post
                        final post = posts[index];
                        final postID = post.id;

                        // get data from each post
                        String message = post['PostMessage'];
                        String userEmail = post['UserEmail'];
                        Timestamp timestamp = post['TimeStamp'];

                        // return as a list tile
                        return MyListTile(
                          title: message,
                          subTitle: userEmail,
                          iconButton: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => edit(postID, message),
                                icon: const Icon(Icons.mode_edit),
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                              IconButton(
                                onPressed: () => delete(postID),
                                icon: const Icon(Icons.delete_rounded),
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ],
                          ),
                        );
                      }),
                );
              })
        ],
      ),
    );
  }
}
