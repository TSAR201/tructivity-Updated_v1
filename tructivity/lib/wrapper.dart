import 'package:firebase_auth/firebase_auth.dart';
import 'package:tructivity/local%20auth/local-auth-service.dart';
import 'package:tructivity/pages/login-page.dart';
import 'package:tructivity/pages/email-login-page.dart';
import 'package:tructivity/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class Wrapper extends StatefulWidget {
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isLoading = true;
  bool showHome = false;
  bool useFirebaseAuth = true; // Set to true to use Firebase Auth, false to use local auth
  late String _pin, _fingerprint, _email;
  
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    // Check if user is already authenticated with Firebase
    User? currentUser = firebaseAuthService.currentUser;
    
    if (useFirebaseAuth && currentUser != null) {
      // User is already signed in with Firebase
      setState(() {
        showHome = true;
        isLoading = false;
      });
      return;
    }
    
    // Check local auth settings
    _pin = await authService.read('pin');
    _fingerprint = await authService.read('fingerprint');
    _email = await authService.read('email');
    
    if (useFirebaseAuth) {
      // Using Firebase Auth, but user is not signed in
      setState(() {
        showHome = false;
        isLoading = false;
      });
    } else {
      // Using local auth
      if (_pin == '' && _fingerprint == '') {
        setState(() {
          showHome = true;
          isLoading = false;
        });
      } else {
        setState(() {
          showHome = false;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingWidget();
    }
    
    if (showHome) {
      return Home();
    }
    
    // Choose authentication method
    if (useFirebaseAuth) {
      return EmailLoginPage(
        onAuthenticated: () {
          setState(() {
            showHome = true;
          });
        },
      );
    } else {
      return LoginPage(
        pin: _pin,
        fingerprint: _fingerprint,
        onAuthenticated: () {
          setState(() {
            showHome = true;
          });
        },
      );
    }
  }
}

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/icon.png', width: 80, height: 80),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
}
