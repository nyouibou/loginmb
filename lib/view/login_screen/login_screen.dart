// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginmb/view/home_screen/home_screen.dart';
import 'package:loginmb/view/reg_screen/reg_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  TextEditingController c1 = TextEditingController();
  TextEditingController c2 = TextEditingController();
  String username = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 40),
                ),
                Text(
                  "login to your existent account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: c1,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    if (RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(c1.text)) {
                      return null;
                    } else {
                      return "enter a valid email";
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: c2,
                  obscureText: true,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    if (value != null && value.length >= 6) {
                      return null;
                    } else {
                      return "enter a valid password";
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                //
                ElevatedButton(
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        try {
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: c1.text, password: c2.text);
                          log(credential.user?.uid.toString() ?? "no data");
                          if (credential.user?.uid != null) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Failed to create Account , try again')));
                          }
                        } on FirebaseAuthException catch (e) {
                          log(e.code.toString());
                          if (e.code == 'user-not-found') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('No user found for that email.')));
                            log('No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Wrong password provided for that user.')));
                            log('Wrong password provided for that user.');
                          }
                        }
                      }
                    },
                    child: Text("Login")),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      // navigate to registor screen
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ));
                    },
                    child: Text("register now"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
