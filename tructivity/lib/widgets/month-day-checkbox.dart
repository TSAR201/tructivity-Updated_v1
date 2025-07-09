import 'package:flutter/material.dart';

class MonthDayCheckBox extends StatefulWidget {
  final bool initialValue;
  final String title;
  final Function(bool) onChanged;
  MonthDayCheckBox(
      {required this.initialValue,
      required this.title,
      required this.onChanged});
  @override
  _MonthDayCheckBoxState createState() => _MonthDayCheckBoxState(initialValue);
}

class _MonthDayCheckBoxState extends State<MonthDayCheckBox> {
  _MonthDayCheckBoxState(this.checkBoxValue);
  bool checkBoxValue;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: checkBoxValue ? Colors.teal : null,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            widget.title,
          ),
        ),
      ),
      onTap: () {
        setState(() {
          checkBoxValue = !checkBoxValue;
          widget.onChanged(checkBoxValue);
        });
      },
    );
  }
}
