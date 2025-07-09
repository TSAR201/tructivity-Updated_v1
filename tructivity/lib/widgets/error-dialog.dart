import 'package:flutter/material.dart';

class ErrorDialog extends StatefulWidget {
  final String error;
  ErrorDialog({required this.error});

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Error'),
      content: Text(widget.error),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.teal)),
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
