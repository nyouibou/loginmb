import 'package:flutter/material.dart';
import 'package:loginmb/view/login_screen/login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _logout() async {
    // Navigate back to SplashScreen and replace the current route
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              _logout();
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => RegisterScreen(),
              //     ));
            },
            child: Text("Log Out")),
      ),
    );
  }
}
