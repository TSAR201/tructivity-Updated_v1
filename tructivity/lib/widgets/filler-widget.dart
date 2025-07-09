import 'package:flutter/material.dart';

class FillerWidget extends StatelessWidget {
  final IconData icon;
  FillerWidget({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(child: Opacity(opacity: 0.2, child: Icon(icon, size: 80)));
  }
}
