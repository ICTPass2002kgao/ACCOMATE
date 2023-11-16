// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, sized_box_for_whitespace

import 'package:api_com/Student_Registration_page2.dart';
import 'package:api_com/login_page.dart';
import 'package:flutter/material.dart';

class StudentRegistrationPage extends StatefulWidget {
  const StudentRegistrationPage({super.key});

  @override
  State<StudentRegistrationPage> createState() =>
      _StudentRegistrationPageState();
}

class _StudentRegistrationPageState extends State<StudentRegistrationPage> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtSurname = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 50, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                MediaQuery.of(context).size.width < 480
                    ? Column(children: [
                        Icon(Icons.lock_person, size: 150, color: Colors.blue),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.all(0.0),
                          child: TextField(
                            controller: txtEmail,
                            decoration: InputDecoration(
                                focusColor: Colors.blue,
                                fillColor: Color.fromARGB(255, 230, 230, 230),
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.mail_outline,
                                  color: Colors.blue,
                                ),
                                hintText: 'Enter your email'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 0, top: 10),
                          child: TextField(
                            controller: txtPassword,
                            decoration: InputDecoration(
                                focusColor: Colors.blue,
                                fillColor: Color.fromARGB(255, 230, 230, 230),
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.blue,
                                ),
                                hintText: 'Password'),
                            obscureText: true,
                            obscuringCharacter: '*',
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: txtName,
                          decoration: InputDecoration(
                              focusColor: Colors.blue,
                              fillColor: Color.fromARGB(255, 230, 230, 230),
                              filled: true,
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                              hintText: 'Enter your name'),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: txtSurname,
                          decoration: InputDecoration(
                              focusColor: Colors.blue,
                              fillColor: Color.fromARGB(255, 230, 230, 230),
                              filled: true,
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                              hintText: 'Enter your Surname'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          StudentRegistration2())));
                            });
                          },
                          child: Text(
                            'Proceed',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.blue),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.blue),
                              minimumSize: MaterialStatePropertyAll(
                                  Size(double.infinity, 50))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => LoginPage())));
                            });
                          },
                          child: Text(
                            "Go to sign-in",
                            style: TextStyle(color: Colors.blue, fontSize: 18),
                          ),
                        )
                      ])
                    : Center(
                        child: Container(
                          width: 300,
                          child: Column(children: [
                            Icon(Icons.lock_person,
                                size: 150, color: Colors.blue),
                            SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Container(
                                width: 300,
                                child: TextField(
                                  controller: txtEmail,
                                  decoration: InputDecoration(
                                      focusColor: Colors.blue,
                                      fillColor:
                                          Color.fromARGB(255, 230, 230, 230),
                                      filled: true,
                                      prefixIcon: Icon(
                                        Icons.mail_outline,
                                        color: Colors.blue,
                                      ),
                                      hintText: 'Enter your email'),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 0, top: 10),
                              child: Container(
                                width: 300,
                                child: TextField(
                                  controller: txtPassword,
                                  decoration: InputDecoration(
                                      focusColor: Colors.blue,
                                      fillColor:
                                          Color.fromARGB(255, 230, 230, 230),
                                      filled: true,
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.blue,
                                      ),
                                      hintText: 'Password'),
                                  obscureText: true,
                                  obscuringCharacter: '*',
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 300,
                              child: TextField(
                                controller: txtName,
                                decoration: InputDecoration(
                                    focusColor: Colors.blue,
                                    fillColor:
                                        Color.fromARGB(255, 230, 230, 230),
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.blue,
                                    ),
                                    hintText: 'Enter your name'),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 300,
                              child: TextField(
                                controller: txtSurname,
                                decoration: InputDecoration(
                                    focusColor: Colors.blue,
                                    fillColor:
                                        Color.fromARGB(255, 230, 230, 230),
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.blue,
                                    ),
                                    hintText: 'Enter your Surname'),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              StudentRegistration2())));
                                });
                              },
                              child: Text(
                                'Proceed',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStatePropertyAll(Colors.blue),
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.blue),
                                  minimumSize:
                                      MaterialStatePropertyAll(Size(300, 50))),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => LoginPage())));
                                });
                              },
                              child: Text(
                                "Go to sign-in",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 18),
                              ),
                            )
                          ]),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
