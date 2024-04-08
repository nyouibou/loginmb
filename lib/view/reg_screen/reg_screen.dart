// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginmb/view/login_screen/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController passwrd = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  final formkey = GlobalKey<FormState>();

  List<String> roles = ['', 'Admin', 'User'];
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("users");
  XFile? pickedImage;
  var url = "";
  String selectedRole = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formkey,
            child: Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 40),
                  ),
                  Text(
                    "Create new account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      pickedImage = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);

                      if (pickedImage != null) {
                        final uniquename = DateTime.timestamp()
                            .microsecondsSinceEpoch
                            .toString();
                        final storageRef = FirebaseStorage.instance.ref();
                        final imageRef = storageRef.child("users");
                        final uploadRef = imageRef.child("$uniquename");
                        await uploadRef.putFile(File(pickedImage!.path));
                        url = await uploadRef.getDownloadURL();
                        setState(() {});
                        if (url != null) {
                          log("upload successfully");
                        } else {
                          log("couldnt upload");
                        }
                      }
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: url != null ? NetworkImage(url) : null,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: username,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value!.length == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Email cannot be empty"),
                        ));

                        // return "Email cannot be empty";
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Please enter a valid email"),
                        ));
                        // return ("Please enter a valid email");
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: phone,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwrd,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    onChanged: (newValue) {
                      setState(() {
                        selectedRole = newValue!;
                      });
                    },
                    items: roles.map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          if (formkey.currentState!.validate()) {
                            final cred = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: email.text,
                              password: passwrd.text,
                            );
                            collectionReference.add({
                              "username": username.text,
                              "ph": phone.text,
                              "image": url,
                              "role": selectedRole
                            });
                            if (cred.user?.uid != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Failed to create Account, try again.."),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          print("Error: $e");
                        }
                      },
                      child: Text("Register")),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ));
                      },
                      child: Text("login now"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
