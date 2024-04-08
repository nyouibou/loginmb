// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginmb/view/login_screen/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? pickedImage;

  CollectionReference collecitonReference =
      FirebaseFirestore.instance.collection("users");
  var url;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                      (route) => false);
                },
                icon: Icon(Icons.logout))
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.add_moderator_outlined),
              ),
              Tab(
                icon: Icon(Icons.people),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Expanded(
                  child: StreamBuilder(
                stream: collecitonReference.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("error");
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          //
                          final DocumentSnapshot userSnap =
                              snapshot.data!.docs[index];
                          return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  userSnap["image"],
                                ),
                                radius: 40,
                              ),
                              title: Text(userSnap["username"]),
                              subtitle: Text(userSnap["ph"]),
                              trailing: Text(userSnap["role"]));
                        });
                  }
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
