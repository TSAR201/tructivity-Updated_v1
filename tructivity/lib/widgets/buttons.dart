import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final onTapSave;
  SaveButton({required this.onTapSave});
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      buttonColor: Colors.teal,
      textColor: Colors.white,
      label: 'Save',
      onTapButton: onTapSave,
    );
  }
}

class DeleteButton extends StatelessWidget {
  final onTapDelete;
  DeleteButton({required this.onTapDelete});
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      buttonColor: Colors.transparent,
      textColor: Colors.teal,
      label: 'Delete',
      onTapButton: onTapDelete,
    );
  }
}

class CustomButton extends StatelessWidget {
  final onTapButton;
  final String label;
  final Color buttonColor, textColor;
  CustomButton(
      {required this.onTapButton,
      required this.buttonColor,
      required this.textColor,
      required this.label});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(buttonColor)),
      child: Text(
        label,
        style: TextStyle(color: textColor),
      ),
      onPressed: onTapButton,
    );
  }
}
