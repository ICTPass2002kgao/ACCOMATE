// ignore_for_file: prefer_const_constructors

import 'package:api_com/UpdatedApp/StudentPages/Inbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  TextEditingController messagesController = TextEditingController();
  List<Map<String, dynamic>> _landlordAccepted = [];

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
    await _loadStudentRegistration();
  }

  Future<void> _loadStudentRegistration() async {
    try {
      // Assuming there is a specific landlord ID (replace 'your_landlord_id' with the actual ID)
      String landlordUserId = _userData?['userId'] ?? '';

      QuerySnapshot registrationSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(landlordUserId)
          .collection('registrationResponse')
          .get();

      List<Map<String, dynamic>> acceptedLandlord = [];

      for (QueryDocumentSnapshot documentSnapshot
          in registrationSnapshot.docs) {
        Map<String, dynamic> messageData =
            documentSnapshot.data() as Map<String, dynamic>;
        acceptedLandlord.add(messageData);
      }

      setState(() {
        _landlordAccepted = acceptedLandlord;
      });
    } catch (e) {
      print('Error loading student applications: $e');
    }
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
        'message': messagesController.text,
        'userId': _userData?['userId'] ?? '',

        // Add more details as needed
      });
    } catch (e) {
      print(e);
    }
  }

  // Future<void> _loadMessages() async {
  //   try {
  //     // Assuming there is a specific landlord ID (replace 'your_landlord_id' with the actual ID)
  //     String studentUserId = _userData?['userId'] ?? '';

  //     QuerySnapshot messageSnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(studentUserId)
  //         .collection('messages')
  //         .get();

  //     List<Map<String, dynamic>> messages = [];

  //     for (QueryDocumentSnapshot documentSnapshot in messageSnapshot.docs) {
  //       Map<String, dynamic> messageData =
  //           documentSnapshot.data() as Map<String, dynamic>;
  //       messages.add(messageData);
  //     }

  //     setState(() {
  //       _landlordMessages = messages;
  //     });
  //   } catch (e) {
  //     print('Error loading student messages: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Accomate Chat',
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(
                  height: 5,
                ),
                for (int Index = 0; Index < _landlordAccepted.length; Index++)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          6), // Adjust the radius as needed
                      color: Colors
                          .grey[200], // Optional: Set the background color
                    ),
                    child: ListTile(
                      title: Row(
                        children: [
                          Flexible(
                            child: Text(
                              _landlordAccepted[Index]['accomodationName'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Icon(
                            Icons.verified,
                            color: Colors.blue[900],
                            size: 13,
                          )
                        ],
                      ),
                      subtitle: Text(
                          '${_landlordAccepted[Index]['message']}Hi Welcome To ${_landlordAccepted[Index]['accomodationName']} ${_landlordAccepted[Index]['message']}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      trailing: Icon(Icons.keyboard_arrow_right_sharp),
                      leading: ClipRRect(
                          borderRadius: BorderRadius.circular(27.5),
                          child: Image.network(
                            _landlordAccepted[Index]['profile'],
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                          )),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InboxMessages(
                                    landlordDetails: _landlordAccepted[Index],
                                  )),
                        );
                      },
                    ),
                  )
              ],
            ),
          )),
    );
  }
}
