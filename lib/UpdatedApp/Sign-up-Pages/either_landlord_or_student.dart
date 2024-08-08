// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, sized_box_for_whitespace, sort_child_properties_last, unnecessary_brace_in_string_interps, unnecessary_string_interpolations

import 'dart:math';

import 'package:api_com/UpdatedApp/StudentPages/textfield.dart';
import 'package:api_com/UpdatedApp/StudentPages/VerifyEmail.dart';
import 'package:api_com/UpdatedApp/Sign-up-Pages/landlordFurntherRegistration.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
// import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:page_transition/page_transition.dart';
import 'package:text_field_validation/text_field_validation.dart';

class StudentOrLandlord extends StatefulWidget {
  const StudentOrLandlord(
      {super.key, required this.isLandlord, required this.guest});
  final bool isLandlord;
  final bool guest;

  @override
  State<StudentOrLandlord> createState() => _StudentOrLandlordState();
}

class _StudentOrLandlordState extends State<StudentOrLandlord> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController CpasswordController = TextEditingController();
  final TextEditingController accomodationName = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    selectedUniversity = 'Vaal University of Technology';

    nameController.addListener(() {
      String nameText = nameController.text;

      if (nameText.isNotEmpty && nameText[nameText.length - 1] == ' ') {
        nameController.text = nameText.trim();
        nameController.selection = TextSelection.fromPosition(
            TextPosition(offset: nameController.text.length));
      }
    });
    CpasswordController.addListener(() {
      String nameText = CpasswordController.text;

      if (nameText.isNotEmpty && nameText[nameText.length - 1] == ' ') {
        CpasswordController.text = nameText.trim();
        CpasswordController.selection = TextSelection.fromPosition(
            TextPosition(offset: CpasswordController.text.length));
      }
    });
    surnameController.addListener(() {
      String nameText = surnameController.text;

      if (nameText.isNotEmpty && nameText[nameText.length - 1] == ' ') {
        surnameController.text = nameText.trim();
        surnameController.selection = TextSelection.fromPosition(
            TextPosition(offset: surnameController.text.length));
      }
    });
    emailController.addListener(() {
      String nameText = emailController.text;
      if (nameText.isNotEmpty && nameText[nameText.length - 1] == ' ') {
        emailController.text = nameText.trim();
        emailController.selection = TextSelection.fromPosition(
            TextPosition(offset: emailController.text.length));
      }
    });
    passwordController.addListener(() {
      String nameText = passwordController.text;

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

    CpasswordController.dispose();
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
    if (!kIsWeb) {
      final smtpServer = gmail('accomate33@gmail.com', 'nhle ndut leqq baho');
      final message = Message()
        ..from = Address('accomate33@gmail.com', 'Accomate')
        ..recipients.add(recipientEmail)
        ..subject = subject
        ..html = body;

      try {
        await send(message, smtpServer);
        print('Email sent successfully');
      } catch (e) {
        print('Error sending email: $e');
      }
    } else {
      try {
        final result = await sendEmailCallable.call({
          'to': recipientEmail,
          'subject': subject,
          'body': body,
        });
        print(result.data);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  final HttpsCallable sendEmailCallable =
      FirebaseFunctions.instance.httpsCallable('sendEmail');

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
    String _generateRandomCode() {
      final random = Random();
      return '${random.nextInt(999999).toString().padLeft(6, '0')}';
    }

    String verificationCode = _generateRandomCode();

    kIsWeb? sendEmail(
                          emailController.text,
                          'Verification Code',
                          selectedGender == 'Male'
                              ? 'Hello Mr ${surnameController.text},\nWe are aware that you are trying to register your account on Accomate App.\nHere is your verification code: $verificationCode'
                              : 'Hello Mrs ${surnameController.text},\nWe are aware that you are trying to register your account on Accomate App.\nHere is your verification code: $verificationCode',
                        ):
                         sendEmail(
                          emailController.text,
                          'Verification Code',
                          selectedGender == 'Male'
                              ? '''<p>Hello Mr ${surnameController.text},<br/>We are aware that you are trying to register your account on Accomate App.<br/>Here is your verification code: $verificationCode</p>'''
                              : '''<p>Hello Mrs ${surnameController.text},<br/>We are aware that you are trying to register your account on Accomate App.<br/>Here is your verification code: $verificationCode</p>''',
                        ); 
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

                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child:CodeVerificationPage(
                            email: emailController.text,
                            verificationCode: verificationCode,
                            name: nameController.text,
                            surname: surnameController.text,
                            university: selectedUniversity,
                            gender: selectedGender,
                            password: passwordController.text,
                            contactDetails: phoneNumber,
                            isLandlord: widget.isLandlord,
                            isGuest: widget.guest)));
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
  }

  void checkLandlordValues() {
    print(emailController.text);
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
      backgroundColor: Colors.blue[100],
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
      body: Center(
        child: Container(
          width: buttonWidth,
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
                          Form(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            key: _formKey,
                            child: Column(
                              children: [
                                AuthTextField(
                                  icon: Icons.person,
                                  placeholder: 'Name',
                                  controller: nameController,
                                  onValidate: (value) =>
                                      TextFieldValidation.name(value!),
                                ),
                                SizedBox(height: 8),
                                AuthTextField(
                                  icon: Icons.person,
                                  placeholder: 'Surname',
                                  controller: surnameController,
                                  onValidate: (value) => TextFieldValidation.name(
                                      value!,
                                      textResponse: TextValidateResponse(
                                          empty: 'Surname is required',
                                          invalid:
                                              'Surname cannot have less than 3 chararacters')),
                                ),
                                SizedBox(height: 8),
                                AuthTextField(
                                  placeholder: 'Email',
                                  controller: emailController,
                                  onValidate: (value) =>
                                      TextFieldValidation.email(value!),
                                  icon: Icons.mail_outline_outlined,
                                ),
                                SizedBox(height: 8),
                                AuthTextField(
                                  visible: _obscureText,
                                  placeholder: 'Password',
                                  controller: passwordController,
                                  onValidate: (value) =>
                                      TextFieldValidation.strictPassword(value!,
                                          textResponse: TextValidateResponse(
                                              empty: 'Password is required',
                                              invalid:
                                                  'Password should contain special character(!@#\$%^&*)\nNumbers(1234567890)\nUpperCase Chars(A-Z)\nLowerCase Chars(a-z)')),
                                  icon: Icons.password,
                                ),
                                SizedBox(height: 8),
                                AuthTextField(
                                    icon: Icons.password,
                                    visible: _obscureText,
                                    placeholder: 'Confirm password',
                                    controller: CpasswordController,
                                    onValidate: (value) =>
                                        TextFieldValidation.strictPassword(value!,
                                            textResponse: TextValidateResponse(
                                                empty: 'Password is required',
                                                invalid:
                                                    'Password does not match!'))),
                                SizedBox(height: 8),
                                IntlPhoneField(
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
                                ),
                                SizedBox(height: 8),
                                ExpansionTile(
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
                                SizedBox(height: 8),
                                ExpansionTile(
                                  title: Text('Select Gender'),
                                  children: gender.map((gender) {
                                    return RadioListTile<String>(
                                      title: Text(gender),
                                      value: gender,
                                      groupValue: selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedGender = value!;
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 20),
                                TextButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate() &&
                                        _phoneController.text.length == 9 &&
                                        _phoneController.text.length == 9 &&selectedGender!='') {
                                      if (CpasswordController.text ==
                                          passwordController.text) {
                                        checkStudentValues();
                                      } else {
                                        showError('Password does not Match');
                                      }
                                    } else {
                                      showError(
                                          'Cannot continue without the correct inputs and make sure that the gender is selected');
                                    }
                                  },
                                  child: Text(
                                    'Continue',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  style: ButtonStyle(
                                      shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                      foregroundColor:
                                          WidgetStatePropertyAll(Colors.blue),
                                      backgroundColor:
                                          WidgetStatePropertyAll(Colors.blue),
                                      minimumSize: WidgetStatePropertyAll(
                                          Size(buttonWidth, 50))),
                                ),
                              ],
                            ),
                          ),
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
                          Form(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            key: _formKey,
                            child: Column(
                              children: [
                                AuthTextField(
                                  icon: Icons.person,
                                  placeholder: 'Email',
                                  controller: emailController,
                                  onValidate: (value) =>
                                      TextFieldValidation.email(value!),
                                ),
                                SizedBox(height: 8),
                                AuthTextField(
                                  icon: Icons.password_rounded,
                                  visible: _obscureText,
                                  placeholder: 'Password',
                                  controller: passwordController,
                                  onValidate: (value) =>
                                      TextFieldValidation.strictPassword(value!,
                                          textResponse: TextValidateResponse(
                                              empty: 'Password is required',
                                              invalid:
                                                  'Password should have special character(!@#\$%^&*)\nNumbers(1234567890)\nUpperCase Chars(A-Z)\nLowerCase Chars(a-z)')),
                                ),
                                SizedBox(height: 8),
                                AuthTextField(
                                    icon: Icons.password_rounded,
                                    visible: _obscureText,
                                    placeholder: 'Confirm password',
                                    controller: CpasswordController,
                                    onValidate: (value) =>
                                        TextFieldValidation.strictPassword(value!,
                                            textResponse: TextValidateResponse(
                                                empty: 'Password is required',
                                                invalid: passwordController
                                                            .text !=
                                                        CpasswordController.text
                                                    ? 'Password does not match!'
                                                    : 'Password does not match!'))),
                                SizedBox(height: 8),
                                AuthTextField(
                                  placeholder: 'Residence Name',
                                  controller: accomodationName,
                                  onValidate: (value) => TextFieldValidation.name(
                                      value!,
                                      textResponse: TextValidateResponse(
                                          empty: 'Residence name required',
                                          invalid:
                                              'Please provide the Residence name')),
                                  icon: Icons.home_work,
                                ),
                                SizedBox(height: 8),
                                IntlPhoneField(
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
                                ),
                                SizedBox(height: 10),
                                TextButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate() &&
                                        _phoneController.text.length == 9) {
                                      if (CpasswordController.text ==
                                          passwordController.text) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    LandlordFurtherRegistration(
                                                      password:
                                                          passwordController.text,
                                                      contactDetails: phoneNumber,
                                                      isLandlord:
                                                          widget.isLandlord,
                                                      accomodationName:
                                                          accomodationName.text,
                                                      landlordEmail:
                                                          emailController.text,
                                                    ))));
                                      } else {
                                        showError('Password does not Match');
                                      }
                                    } else {
                                      showError(
                                          'Cannot continue without the correct inputs');
                                    }
                                  },
                                  child: Text(
                                    'Continue',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  style: ButtonStyle(
                                      shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                      foregroundColor:
                                          WidgetStatePropertyAll(Colors.blue),
                                      backgroundColor:
                                          WidgetStatePropertyAll(Colors.blue),
                                      minimumSize: WidgetStatePropertyAll(
                                          Size(buttonWidth, 50))),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
