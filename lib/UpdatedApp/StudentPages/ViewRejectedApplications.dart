// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ViewRejectedApplications extends StatefulWidget {
  const ViewRejectedApplications({super.key});

  @override
  State<ViewRejectedApplications> createState() =>
      _ViewRejectedApplicationsState();
}

class _ViewRejectedApplicationsState extends State<ViewRejectedApplications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        title: Text('Rejected Applications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(),
      ),
    );
  }
}
