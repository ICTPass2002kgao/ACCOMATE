// ignore_for_file: prefer_const_constructors
import 'package:api_com/UpdatedApp/LandlordPage.dart';
import 'package:api_com/UpdatedApp/login_page.dart';
import 'package:api_com/UpdatedApp/student_page.dart';
import 'package:api_com/userData.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ResData()),
        ChangeNotifierProvider(create: (context) => UserData()),
        ChangeNotifierProvider(create: (context) => ButtonStateProvider())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/LandlordPage': (context) => LandlordPage(),
        '/studentPage': (context) => StudentPage(),
        // '/studentRegistration': (context) => StudentRegistrationPage(),
        // '/contactInfo': (context) => ContactInfoPage(),
      },
    );
  }
}
