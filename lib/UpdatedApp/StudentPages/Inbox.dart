import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class InboxMessages extends StatefulWidget {
  final Map<String, dynamic> landlordDetails;
  const InboxMessages({super.key, required this.landlordDetails});

  @override
  State<InboxMessages> createState() => _InboxMessagesState();
}

class _InboxMessagesState extends State<InboxMessages> {
  TextEditingController messagesController = TextEditingController();
  List<Map<String, dynamic>> chatMessages = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadChatMessages();
    _loadChatLandlordMessages();
  }

  Map<String, dynamic>? _userData; // Make _userData nullable

  late User _user;
  Future<void> _loadUserData() async {
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .get();
    setState(() {
      _userData = userDataSnapshot.data() as Map<String, dynamic>?;
    });
    await _loadChatLandlordMessages();
  }

  Future<void> _loadChatLandlordMessages() async {
    try {
      // Fetch chat messages from Firestore
      QuerySnapshot messagesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('messages')
          .doc(widget.landlordDetails['userId'])
          .collection('chat')
          .orderBy('timestamp', descending: true)
          .get();

      // Update the chatMessages list with the retrieved messages
      setState(() {
        chatMessages = messagesSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
      await _loadChatMessages();
    } catch (e) {
      print('Error loading chat messages: $e');
    }
  }

  Future<void> _loadChatMessages() async {
    try {
      String studentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
      String landlordUserId = widget.landlordDetails['userId'];

      // Fetch chat messages from Firestore
      QuerySnapshot messagesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(landlordUserId)
          .collection('messages')
          .doc(studentUserId)
          .collection('chat')
          .orderBy('timestamp', descending: true)
          .get();

      // Update the chatMessages list with the retrieved messages

      setState(() {
        chatMessages = messagesSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print('Error loading chat messages: $e');
    }
  }

  Future<void> _sendMessage() async {
    try {
      String studentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
      String landlordUserId = widget.landlordDetails['userId'];

      print('Sending message...');

      await FirebaseFirestore.instance
          .collection('users')
          .doc(landlordUserId)
          .collection('messages')
          .doc(studentUserId)
          .collection('chat')
          .add({
        'name': _userData?['name'] ?? '',
        'surname': _userData?['surname'] ?? '',
        'email': _userData?['email'] ?? '',
        'studentNumber': _userData?['studentNumber'] ?? '',
        'university': _userData?['university'] ?? '',
        'message': messagesController.text,
        'userId': studentUserId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Message sent successfully!');

      // Clear the input field after sending a message
      messagesController.clear();

      // Refresh the chat messages
      _loadChatMessages();

      _loadChatLandlordMessages();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... rest of your widget build method
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(widget.landlordDetails['profile'],
                    width: 40, height: 40, fit: BoxFit.cover)),
            SizedBox(width: 5),
            Flexible(child: Text(widget.landlordDetails['accomodationName'])),
          ],
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // ... other chat UI elements

          Expanded(
              child: ListView.builder(
            reverse: true,
            itemCount: chatMessages.length,
            itemBuilder: (context, index) {
              DateTime timestamp =
                  (chatMessages[index]['timestamp'] as Timestamp).toDate();
              String formattedTime = DateFormat.jm().format(timestamp);

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: chatMessages[index]['userId'] ==
                          FirebaseAuth.instance.currentUser?.uid
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: 250,
                      ),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: chatMessages[index]['userId'] ==
                                FirebaseAuth.instance.currentUser?.uid
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            chatMessages[index]['message'],
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 5),
                          Text(
                            formattedTime,
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          )),

          // ... input field and send button
          Container(
            height: 50,
            color: Color.fromARGB(255, 230, 230, 230),
            child: TextField(
              cursorColor: Colors.blue,
              controller: messagesController,
              decoration: InputDecoration(
                  hoverColor: Colors.blue,
                  border: OutlineInputBorder(),
                  focusColor: Colors.blue,
                  suffixIcon: IconButton(
                      onPressed: () {
                        messagesController.text.isNotEmpty
                            ? _sendMessage()
                            : ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text("Can't sent an empty message")));
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.blue,
                      )),
                  prefixIcon: IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.white,
                          duration: Duration(days: 36),
                          content: Column(
                            children: [
                              ListTile(
                                textColor: Colors.blue,
                                title: Text('Camera'),
                                leading: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.blue,
                                ),
                                onTap: () {},
                              ),
                              ListTile(
                                textColor: Colors.blue,
                                title: Text('Image & Video Library'),
                                leading: Icon(
                                  Icons.image,
                                  color: Colors.blue,
                                ),
                                onTap: () {},
                              ),
                              ListTile(
                                textColor: Colors.blue,
                                title: Text('Documents'),
                                leading: Icon(
                                  Icons.upload_file_outlined,
                                  color: Colors.blue,
                                ),
                                onTap: () async {
                                  // _pickDocuments(context);
                                },
                              ),
                            ],
                          )));
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
    );
  }
}
