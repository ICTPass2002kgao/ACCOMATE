// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, sort_child_properties_last, use_function_type_syntax_for_parameters

import 'package:api_com/Pages/HomePage.dart';
import 'package:api_com/Pages/MessagesPage.dart';
import 'package:api_com/Pages/NotificationPage.dart';
import 'package:api_com/Pages/PeersonalPage.dart';
import 'package:api_com/login_page.dart';

import 'package:flutter/material.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    Icon(Icons.warning_outlined, color: Colors.red, size: 40),
                    SizedBox(width: 10),
                    Text('Are you sure you want to logout?'),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                // Perform logout logic here
                // ...
                Navigator.of(context).pop(); // Close the dialog

                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => LoginPage())));

                // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  int _index = 0;
  List screens = [
    HomePage(),
    MessagesPage(),
    NotificationPage(),
    PersonalPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Hi Student'),
          centerTitle: true,
          backgroundColor: Colors.blue,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded))
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _index,
            unselectedItemColor: Colors.white54,
            selectedItemColor: Colors.white,
            onTap: (value) {
              setState(() {
                _index = value;
              });
            },
            items: [
              BottomNavigationBarItem(
                backgroundColor: Colors.blue,
                icon: Icon(Icons.home_outlined, size: 30),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.blue,
                icon: Icon(Icons.notifications_active_outlined, size: 30),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.blue,
                icon: Icon(Icons.message_outlined, size: 30),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.blue,
                icon: Icon(
                  Icons.person_outlined,
                  size: 30,
                ),
                label: 'Personal account',
              )
            ]),
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Icon(
                  Icons.settings,
                  size: 100,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 50,
                ),
                ListTile(
                  leading: Icon(Icons.policy_outlined, color: Colors.white),
                  title: Text('Terms & conditions'),
                  onTap: () {},
                  textColor: Colors.white,
                ),
                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  title: Text('More Info'),
                  onTap: () {},
                  textColor: Colors.white,
                ),
                ListTile(
                  leading: Icon(Icons.logout_outlined, color: Colors.white),
                  title: Text('Logout'),
                  onTap: () {
                    _showLogoutConfirmationDialog(context);
                  },
                  textColor: Colors.white,
                )
              ],
            ),
          ),
          backgroundColor: Colors.blue,
        ),
        body: screens[_index]);
  }
}
