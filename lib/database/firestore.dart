/*
This database stores posts that users have published in the app.
It is stored in a collection called 'Posts' in Firebase.

Each post contains:
- a message
- email of the user
- timestamp
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreDatabase {
  // current logged in user
  User? user = FirebaseAuth.instance.currentUser;

  // get collection of posts from firebase
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('Posts');

  // post a message
  Future<void> addPost(String message) {
    return posts.add({
      'UserEmail': user!.email,
      'PostMessage': message,
      'TimeStamp': Timestamp.now(),
    });
  }

  // read posts from firebase
  Stream<QuerySnapshot> getPostsStream() {
    final postsStream = FirebaseFirestore.instance
        .collection('Posts')
        .orderBy('TimeStamp', descending: true)
        .snapshots();

    return postsStream;
  }

  // update post given a post id
  Future<void> updatePost(BuildContext context, String postID, String newPost) {
    return posts.doc(postID).update({
      'PostMessage': newPost,
      'timestamp': Timestamp.now(),
    });
  }

  // delete post given a post id
  Future<void> deletePost(BuildContext context, String postID) {
    return posts.doc(postID).delete();
  }
}
