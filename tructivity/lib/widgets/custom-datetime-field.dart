import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateTimeField extends StatefulWidget {
  final Icon icon;
  final DateTimeFieldPickerMode mode;
  final DateTime selectedDate;
  final dateSelectedCallback;
  final String? label;
  final DateFormat? dateFormat;
  CustomDateTimeField({
    required this.dateSelectedCallback,
    required this.selectedDate,
    required this.mode,
    required this.icon,
    this.label,
    this.dateFormat,
  });

  @override
  _CustomDateTimeFieldState createState() =>
      _CustomDateTimeFieldState(selectedDate);
}

class _CustomDateTimeFieldState extends State<CustomDateTimeField> {
  _CustomDateTimeFieldState(this.selectedDate);
  DateTime selectedDate;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: DateTimeField(
        dateFormat: widget.dateFormat,
        mode: widget.mode,
        onDateSelected: (val) {
          widget.dateSelectedCallback(val);
          setState(() {
            selectedDate = val;
          });
        },
        selectedDate: selectedDate,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: widget.icon,
          labelText: widget.label,
        ),
      ),
    );
  }
}
