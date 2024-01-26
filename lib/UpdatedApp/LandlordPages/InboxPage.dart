import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InboxPage extends StatefulWidget {
  final Map<String, dynamic> studentDetails;

  const InboxPage({Key? key, required this.studentDetails}) : super(key: key);

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  TextEditingController messagesController = TextEditingController();
  List<Map<String, dynamic>> chatMessages = [];

  @override
  void initState() {
    super.initState();
    _loadChatMessages();
  }

  Future<void> _loadChatMessages() async {
    try {
      // Fetch chat messages from Firestore
      QuerySnapshot messagesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.studentDetails['userId'])
          .collection('messages')
          .doc(FirebaseAuth.instance.currentUser!.uid)
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
      String studentUserId = widget.studentDetails['userId'];

      await FirebaseFirestore.instance
          .collection('users')
          .doc(studentUserId)
          .collection('messages')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('chat')
          .add({
        'message': messagesController.text,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the input field after sending a message
      messagesController.clear();

      // Refresh the chat messages
      _loadChatMessages();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/icon.jpg',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                )),
            SizedBox(
              width: 5,
            ),
            Text(widget.studentDetails['name'] ?? 'name'),
          ],
        ),
      ),
      body: Column(
        children: [
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
          Container(
            color: const Color.fromARGB(255, 238, 238, 238),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messagesController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _sendMessage();
                    },
                    icon: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
