// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:api_com/UpdatedApp/LandlordPages/viewApplicantDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  List<Map<String, dynamic>> _studentApplications = [];
  bool isTileClicked = false;
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
    loadData();
  }

  Future<void> loadData() async {
    // Simulate loading data
    await Future.delayed(Duration(seconds: 3));

    // Set isLoading to false when data is loaded
    setState(() {
      isLoading = false;
    });
  }

  late User _user;
  Map<String, dynamic>? _userData;
  Future<void> _loadUserData() async {
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('Landlords')
        .doc(_user.uid)
        .get();
    setState(() {
      _userData = userDataSnapshot.data() as Map<String, dynamic>?;
      isLoading = false;
    });
    await _loadStudentApplications();
  }

  Future<void> _loadStudentApplications() async {
    try {
      String landlordUserId = _userData?['userId'] ?? '';

      QuerySnapshot applicationsSnapshot = await FirebaseFirestore.instance
          .collection('Landlords')
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

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Future<void> _handleRefresh() async {
    await _loadStudentApplications();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _handleRefresh,
        header: WaterDropMaterialHeader(
          backgroundColor: Colors.blue,
        ),
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
                            child: LinearProgressIndicator(color: Colors.blue)),
                      ],
                    ))))
            : Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notifications',
                        style:
                            TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      for (int index = 0;
                          index < _studentApplications.length;
                          index++)
                        if (_studentApplications[index]['applicationReviewed'] ==
                            false)
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.blue)),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewApplicantDetails(
                                      studentApplicationData:
                                          _studentApplications[index],
                                    ),
                                  ),
                                );
                              },
                              title: Text(
                                '${_studentApplications[index]['name'] ?? ''} ${_studentApplications[index]['surname'] ?? ''}',
                                style: TextStyle(
                                  fontWeight: _studentApplications[index]
                                              ['applicationReviewed'] ==
                                          true
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'You have a new application from ${_studentApplications[index]['name'] ?? ''}',
                                style: TextStyle(
                                  fontWeight: _studentApplications[index]
                                              ['applicationReviewed'] ==
                                          true
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                ),
                              ),
                              trailing: Row(
                                children: [
                                  Text(DateFormat('yyyy-MM-dd HH:mm').format(
                                      _studentApplications[index]['appliedDate']
                                          .toDate())),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            ),
                          )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
