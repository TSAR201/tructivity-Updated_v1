import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
  final double? padding;
  final onPressed;
  CustomFAB({required this.onPressed, this.padding});
  @override
  Widget build(BuildContext context) {
    double pad = padding != null ? padding! : 15;
    return Padding(
      padding: EdgeInsets.all(pad),
      child: FloatingActionButton(
        onPressed: onPressed,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
