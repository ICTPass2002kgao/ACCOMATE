// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:api_com/UpdatedApp/LandlordPages/viewApplicantDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  List<Map<String, dynamic>> _studentApplications = [];
  bool isTileClicked = false; // State to track if a ListTile is clicked

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
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
      // Assuming there is a specific landlord ID (replace 'your_landlord_id' with the actual ID)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : Container(
              color: Colors.blue[100],
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifications',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    for (int index = 0;
                        index < _studentApplications.length;
                        index++)
                      if (_studentApplications[index]['applicationReviewed'] ==
                          false)
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.blue)),
                              child: ListTile(
                                shape: Border.all(color: Colors.blue),
                                tileColor: Color.fromARGB(179, 211, 211, 211),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ViewApplicantDetails(
                                        studentApplicationData:
                                            _studentApplications[index],
                                      ),
                                    ),
                                  );
                                },
                                title: Text(
                                  '${_studentApplications[index]['name'] ?? ''}${_studentApplications[index]['surname'] ?? ''}',
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
                                trailing: Icon(Icons.arrow_forward_ios_rounded),
                              ),
                            )
                          ],
                        )
                  ],
                ),
              ),
            ),
    );
  }
}
//  TabBar(
//                       labelColor: Colors.blue,
//                       indicatorColor: Colors.blue,
//                       controller: _tabController,
//                       tabs: [
//                         Tab(
//                           child: Stack(
//                             children: [
//                               Row(
//                                 children: [
//                                   Text('Available Applications'),
//                                 ],
//                               ),
//                               if (getUnclickedApplicationsCount() > 0)
//                                 Positioned(
//                                   right: 0,
//                                   child: Container(
//                                     height: 15,
//                                     width: 15,
//                                     decoration: BoxDecoration(
//                                       color: Colors.red,
//                                       borderRadius: BorderRadius.circular(7.5),
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         getUnclickedApplicationsCount()
//                                             .toString(),
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 10,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),