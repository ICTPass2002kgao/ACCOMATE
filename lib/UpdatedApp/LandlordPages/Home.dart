// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:api_com/UpdatedApp/LandlordPages/viewApplicantDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User? _user;
  bool isLoading = true;
  // List<Map<String, dynamic>> _studentApplications = [];

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    // _loadUserData();
    loadData();
  }

  // Map<String, dynamic>? _userData;
  // Future<void> _loadUserData() async {
  //   try {
  //     DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
  //         .collection('Landlords')
  //         .doc(_user?.uid)
  //         .get(); 
  //     // await _loadStudentApplications();
  //   } catch (e) {
  //     print('Error loading user data: $e');
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // Future<void> _loadStudentApplications() async {
  //   try {
  //     String landlordId = _userData?['userId'] ?? '';
  //     QuerySnapshot applicationsSnapshot = await FirebaseFirestore.instance
  //         .collection('Landlords')
  //         .doc(landlordId)
  //         .collection('applications')
  //         .get();

  //     List<Map<String, dynamic>> studentApplications = [];

  //     for (QueryDocumentSnapshot documentSnapshot
  //         in applicationsSnapshot.docs) {
  //       Map<String, dynamic> applicationData =
  //           documentSnapshot.data() as Map<String, dynamic>;
  //       studentApplications.add(applicationData);
  //     }

  //     setState(() {
  //       _studentApplications = studentApplications;
  //     });
  //   } catch (e) {
  //     print('Error loading student applications: $e');
  //   }
  // }

  Future<void> loadData() async {
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      isLoading = false;
    });
  }

  // void _viewStudent(Map<String, dynamic> student) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => Detailsforregisteredstudent(
  //         registeredStudents: student,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[100],
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Landlords')
              .doc(_user?.uid)
              .collection('applications')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Map<String, dynamic>> registeredStudents = snapshot
                  .data!.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconBadge(
                    hideZero: true,
                    maxCount: registeredStudents.length,
                    badgeColor: Colors.blue,
                    itemCount: registeredStudents.length,
                    icon:
                        Icon(Icons.people_sharp, size: 200, color: Colors.blue),
                  ),
                  Text(
                    'Total number of students who are not did not get a feedback [${registeredStudents.length}]',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  Expanded(
                    child: DataTable2(
                      headingRowColor: WidgetStatePropertyAll(Colors.grey),
                      dataRowColor: WidgetStatePropertyAll(Colors.blue[50]),
                      columnSpacing: 8,
                      horizontalMargin: 10,
                      minWidth: 600,
                      border: TableBorder.all(
                          style: BorderStyle.solid,
                          width: 1,
                          color: Color.fromARGB(255, 145, 204, 252)),
                      columns: [
                        DataColumn2(
                          label: Text('Name'),
                          size: ColumnSize.S,
                        ),
                        DataColumn(
                          label: Text('Surname'),
                        ),
                        DataColumn(
                          label: Text('Email'),
                        ),
                        DataColumn(
                          label: Text('Phone Number'),
                        ),
                        DataColumn(
                          label: Text('University'),
                        ),
                        DataColumn(
                          label: Text('Gender'),
                        ),
                        DataColumn(
                          label: Text('Application Date and Time'),
                        ),
                      ],
                      rows: registeredStudents
                          .map((student) => DataRow(cells: [
                                DataCell(onTap: () {
                                  ViewApplicantDetails(
                                    studentApplicationData: student,
                                  );
                                }, Text(student['name'] ?? '')),
                                DataCell(onTap: () {
                                  ViewApplicantDetails(
                                    studentApplicationData: student,
                                  );
                                }, Text(student['surname'] ?? '')),
                                DataCell(onTap: () {
                                  ViewApplicantDetails(
                                    studentApplicationData: student,
                                  );
                                }, Text(student['email'] ?? '')),
                                DataCell(onTap: () {
                                  ViewApplicantDetails(
                                    studentApplicationData: student,
                                  );
                                }, Text(student['contactDetails'] ?? '')),
                                DataCell(onTap: () {
                                  ViewApplicantDetails(
                                    studentApplicationData: student,
                                  );
                                }, Text(student['university'] ?? '')),
                                DataCell(onTap: () {
                                  ViewApplicantDetails(
                                    studentApplicationData: student,
                                  );
                                }, Text(student['gender'] ?? '')),
                                DataCell(onTap: () {
                                  ViewApplicantDetails(
                                    studentApplicationData: student,
                                  );
                                },
                                    Text(DateFormat('yyyy-MM-dd HH:mm').format(
                                        student['appliedDate'].toDate() ??
                                            DateTime.now()))),
                              ]))
                          .toList(),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
    //        StreamBuilder<QuerySnapshot>(
    //           stream: FirebaseFirestore.instance
    //               .collection('Landlords')
    //               .doc(_user?.uid)
    //               .collection('signedContracts')
    //               .snapshots(),
    //           builder: (context, snapshot) {
    //             if (snapshot.hasData) {
    //               List<Map<String, dynamic>> registeredStudents = snapshot
    //                   .data!.docs
    //                   .map((doc) => doc.data() as Map<String, dynamic>)
    //                   .toList();

    //               return Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   IconBadge(
    //                     hideZero: true,
    //                     maxCount: registeredStudents.length,
    //                     badgeColor: Colors.blue,
    //                     itemCount: registeredStudents.length,
    //                     icon: Icon(Icons.people_sharp,
    //                         size: 200, color: Colors.blue),
    //                   ),
    //                   Text(
    //                     'Total Number of Registered Students [${registeredStudents.length}]',
    //                     style: TextStyle(
    //                       fontSize: 24,
    //                     ),
    //                   ),
    //                   Expanded(
    //                     child: DataTable2(
    //                       headingRowColor: WidgetStatePropertyAll(Colors.grey),
    //                       dataRowColor: WidgetStatePropertyAll(Colors.blue[50]),
    //                       columnSpacing: 8,
    //                       horizontalMargin: 10,
    //                       minWidth: 600,
    //                       border: TableBorder.all(
    //                           style: BorderStyle.solid,
    //                           width: 1,
    //                           color: Color.fromARGB(255, 145, 204, 252)),
    //                       columns: [
    //                         DataColumn2(
    //                           label: Text('Name'),
    //                           size: ColumnSize.S,
    //                         ),
    //                         DataColumn(
    //                           label: Text('Surname'),
    //                         ),
    //                         DataColumn(
    //                           label: Text('Email'),
    //                         ),
    //                         DataColumn(
    //                           label: Text('Phone Number'),
    //                         ),
    //                         DataColumn(
    //                           label: Text('University'),
    //                         ),
    //                         DataColumn(
    //                           label: Text('Gender'),
    //                         ),
    //                         DataColumn(
    //                           label: Text('Registered Date and Time'),
    //                         ),
    //                       ],
    //                       rows: registeredStudents
    //                           .map((student) => DataRow(cells: [
    //                                 DataCell(onTap: () {
    //                                   _viewStudent(student);
    //                                 }, Text(student['name'] ?? '')),
    //                                 DataCell(onTap: () {
    //                                   _viewStudent(student);
    //                                 }, Text(student['surname'] ?? '')),
    //                                 DataCell(onTap: () {
    //                                   _viewStudent(student);
    //                                 }, Text(student['email'] ?? '')),
    //                                 DataCell(onTap: () {
    //                                   _viewStudent(student);
    //                                 }, Text(student['contactDetails'] ?? '')),
    //                                 DataCell(onTap: () {
    //                                   _viewStudent(student);
    //                                 }, Text(student['university'] ?? '')),
    //                                 DataCell(onTap: () {
    //                                   _viewStudent(student);
    //                                 }, Text(student['gender'] ?? '')),
    //                                 DataCell(onTap: () {
    //                                   _viewStudent(student);
    //                                 },
    //                                     Text(DateFormat('yyyy-MM-dd HH:mm')
    //                                         .format(student['registeredDate']
    //                                                 .toDate() ??
    //                                             DateTime.now()))),
    //                               ]))
    //                           .toList(),
    //                     ),
    //                   ),
    //                 ],
    //               );
    //             } else if (snapshot.hasError) {
    //               return Center(child: Text('Error: ${snapshot.error}'));
    //             }
    //             return Center(child: CircularProgressIndicator());
    //           },
    //         ),
    // );
  }
}
