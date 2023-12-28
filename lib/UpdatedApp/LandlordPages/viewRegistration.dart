import 'package:flutter/material.dart';

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
        children: [],
      ),
    );
  }
}
