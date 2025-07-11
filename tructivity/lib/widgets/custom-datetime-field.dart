import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateTimeField extends StatefulWidget {
  final Icon icon;
  final DateTimeFieldPickerMode mode;
  final DateTime selectedDate;
  final Function(DateTime) dateSelectedCallback;
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
  DateTime selectedDate;
  _CustomDateTimeFieldState(this.selectedDate);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: DateTimeFormField(
        initialValue: selectedDate,
        mode: widget.mode,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: widget.icon,
          labelText: widget.label,
        ),
        dateFormat: widget.dateFormat,
        onChanged: (val) {
          widget.dateSelectedCallback(val!);
          setState(() {
            selectedDate = val;
          });
        },
      ),
    );
  }
}
