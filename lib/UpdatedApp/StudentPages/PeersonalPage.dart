// ignore_for_file: prefer_const_constructors, unnecessary_brace_in_string_interps, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  late User _user;
  Map<String, dynamic>? _userData; // Make _userData nullable

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .get();
    setState(() {
      _userData = userDataSnapshot.data() as Map<String, dynamic>?;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the user image in a Card
          Container(
              color: const Color.fromARGB(179, 231, 231, 231),
              width: double.infinity,
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.0),
                    Text(
                        "Student's Name: ${_userData?['name'] ?? 'Loading...'}"),
                    SizedBox(height: 10),
                    Text(
                        "Student's Surname: ${_userData?['surname'] ?? 'Loading...'}"),
                    SizedBox(height: 10),
                    Text(
                        "Student's Enrolled Institution: ${_userData?['university']}"),
                    SizedBox(height: 10),
                    Text(
                        "Student's Email: ${_userData?['email'] ?? 'Loading...'}"),
                  ],
                ),
              )),

          // Other user information

          // You can add more UI elements to display additional user information
        ],
      ),
    );
  }
}
