import 'package:flutter/material.dart';

class DrawerItemModel {
  final IconData iconData;
  final String text;
  final int index;
  DrawerItemModel(
      {required this.iconData, required this.index, required this.text});
}
