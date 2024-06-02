// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, sized_box_for_whitespace, sort_child_properties_last, unnecessary_brace_in_string_interps, unnecessary_string_interpolations

import 'dart:math';

import 'package:api_com/UpdatedApp/VerifyEmail.dart';
import 'package:api_com/UpdatedApp/landlordFurntherRegistration.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
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
  final TextEditingController accomodationName = TextEditingController();
  final TextEditingController distanceController = TextEditingController();

  @override
  void initState() {
    super.initState();

    selectedUniversity = 'Vaal University of Technology';
    // Listen to changes in the TextField
    nameController.addListener(() {
      // Get the current text
      String nameText = nameController.text;

      // If the last character is a space, remove it
      if (nameText.isNotEmpty && nameText[nameText.length - 1] == ' ') {
        nameController.text = nameText.trim();
        nameController.selection = TextSelection.fromPosition(
            TextPosition(offset: nameController.text.length));
      }
    });
    surnameController.addListener(() {
      // Get the current text
      String nameText = surnameController.text;

      // If the last character is a space, remove it
      if (nameText.isNotEmpty && nameText[nameText.length - 1] == ' ') {
        surnameController.text = nameText.trim();
        surnameController.selection = TextSelection.fromPosition(
            TextPosition(offset: surnameController.text.length));
      }
    });
    emailController.addListener(() {
      // Get the current text
      String nameText = emailController.text;

      // If the last character is a space, remove it
      if (nameText.isNotEmpty && nameText[nameText.length - 1] == ' ') {
        emailController.text = nameText.trim();
        emailController.selection = TextSelection.fromPosition(
            TextPosition(offset: emailController.text.length));
      }
    });
    accomodationName.addListener(() {
      // Get the current text
      String nameText = accomodationName.text;

      // If the last character is a space, remove it
      if (nameText.isNotEmpty && nameText[nameText.length - 1] == ' ') {
        accomodationName.text = nameText.trim();
        accomodationName.selection = TextSelection.fromPosition(
            TextPosition(offset: accomodationName.text.length));
      }
    });
    passwordController.addListener(() {
      // Get the current text
      String nameText = passwordController.text;

      // If the last character is a space, remove it
      if (nameText.isNotEmpty && nameText[nameText.length - 1] == ' ') {
        passwordController.text = nameText.trim();
        passwordController.selection = TextSelection.fromPosition(
            TextPosition(offset: passwordController.text.length));
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    accomodationName.dispose();
    super.dispose();
  }

  String phoneNumber = '';
  final TextEditingController _phoneController = TextEditingController();
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
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
                backgroundColor: WidgetStatePropertyAll(Colors.red[300]),
                minimumSize: WidgetStatePropertyAll(Size(300, 50))),
          ),
        ],
      ),
    );
  }

  Future<void> sendEmail(
      String recipientEmail, String subject, String body) async {
    final smtpServer = gmail('accomate33@gmail.com', 'nhle ndut leqq baho');
    final message = Message()
      ..from = Address('accomate33@gmail.com', 'Accomate Team')
      ..recipients.add(recipientEmail)
      ..subject = subject
      ..html = body;

    try {
      await send(message, smtpServer);
      print('Email sent successfully');
    } catch (e) {
      print('Error sending email: $e');
    }
  }

  String maskEmail(String email) {
    final emailParts = email.split('@');
    if (emailParts.length != 2) return email;

    final domain = emailParts[1];
    final local = emailParts[0];
    if (local.length <= 3) {
      return '***@$domain';
    }

    final maskedLocal =
        local.substring(0, local.length - 3).replaceAll(RegExp('.'), '*') +
            local.substring(local.length - 3);
    return '$maskedLocal@$domain';
  }

  void checkStudentValues() {
    String email = emailController.text;
    String contacts = _phoneController.text;
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
    if (_phoneController.text == '') {
      showError('Please make sure you fill in all the required details');
    } else if (contacts.length != 9) {
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
                ? 'Hello Mr ${surnameController.text},\nA verification code have been sent to ${maskEmail(emailController.text)} provide the codes to proceed'
                : 'Hello Mrs ${surnameController.text},\nA verification code have been sent to ${maskEmail(emailController.text)} provide the codes to proceed'),
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
                                  contactDetails: phoneNumber,
                                  isLandlord: widget.isLandlord,
                                ))));
                  },
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                    backgroundColor: WidgetStatePropertyAll(Colors.blue),
                  )),
            ],
          ),
        );
      });
    }
  }

  void checkLandlordValues() {
    String email = emailController.text;
    String contacts = _phoneController.text;
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
    if (_phoneController.text == '') {
      showError('Please make sure you fill in all the required details');
    } else if (contacts.length != 9) {
      showError('Please make sure the contacts are correct');
    } else if (contacts.length != 9) {
      showError('Please make sure the contacts are correct');
    } else {
      setState(() {
        Navigator.of(context).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => LandlordFurtherRegistration(
                      password: passwordController.text,
                      contactDetails: phoneNumber,
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
          child: !widget.isLandlord
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
                                labelText: 'Name'),
                          ),
                        ),
                        SizedBox(height: 8),
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
                                labelText: 'Surname'),
                          ),
                        ),
                        SizedBox(height: 8),
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
                                labelText: 'Email account'),
                          ),
                        ),
                        SizedBox(height: 8),
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
                                labelText: 'Password'),
                            obscureText: _obscureText,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                            width: buttonWidth,
                            child: IntlPhoneField(
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
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
                              ),
                              initialCountryCode: 'ZA',
                              onChanged: (phone) {
                                setState(() {
                                  phoneNumber = phone.completeNumber;
                                });
                              },
                              controller: _phoneController,
                            )),
                        SizedBox(height: 8),
                        Container(
                          width: buttonWidth,
                          child: ExpansionTile(
                            title: Text('Select University'),
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
                        SizedBox(height: 8),
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
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              foregroundColor:
                                  WidgetStatePropertyAll(Colors.blue),
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.blue),
                              minimumSize: WidgetStatePropertyAll(
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
                                labelText: 'Email'),
                          ),
                        ),
                        SizedBox(height: 8),
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
                                labelText: 'Password'),
                            obscureText: _obscureText,
                          ),
                        ),
                        SizedBox(height: 8),
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
                              labelText: 'Accomodation Name'),
                        ),
                        SizedBox(height: 8),
                        Container(
                            width: buttonWidth,
                            child: IntlPhoneField(
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              initialCountryCode: 'ZA',
                              onChanged: (phone) {
                                setState(() {
                                  if (phone.isValidNumber()) {
                                    phoneNumber = phone.completeNumber;
                                  }
                                });
                              },
                              controller: _phoneController,
                            )),
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
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              foregroundColor:
                                  WidgetStatePropertyAll(Colors.blue),
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.blue),
                              minimumSize: WidgetStatePropertyAll(
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
