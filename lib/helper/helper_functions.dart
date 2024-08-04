import 'package:flutter/material.dart';

// display error message to user
void displayMessageToUser(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        AlertDialog(
          title: Center(child: Text(message)),
        ),
      ]),
    ),
  );
}
