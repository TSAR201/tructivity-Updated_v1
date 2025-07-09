import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String? text;
  ConfirmationDialog({this.text});
  @override
  Widget build(BuildContext context) {
    String? title = text;
    if (title == null) {
      title = 'Delete this entry?';
    }
    return AlertDialog(
      content: Text(title),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent)),
          child: Text(
            "No",
            style: TextStyle(color: Colors.teal),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.teal)),
          child: Text(
            "Yes",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
