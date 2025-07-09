import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

class LoginPage extends StatefulWidget {
  final String pin, fingerprint;
  final Function() onAuthenticated;

  LoginPage(
      {required this.onAuthenticated,
      required this.pin,
      required this.fingerprint});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final bool useFingerprint;
  late bool showPinLogin;
  final LocalAuthentication localAuth = LocalAuthentication();
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  @override
  void initState() {
    super.initState();
    useFingerprint = widget.fingerprint == 'true';
    if (useFingerprint) {
      showPinLogin = false;
      _authenticate();
    } else {
      showPinLogin = widget.pin == '' ? false : true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _verificationNotifier.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: showPinLogin
            ? pinScreen()
            : SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('images/icon.png', width: 80),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            'Authentication Required',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(height: 30),
                          !useFingerprint
                              ? SizedBox()
                              : authButton(
                                  label: 'Unlock With Biometrics',
                                  icon: Icons.fingerprint_outlined,
                                  onTap: () async {
                                    await _authenticate();
                                  },
                                ),
                          widget.pin == ''
                              ? SizedBox()
                              : authButton(
                                  label: 'Unlock With Pin Code',
                                  icon: Icons.pin_outlined,
                                  onTap: () {
                                    setState(() {
                                      showPinLogin = true;
                                    });
                                  },
                                ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  PasscodeScreen pinScreen() {
    return PasscodeScreen(
      title: Text('Enter Pin'),
      passwordEnteredCallback: (String val) {
        if (val == widget.pin) {
          _verificationNotifier.add(true);
        } else {
          _verificationNotifier.add(false);
        }
      },
      cancelButton: Text('Cancel'),
      deleteButton: Text('Delete'),
      passwordDigits: 4,
      cancelCallback: () {
        setState(() {
          showPinLogin = false;
        });
      },
      isValidCallback: widget.onAuthenticated,
      shouldTriggerVerification: _verificationNotifier.stream,
    );
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await localAuth.authenticate(
        localizedReason: 'Use Your Fingerprint',

        ///ff_log below lines commented, removed from updated package and replaced by authMessages param
        // androidAuthStrings: AndroidAuthMessages(
        //   biometricHint: '',
        //   signInTitle: 'Authentication Required',
        // ),

        authMessages: <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Oops! Biometric authentication required!',
            cancelButton: 'No thanks',
          ),
          IOSAuthMessages(
            cancelButton: 'No thanks',
          ),
        ],

        ///ff_log below lines commented, removed from updated package and replaced by options param
        // biometricOnly: true,
        // useErrorDialogs: true,
        // stickyAuth: true,

        options: const AuthenticationOptions(
            biometricOnly: true, useErrorDialogs: true, stickyAuth: true),
      );
    } on PlatformException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('Biometrics Not Set', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey[400],
      ));
    }
    if (authenticated) {
      widget.onAuthenticated();
    }
  }

  Widget authButton({
    required String label,
    required IconData icon,
    required Function() onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.teal)),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        onPressed: onTap,
      ),
    );
  }
}
