import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String text;
  final Color color;
  final onTileSelected;
  CategoryTile(
      {required this.text, required this.color, required this.onTileSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Theme.of(context).cardColor)),
        child: Center(child: Text(text)),
      ),
      onTap: () => onTileSelected(text),
    );
  }
}
