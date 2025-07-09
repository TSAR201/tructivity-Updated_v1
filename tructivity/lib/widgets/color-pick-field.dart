import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickField extends StatefulWidget {
  final Color initialColor;
  final onColorChanged;
  ColorPickField({
    required this.initialColor,
    required this.onColorChanged,
  });
  @override
  State<ColorPickField> createState() => _ColorPickFieldState(initialColor);
}

class _ColorPickFieldState extends State<ColorPickField> {
  Color selectedColor;
  _ColorPickFieldState(this.selectedColor);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        children: [
          Icon(Icons.color_lens_outlined),
          SizedBox(width: 20),
          GestureDetector(
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                color: selectedColor,
                shape: BoxShape.circle,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) =>
                    ColorPickerDialog(initialColor: widget.initialColor),
              ).then((newColor) {
                if (newColor != null) {
                  changeColor(newColor);
                }
              });
            },
          )
        ],
      ),
    );
  }

  void changeColor(Color newColor) {
    setState(() {
      selectedColor = newColor;
    });
    widget.onColorChanged(newColor);
  }
}

class ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  ColorPickerDialog({required this.initialColor});

  @override
  _ColorPickerDialogState createState() =>
      _ColorPickerDialogState(initialColor);
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color pickerColor;
  _ColorPickerDialogState(this.pickerColor);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick a color'),
      content: SingleChildScrollView(
        child: MaterialPicker(
          pickerColor: pickerColor,
          onColorChanged: changeColor,
          enableLabel: false,
        ),
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent)),
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.teal),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.teal)),
          child: Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context, pickerColor);
          },
        )
      ],
    );
  }

  void changeColor(Color val) {
    setState(() {
      pickerColor = val;
    });
  }

  List<Color> colorList = [
    Color(0xffcc2728),
    Color(0xffd65253),
    Color(0xffe07d7e),
    Color(0xffeba9a9),
    Color(0xffb21358),
    Color(0xffc14279),
    Color(0xffd1719b),
    Color(0xffe0a1bc),
    Color(0xff6e1a9a),
    Color(0xff8b48ae),
    Color(0xffa876c2),
    Color(0xffc5a3d7),
    Color(0xff4826a1),
    Color(0xff6d51b4),
    Color(0xff917dc7),
    Color(0xffb6a8d9),
    Color(0xff283395),
    Color(0xff535caa),
    Color(0xff7e85bf),
    Color(0xffa9add5),
    Color(0xff0764c0),
    Color(0xff3983cd),
    Color(0xff6aa2d9),
    Color(0xff9cc1e6),
    Color(0xff0072bd),
    Color(0xff338eca),
    Color(0xff66aad7),
    Color(0xff99c7e5),
    Color(0xff008390),
    Color(0xff339ca6),
    Color(0xff66b5bc),
    Color(0xff99cdd3),
    Color(0xff00685e),
    Color(0xff33867e),
    Color(0xff66a49e),
    Color(0xff99c3bf),
    Color(0xff287c35),
    Color(0xff53965d),
    Color(0xff7eb086),
    Color(0xffa9cbae),
    Color(0xff548b34),
    Color(0xff76a25d),
    Color(0xff98b985),
    Color(0xffbbd1ae),
    Color(0xff9e9c29),
    Color(0xffb1b054),
    Color(0xffc5c47f),
    Color(0xffd8d7a9),
    Color(0xffa59c2d),
    Color(0xffb7b057),
    Color(0xffc9c481),
    Color(0xffdbd7ab),
    Color(0xfffca729),
    Color(0xfffdb954),
    Color(0xfffdca7f),
    Color(0xfffedca9),
    Color(0xffff8f0b),
    Color(0xffffa53c),
    Color(0xffffbc6d),
    Color(0xffffd29d),
    Color(0xfff66b07),
    Color(0xfff88939),
    Color(0xfffaa66a),
    Color(0xfffbc49c),
    Color(0xffd2430d),
    Color(0xffdb693d),
    Color(0xffe48e6e),
    Color(0xffedb49e),
    Color(0xff5f3e38),
    Color(0xff7f6560),
    Color(0xff9f8b88),
    Color(0xffbfb2af),
    Color(0xff434243),
    Color(0xff696869),
    Color(0xff8e8e8e),
    Color(0xffb4b3b4),
    Color(0xff455966),
    Color(0xff6a7a85),
    Color(0xff8f9ba3),
    Color(0xffb5bdc2),
  ];
}
