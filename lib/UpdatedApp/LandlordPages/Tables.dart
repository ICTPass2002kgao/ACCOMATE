import 'package:flutter/material.dart';

class Tables extends StatelessWidget {
  final String columnName;
  final String columnValue;
  const Tables(
      {super.key, required this.columnName, required this.columnValue});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(columnName,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(columnValue),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


  // if (widget.userRole == 'Student')
                                  //   Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.center,
                                  //     children: <Widget>[
                                  //       Expanded(
                                  //         child: Divider(
                                  //           color: Colors.black,
                                  //         ),
                                  //       ),
                                  //       Padding(
                                  //         padding:
                                  //             const EdgeInsets.symmetric(
                                  //                 horizontal: 8.0),
                                  //         child: Text(
                                  //           'OR sign in with',
                                  //           style: TextStyle(
                                  //             color: Colors.black,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //       Expanded(
                                  //         child: Divider(
                                  //           color: Colors.black,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // SizedBox(
                                  //   height: 20,
                                  // ),
                                  // if (widget.userRole == 'Student')
                                  //   Row(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.center,
                                  //       children: [
                                  //         ClipRRect(
                                  //           borderRadius:
                                  //               BorderRadius.circular(90),
                                  //           child: GestureDetector(
                                  //             onTap: () async {
                                  //               await _handleSignIn();
                                  //             },
                                  //             child: Image.asset(
                                  //                 'assets/google.png',
                                  //                 height: 55,
                                  //                 width: 55),
                                  //           ),
                                  //         ),
                                  //         SizedBox(width: 10),
                                  //         if (isIOS)
                                  //           Padding(
                                  //             padding:
                                  //                 const EdgeInsets.only(
                                  //                     bottom: 10.0),
                                  //             child: GestureDetector(
                                  //               onTap: () {},
                                  //               child: Icon(
                                  //                 Icons.apple,
                                  //                 size: 77,
                                  //               ),
                                  //             ),
                                  //           )
                                  //       ]),  // if (widget.userRole == 'Student')
                                  //   Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.center,
                                  //     children: <Widget>[
                                  //       Expanded(
                                  //         child: Divider(
                                  //           color: Colors.black,
                                  //         ),
                                  //       ),
                                  //       Padding(
                                  //         padding:
                                  //             const EdgeInsets.symmetric(
                                  //                 horizontal: 8.0),
                                  //         child: Text(
                                  //           'OR sign in with',
                                  //           style: TextStyle(
                                  //             color: Colors.black,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //       Expanded(
                                  //         child: Divider(
                                  //           color: Colors.black,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // SizedBox(
                                  //   height: 20,
                                  // ),
                                  // if (widget.userRole == 'Student')
                                  //   Row(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.center,
                                  //       children: [
                                  //         ClipRRect(
                                  //           borderRadius:
                                  //               BorderRadius.circular(90),
                                  //           child: GestureDetector(
                                  //             onTap: () async {
                                  //               await _handleSignIn();
                                  //             },
                                  //             child: Image.asset(
                                  //                 'assets/google.png',
                                  //                 height: 55,
                                  //                 width: 55),
                                  //           ),
                                  //         ),
                                  //         SizedBox(width: 10),
                                  //         if (isIOS)
                                  //           Padding(
                                  //             padding:
                                  //                 const EdgeInsets.only(
                                  //                     bottom: 10.0),
                                  //             child: GestureDetector(
                                  //               onTap: () {},
                                  //               child: Icon(
                                  //                 Icons.apple,
                                  //                 size: 77,
                                  //               ),
                                  //             ),
                                  //           )
                                  //       ]),

                                  
  // late GoogleSignIn _googleSignIn;
  // Future<User?> _handleSignIn() async {
  //   try {
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return Center(
  //           child: CircularProgressIndicator(
  //             valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
  //           ),
  //         );
  //       },
  //     );

  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

  //     if (googleUser != null) {
  //       final GoogleSignInAuthentication googleAuth =
  //           await googleUser.authentication;

  //       final AuthCredential credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );

  //       final UserCredential userCredential =
  //           await FirebaseAuth.instance.signInWithCredential(credential);

  //       User? user = userCredential.user;

  //       if (user != null) {
  //         if (widget.userRole == 'Student') {
  //           Navigator.pushReplacementNamed(context, '/studentPage');
  //         } else if (widget.userRole == 'Landlord') {
  //           Navigator.pushReplacementNamed(context, '/landlordPage');
  //         } else if (widget.userRole == 'Admin') {
  //           Navigator.pushReplacementNamed(context, '/adminPage');
  //         }
  //       }
  //       return user;
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         backgroundColor: Colors.red,
  //         content: Text('Google Sign-In Failed'),
  //       ));
  //       return null;
  //     }
  //   } on FirebaseException catch (e) {
  //     print(e);
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       backgroundColor: Colors.red,
  //       content: Text(e.message.toString()),
  //     ));
  //     return null;
  //   } finally {
  //     Navigator.pop(context);
  //   }
  // }
  //  SizedBox(height: 5),
  //                   Container(
  //                     color: Colors.blue[50],
  //                     width: buttonWidth,
  //                     height: 50,
  //                     child: Row(
  //                       children: [
  //                         TextButton.icon(
  //                           onPressed: () {
  //                             _pickSignedContract(context);
  //                           },
  //                           icon: Icon(Icons.add_photo_alternate_outlined,
  //                               color: Colors.white),
  //                           label: Text(
  //                             'Upload Contract',
  //                             style:
  //                                 TextStyle(  fontSize: 18),
  //                           ),
  //                           style: ButtonStyle(
  //                               shape: WidgetStatePropertyAll(
  //                                   RoundedRectangleBorder(
  //                                       borderRadius:
  //                                           BorderRadius.circular(5))),
  //                               foregroundColor:
  //                                   WidgetStatePropertyAll(Colors.blue),
  //                               backgroundColor:
  //                                   WidgetStatePropertyAll(Colors.white),
  //                               minimumSize:
  //                                   WidgetStatePropertyAll(Size(130, 50))),
  //                         ),
  //                         SizedBox(width: 5),
  //                         Text(basename(_pdfContractPath))
  //                       ],
  //                     ),
  //                   ), 
                   
  // File? pdfContractFile;
  // Future<void> _pickSignedContract(BuildContext context) async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['pdf'],
  //     );

  //     if (result != null) {
  //       pdfContractFile = File(result.files.single.path!);
  //       setState(() {
  //         _pdfContractPath = pdfContractFile!.path;
  //       });
  //     } else {
  //       setState(() {});
  //     }
  //   } catch (e) {
  //     _showErrorDialog(e.toString(), context);
  //   }
  // }
