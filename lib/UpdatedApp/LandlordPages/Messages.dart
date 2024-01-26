// ignore_for_file: prefer_const_constructors

import 'package:api_com/UpdatedApp/LandlordPages/InboxPage.dart';
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
    _loadRegisteredStudent();
    // _loadChatMessages();
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
    await _loadRegisteredStudent();
    // After loading landlord data, load student applications
  }

  List<Map<String, dynamic>> _registeredStudents = [];

  Future<void> _loadRegisteredStudent() async {
    try {
      // Assuming there is a specific landlord ID (replace 'your_landlord_id' with the actual ID)
      String landlordUserId = _userData?['userId'] ?? '';

      QuerySnapshot registrationSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(landlordUserId)
          .collection('registeredStudents')
          .get();

      List<Map<String, dynamic>> registeredStudents = [];

      for (QueryDocumentSnapshot documentSnapshot
          in registrationSnapshot.docs) {
        Map<String, dynamic> messageData =
            documentSnapshot.data() as Map<String, dynamic>;
        registeredStudents.add(messageData);
      }

      setState(() {
        _registeredStudents = registeredStudents;
      });
    } catch (e) {
      print('Error loading student applications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _registeredStudents.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              '${_registeredStudents[index]['name']} ${_registeredStudents[index]['surname']}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Flexible(
                child: Text(_registeredStudents[index]['message'] ??
                    'You have a new message.')),
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(27.5),
                child: Image.asset(
                  'assets/icon.jpg',
                  width: 55,
                  height: 55,
                  fit: BoxFit.cover,
                )),
            onTap: () {
              // Navigate to the messages page for the selected student
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InboxPage(
                    studentDetails: _registeredStudents[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
