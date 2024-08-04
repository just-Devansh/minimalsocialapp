import 'package:flutter/material.dart';

class MyMaterialButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const MyMaterialButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: MaterialButton(
          elevation: 0,
          onPressed: onPressed,
          color: Theme.of(context).colorScheme.secondary,
          child: Text(text),
        ),
      ),
    );
  }
}
