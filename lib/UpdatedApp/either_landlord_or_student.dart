// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, sized_box_for_whitespace, sort_child_properties_last, unnecessary_brace_in_string_interps, unnecessary_string_interpolations

import 'dart:math';

import 'package:api_com/UpdatedApp/VerifyEmail.dart';
import 'package:api_com/UpdatedApp/landlordFurntherRegistration.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

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
  void showError(String val) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Text('Missing information',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        content: Text(val),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Retry'),
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
                foregroundColor: MaterialStatePropertyAll(Colors.white),
                backgroundColor: MaterialStatePropertyAll(Colors.red[300]),
                minimumSize: MaterialStatePropertyAll(Size(300, 50))),
          ),
        ],
      ),
    );
  }

  final HttpsCallable sendEmailCallable =
      FirebaseFunctions.instance.httpsCallable('sendEmail');

  Future<void> sendEmail(String to, String subject, String body) async {
    try {
      final result = await sendEmailCallable.call({
        'to': to,
        'subject': subject,
        'body': body,
      });
      print(result.data);
    } catch (e) {}
  }

  void checkStudentValues() {
    String email = emailController.text;
    String contacts = contactDetails.text;
    String password = passwordController.text;
    if (nameController.text == '') {
      showError('Please make sure you fill in all the required details');
    } else if (surnameController.text == '') {
      showError('Please make sure you fill in all the required details');
    } else if (emailController.text == '') {
      showError('Please make sure you fill in all the required details');
    } else if (passwordController.text == '') {
      showError('Please make sure you fill in all the required details');
    } else if (password.length < 8) {
      showError('Please make sure the length of your password is 8 or more');
    }
    if (email.contains('@gmail.com')) {
      print('everything is well');
    } else {
      showError(
          'Invalid email, Please make sure the email is in a correct format');
    }
    if (email.contains('@edu.vut.ac.za')) {
      print('everything is well');
    } else {
      showError(
          'Invalid email, Please make sure the email is in a correct format');
    }
    if (contactDetails.text == '') {
      showError('Please make sure you fill in all the required details');
    } else if (contacts.length != 10) {
      showError('Please make sure the contacts are correct');
    } else {
      String _generateRandomCode() {
        final random = Random();
        // Generate a random 6-digit code
        return '${random.nextInt(999999).toString().padLeft(6, '0')}';
      }

      String verificationCode = _generateRandomCode();

      sendEmail(
          emailController.text, // Student's email
          'Verification Code',
          selectedGender == 'Male'
              ? 'Hello Mr ${surnameController.text},\nWe are aware that you are trying to register your account with accomate\nHere  is your verification code:  $verificationCode\n\n\n\n\n\n\n\nBest Regards\nYours Accomate'
              : 'Hello Mrs ${surnameController.text},\nWe are aware that you are trying to register your account with accomate\nHere  is your verification code: $verificationCode\n\n\n\n\n\n\n\nBest Regards\nYours Accomate');

      setState(() {
        Navigator.of(context).pop();
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.blue[100],
            title: Text(
              'Verification Email Sent',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            icon: Icon(Icons.verified_user_rounded, size: 50),
            iconColor: Colors.blue,
            content: Text(selectedGender == 'Male'
                ? 'Hello Mr ${surnameController.text},\nA verification code have been sent to ${emailController.text} provide the codes to proceed'
                : 'Hello Mrs ${surnameController.text},\nA verification code have been sent to ${emailController.text} provide the codes to proceed'),
            actions: [
              OutlinedButton(
                  child: Text('Verify'),
                  onPressed: () async {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => CodeVerificationPage(
                                  email: emailController.text,
                                  verificationCode: verificationCode,
                                  name: nameController.text,
                                  surname: surnameController.text,
                                  university: selectedUniversity,
                                  gender: selectedGender,
                                  password: passwordController.text,
                                  contactDetails: contactDetails.text,
                                  isLandlord: widget.isLandlord,
                                ))));
                  },
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                  )),
            ],
          ),
        );
      });
    }
  }

  void checkLandlordValues() {
    String email = emailController.text;
    String contacts = contactDetails.text;
    String password = passwordController.text;
    if (emailController.text == '') {
      showError('Please make sure you fill in all the required details');
    } else if (passwordController.text == '') {
      showError('Please make sure you fill in all the required details');
    } else if (password.length < 8) {
      showError('Please make sure the length of your password is 8 or more');
    } else if (email.contains('@gmail.com')) {
      print('everything is well');
    } else {
      showError(
          'Invalid email, Please make sure the email is in a correct format');
    }
    if (email.contains('@edu.vut.ac.za')) {
      print('everything is well');
    } else {
      showError(
          'Invalid email, Please make sure the email is in a correct format');
    }
    if (contactDetails.text == '') {
      showError('Please make sure you fill in all the required details');
    } else if (contacts.length != 10) {
      showError('Please make sure the contacts are correct');
    } else if (contacts.length != 10) {
      showError('Please make sure the contacts are correct');
    } else {
      setState(() {
        Navigator.of(context).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => LandlordFurtherRegistration(
                      password: passwordController.text,
                      contactDetails: contactDetails.text,
                      isLandlord: widget.isLandlord,
                      accomodationName: accomodationName.text,
                      landlordEmail: emailController.text,
                    ))));
      });
    }
  }

  bool _obscureText = true;
  String selectedUniversity = '';

  List<String> universities = [
    'Vaal University of Technology',
    'North West University(vaal campus)',
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

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 400;
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        foregroundColor: Colors.white,
        title: Text(
            widget.isLandlord
                ? 'Landlord Registration(1/3)'
                : 'Student Registration(1/2)',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        color: Colors.blue[100],
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: !widget.isLandlord //This is for student
              ? SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Center(
                    child: Container(
                      width: buttonWidth,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(105),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      const Color.fromARGB(255, 187, 222, 251),
                                      Colors.blue,
                                      const Color.fromARGB(255, 15, 76, 167)
                                    ],
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.asset(
                                      'assets/icon.jpg',
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: buttonWidth,
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusColor: Colors.blue,
                                fillColor: Colors.blue[50],
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
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusColor: Colors.blue,
                                fillColor: Colors.blue[50],
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
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusColor: Colors.blue,
                                fillColor: Colors.blue[50],
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.blue,
                                ),
                                hintText: 'Email account'),
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          width: buttonWidth,
                          child: TextField(
                            controller: passwordController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusColor: Colors.blue,
                                fillColor: Colors.blue[50],
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
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          width: buttonWidth,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: contactDetails,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusColor: Colors.blue,
                                fillColor: Colors.blue[50],
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
                            title: Text('Select Gender',
                                style: TextStyle(
                                    color: selectedGender.isEmpty
                                        ? Colors.red
                                        : Colors.black)),
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
                            checkStudentValues();
                          },
                          child: Text(
                            'Continue',
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
                        ),
                        SizedBox(height: 20.0),
                      ]),
                    ),
                  ),
                )

              //User registering as a landlord
              : SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Center(
                    child: Container(
                      width: buttonWidth,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(105),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      const Color.fromARGB(255, 187, 222, 251),
                                      Colors.blue,
                                      const Color.fromARGB(255, 15, 76, 167)
                                    ],
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.asset(
                                      'assets/icon.jpg',
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: buttonWidth,
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusColor: Colors.blue,
                                fillColor: Colors.blue[50],
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
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusColor: Colors.blue,
                                fillColor: Colors.blue[50],
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
                          ),
                        ),
                        SizedBox(height: 5),
                        TextField(
                          controller: accomodationName,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusColor: Colors.blue,
                              fillColor: Colors.blue[50],
                              filled: true,
                              prefixIcon: Icon(
                                Icons.maps_home_work_outlined,
                                color: Colors.blue,
                              ),
                              hintText: 'Accomodation Name'),
                        ),
                        SizedBox(height: 5),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: contactDetails,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusColor: Colors.blue,
                              fillColor: Colors.blue[50],
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
                            checkLandlordValues();
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
      ),
    );
  }
}
