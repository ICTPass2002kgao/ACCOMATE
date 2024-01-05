// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ViewRegistrations extends StatefulWidget {
  final Map<String, dynamic> studentRegistrationData;
  const ViewRegistrations({super.key, required this.studentRegistrationData});

  @override
  State<ViewRegistrations> createState() => _ViewRegistrationsState();
}

class _ViewRegistrationsState extends State<ViewRegistrations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registered Student'),
      ),
      body: Column(
        children: [
          Table(
            border: TableBorder.all(),
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: Center(
                        child: Text('Name',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  TableCell(
                    child: Center(
                        child: Text('Surname',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  TableCell(
                    child: Center(
                        child: Text('Gender',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  TableCell(
                    child: Center(
                        child: Text('Cell No',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  TableCell(
                    child: Center(
                        child: Text('Email Address',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  TableCell(
                    child: Center(
                        child: Text('University',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  TableCell(
                    child: Center(
                        child: Text('Proof Of Registration',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  TableCell(
                    child: Center(
                        child: Text('Id Document',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  TableCell(
                    child: Center(
                        child: Text('Identification Number',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  TableCell(
                    child: Center(
                        child: Text('Student Number',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  TableCell(
                    child: Center(
                        child: Text('Room Type',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  TableCell(
                    child: Center(
                        child: Text('Year of study',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  TableCell(
                    child: Center(
                        child: Text('Signed Contract',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Center(
                        child: Text(widget.studentRegistrationData['name'] ??
                            'Kgaogelo')),
                  ),
                  TableCell(
                    child: Center(
                        child: Text(widget.studentRegistrationData['surname'] ??
                            'Mthimkhulu')),
                  ),
                  TableCell(
                    child: Center(
                        child: Text(widget.studentRegistrationData['gender'] ??
                            'male')),
                  ),
                  TableCell(
                    child: Center(
                        child: Text(
                            widget.studentRegistrationData['contactDetails'] ??
                                'null')),
                  ),
                  TableCell(
                    child: Center(
                        child: Text(
                            widget.studentRegistrationData['email'] ?? 'null')),
                  ),
                  TableCell(
                    child: Center(
                        child: Text(
                            widget.studentRegistrationData['university'] ??
                                'yyyy')),
                  ),
                  TableCell(
                    child: Center(
                        child: ElevatedButton.icon(
                            onPressed: () async {
                              final String downloadUrl =
                                  widget.studentRegistrationData[
                                          'ProofOfRegistration'] ??
                                      '';

                              downloadFile(context, downloadUrl,
                                  "${widget.studentRegistrationData['name'] ?? ''}'s Proof of registration");
                            },
                            icon: Column(
                              children: [
                                Icon(Icons.download, color: Colors.blue),
                                Text('Download POR'),
                              ],
                            ),
                            label: Text(''))),
                  ),
                  TableCell(
                    child: Center(
                        child: ElevatedButton.icon(
                            onPressed: () async {
                              final String downloadUrl = widget
                                      .studentRegistrationData['IdDocument'] ??
                                  '';

                              downloadFile(context, downloadUrl,
                                  "${widget.studentRegistrationData['name'] ?? ''}'s Id document");
                            },
                            icon: Column(
                              children: [
                                Icon(Icons.download, color: Colors.blue),
                                Text('Download ID')
                              ],
                            ),
                            label: Text(''))),
                  ),
                  TableCell(
                    child: Center(
                        child: Text(
                            widget.studentRegistrationData['studentId'] ??
                                'yyyy')),
                  ),
                  TableCell(
                    child: Center(
                        child: Text(
                            widget.studentRegistrationData['studentNumber'] ??
                                'yyyy')),
                  ),
                  TableCell(
                    child: Center(
                        child: Text(
                            widget.studentRegistrationData['roomType'] ??
                                'yyyy')),
                  ),
                  TableCell(
                    child: Center(
                        child: Text(
                            widget.studentRegistrationData['fieldOfStudy'] ??
                                'yyyy')),
                  ),
                  TableCell(
                    child: Center(
                        child: ElevatedButton.icon(
                            onPressed: () async {
                              final String downloadUrl =
                                  widget.studentRegistrationData[
                                          'signedContract'] ??
                                      '';

                              downloadFile(context, downloadUrl,
                                  "${widget.studentRegistrationData['name'] ?? ''}'s signed Contract");
                            },
                            icon: Column(
                              children: [
                                Icon(Icons.download, color: Colors.blue),
                                Text('Download contract')
                              ],
                            ),
                            label: Text(''))),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> downloadFile(
      BuildContext context, String downloadUrl, String fileName) async {
    try {
      // Check for storage permission
      // var status = await Permission.storage.status;
      // if (!status.isGranted) {
      //   await Permission.storage.request();
      // }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blue,
        content: Text('Downloading...', style: TextStyle(color: Colors.white)),
        duration: Duration(seconds: 2),
      ));
      // Get the application documents directory
      // Get the Downloads directory
      Directory? downloadsDirectory = await getDownloadsDirectory();

      if (downloadsDirectory != null) {
        String savePath = '${downloadsDirectory.path}/${fileName}.pdf';

        // Create a reference to the Firebase Storage file
        Reference storageReference =
            FirebaseStorage.instance.ref().child(downloadUrl);

        // Download the file to the device
        await Dio().download(storageReference.fullPath, savePath);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('File downloaded successfully!',
              style: TextStyle(color: Colors.white)),
        ),
      );
    } catch (e) {
      print('Error downloading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading file'),
        ),
      );
    }
  }
}
