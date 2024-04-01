// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:api_com/UpdatedApp/StudentPages/ViewApplicationResponses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _studentApplications = [];

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
        .collection('Students')
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
      // Assuming there is a specific landlord ID (replace 'your_landlord_id' with the actual ID)
      String studentUserId = _userData?['userId'] ?? '';

      QuerySnapshot applicationsSnapshot = await FirebaseFirestore.instance
          .collection('Students')
          .doc(studentUserId)
          .collection('applicationsResponse')
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

  bool isTileClicked = false;
  Set<int> clickedTiles = Set<int>();
  int getUnclickedApplicationsCount() {
    // Calculate the number of unclicked applications
    return _studentApplications.where((application) => !isTileClicked).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              semanticsLabel: 'Loading...',
              semanticsValue: 'Loading...',
            ))
          : Container(
              height: double.infinity,
              color: Colors.blue[100],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notifications',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      for (int index = 0;
                          index < _studentApplications.length;
                          index++)
                        if (_studentApplications[index]['status'] == true)
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.blue)),
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ViewApplicationResponses(
                                          studentApplicationData:
                                              _studentApplications[index],
                                        ),
                                      ),
                                    );
                                    setState(() {
                                      // Toggle the clicked state of the tile
                                      if (clickedTiles.contains(index)) {
                                        clickedTiles.remove(index);
                                      } else {
                                        clickedTiles.add(index);
                                      }
                                    });
                                  },
                                  title: Text(
                                    '${_studentApplications[index]['accomodationName']}',
                                    style: TextStyle(
                                      fontWeight: clickedTiles.contains(index)
                                          ? FontWeight.normal
                                          : FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${_studentApplications[index]['landlordMessage']} Your application was successfully accepted',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing:
                                      Icon(Icons.arrow_forward_ios_rounded),
                                )
                              ],
                            ),
                          )
                    ]),
              ),
            ),
    );
  }
}
