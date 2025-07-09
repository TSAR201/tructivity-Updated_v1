import 'dart:io';
import 'package:tructivity/local%20auth/local-auth-service.dart';
import 'package:tructivity/pages/pin-setting-page.dart';
import 'package:tructivity/pages/setting-page.dart';
import 'package:tructivity/dialogs/confirmation-dialog.dart';
import 'package:tructivity/widgets/error-dialog.dart';
import 'package:tructivity/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class SecurityPage extends StatefulWidget {
  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  String pinButtonText = '';
  final LocalAuthentication localAuth = LocalAuthentication();
  late bool pinSet, fingerprintSet;
  String fingerprintButtonText = '';
  late bool fingerprintAvailable;

  Future<void> checkBiometrics() async {
    if (Platform.isAndroid) {
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;
      List<BiometricType> biometrics = await localAuth.getAvailableBiometrics();
      ///ff_log channel UPDATED BELOW CONDITIONS TO SHOW BIOMATRIC OPTION
      // if (canCheckBiometrics && biometrics.contains(BiometricType.fingerprint)) {
      if (canCheckBiometrics && biometrics.isNotEmpty) {
        fingerprintAvailable = true;
      } else {
        fingerprintAvailable = false;
      }
    } else {
      fingerprintAvailable = false;
    }

  }

  Future<Map<String, String>> getData() async {
    await checkBiometrics();
    String _pin = await authService.read('pin');
    String _fingerprint = await authService.read('fingerprint');
    return {'pin': _pin, 'fingerprint': _fingerprint};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          'Security',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, String>> snapshot) {
          if (!snapshot.hasData) {
            return LoadingWidget();
          } else {
            initializeVariables(snapshot);
            return Column(
              children: [
                SettingTile(
                  ontap: onTapPinButton,
                  icon: Icons.pin_outlined,
                  text: pinButtonText,
                  iconColor: pinSet ? Colors.teal : null,
                ),
                !fingerprintAvailable
                    ? SizedBox()
                    : SettingTile(
                        ontap: onTapFingerprintButton,
                        icon: Icons.fingerprint_outlined,
                        text: fingerprintButtonText,
                        iconColor: fingerprintSet ? Colors.teal : null,
                      ),
              ],
            );
          }
        },
      ),
    );
  }

  void onTapFingerprintButton() async {
    if (fingerprintAvailable) {
      showDialog(
          context: context,
          builder: (_) => ConfirmationDialog(
                text: fingerprintSet
                    ? 'Remove Fingerprint Lock?'
                    : 'Set Fingerprint Lock?',
              )).then((confirmed) async {
        if (confirmed != null) {
          if (confirmed) {
            if (fingerprintSet) {
              await authService.write('fingerprint', '');
              setState(() {});
            } else {
              await authService.write('fingerprint', 'true');
              setState(() {});
            }
          }
        }
      });
    } else {
      showDialog(
          context: context,
          builder: (_) =>
              ErrorDialog(error: 'Please Set Up a Fingerprint First'));
    }
  }

  void onTapPinButton() async {
    if (!pinSet) {
      Navigator.push(
              context, MaterialPageRoute(builder: (_) => PinSettingPage()))
          .whenComplete(() {
        setState(() {});
      });
    } else {
      showDialog(
          context: context,
          builder: (_) => ConfirmationDialog(
                text: 'Remove Pin Lock?',
              )).then((confirmed) async {
        if (confirmed != null) {
          if (confirmed) {
            await authService.clearStorage();
            setState(() {});
          }
        }
      });
    }
  }

  void initializeVariables(AsyncSnapshot<Map<String, String>> snapshot) {
    if (snapshot.data!['pin'] == '') {
      pinSet = false;
      pinButtonText = 'Set Pin Lock';
    } else {
      pinSet = true;
      pinButtonText = 'Remove Pin Lock';
    }
    if (snapshot.data!['fingerprint'] == '') {
      fingerprintSet = false;
      fingerprintButtonText = 'Set Fingerprint Lock';
    } else {
      fingerprintSet = true;
      fingerprintButtonText = 'Remove Fingerprint Lock';
    }
  }
}
