import 'package:flutter/material.dart';

class DropdownList extends StatefulWidget {
  final Function(String) onChanged;
  final String? label;
  final String initialSelection;
  final List<String> options;
  final IconData? icon;
  const DropdownList(
      {required this.label,
      required this.onChanged,
      required this.options,
      required this.icon,
      required this.initialSelection});

  @override
  State<DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: DropdownButtonFormField(
        value: widget.initialSelection,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: widget.label == null ? null : widget.label,
          prefixIcon: widget.icon == null ? null : Icon(widget.icon),
        ),
        items: widget.options
            .map((e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ))
            .toList(),
        onChanged: (String? val) {
          widget.onChanged(val!);
        },
      ),
    );
  }
}
