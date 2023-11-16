// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, sized_box_for_whitespace

import 'package:api_com/student_page.dart';
import 'package:flutter/material.dart';

class StudentRegistration2 extends StatefulWidget {
  const StudentRegistration2({super.key});

  @override
  State<StudentRegistration2> createState() => _StudentRegistration2State();
}

class _StudentRegistration2State extends State<StudentRegistration2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Personal Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MediaQuery.of(context).size.width < 480
                  ? Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Icon(Icons.lock_person,
                            size: 150, color: Colors.blue),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        // controller: txtName,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            focusColor: Colors.blue,
                            fillColor: Color.fromARGB(255, 230, 230, 230),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.person_3_outlined,
                              color: Colors.blue,
                            ),
                            hintText: 'Enter your ID Number'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        // controller: txtSurname,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            focusColor: Colors.blue,
                            fillColor: Color.fromARGB(255, 230, 230, 230),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.numbers,
                              color: Colors.blue,
                            ),
                            hintText: 'Enter your Student Number'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        // controller: txtSurname,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            focusColor: Colors.blue,
                            fillColor: Color.fromARGB(255, 230, 230, 230),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.numbers,
                              color: Colors.blue,
                            ),
                            labelText: 'Cellphone No'),
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
                                    builder: ((context) => StudentPage())));
                          });
                        },
                        child: Text(
                          'Proceed',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              letterSpacing: 2),
                        ),
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.blue),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue),
                            minimumSize: MaterialStatePropertyAll(
                                Size(double.infinity, 50))),
                      ),
                    ])
                  : Center(
                      child: Container(
                        width: 300,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Icon(Icons.lock_person,
                                  size: 150, color: Colors.blue),
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: 300,
                              child: TextField(
                                // controller: txtName,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    focusColor: Colors.blue,
                                    fillColor:
                                        Color.fromARGB(255, 230, 230, 230),
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.person_3_outlined,
                                      color: Colors.blue,
                                    ),
                                    hintText: 'Enter your ID Number'),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 300,
                              child: TextField(
                                // controller: txtSurname,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    focusColor: Colors.blue,
                                    fillColor:
                                        Color.fromARGB(255, 230, 230, 230),
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.numbers,
                                      color: Colors.blue,
                                    ),
                                    hintText: 'Enter your Student Number'),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 300,
                              child: TextField(
                                // controller: txtSurname,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    focusColor: Colors.blue,
                                    fillColor:
                                        Color.fromARGB(255, 230, 230, 230),
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.numbers,
                                      color: Colors.blue,
                                    ),
                                    labelText: 'Cellphone No'),
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
                                              StudentPage())));
                                });
                              },
                              child: Text(
                                'Proceed',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    letterSpacing: 2),
                              ),
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStatePropertyAll(Colors.blue),
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.blue),
                                  minimumSize:
                                      MaterialStatePropertyAll(Size(300, 50))),
                            ),
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
