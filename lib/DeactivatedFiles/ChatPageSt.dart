// import 'package:api_com/UpdatedApp/StudentPages/InboxPageSt.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class Chatpage extends StatefulWidget {
//   const Chatpage({super.key});

//   @override
//   State<Chatpage> createState() => _ChatpageState();
// }

// class _ChatpageState extends State<Chatpage> {
//   late User? _user;

//   @override
//   void initState() {
//     super.initState();
//     _user = FirebaseAuth.instance.currentUser;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[100],
//       body: _user == null
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.sentiment_dissatisfied_rounded,
//                     color: Colors.red,
//                     size: 150,
//                   ),
//                   SizedBox(height: 10),
//                   Text('Oops user not found!\nTry to login.'),
//                 ],
//               ),
//             )
//           : StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('Students')
//                   .doc(_user?.uid)
//                   .collection('registeredResidence')
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (snapshot.hasError) {
//                   return Center(
//                     child: Text('Error loading data'),
//                   );
//                 } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.sentiment_dissatisfied_rounded,
//                           color: Colors.red,
//                           size: 150,
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                             'Oops!! you are not registered in any Residence yet!.'),
//                       ],
//                     ),
//                   );
//                 } else {
//                   List<Map<String, dynamic>> registeredResidences = snapshot
//                       .data!.docs
//                       .map((doc) => doc.data() as Map<String, dynamic>)
//                       .toList();
//                   return SingleChildScrollView(
//                     child: Column(
//                       children: registeredResidences.map((residence) {
//                         return Column(
//                           children: [
//                             SizedBox(height: 5),
//                             Padding(
//                               padding: const EdgeInsets.all(5.0),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   border: Border.all(color: Colors.blue),
//                                 ),
//                                 child: ListTile(
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => StudentInboxPage(
//                                           landlordContracts: residence,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   title: Text(
//                                     '${residence['accommodationName'] ?? ''}',
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.w900),
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   subtitle: Text('Tap to report any issue...'),
//                                   leading: ClipRRect(
//                                       borderRadius: BorderRadius.circular(25),
//                                       child: Image.network(
//                                         residence['logo'] ?? '',
//                                         width: 50,
//                                         height: 50,
//                                         fit: BoxFit.cover,
//                                       )),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                   );
//                 }
//               },
//             ),
//     );
//   }
// }
