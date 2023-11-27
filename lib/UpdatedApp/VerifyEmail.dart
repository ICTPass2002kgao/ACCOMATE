// ignore_for_file: prefer_const_constructors

import 'package:api_com/UpdatedApp/student_page.dart';
import 'package:flutter/material.dart';

class CodeVerificationPage extends StatefulWidget {
  final bool isLandlord;
  final String email;
  final String verificationCode;

  CodeVerificationPage(
      {required this.isLandlord,
      required this.email,
      required this.verificationCode});

  @override
  State<CodeVerificationPage> createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController codeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Code Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: codeController,
              decoration: InputDecoration(labelText: 'Enter Verification Code'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String enteredCode = codeController.text;

                if (enteredCode == widget.verificationCode) {
                  // Code is correct, navigate to the home page based on the user's role
                  if (!widget.isLandlord) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentPage(),
                      ),
                    );
                  }
                } else {
                  // Incorrect code, show an error message
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Incorrect Code'),
                      content: Text(
                          'The entered verification code is incorrect. Please try again.'),
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
              child: Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
