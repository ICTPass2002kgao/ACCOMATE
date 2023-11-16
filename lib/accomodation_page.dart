// ignore_for_file: prefer_const_constructors, dead_code, prefer_const_literals_to_create_immutables, sort_child_properties_last, avoid_unnecessary_containers, unnecessary_string_interpolations, sized_box_for_whitespace

import 'package:api_com/student_page.dart';
import 'package:flutter/material.dart';

class AccomodationPage extends StatefulWidget {
  const AccomodationPage({super.key, required this.residenceDetails});
  final Map<String, Object> residenceDetails;

  @override
  State<AccomodationPage> createState() => _AccomodationPageState();
}

class _AccomodationPageState extends State<AccomodationPage> {
  Future<void> _connectToServer() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate a delay

    // Your connecting logic goes here

    print('Connected to the server');
  }

  void loadingDetails(val) {
    Center(
      child: FutureBuilder(
        future: _connectToServer(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the connection, show a CircularProgressIndicator
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // If an error occurred during the connection, handle it here
            return Text('Error: ${snapshot.error}');
          } else {
            // If the connection is successful, display your app content
            return val;
          }
        },
      ),
    );
  }

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
                    Icon(Icons.done,
                        color: const Color.fromARGB(255, 14, 226, 21),
                        size: 40),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Color.fromARGB(255, 14, 226, 21)),
                foregroundColor:
                    MaterialStatePropertyAll(Color.fromARGB(255, 14, 226, 21)),
              ),
              child: Text(
                'Done',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // Perform logout logic here
                // ...

                loadingDetails(Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => StudentPage()))));
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
                    Icon(Icons.warning, color: Colors.yellow, size: 40),
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

                loadingDetails(_comfirmedRegistration(context));

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
                loadingDetails(_agreeWithTermsAndConditions(context));

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
          widget.residenceDetails['name'] as String,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                widget.residenceDetails['imagePath'] as String,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(widget.residenceDetails['name'] as String,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            Center(
              child: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.yellow,
                  ),
                  label: Text('Add to favorite',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold))),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Location: ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Status: ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  widget.residenceDetails['status'] as String,
                  style: TextStyle(fontSize: 15, color: Colors.green),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                loadingDetails(_showLogoutConfirmationDialog(context));
              },
              child: Text(
                'Register Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              style: ButtonStyle(
                minimumSize:
                    MaterialStatePropertyAll(Size(double.infinity, 50)),
                foregroundColor: MaterialStatePropertyAll(Colors.blue),
                backgroundColor: MaterialStatePropertyAll(Colors.blue),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
