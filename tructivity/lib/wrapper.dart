import 'package:tructivity/local%20auth/local-auth-service.dart';
import 'package:tructivity/pages/login-page.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class Wrapper extends StatefulWidget {
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isLoading = true;
  bool showHome = false;
  late String _pin, _fingerprint;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    _pin = await authService.read('pin');
    _fingerprint = await authService.read('fingerprint');
    if (_pin == '' && _fingerprint == '') {
      showHome = true;
    } else {
      showHome = false;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingWidget()
        : (showHome
            ? Home()
            : LoginPage(
                pin: _pin,
                fingerprint: _fingerprint,
                onAuthenticated: () {
                  setState(() {
                    showHome = true;
                  });
                },
              ));
  }
}

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
