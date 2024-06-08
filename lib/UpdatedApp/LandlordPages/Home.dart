// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User _user;
  bool isLoading = true;
  List<Map<String, dynamic>> _studentApplications = [];

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
    loadData();
  }

  Map<String, dynamic>? _userData;
  Future<void> _loadUserData() async {
    try {
      _user = FirebaseAuth.instance.currentUser!;
      if (_user.uid.isNotEmpty) {
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
      } else {
        print('User UID is empty');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadStudentApplications() async {
    try {
      String landlordId = _userData?['userId'] ?? '';
      QuerySnapshot applicationsSnapshot = await FirebaseFirestore.instance
          .collection('Landlords')
          .doc(landlordId)
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

  Future<void> loadData() async {
    // Simulate loading data
    await Future.delayed(Duration(seconds: 3));

    // Set isLoading to false when data is loaded
    setState(() {
      isLoading = false;
    });
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
            child: isLoading
                ? Center(
                    child: Container(
                        width: 100,
                        height: 100,
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(child: Text("Loading...")),
                            Center(
                                child: LinearProgressIndicator(
                                    color: Colors.blue)),
                          ],
                        ))))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Applied Students',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Table(
                            border: TableBorder.all(),
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Center(
                                      child: Text(
                                        'Name',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Center(
                                      child: Text(
                                        'Surname',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Center(
                                      child: Text(
                                        'Gender',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Center(
                                      child: Text(
                                        'Cell No',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Center(
                                      child: Text(
                                        'Application Date & time',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Table rows for student applications
                              for (int index = 0;
                                  index < _studentApplications.length;
                                  index++)
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Center(
                                        child: Text(
                                          _studentApplications[index]['name'] ??
                                              'null',
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Text(
                                          _studentApplications[index]
                                                  ['surname'] ??
                                              'null',
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Text(
                                          _studentApplications[index]
                                                  ['gender'] ??
                                              'null',
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Text(
                                          _studentApplications[index]
                                                  ['contactDetails'] ??
                                              'null',
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Text(
                                            DateFormat('yyyy-MM-dd HH:mm')
                                                .format(
                                                    _studentApplications[index]
                                                            ['appliedDate']
                                                        .toDate())),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
