// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, sized_box_for_whitespace

import 'package:api_com/UpdatedApp/either_landlord_or_student.dart';
import 'package:flutter/material.dart';

class RegistrationOption extends StatefulWidget {
  const RegistrationOption({super.key});

  @override
  State<RegistrationOption> createState() => _RegistrationOptionState();
}

class _RegistrationOptionState extends State<RegistrationOption> {
  bool isLandlord = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    // Simulate loading data
    await Future.delayed(Duration(seconds: 1));

    // Set isLoading to false when data is loaded
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth =
        MediaQuery.of(context).size.width < 450 ? double.infinity : 400;
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(
            "Kgaogelo's App",
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator()) // Show a loading indicator
            : Padding(
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Center(
                  child: Container(
                    width: containerWidth,
                    child: Column(children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.person_add,
                                    size: 200,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'You are registering as:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Radio(
                                  activeColor: Colors.blue,
                                  value: true,
                                  groupValue: isLandlord,
                                  onChanged: (value) {
                                    setState(() {
                                      isLandlord = true;
                                    });
                                  },
                                ),
                                Text('Landlord'),
                              ],
                            ),
                            SizedBox(width: 16),
                            Row(
                              children: [
                                Radio(
                                  activeColor: Colors.blue,
                                  value: false,
                                  groupValue: isLandlord,
                                  onChanged: (value) {
                                    setState(() {
                                      isLandlord = false;
                                    });
                                  },
                                ),
                                Text('Student'),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CheckboxListTile(
                              activeColor: Colors.blue,
                              value: true,
                              onChanged: (value) {
                                setState(() {});
                              },
                              title: Text('Agree with terms & conditions'),
                              tileColor: Colors.white,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StudentOrLandlord(
                                          isLandlord: isLandlord)),
                                );
                              },
                              child: Text(
                                'Get Started',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStatePropertyAll(Colors.blue),
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.blue),
                                  minimumSize: MaterialStatePropertyAll(
                                      Size(double.infinity, 50))),
                            )
                          ])
                    ]),
                  ),
                ),
              ));
  }
}
