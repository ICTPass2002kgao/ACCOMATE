// ignore_for_file: prefer_const_constructors

import 'package:api_com/accomodation_page.dart';
import 'package:api_com/global_variables.dart';
import 'package:api_com/login_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme.highContrastLight(background: Colors.white70)
        
      ),
      home:  AccomodationPage(
        residenceDetails:residencesCard[0]
      )
    );
  }
}
 