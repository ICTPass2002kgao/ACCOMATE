//ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'login_page.dart';

class CodeVerificationPage extends StatefulWidget {
  final String email;
  final String name;
  final String password;
  final String surname;
  final String gender;
  final String university;
  final String contactDetails;
  final bool isLandlord;
  final String verificationCode;
  final bool isGuest;

  const CodeVerificationPage({
    super.key,
    required this.isLandlord,
    required this.email,
    required this.verificationCode,
    required this.name,
    required this.password,
    required this.surname,
    required this.gender,
    required this.university,
    required this.contactDetails,
    required this.isGuest,
  });

  @override
  State<CodeVerificationPage> createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
  String formattedDate = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> checkStudentValues() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator(color: Colors.blue));
        },
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );

      String userId = userCredential.user!.uid;
      String? user = FirebaseAuth.instance.currentUser!.email;

      DateTime now = DateTime.now();
      Timestamp registeredDate = Timestamp.fromDate(now);

      await FirebaseFirestore.instance.collection('Students').doc(userId).set({
        'name': widget.name,
        'surname': widget.surname,
        'email': user,
        'university': widget.university,
        'contactDetails': widget.contactDetails,
        'userId': userId,
        'gender': widget.gender,
        'roomType': '',
        'fieldOfStudy': '',
        'periodOfStudy': '',
        'registeredDate': registeredDate,
        'appliedAccomodation': false,
        'applicationReviewed': false,
        'isRegistered':false,
        'registeredResidence':''
      });

      sendEmail(
          widget.email,
          'Successful account',
          widget.gender == 'Male'
              ? 'Hello Mr ${widget.surname},\nYour account has been registered successfully. Please proceed to login.\n\nBest Regards,\nYours Accomate'
              : 'Hello Mrs ${widget.surname},\nYour account has been registered successfully. Please proceed to login.\n\nBest Regards,\nYours Accomate');

      Navigator.pop(context);
      
    Navigator.of(context).pop();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 30), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, '/studentPage');
          }
        });

        return Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.blue[50],
            ),
            height: 360,
            width: 300,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Lottie.network(
                      repeat: false,
                      'https://lottie.host/7b0dcc73-3274-41ef-a3f3-5879cade8ffa/zCbLIAPAww.json',
                      height: 250,
                      width: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50)),
                            height: 100,
                            width: 100,
                            color: Colors.green,
                            child: Center(
                              child: Icon(
                                Icons.done,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Submitted successfully',
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 20,
                        color: Colors.green),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop(); 
                        if (widget.isGuest == true) 
        Navigator.pushReplacementNamed(context, '/studentPage');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(userRole: 'Student', guest: false,)),
      );
                      },
                      child: Text('Done'),
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                          backgroundColor: WidgetStatePropertyAll(Colors.blue),
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                          minimumSize: WidgetStatePropertyAll(Size(200, 50))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  

     
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          title: Text('Registration Error',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          content: Text(e.message.toString()),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Retry'),
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
                backgroundColor: WidgetStatePropertyAll(Colors.red),
              ),
            ),
          ],
        ),
      );
    }
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

  Future<void> checkDeviceDate(BuildContext context) async {
    final serverTime = await getServerTime();
    if (serverTime == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'Unable to fetch server time. Please check your internet connection.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final deviceTime = DateTime.now();
    final difference = deviceTime.difference(serverTime).inMinutes;

    if (difference.abs() > 5) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Incorrect Date/Time'),
          content: Text(
              'Your device date and time are incorrect. Please set the correct date and time.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      print('Device date and time are correct.');
    }
  }

  Future<DateTime?> getServerTime() async {
    try {
      final response =
          await http.get(Uri.parse('http:worldtimeapi.org/api/ip'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final dateTimeString = data['utc_datetime'];
        return DateTime.parse(dateTimeString);
      } else {
        print('Failed to load server time');
        return null;
      }
    } catch (e) {
      print('Error fetching server time: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 450;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Page (2/2)'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        color: Colors.blue[100],
        width: buttonWidth,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                              const Color.fromARGB(255, 15, 76, 167),
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
                Text(
                  'Hi ${widget.name}, please note that we have sent a verification email to ${maskEmail(widget.email)}.',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Change Email?',
                    style: TextStyle(
                      decorationThickness: 0.5,
                      decorationColor: Colors.blue,
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => SizedBox(
                      width: 50,
                      child: TextField(
                        controller: otpControllers[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        onChanged: (value) {
                          if (index < 5 && value.isNotEmpty) {
                            FocusScope.of(context).nextFocus();
                          } else if (index > 0 && value.isEmpty) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        decoration: InputDecoration(
                          counterText: '',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        String generateRandomCode() {
                          final random = Random();
                          return '${random.nextInt(999999).toString().padLeft(6, '0')}';
                        }

                        String verificationCode = generateRandomCode();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.blue,
                          content: Text('Verification code sent',
                              style: TextStyle(color: Colors.white)),
                        ));

                        sendEmail(
                          widget.email,
                          'Verification Code',
                          widget.gender == 'Male'
                              ? 'Hello Mr ${widget.surname},\nWe are aware that you are trying to register your account on Accomate App.\nHere is your verification code: $verificationCode'
                              : 'Hello Mrs ${widget.surname},\nWe are aware that you are trying to register your account on Accomate App.\nHere is your verification code: $verificationCode',
                        );
                      },
                      child: Text(
                        'Resend code',
                        style: TextStyle(
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String enteredOTP = otpControllers
                        .map((controller) => controller.text)
                        .join('');

                    if (enteredOTP == widget.verificationCode) {
                      checkStudentValues();
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Error'),
                          content: Text(
                              'Incorrect verification code. Please try again.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                    backgroundColor: WidgetStatePropertyAll(Colors.blue),
                    minimumSize: WidgetStatePropertyAll(Size(buttonWidth, 50)),
                  ),
                  child: Text(
                    'Confirm Account',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
