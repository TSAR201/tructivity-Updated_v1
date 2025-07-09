import 'package:tructivity/local%20auth/local-auth-service.dart';
import 'package:flutter/material.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'dart:async';

class PinSettingPage extends StatelessWidget {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _verificationNotifier.close();
        return Future.value(true);
      },
      child: Scaffold(
        body: PasscodeScreen(
          title: Text('Enter Pin'),
          passwordEnteredCallback: (String val) async {
            await authService.write('pin', val);
            _verificationNotifier.add(true);
          },
          cancelButton: Text('Cancel'),
          deleteButton: Text('Delete'),
          passwordDigits: 4,
          shouldTriggerVerification: _verificationNotifier.stream,
          cancelCallback: () {
            _verificationNotifier.close();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
