// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  TextEditingController messagesController = TextEditingController();
  List<Map<String, dynamic>> _studentMessages = [];
  List<Map<String, dynamic>> _studentRegistration = [];

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

      String studentUserId = _userData?['userId'] ?? '';
      String landlordUserId = userId;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(landlordUserId)
          .collection('messages')
          .doc(studentUserId)
          .set({
        'landlordMessage': messagesController.text,
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
      String landlordUserId = _userData?['userId'] ?? '';

      QuerySnapshot messageSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(landlordUserId)
          .collection('messages')
          .get();

      List<Map<String, dynamic>> messages = [];

      for (QueryDocumentSnapshot documentSnapshot in messageSnapshot.docs) {
        Map<String, dynamic> messageData =
            documentSnapshot.data() as Map<String, dynamic>;
        messages.add(messageData);
      }

      setState(() {
        _studentMessages = messages;
      });
    } catch (e) {
      print('Error loading student messages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      width: 300,
                      color: Color.fromARGB(255, 230, 230, 230),
                      child: Text(messagesController.text,
                          style: TextStyle(color: Colors.black)))
                ],
              ),
              // SizedBox(height: 20),
              // for (int index = 0; index < _studentMessages.length; index++)
              //   Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Container(
              //           width: 300,
              //           color: Color.fromARGB(255, 33, 147, 240),
              //           child: Text(
              //             _studentMessages[index]['studentMessages'] ??
              //                 'no message',
              //             style: TextStyle(color: Colors.white),
              //           ))
              //     ],
              //   ),
              SizedBox(height: 20),
            ],
          ),
          Column(
            children: [
              for (int index = 0; index < _studentMessages.length; index++)
                Container(
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
                              String messages = messagesController.text;

                              messages.isNotEmpty
                                  ? sendMessage(
                                      _studentMessages[index]['userId'] ?? '')
                                  : Container();
                              setState(() {
                                messagesController.clear();
                              });
                            },
                            icon: Icon(
                              Icons.send,
                              color: Colors.blue,
                            )),
                        prefixIcon: Icon(
                          Icons.add,
                          color: Colors.blue,
                        ),
                        hintText: 'Sent a message'),
                  ),
                ),
            ],
          ),
        ],
      ),
    ));
  }
}
