import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class AllowNotificationsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Allow Notifications'),
      content: Text('Our app would like to send you notifications'),
      actions: [
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Don't Allow",
            style: TextStyle(color: Colors.teal),
          ),
        ),
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.teal)),
          onPressed: () {
            AwesomeNotifications()
                .requestPermissionToSendNotifications()
                .then((_) => Navigator.pop(context));
          },
          child: Text(
            'Allow',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
