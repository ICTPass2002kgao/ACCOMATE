// ignore_for_file: prefer_const_constructors, dead_code, prefer_const_literals_to_create_immutables, sort_child_properties_last, avoid_unnecessary_containers, unnecessary_string_interpolations, sized_box_for_whitespace

import 'package:api_com/userData.dart';
import 'package:flutter/material.dart';

class AccomodationPage extends StatelessWidget {
  const AccomodationPage({super.key, required this.residence});

  final Residence residence;

  Future<void> _comfirmedRegistration(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Done'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    SizedBox(width: 10),
                    Container(
                        width: 200,
                        child: Text("Accomodation registered successfully")),
                    Icon(Icons.done, color: Colors.greenAccent[700], size: 40),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Colors.greenAccent[700]),
                foregroundColor:
                    MaterialStatePropertyAll(Colors.greenAccent[700]),
              ),
              child: Text(
                'Done',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // Perform logout logic here
                // ...

                Navigator.popUntil(
                    context, ModalRoute.withName('/StudentPage'));
                // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _agreeWithTermsAndConditions(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Comfirm the registration'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    Icon(Icons.warning,
                        color: const Color.fromARGB(255, 235, 215, 38),
                        size: 40),
                    SizedBox(width: 5),
                    Container(
                        width: 200,
                        child: Text(
                            "Are you sure you're registering the residence?")),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
              ),
              onPressed: () {
                // Perform logout logic here
                // ...

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            SizedBox(width: 5),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue),
                foregroundColor: MaterialStatePropertyAll(Colors.blue),
              ),
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // Perform logout logic here
                // ...
                Navigator.of(context).pop();

                _comfirmedRegistration(context);

                // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Terms & Conditions'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Column(
                  children: [
                    SizedBox(width: 10),
                    Text('This are the terms and conditions of the app '),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue),
                foregroundColor: MaterialStatePropertyAll(Colors.blue),
              ),
              child: Text(
                'I Agree',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // Perform logout logic here
                // ...
                Navigator.of(context).pop();
                _agreeWithTermsAndConditions(context);

                // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          residence.name,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200, // Set the height based on your design
            child: PageView.builder(
              itemCount: residence.images.length,
              itemBuilder: (context, index) {
                return Image.network(residence.images[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${residence.name}'),
                Text('Address: ${residence.location}'),
                Text('Details: ${residence.moreDetails}'),
                Text('Status: ${residence.status}'),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement the action when the user applies for accommodation
              print('Apply for accommodation: ${residence.name}');
            },
            child: Text('Apply Accommodation'),
          ),
        ],
      ),
    );
  }
}
