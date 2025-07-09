import 'package:flutter/material.dart';

class WeekDayCheckBox extends StatefulWidget {
  final bool initialValue;
  final String title;
  final Function(bool) onChanged;
  WeekDayCheckBox(
      {required this.initialValue,
      required this.title,
      required this.onChanged});
  @override
  _WeekDayCheckBoxState createState() => _WeekDayCheckBoxState(initialValue);
}

class _WeekDayCheckBoxState extends State<WeekDayCheckBox> {
  _WeekDayCheckBoxState(this.checkBoxValue);
  bool checkBoxValue;
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        activeColor: Colors.teal,
        title: Text(widget.title),
        value: checkBoxValue,
        onChanged: (bool? val) {
          setState(() {
            checkBoxValue = val!;
            widget.onChanged(checkBoxValue);
          });
        });
  }
}
