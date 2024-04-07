// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController c1 = TextEditingController();

  String? savedData = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout))],
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 100,
              ),
              ElevatedButton(
                  onPressed: () async {
                    // shared prefs
                    //  to save data to shared preferences
                    setState(() {});
                  },
                  child: Text("save")),
              SizedBox(height: 100),
              //
              // Text(c1.text),
              Text(savedData.toString()),
              SizedBox(height: 50),
              ElevatedButton(
                  onPressed: () async {
                    //  again created object for shared prefs bcoz it is in function above
                    // to get data
                    // preferences.get("text");
                    setState(() {});
                  },
                  child: Text("get"))
            ],
          ),
        ),
      ),
    );
  }
}
