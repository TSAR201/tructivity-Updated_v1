import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextInputType? type;
  final labelText;
  final fieldIcon;
  final capitalizaton;
  final Function(String) onChangedCallback;
  final String initialText;
  final bool validate;
  final TextInputFormatter? formatter;
  CustomTextField({
    required this.labelText,
    required this.fieldIcon,
    required this.onChangedCallback,
    required this.capitalizaton,
    required this.validate,
    required this.initialText,
    this.type,
    this.formatter,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  final controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    controller.text = widget.initialText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: TextFormField(
        controller: controller,
        keyboardType: widget.type != null ? widget.type : TextInputType.text,
        textCapitalization: widget.capitalizaton,
        expands: false,
        inputFormatters: widget.formatter != null ? [widget.formatter!] : null,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: widget.labelText,
          prefixIcon: Icon(widget.fieldIcon),
        ),
        onChanged: widget.onChangedCallback,
        validator: !widget.validate
            ? null
            : (val) {
                if (val == '') {
                  return 'Required Field';
                }
                return null;
              },
      ),
    );
  }
}
