import 'package:flutter/material.dart';
import 'dart:async';

class CustomSuccessDialog extends StatefulWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  const CustomSuccessDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
  }) : super(key: key);

  @override
  _CustomSuccessDialogState createState() => _CustomSuccessDialogState();
}

class _CustomSuccessDialogState extends State<CustomSuccessDialog> {
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
        Icons.check_circle,
        size: 100,
        color: Colors.green,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min, // Automatically adjust the height
        crossAxisAlignment:
            CrossAxisAlignment.center, // Align content to center
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
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
              fontSize: 14,
              fontFamily: 'Poppins',
              color: Color(0xFF6D674B),
            ),
          ),
        ],
      ),
    );
  }
}
