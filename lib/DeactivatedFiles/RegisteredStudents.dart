// import 'package:api_com/UpdatedApp/LandlordPages/DetailsForRegisteredStudent.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:data_table_2/data_table_2.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:icon_badge/icon_badge.dart';
// import 'package:intl/intl.dart';

// class RegisteredStudents extends StatefulWidget {
//   const RegisteredStudents({super.key});

//   @override
//   State<RegisteredStudents> createState() => _RegisteredStudentsState();
// }

// class _RegisteredStudentsState extends State<RegisteredStudents> {
//   late User? _user;

//   @override
//   void initState() {
//     super.initState();
//     _user = FirebaseAuth.instance.currentUser;
//   }

//   void _viewStudent(Map<String, dynamic> student) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Detailsforregisteredstudent(
//           registeredStudents: student,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[100],
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('Landlords')
//             .doc(_user?.uid)
//             .collection('signedContracts')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             List<Map<String, dynamic>> registeredStudents = snapshot.data!.docs
//                 .map((doc) => doc.data() as Map<String, dynamic>)
//                 .toList();

//             return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconBadge(
//                   hideZero: true,
//                   maxCount: registeredStudents.length,
//                   badgeColor: Colors.blue,
//                   itemCount: registeredStudents.length,
//                   icon: Icon(Icons.people_sharp, size: 200, color: Colors.blue),
//                 ),
//                 Text(
//                   'Total Number of Registered Students [${registeredStudents.length}]',
//                   style: TextStyle(
//                     fontSize: 24,
//                   ),
//                 ),
//                 Expanded(
//                   child: DataTable2(
//                     headingRowColor: WidgetStatePropertyAll(Colors.grey),
//                     dataRowColor: WidgetStatePropertyAll(Colors.blue[50]),
//                     columnSpacing: 8,
//                     horizontalMargin: 10,
//                     minWidth: 600,
//                     border: TableBorder.all(
//                         style: BorderStyle.solid,
//                         width: 1,
//                         color: Color.fromARGB(255, 145, 204, 252)),
//                     columns: [
//                       DataColumn2(
//                         label: Text('Name'),
//                         size: ColumnSize.S,
//                       ),
//                       DataColumn(
//                         label: Text('Surname'),
//                       ),
//                       DataColumn(
//                         label: Text('Email'),
//                       ),
//                       DataColumn(
//                         label: Text('Phone Number'),
//                       ),
//                       DataColumn(
//                         label: Text('University'),
//                       ),
//                       DataColumn(
//                         label: Text('Gender'),
//                       ),
//                       DataColumn(
//                         label: Text('Registered Date and Time'),
//                       ),
//                     ],
//                     rows: registeredStudents
//                         .map((student) => DataRow(cells: [
//                               DataCell(onTap: () {
//                                 _viewStudent(student);
//                               }, Text(student['name'] ?? '')),
//                               DataCell(onTap: () {
//                                 _viewStudent(student);
//                               }, Text(student['surname'] ?? '')),
//                               DataCell(onTap: () {
//                                 _viewStudent(student);
//                               }, Text(student['email'] ?? '')),
//                               DataCell(onTap: () {
//                                 _viewStudent(student);
//                               }, Text(student['contactDetails'] ?? '')),
//                               DataCell(onTap: () {
//                                 _viewStudent(student);
//                               }, Text(student['university'] ?? '')),
//                               DataCell(onTap: () {
//                                 _viewStudent(student);
//                               }, Text(student['gender'] ?? '')),
//                               DataCell(onTap: () {
//                                 _viewStudent(student);
//                               },
//                                   Text(DateFormat('yyyy-MM-dd HH:mm').format(
//                                       student['registeredDate'].toDate() ??
//                                           DateTime.now()))),
//                             ]))
//                         .toList(),
//                   ),
//                 ),
//               ],
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           return Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }
