
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:test_weather/ui/login_page.dart';

class SplashPage extends StatefulWidget{
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => InitState();
}

const timeout = Duration(seconds: 4);

class InitState extends State<SplashPage> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    // TODO: implement initState
    // initializeFlutterFire();
    startTimeout();
    super.initState();
  }

  startTimeout() {
    return Timer(timeout, initializeFlutterFire);
  }

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if(_error) {
      return const Center(
        // 'Could not load App'
        child: Text('Невозможно загрузить приложение'),
      );
    }

    return _initialized == false
      ? const Center(
        child: CircularProgressIndicator(
        backgroundColor: Colors.lightBlue,
      ),
    ) : const LoginPage();
  }
}