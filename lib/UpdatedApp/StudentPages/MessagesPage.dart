// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  TextEditingController messagesController = TextEditingController();
  List<Map<String, dynamic>> _landlordMessages = [];

  bool isLoading = true;
  Future<void> loadData() async {
    // Simulate loading data
    await Future.delayed(Duration(seconds: 4));

    // Set isLoading to false when data is loaded
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
    loadData();
    _loadMessages();
  }

  late User _user;
  Map<String, dynamic>? _userData; // Make _userData nullable

  Future<void> _loadUserData() async {
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .get();
    setState(() {
      _userData = userDataSnapshot.data() as Map<String, dynamic>?;
      isLoading = false;
    });
    // After loading landlord data, load student applications
  }

  Future<void> sendMessage(String userId) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent user from dismissing the dialog
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      String landlordUserId = userId;
      String studentUserId = _userData?['userId'] ?? '';

      await FirebaseFirestore.instance
          .collection('users')
          .doc(landlordUserId)
          .collection('messages')
          .doc(studentUserId)
          .set({
        'studentMessage': messagesController.text,
        'userId': _userData?['userId'] ?? '',

        // Add more details as needed
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _loadMessages() async {
    try {
      // Assuming there is a specific landlord ID (replace 'your_landlord_id' with the actual ID)
      String studentUserId = _userData?['userId'] ?? '';

      QuerySnapshot messageSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(studentUserId)
          .collection('messages')
          .get();

      List<Map<String, dynamic>> messages = [];

      for (QueryDocumentSnapshot documentSnapshot in messageSnapshot.docs) {
        Map<String, dynamic> messageData =
            documentSnapshot.data() as Map<String, dynamic>;
        messages.add(messageData);
      }

      setState(() {
        _landlordMessages = messages;
      });
    } catch (e) {
      print('Error loading student messages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Landlord Text',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                color: Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'My Text',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ]),
            Container(
              alignment: Alignment.bottomCenter,
              height: 50,
              color: Color.fromARGB(255, 230, 230, 230),
              child: TextField(
                controller: messagesController,
                decoration: InputDecoration(
                    focusColor: Colors.blue,
                    fillColor: Color.fromARGB(255, 230, 230, 230),
                    filled: true,
                    suffixIcon: IconButton(
                        onPressed: () {
                          // String messages = messagesController.text;

                          // messages.isNotEmpty
                          //     ? sendMessage(
                          //         _landlordMessages[index]['userId'] ?? '')
                          //     : '';
                          // setState(() {
                          //   messagesController.clear();
                          // });
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.blue,
                        )),
                    prefixIcon: IconButton(
                      onPressed: () {
                        // String messages = messagesController.text;

                        // messages.isNotEmpty
                        //     ? sendMessage(
                        //         _landlordMessages[index]['userId'] ?? '')
                        //     : '';
                        // setState(() {
                        //   messagesController.clear();
                        // });
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.blue,
                      ),
                    ),
                    hintText: 'Sent a message'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
