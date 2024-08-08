// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show NetworkAssetBundle;
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ViewContract extends StatefulWidget {
//   final Map<String, dynamic> studentApplicationData;

//   const ViewContract({Key? key, required this.studentApplicationData}) : super(key: key);

//   @override
//   _ViewContractState createState() => _ViewContractState();
// }

// class _ViewContractState extends State<ViewContract> {
//   PdfDocument? _pdfDocument;
//   Uint8List? _pdfBytes;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadPdf();
//   }

//   Future<void> _loadPdf() async {
//     final ByteData data = await NetworkAssetBundle(Uri.parse(widget.studentApplicationData['contract'] ??
//         'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf')).load("");
//     _pdfBytes = data.buffer.asUint8List();
//     _pdfDocument = PdfDocument(inputBytes: _pdfBytes);
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   void _downloadPdf() async {
//     String pdfUrl = widget.studentApplicationData['contract'] ??widget.studentApplicationData['signedContract'];
//     await canLaunch(pdfUrl)
//         ? await launch(pdfUrl)
//         : throw 'Could not launch $pdfUrl';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[100],
//       appBar: AppBar(
//         title: Text(
//           '${widget.studentApplicationData['name'] ?? 'NaN'}\'s Contract',
//         ),
//         foregroundColor: Colors.white,
//         backgroundColor: Colors.blue,
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.download),
//             onPressed: _downloadPdf,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SfPdfViewer.memory(
//               _pdfBytes!,
//               scrollDirection: PdfScrollDirection.vertical,
//             ),
//     );
//   }
// }

//  Future<void> _uploadSignedContract(BuildContext context) async {

//     // if (pdfContractFile == null) {
//     //   _showErrorDialog('No contract file selected.', context);
//     //   return;
//     // }

//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//          return Center(
//           child: CircularProgressIndicator(
//             color: Colors.blue,
//           ),
//         );
//       },
//     );

//     // String landlordUserId = widget.studentApplicationData['userId'] ?? '';
//     // String studentUserId = _userData?['userId'] ?? '';

//     //   DocumentSnapshot applicationSnapshot = await FirebaseFirestore.instance
//     //       .collection('Landlords')
//     //       .doc(landlordUserId)
//     //       .collection('signedContracts')
//     //       .doc(studentUserId)
//     //       .get();

//     //   if (applicationSnapshot.exists) {
//     //     Navigator.of(context).pop();
//     //     _appliedStudent(context,'Please Note that you\'re already registered in this Residence and registration duplication can not be allowed.','Registration Duplication');

//     //     return;
//     //   }
//     DateTime now = DateTime.now();
//     Timestamp feedbackDate = Timestamp.fromDate(now);
//     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     firebase_storage.Reference reference =
//         firebase_storage.FirebaseStorage.instance.ref('signedContracts').child(
//             '${_userData?['name'] ?? 'Nan'}\'s signed Contract($fileName).pdf');

//     await reference.putFile(pdfContractFile!);
//     String downloadCOntractUrl = await reference.getDownloadURL();
//     await FirebaseFirestore.instance
//         .collection('Landlords')
//         .doc(landlordUserId)
//         .collection('signedContracts')
//         .doc(studentUserId)
//         .set({
//       'name': _userData?['name'] ?? '',
//       'gender':_userData?['gender']??'',
//       'surname': _userData?['surname'] ?? '',
//       'userId': _userData?['userId'] ?? '',
//       'email': _userData?['email'] ?? '',
//       'registeredDate': feedbackDate,
//       'signedContract': downloadCOntractUrl,
//       'university':_userData?['university'] ?? '',
//       'contactDetails':_userData?['contactDetails'] ?? '',
//         'roomType': _userData?['roomType'] ?? '',
//         'fieldOfStudy': _userData?['fieldOfStudy'] ?? '',
//         'periodOfStudy': _userData?['periodOfStudy'] ?? '',
//     });
//     // await FirebaseFirestore.instance
//     //     .collection('Students')
//     //     .doc(studentUserId)
//     //     .collection('registeredResidence')
//     //     .doc(landlordUserId)
//     //     .set({
//     //   'accommodationName':
//     //       widget.studentApplicationData['accomodationName']  ,
//     //   'logo': widget.studentApplicationData['profilePicture'],
//     //   'userId': widget.studentApplicationData['userId']  ,
//     //   'email': widget.studentApplicationData['email']  ,
//     //   'registeredDate': feedbackDate,
//     //     'accomodationStatus': false,
//     //     'location': widget.studentApplicationData['location'] ?? '',
//     //     'selectedOffers': widget.studentApplicationData['selectedOffers'] ?? '',
//     //     'selectedUniversity': widget.studentApplicationData['selectedUniversity'] ?? '',
//     //     'distance': widget.studentApplicationData['distance'] ?? '',
//     //     'selectedPaymentsMethods': widget.studentApplicationData['selectedPaymentsMethods'] ?? '',
//     //     'requireDeposit': widget.studentApplicationData['requireDeposit'] ?? '',
//     //     'contactDetails': widget.studentApplicationData['contactDetails'] ?? '',
//     //     'accomodationType': widget.studentApplicationData['accomodationType'] ?? '',
//     //     'roomType': widget.studentApplicationData['roomType'] ?? '',
//     //     'displayedImages': widget.studentApplicationData['displayedImages'] ?? '',
//     //     'isNsfasAccredited': widget.studentApplicationData['isNsfasAccredited'] ?? '',
//     //     'isFull': false,
//     //     'Duration': widget.studentApplicationData['Duration'] ?? '',

//     // });

// // await FirebaseFirestore.instance
// //           .collection('Students')
// //           .doc(_user.uid)
// //           .update({
// //             'isRegistered':true,
// //             'registeredResidence':widget.studentApplicationData['accomodationName'] ?? ''
// //       });
//     // await sendEmail(
//     //   widget.studentApplicationData['email'] ?? '',
//     //   'Signed Contract',
//     //   'Hi ${widget.studentApplicationData['accomodationName'] ?? ''} , \nYou you have a new signed contract from ${_userData?['name'] ?? ''} ${_userData?['surname'] ?? ''}.\nBest Regards\nYour Accomate Team',
//     // );
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         Future.delayed(Duration(seconds: 30), () {
//           if (Navigator.of(context).canPop()) {
//             Navigator.of(context).pop();
//             Navigator.pushReplacementNamed(context, '/studentPage');
//           }
//         });

//         return Center(
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5),
//               color: Colors.blue[50],
//             ),
//             height: 360,
//             width: 300,
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Center(
//                     child: Lottie.network(
//                       repeat: false,
//                       'https://lottie.host/7b0dcc73-3274-41ef-a3f3-5879cade8ffa/zCbLIAPAww.json',
//                       height: 250,
//                       width: 250,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Center(
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(50)),
//                             height: 100,
//                             width: 100,
//                             color: Colors.green,
//                             child: Center(
//                               child: Icon(
//                                 Icons.done,
//                                 size: 60,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     'Submitted successfully',
//                     style: TextStyle(
//                         decoration: TextDecoration.none,
//                         fontSize: 20,
//                         color: Colors.green),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Center(
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         Navigator.of(context).pop();
//                         Navigator.pushReplacementNamed(context, '/studentPage');
//                       },
//                       child: Text('Done'),
//                       style: ButtonStyle(
//                           shape: WidgetStatePropertyAll(RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5))),
//                           backgroundColor: WidgetStatePropertyAll(Colors.blue),
//                           foregroundColor: WidgetStatePropertyAll(Colors.white),
//                           minimumSize: WidgetStatePropertyAll(Size(200, 50))),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

  // void _showErrorDialog(String errorMessage, BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(5),
  //       ),
  //       title: Text(
  //         'Error Occurred',
  //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //       ),
  //       content: Text(
  //         errorMessage,
  //         style: TextStyle(fontSize: 16),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //           child: Text('OK'),
  //           style: ButtonStyle(
  //             shape: MaterialStateProperty.all(RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(5),
  //             )),
  //             foregroundColor: MaterialStateProperty.all(Colors.white),
  //             backgroundColor: MaterialStateProperty.all(Colors.blue),
  //             minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
