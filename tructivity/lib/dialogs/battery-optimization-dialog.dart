import 'package:tructivity/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BatteryOptimizationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Disable battery optimization for this app to receive notifications on time.',
          ),
        ],
      ),
      actions: [
        CustomButton(
          buttonColor: Colors.teal,
          textColor: Colors.white,
          label: 'Learn More',
          onTapButton: () async {
            final url =
                'https://www.youtube.com/watch?v=PjihvI8G46Q&ab_channel=Tructivity';
            if (await canLaunch(url)) {
              await launch(url);
            }
          },
        ),
      ],
    );
  }
}
