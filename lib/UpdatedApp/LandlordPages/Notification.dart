// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:api_com/UpdatedApp/LandlordPages/viewApplicantDetails.dart';
import 'package:api_com/UpdatedApp/LandlordPages/viewRegistration.dart';
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
  List<Map<String, dynamic>> _studentRegistration = [];
  List<Map<String, dynamic>> _LandlordMessages = [];
  List<Map<String, dynamic>> _studentApplications = [];
  late TabController _tabController;
  bool isTileClicked = false; // State to track if a ListTile is clicked

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

  Future<void> _loadStudentRegistration() async {
    try {
      // Assuming there is a specific landlord ID (replace 'your_landlord_id' with the actual ID)
      String landlordUserId = _userData?['userId'] ?? '';

      QuerySnapshot registrationSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(landlordUserId)
          .collection('registeredStudents')
          .get();

      List<Map<String, dynamic>> studentRegistrations = [];

      for (QueryDocumentSnapshot documentSnapshot
          in registrationSnapshot.docs) {
        Map<String, dynamic> registrationData =
            documentSnapshot.data() as Map<String, dynamic>;
        studentRegistrations.add(registrationData);
      }

      setState(() {
        _studentRegistration = studentRegistrations;
      });
    } catch (e) {
      print('Error loading student applications: $e');
    }
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

  Set<int> clickedTiles = Set<int>();
  int getUnclickedApplicationsCount() {
    // Calculate the number of unclicked applications
    return _studentApplications.where((application) => !isTileClicked).length;
  }

  int getUnclickedRegistrationCount() {
    // Calculate the number of unclicked applications
    return _studentRegistration.where((registration) => !isTileClicked).length;
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
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  labelColor: Colors.blue,
                  indicatorColor: Colors.blue,
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'Available Applications '),
                    Tab(text: 'Available Registrations ')
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 1, right: 1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // for (Map<String, dynamic> studentApplication
                            //     in _studentAppcations)
                            for (int index = 0;
                                index < _studentApplications.length;
                                index++)
                              if (_studentApplications[index]
                                      ['applicationReviewed'] ==
                                  false)
                                Column(
                                  children: [
                                    Container(
                                      child: ListTile(
                                        tileColor:
                                            Color.fromARGB(179, 211, 211, 211),
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
                                          'You have a new application from ${_studentApplications[index]['name']}',
                                          style: TextStyle(
                                            fontWeight:
                                                clickedTiles.contains(index)
                                                    ? FontWeight.normal
                                                    : FontWeight.bold,
                                          ),
                                        ),
                                        trailing: Icon(
                                            Icons.arrow_forward_ios_rounded),
                                      ),
                                    )
                                  ],
                                )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            for (int index = 0;
                                index < _studentRegistration.length;
                                index++)
                              Column(
                                children: [
                                  Container(
                                    child: Card(
                                      color: Color.fromARGB(255, 243, 243, 243),
                                      elevation: 4,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewRegistrations(
                                                studentRegistrationData:
                                                    _studentRegistration[index],
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
                                        title: Text(_studentRegistration[index]
                                                ['name'] ??
                                            ''),
                                        subtitle: Text(
                                          'You have a new registered student...',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight:
                                                clickedTiles.contains(index)
                                                    ? FontWeight.normal
                                                    : FontWeight.bold,
                                          ),
                                        ),
                                        trailing: Icon(
                                            Icons.arrow_forward_ios_rounded),
                                      ),
                                    ),
                                  )
                                ],
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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