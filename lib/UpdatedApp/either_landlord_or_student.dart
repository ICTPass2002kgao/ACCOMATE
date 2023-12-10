// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, sized_box_for_whitespace, sort_child_properties_last, unnecessary_brace_in_string_interps, unnecessary_string_interpolations

import 'dart:math';

import 'package:api_com/UpdatedApp/landlordFurntherRegistration.dart';
import 'package:api_com/UpdatedApp/studentFurtherRegistrationPage.dart';
import 'package:api_com/UpdatedApp/student_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentOrLandlord extends StatefulWidget {
  const StudentOrLandlord({super.key, required this.isLandlord});
  final bool isLandlord;

  @override
  State<StudentOrLandlord> createState() => _StudentOrLandlordState();
}

class _StudentOrLandlordState extends State<StudentOrLandlord> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController contactDetails = TextEditingController();
  final TextEditingController accomodationName = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  String selectedUniversity = '';
  bool _obscureText = true;
  List<String> universities = [
    'Vaal University of Technology',
    'University of Johannesburg',
    'University of pretoria',
    'University of the Witwatersrand',
    'Cape Peninsula University of technology',
    'University of Cape Town',
    'North West University(vaal campus)',
    'University of Freestate',
    'University of Western Cape',
    'University of Kwa-zulu Natal',
    'Tshwane University of Technology',
    'Stellenbosch University',
    'Durban University of Technology',
    'North West University'
  ];
  String selectedGender = '';
  List<String> gender = [
    'Male',
    'Female',
  ];

  @override
  void initState() {
    super.initState();
    selectedUniversity = 'Vaal University of Technology'; // Default value
  }

  String verificationCode = _generateRandomCode();
  static String _generateRandomCode() {
    final random = Random();
    // Generate a random 6-digit code
    return '${random.nextInt(999999).toString().padLeft(6, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 400;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
            widget.isLandlord
                ? 'Landlord Registration'
                : 'Student Registration',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: !widget.isLandlord //This is for student
            ? SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  width: buttonWidth,
                  child: Column(children: [
                    Icon(
                      Icons.person_add,
                      size: 150,
                      color: Colors.blue,
                    ),
                    Container(
                      width: buttonWidth,
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                            focusColor: Colors.blue,
                            fillColor: Color.fromARGB(255, 230, 230, 230),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.blue,
                            ),
                            hintText: 'Name'),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: buttonWidth,
                      child: TextField(
                        controller: surnameController,
                        decoration: InputDecoration(
                            focusColor: Colors.blue,
                            fillColor: Color.fromARGB(255, 230, 230, 230),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.blue,
                            ),
                            hintText: 'Surname'),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: buttonWidth,
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            focusColor: Colors.blue,
                            fillColor: Color.fromARGB(255, 230, 230, 230),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.mail,
                              color: Colors.blue,
                            ),
                            hintText: 'example.@gmail.com'),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: buttonWidth,
                      child: TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                            focusColor: Colors.blue,
                            fillColor: Color.fromARGB(255, 230, 230, 230),
                            filled: true,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.blue,
                            ),
                            hintText: 'Password'),
                        obscureText: _obscureText,
                        obscuringCharacter: '*',
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: buttonWidth,
                      child: TextField(
                        controller: contactDetails,
                        decoration: InputDecoration(
                            focusColor: Colors.blue,
                            fillColor: Color.fromARGB(255, 230, 230, 230),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Colors.blue,
                            ),
                            hintText: 'Contact details'),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: buttonWidth,
                      child: ExpansionTile(
                        title: Text('Select University Or College'),
                        children: universities.map((university) {
                          return RadioListTile<String>(
                            title: Text(university),
                            value: university,
                            groupValue: selectedUniversity,
                            onChanged: (value) {
                              setState(() {
                                selectedUniversity = value!;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: buttonWidth,
                      child: ExpansionTile(
                        title: Text('Select Gender'),
                        children: gender.map((paramgender) {
                          return RadioListTile<String>(
                            title: Text(paramgender),
                            value: paramgender,
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value!;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextButton(
                      onPressed: () async {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentFurtherRegister(
                                name: nameController.text,
                                surname: surnameController.text,
                                contactDetails: contactDetails.text,
                                university: selectedUniversity,
                                gender: selectedGender,
                                email: emailController.text,
                                password: passwordController.text,
                                isLandlord: widget.isLandlord,
                              ),
                            ));
                      },
                      child: Text(
                        widget.isLandlord ? 'Create account' : 'Continue',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.blue),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blue),
                          minimumSize:
                              MaterialStatePropertyAll(Size(buttonWidth, 50))),
                    ),
                  ]),
                ),
              )

            //User registering as a landlord
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: Container(
                    width: buttonWidth,
                    child: Column(children: [
                      Icon(
                        Icons.maps_home_work_outlined,
                        size: 150,
                        color: Colors.blue,
                      ),
                      Container(
                        width: buttonWidth,
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                              focusColor: Colors.blue,
                              fillColor: Color.fromARGB(255, 230, 230, 230),
                              filled: true,
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Colors.blue,
                              ),
                              hintText: 'Email'),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: buttonWidth,
                        child: TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                              focusColor: Colors.blue,
                              fillColor: Color.fromARGB(255, 230, 230, 230),
                              filled: true,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.blue,
                              ),
                              hintText: 'Password'),
                          obscureText: _obscureText,
                          obscuringCharacter: '*',
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: accomodationName,
                        decoration: InputDecoration(
                            focusColor: Colors.blue,
                            fillColor: Color.fromARGB(255, 230, 230, 230),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.maps_home_work_outlined,
                              color: Colors.blue,
                            ),
                            hintText: 'Accomodation Name'),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: contactDetails,
                        decoration: InputDecoration(
                            focusColor: Colors.blue,
                            fillColor: Color.fromARGB(255, 230, 230, 230),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.phone_enabled_sharp,
                              color: Colors.blue,
                            ),
                            hintText: 'Contact details'),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        LandlordFurtherRegistration(
                                          password: passwordController.text,
                                          contactDetails: contactDetails.text,
                                          isLandlord: widget.isLandlord,
                                          accomodationName:
                                              accomodationName.text,
                                          landlordEmail: emailController.text,
                                        ))));
                            print(
                              widget.isLandlord,
                            );
                          });
                        },
                        child: Text(
                          widget.isLandlord ? 'Create account' : 'Continue',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.blue),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue),
                            minimumSize: MaterialStatePropertyAll(
                                Size(buttonWidth, 50))),
                      )
                    ]),
                  ),
                ),
              ),
      ),
    );
  }
}
