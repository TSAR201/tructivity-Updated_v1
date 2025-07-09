import 'package:flutter/material.dart';

class NoteCategoryOption extends StatelessWidget {
  final onTap;
  final String text;
  NoteCategoryOption({required this.text, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Center(
          child: Text(text,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              )),
        ),
      ),
      onTap: onTap,
    );
  }
}
