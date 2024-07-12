// import 'package:api_com/UpdatedApp/ViewImage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class InboxPage extends StatefulWidget {
//   final Map<String, dynamic>? studentsContracts;
//   const InboxPage({Key? key, required this.studentsContracts})
//       : super(key: key);

//   @override
//   State<InboxPage> createState() => _InboxPageState();
// }

// class _InboxPageState extends State<InboxPage> {
//   final TextEditingController _controller = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   User? _user;

//   @override
//   void initState() {
//     super.initState();
//     _getUser();
//     _setupListeners();
//   }

//   Future<void> _getUser() async {
//     User? user = _auth.currentUser;
//     setState(() {
//       _user = user;
//     });
//   }

//   void _sendMessage() {
//     if (_controller.text.isNotEmpty &&
//         _user != null &&
//         widget.studentsContracts != null) {
//       String recipientId = widget.studentsContracts?['userId'];
//       FirebaseFirestore.instance
//           .collection('Students')
//           .doc(recipientId)
//           .collection('Messages')
//           .add({
//         'text': _controller.text,
//         'senderId': _user?.uid,
//         'timestamp': FieldValue.serverTimestamp(),
//         'seen': false
//       });
//       _controller.clear();
//     }
//   }

//   List<Map<String, dynamic>> _messages = [];

//   void _setupListeners() {
//     String? userId = _user?.uid;
//     if (userId != null) {
//       // Listen to both landlord's and student's messages
//       String studentId = widget.studentsContracts?['userId'];
//       List<String> collectionPaths = [
//         'Landlords/$userId/Messages',
//         'Students/$studentId/Messages'
//       ];

//       for (String path in collectionPaths) {
//         FirebaseFirestore.instance
//             .collection(path)
//             .orderBy('timestamp', descending: false)
//             .snapshots()
//             .listen((QuerySnapshot snapshot) {
//           _processMessages(snapshot);
//         });
//       }
//     }
//   }

//   void _processMessages(QuerySnapshot snapshot) {
//     List<Map<String, dynamic>> newMessages = [];

//     for (QueryDocumentSnapshot documentSnapshot in snapshot.docs) {
//       Map<String, dynamic> messageData =
//           documentSnapshot.data() as Map<String, dynamic>;
//       messageData['id'] = documentSnapshot.id;
//       newMessages.add(messageData);
//     }

//     setState(() {
//       // Merge the new messages with the existing messages
//       _messages = _messages
//           .where((existingMessage) => !newMessages
//               .any((newMessage) => newMessage['id'] == existingMessage['id']))
//           .toList()
//         ..addAll(newMessages)
//         ..sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
//     });
//   }

//   String _formatTimestamp(Timestamp timestamp) {
//     DateTime dateTime = timestamp.toDate();
//     return DateFormat('hh:mm a').format(dateTime);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//             '${widget.studentsContracts?['name']} ${widget.studentsContracts?['surname']}'),
//         centerTitle: true,
//         foregroundColor: Colors.white,
//         backgroundColor: Colors.blue,
//       ),
//       backgroundColor: Colors.blue[100],
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 Map<String, dynamic> message = _messages[index];
//                 bool isStudentMessage =
//                     message['senderId'] == widget.studentsContracts?['userId'];
//                 return Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: isStudentMessage
//                           ? MainAxisAlignment.start
//                           : MainAxisAlignment.end,
//                       children: [
//                         if (message['picture'] != null)
//                           Container(
//                             constraints: BoxConstraints(maxWidth: 258),
//                             decoration: BoxDecoration(
//                               color:
//                                   isStudentMessage ? Colors.grey : Colors.blue,
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(5),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => ViewImage(
//                                               imageUrl: message['picture'])));
//                                 },
//                                 child: Image.network(
//                                   message['picture'] ?? '',
//                                   height: 250,
//                                   width: 250,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: isStudentMessage
//                           ? MainAxisAlignment.start
//                           : MainAxisAlignment.end,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(2.0),
//                           child: Container(
//                             constraints: BoxConstraints(maxWidth: 250),
//                             decoration: BoxDecoration(
//                               color:
//                                   isStudentMessage ? Colors.grey : Colors.blue,
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 if (message['text'] != null)
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                         left: 8.0, right: 8),
//                                     child: Text(
//                                       message['text'],
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(4.0),
//                                   child: Text(
//                                     _formatTimestamp(
//                                         message['timestamp'] as Timestamp),
//                                     style: TextStyle(
//                                       color: Colors.white70,
//                                       fontSize: 10,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           Container(
//             color: Colors.blue[200],
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _controller,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.blue),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.blue),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         focusColor: Colors.blue,
//                         fillColor: Colors.blue[50],
//                         filled: true,
//                         hintText: 'Enter your message...',
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.send),
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
