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

  List<Map<String, dynamic>> _studentRegistration = [];
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2,
        vsync: this); // Adjust the length based on the number of tabs

    _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
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
    await _loadStudentApplications();
    await _loadStudentRegistration();
  }

  Future<void> _loadStudentApplications() async {
    try {
      // Assuming there is a specific landlord ID (replace 'your_landlord_id' with the actual ID)
      String landlordUserId = _userData?['userId'] ?? '';

      QuerySnapshot applicationsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(landlordUserId)
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

  Future<void> _loadStudentRegistration() async {
    try {
      // Assuming there is a specific landlord ID (replace 'your_landlord_id' with the actual ID)
      String landlordUserId = _userData?['userId'] ?? '';

      QuerySnapshot registrationSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(landlordUserId)
          .collection('registration')
          .get();

      List<Map<String, dynamic>> studentRegistration = [];

      for (QueryDocumentSnapshot documentSnapshot
          in registrationSnapshot.docs) {
        Map<String, dynamic> registrationData =
            documentSnapshot.data() as Map<String, dynamic>;
        studentRegistration.add(registrationData);
      }

      setState(() {
        _studentRegistration = studentRegistration;
      });
    } catch (e) {
      print('Error loading student applications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            labelColor: Colors.blue,
            indicatorColor: Colors.blue,
            controller: _tabController,
            tabs: [
              Tab(text: 'Available Applications'),
              Tab(text: 'Available Registrations'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Available Applications',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 5,
                      ),
                      Table(
                        border: TableBorder.all(),
                        children: [
                          // Table header
                          TableRow(
                            children: [
                              TableCell(
                                child: Center(
                                    child: Text('Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                              ),
                              TableCell(
                                child: Center(
                                    child: Text('Surname',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                              ),
                              TableCell(
                                child: Center(
                                    child: Text('Gender',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                              ),
                              TableCell(
                                child: Center(
                                    child: Text('Cell No',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                              ),
                              TableCell(
                                child: Center(
                                    child: Text('Email Address',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
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
                                      child: Text(studentApplication['name'] ??
                                          'Kgaogelo')),
                                ),
                                TableCell(
                                  child: Center(
                                      child: Text(
                                          studentApplication['surname'] ??
                                              'Mthimkhulu')),
                                ),
                                TableCell(
                                  child: Center(
                                      child: Text(
                                          studentApplication['gender'] ??
                                              'male')),
                                ),
                                TableCell(
                                  child: Center(
                                      child: Text(studentApplication[
                                              'contactDetails'] ??
                                          'null')),
                                ),
                                TableCell(
                                  child: Center(
                                      child: Text(studentApplication['email'] ??
                                          'null')),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Available Registration',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 5,
                        ),
                        Table(
                          border: TableBorder.all(),
                          children: [
                            // Table header
                            TableRow(
                              children: [
                                TableCell(
                                  child: Center(
                                      child: Text('Name',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                ),
                                TableCell(
                                  child: Center(
                                      child: Text('Surname',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                ),
                                TableCell(
                                  child: Center(
                                      child: Text('Gender',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                ),
                                TableCell(
                                  child: Center(
                                      child: Text('Cell No',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                ),
                                TableCell(
                                  child: Center(
                                      child: Text('Email Address',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                ),
                              ],
                            ),
                            // Table rows for student applications
                            for (Map<String, dynamic> studentApplication
                                in _studentRegistration)
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Center(
                                        child: Text(
                                            studentApplication['name'] ??
                                                'Kgaogelo')),
                                  ),
                                  TableCell(
                                    child: Center(
                                        child: Text(
                                            studentApplication['surname'] ??
                                                'Mthimkhulu')),
                                  ),
                                  TableCell(
                                    child: Center(
                                        child: Text(
                                            studentApplication['gender'] ??
                                                'male')),
                                  ),
                                  TableCell(
                                    child: Center(
                                        child: Text(studentApplication[
                                                'contactDetails'] ??
                                            'null')),
                                  ),
                                  TableCell(
                                    child: Center(
                                        child: Text(
                                            studentApplication['email'] ??
                                                'null')),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ]),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
