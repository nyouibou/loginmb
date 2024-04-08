// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loginmb/view/login_screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 2), () async {
      {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Loading..."),
            SizedBox(
              height: 15,
            ),
            CircularProgressIndicator(
              backgroundColor: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}
