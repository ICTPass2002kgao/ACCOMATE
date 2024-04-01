// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  List<Map<String, dynamic>> _studentApplications = [];
  @override
  void initState() {
    super.initState();
    // _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
  }

  late User _user;
  Map<String, dynamic>? _userData; // Make _userData nullable

  Future<void> _loadUserData() async {
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('Landlords')
        .doc(_user.uid)
        .get();
    setState(() {
      _userData = userDataSnapshot.data() as Map<String, dynamic>?;
      isLoading = false;
    });
    // After loading landlord data, load student applications
    await _loadStudentApplications();
  }

  Future<void> _loadStudentApplications() async {
    try {
      String studentId = _userData?['userId'] ?? '';
      QuerySnapshot applicationsSnapshot = await FirebaseFirestore.instance
          .collection('Landlords')
          .doc(studentId)
          .collection('applications')
          .get();

      List<Map<String, dynamic>> studentApplications = [];

      for (QueryDocumentSnapshot documentSnapshot
          in applicationsSnapshot.docs) {
        Map<String, dynamic> applicationData =
            documentSnapshot.data() as Map<String, dynamic>;
        studentApplications.add(applicationData);
      }

      setState(() {
        _studentApplications = studentApplications;
      });
    } catch (e) {
      print('Error loading student applications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      color: Colors.blue[100],
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Applied Students',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
              Table(
                border: TableBorder.all(),
                children: [
                  // Table header
                  TableRow(
                    children: [
                      TableCell(
                        child: Center(
                            child: Text('Name',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      TableCell(
                        child: Center(
                            child: Text('Surname',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      TableCell(
                        child: Center(
                            child: Text('Gender',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      TableCell(
                        child: Center(
                            child: Text('Cell No',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      TableCell(
                        child: Center(
                            child: Text('Email Address',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                    ],
                  ),
                  // Table rows for student applications
                  for (Map<String, dynamic> studentApplication
                      in _studentApplications)
                    TableRow(
                      children: [
                        TableCell(
                          child: Center(
                              child:
                                  Text(studentApplication['name'] ?? 'null')),
                        ),
                        TableCell(
                          child: Center(
                              child: Text(
                                  studentApplication['surname'] ?? 'null')),
                        ),
                        TableCell(
                          child: Center(
                              child:
                                  Text(studentApplication['gender'] ?? 'null')),
                        ),
                        TableCell(
                          child: Center(
                              child: Text(
                                  studentApplication['contactDetails'] ??
                                      'null')),
                        ),
                        TableCell(
                          child: Center(
                              child:
                                  Text(studentApplication['email'] ?? 'null')),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
