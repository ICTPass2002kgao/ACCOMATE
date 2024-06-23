// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:api_com/UpdatedApp/Apply-Accomodation.dart';
import 'package:api_com/UpdatedApp/CreateAnAccount.dart';
import 'package:api_com/UpdatedApp/LandlordPage.dart';
import 'package:api_com/UpdatedApp/accomodation_page.dart';
import 'package:api_com/UpdatedApp/admin-page.dart';
import 'package:api_com/UpdatedApp/either_landlord_or_student.dart';
import 'package:api_com/UpdatedApp/help-page.dart';
import 'package:api_com/UpdatedApp/initial_page.dart';
import 'package:api_com/UpdatedApp/login_page.dart';
import 'package:api_com/UpdatedApp/student_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: 'AIzaSyBMr012JjG5bXxnGKpRqt8H0beX7GLIdB4',
    authDomain: 'accomodationapp-9d851.firebaseapp.com',
    projectId: 'accomodationapp-9d851',
    storageBucket: 'accomodationapp-9d851.appspot.com',
    messagingSenderId: '1088298291155',
    appId: '1:1088298291155:android:61a70167a445cb5f61a926',
  ));
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: StartPage(),
      routes: {
        '/login': (context) => LoginPage(
              userRole: '',
              guest: false,
            ),
        '/landlordPage': (context) => LandlordPage(),
        '/studentPage': (context) => StudentPage(),
        '/adminPage': (context) => AdminPage(),
        '/helpCenter': (context) => HelpPage(),
        '/studentRegistration': (context) => StudentOrLandlord(
              isLandlord: false,
              guest: false,
            ),
        '/CreateAccountPage': (context) => RegistrationOption(),
        '/startPage': (context) => StartPage(),
      },
    );
  }
}
