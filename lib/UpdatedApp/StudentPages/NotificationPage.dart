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
  bool isLoading = true;
  List<Map<String, dynamic>> _studentApplications = [];
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
  }

  Future<void> _loadStudentApplications() async {
    try {
      // Assuming there is a specific landlord ID (replace 'your_landlord_id' with the actual ID)
      String studentUserId = _userData?['userId'] ?? '';

      QuerySnapshot applicationsSnapshot = await FirebaseFirestore.instance
          .collection('users')
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
      body: Center(
        child: Column(
          children: [
            TabBar(
              labelColor: Colors.blue,
              indicatorColor: Colors.blue,
              controller: _tabController,
              tabs: [
                Tab(text: 'Accepted Notification'),
                Tab(text: 'Rejected Notification'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Accepted Applications',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 5,
                            ),
                            for (int index = 0;
                                index < _studentApplications.length;
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
                                            fontWeight:
                                                clickedTiles.contains(index)
                                                    ? FontWeight.normal
                                                    : FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          '${_studentApplications[index]['landlordMessage']} Your application was successfully accepted',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        trailing: Icon(
                                            Icons.arrow_forward_ios_rounded),
                                      ),
                                    ),
                                  )
                                ],
                              )
                          ]),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        for (int index = 0;
                            index < _studentApplications.length;
                            index++)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Rejected Applications',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                child: Card(
                                  color: Color.fromARGB(255, 243, 243, 243),
                                  elevation: 4,
                                  child: ListTile(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => Container(
                                          height: 350,
                                          width: 250,
                                          child: AlertDialog(
                                            title: Text(
                                              'Rejected Reason',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            content: Text(
                                              _studentApplications[index]
                                                  ['landlordMessage'],
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.of(context).pop;

                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context,
                                                          '/studentPage');
                                                },
                                                child: Text('Okay'),
                                                style: ButtonStyle(
                                                    shape: MaterialStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5))),
                                                    foregroundColor:
                                                        MaterialStatePropertyAll(
                                                            Colors.white),
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            Colors.blue),
                                                    minimumSize:
                                                        MaterialStatePropertyAll(
                                                            Size(
                                                                double.infinity,
                                                                50))),
                                              ),
                                            ],
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
                                      'Your Application have been rejected due to the following reasons ${_studentApplications[index]['landlordMessage']} ',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing:
                                        Icon(Icons.arrow_forward_ios_rounded),
                                  ),
                                ),
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
