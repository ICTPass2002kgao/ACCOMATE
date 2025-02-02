import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentMessagesIssues extends StatefulWidget {
  final Map<String, dynamic> studentsHelpMesseges;
  const StudentMessagesIssues({super.key, required this.studentsHelpMesseges});

  @override
  State<StudentMessagesIssues> createState() => _StudentMessagesIssuesState();
}

class _StudentMessagesIssuesState extends State<StudentMessagesIssues> {
  TextEditingController messagesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _user = FirebaseAuth.instance.currentUser!;
  }

  late User _user;

  Future<void> _sendMessage(BuildContext context) async {
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

      String helpCenterUserId = _user.uid;
      String studentUserId = widget.studentsHelpMesseges['userId'];

      await FirebaseFirestore.instance
          .collection('Students')
          .doc(helpCenterUserId)
          .collection('messages')
          .doc(studentUserId)
          .collection('helpCenter')
          .add({
        'message': messagesController.text,
        'userId': helpCenterUserId,

        // Add more details as needed
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Row(
          children: [
            Text('Help Center'),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Container(
                    color: Colors.grey[400],
                    constraints: BoxConstraints(maxWidth: 250),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '${widget.studentsHelpMesseges['message'] ?? ''}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  messagesController.text,
                  style: TextStyle(
                      color: Colors.black, backgroundColor: Colors.grey),
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
                    border: OutlineInputBorder(),
                    focusColor: Colors.blue,
                    fillColor: Color.fromARGB(255, 230, 230, 230),
                    filled: true,
                    suffixIcon: IconButton(
                        onPressed: () {
                          messagesController.text.isNotEmpty
                              ? _sendMessage(context)
                              : ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Can't sent an empty message")));
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.blue,
                        )),
                    hintText: 'Sent a message'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
