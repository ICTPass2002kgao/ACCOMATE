// import 'dart:io';

// // import 'package:api_com/UpdatedApp/ViewImage.dart'; 
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';

// class StudentInboxPage extends StatefulWidget {
//   final Map<String, dynamic>? landlordContracts;
//   const StudentInboxPage({Key? key, required this.landlordContracts})
//       : super(key: key);

//   @override
//   State<StudentInboxPage> createState() => _StudentInboxPageState();
// }

// class _StudentInboxPageState extends State<StudentInboxPage> {
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

//   void _sendMessage() async {
//     if (_controller.text.isNotEmpty &&
//             _user != null &&
//             widget.landlordContracts != null ||
//         _imageFile != null) {
//       String recipientId = widget.landlordContracts?['userId'];

//       Reference storageReference = FirebaseStorage.instance
//           .ref('Students Reports images')
//           .child('${DateTime.now().toString()}');
//       UploadTask uploadTask = storageReference.putFile(File(_imageFile!.path));
//       setState(() {
//         _imageFile = null;
//       });
//       TaskSnapshot storageTaskSnapshot =
//           await uploadTask.whenComplete(() => null);
//       String downloadImageUrl = await storageTaskSnapshot.ref.getDownloadURL();

//       FirebaseFirestore.instance
//           .collection('Landlords')
//           .doc(recipientId)
//           .collection('Messages')
//           .add({
//         'text': _controller.text,
//         'picture': downloadImageUrl,
//         'senderId': _user?.uid,
//         'timestamp': FieldValue.serverTimestamp(),
//         'seen': false,
//       });
//       _controller.clear();
//     }
//   }

//   List<Map<String, dynamic>> _messages = [];

//   void _setupListeners() {
//     String? userId = _user?.uid;
//     if (userId != null) {
//       String landlordId = widget.landlordContracts?['userId'];
//       List<String> collectionPaths = [
//         'Students/$userId/Messages',
//         'Landlords/$landlordId/Messages'
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

//   XFile? _imageFile;

//   Future<void> _pickImage(ImageSource source) async {
//     XFile? selectedImage = await ImagePicker()
//         .pickImage(source: source, preferredCameraDevice: CameraDevice.rear);

//     setState(() {
//       _imageFile = selectedImage;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(25),
//                 child: Image.network(widget.landlordContracts?['logo'] ?? '',
//                     width: 50, height: 50, fit: BoxFit.cover),
//               ),
//             ),
//             Text('${widget.landlordContracts?['accommodationName']}'),
//           ],
//         ),
//         foregroundColor: Colors.white,
//         backgroundColor: Colors.blue,
//       ),
//       backgroundColor: Colors.blue[100],
//       body: Column(
//         children: [
//           // Center(
//           //   child: Container(
//           //     width: 200,
//           //     decoration: BoxDecoration(
//           //         color: Colors.blue[200],
//           //         borderRadius: BorderRadius.circular(10)),
//           //     child: Padding(
//           //       padding: const EdgeInsets.only(
//           //         left: 8.0,
//           //         right: 8,
//           //         top: 4,
//           //       ),
//           //       child: Text(
//           //         'This inbox is to ensure that everytime you have any issues in you room or Block that needs to be resolved you can report and get fast help.',
//           //         style: TextStyle(
//           //             color: Colors.white, fontWeight: FontWeight.w300),
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 Map<String, dynamic> message = _messages[index];
//                 bool isLandlordMessage =
//                     message['senderId'] == widget.landlordContracts?['userId'];
//                 return Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: isLandlordMessage
//                             ? MainAxisAlignment.start
//                             : MainAxisAlignment.end,
//                         children: [
//                           if (message['picture'] != null)
//                             Container(
//                               constraints: BoxConstraints(maxWidth: 258),
//                               decoration: BoxDecoration(
//                                 color: isLandlordMessage
//                                     ? Colors.grey
//                                     : Colors.blue,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(5),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => ViewImage(
//                                                 imageUrl: message['picture'])));
//                                   },
//                                   child: Image.network(
//                                     message['picture'] ?? '',
//                                     height: 250,
//                                     width: 250,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           SizedBox(
//                             height: 5,
//                           ),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: isLandlordMessage
//                             ? MainAxisAlignment.start
//                             : MainAxisAlignment.end,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(2.0),
//                             child: Container(
//                               constraints: BoxConstraints(maxWidth: 250),
//                               decoration: BoxDecoration(
//                                 color: isLandlordMessage
//                                     ? Colors.grey
//                                     : Colors.blue,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   if (message['text'] != null)
//                                     Text(
//                                       message['text'],
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(4.0),
//                                     child: Text(
//                                       _formatTimestamp(
//                                           message['timestamp'] as Timestamp),
//                                       style: TextStyle(
//                                         color: Colors.white70,
//                                         fontSize: 10,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           Container(
//             color: Colors.blue[200],
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   if (_imageFile != null)
//                     Image.file(
//                       File(
//                         _imageFile!.path,
//                       ),
//                       fit: BoxFit.cover,
//                       height: 250,
//                       width: 250,
//                     ),
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.image),
//                         onPressed: () {
//                           _pickImage(ImageSource.gallery);
//                         },
//                       ),
//                       Expanded(
//                         child: TextField(
//                           controller: _controller,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.blue),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.blue),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             focusColor: Colors.blue,
//                             fillColor: Colors.blue[50],
//                             filled: true,
//                             hintText: 'Enter your message...',
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.send),
//                         onPressed: _sendMessage,
//                       ),
//                     ],
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
