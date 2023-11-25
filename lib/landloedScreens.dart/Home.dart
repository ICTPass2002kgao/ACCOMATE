// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Available Registrations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 5,
          ),
          Table(
            border: TableBorder.all(),
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: Center(child: Text('ID No')),
                  ),
                  TableCell(
                    child: Center(child: Text('Name')),
                  ),
                  TableCell(
                    child: Center(child: Text('Surname')),
                  ),
                  TableCell(
                    child: Center(child: Text('Cell No')),
                  ),
                  TableCell(
                    child: Center(child: Text('Email Address')),
                  ),
                  TableCell(
                    child: Center(child: Text('Proof Of Registration')),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Center(child: Text('')),
                  ),
                  TableCell(
                    child: Center(child: Text('')),
                  ),
                  TableCell(
                    child: Center(child: Text('')),
                  ),
                  TableCell(
                    child: Center(child: Text('')),
                  ),
                  TableCell(
                    child: Center(child: Text('')),
                  ),
                  TableCell(
                    child: Center(
                        child: TextButton(
                      onPressed: () {
                        // Implement logic to open the PDF file
                        // For now, let's just print a message
                        print('Open PDF');
                      },
                      child: Text('View PDF'),
                    )),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
