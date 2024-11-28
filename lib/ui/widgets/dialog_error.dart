import 'package:flutter/material.dart';
import 'dart:async';

class CustomErrorDialog extends StatefulWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  const CustomErrorDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
  }) : super(key: key);

  @override
  _CustomErrorDialogState createState() => _CustomErrorDialogState();
}

class _CustomErrorDialogState extends State<CustomErrorDialog> {
  @override
  void initState() {
    super.initState();
    // Automatically close the dialog after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close the dialog
      widget.onConfirm(); // Call the onConfirm callback if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      title: const Icon(
        Icons.error,
        size: 100,
        color: Colors.red, // Use red for error icon
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Color(0xFF6D674B),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              color: Color(0xFF6D674B),
            ),
          ),
        ],
      ),
    );
  }
}
