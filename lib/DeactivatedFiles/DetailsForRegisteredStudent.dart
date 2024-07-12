// import 'package:api_com/UpdatedApp/LandlordPages/Tables.dart';
// import 'package:api_com/UpdatedApp/DeactivatedFiles/ViewContract.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class Detailsforregisteredstudent extends StatefulWidget {
//   final Map<String, dynamic> registeredStudents;
//   const Detailsforregisteredstudent({
//     super.key,
//     required this.registeredStudents,
//   });

//   @override
//   State<Detailsforregisteredstudent> createState() =>
//       _DetailsforregisteredstudentState();
// }

// class _DetailsforregisteredstudentState
//     extends State<Detailsforregisteredstudent> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[100],
//       appBar: AppBar(
//         title: Text(
//             "${widget.registeredStudents['name'] ?? ''} ${widget.registeredStudents['surname'] ?? ''}"),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         physics: AlwaysScrollableScrollPhysics(),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Tables(
//                   columnName: 'Name',
//                   columnValue:
//                       widget.registeredStudents['name'] ?? ''),
//               Tables(
//                   columnName: 'Surname',
//                   columnValue:
//                       widget.registeredStudents['surname'] ?? ''),
//               Tables(
//                   columnName: 'Cellphone Number',
//                   columnValue:
//                       widget.registeredStudents['contactDetails'] ??
//                           ''),
//               Tables(
//                   columnName: 'Email Address',
//                   columnValue:
//                       widget.registeredStudents['email'] ?? ''),
//               Tables(
//                   columnName: 'Enrolled University',
//                   columnValue:
//                       widget.registeredStudents['university'] ?? ''),
//               Tables(
//                   columnName: 'Registration Date & Time',
//                   columnValue: DateFormat('yyyy-MM-dd HH:mm').format(
//                       widget.registeredStudents['registeredDate']
//                               .toDate() ??
//                           '')),
//               Tables(
//                   columnName: 'Type of room',
//                   columnValue:
//                       widget.registeredStudents['roomType'] ?? ''),
//               Tables(
//                   columnName: 'Period of study',
//                   columnValue:
//                       widget.registeredStudents['fieldOfStudy'] ??
//                           ''),
//               Tables(
//                   columnName: 'Year of study',
//                   columnValue:
//                       widget.registeredStudents['periodOfStudy'] ??
//                           ''),
//               SizedBox(
//                 height: 20,
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => ViewContract(
//                                 studentApplicationData:
//                                     widget.registeredStudents,
//                               )));
//                 },
//                 child: Text('View Contract'),
//                 style: ButtonStyle(
//                     shape: WidgetStatePropertyAll(
//                         RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5))),
//                     foregroundColor:
//                         WidgetStatePropertyAll(Colors.blue),
//                     backgroundColor:
//                         WidgetStatePropertyAll(Colors.blue[50]),
//                     minimumSize:
//                         WidgetStatePropertyAll(Size(400, 50))),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
