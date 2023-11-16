// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, sized_box_for_whitespace

import 'package:api_com/LandlordRegistrationPage.dart';
import 'package:api_com/Student_registration_page.dart';
import 'package:flutter/material.dart';

class RegistrationOption extends StatefulWidget {
  const RegistrationOption({super.key});

  @override
  State<RegistrationOption> createState() => _RegistrationOptionState();
}

class _RegistrationOptionState extends State<RegistrationOption> {
  String _value = 'Student';
  bool isChecked = true;
  void registrationOption() {
    setState(() {
      _value == 'Student'
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => StudentRegistrationPage())))
          : Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => LandlordRegistrationPage())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Name', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          children: [
            MediaQuery.of(context).size.width < 480
                ? Column(children: [
                    Icon(
                      Icons.person_add,
                      size: 200,
                      color: Colors.blue,
                    ),
                    Row(
                      children: [
                        Text(
                          'You are registering as:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    RadioListTile(
                      value: 'Landlord',
                      groupValue: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value.toString();
                        });
                      },
                      title: Text('Landlord'),
                      tileColor: Colors.white,
                    ),
                    RadioListTile(
                      value: 'Student',
                      groupValue: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value.toString();
                        });
                      },
                      title: Text('Student'),
                      tileColor: Colors.white,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CheckboxListTile(
                      value: isChecked,
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
                        registrationOption();
                      },
                      child: Text(
                        'Get Started',
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
                : Center(
                    child: Container(
                      width: 300,
                      child: Column(
                        children: [
                          Icon(
                            Icons.person_add,
                            size: 200,
                            color: Colors.blue,
                          ),
                          Column(children: [
                            Row(
                              children: [
                                Text(
                                  'You are registering as:',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            RadioListTile(
                              value: 'Landlord',
                              groupValue: _value,
                              onChanged: (value) {
                                setState(() {
                                  _value = value.toString();
                                });
                              },
                              title: Text('Landlord'),
                              tileColor: Colors.white,
                            ),
                            RadioListTile(
                              value: 'Student',
                              groupValue: _value,
                              onChanged: (value) {
                                setState(() {
                                  _value = value.toString();
                                });
                              },
                              title: Text('Student'),
                              tileColor: Colors.white,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CheckboxListTile(
                              value: isChecked,
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
                                registrationOption();
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
                            ),
                          ]),
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
