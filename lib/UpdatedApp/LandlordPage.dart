// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:api_com/LandlordDetails/LandlordRegistration.dart';
import 'package:api_com/UpdatedApp/StudentPages/PeersonalPage.dart';
import 'package:api_com/UpdatedApp/LandlordPages/Home.dart';
import 'package:api_com/UpdatedApp/LandlordPages/Messages.dart';
import 'package:api_com/userData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandlordPage extends StatefulWidget {
  const LandlordPage({super.key});

  @override
  State<LandlordPage> createState() => _LandlordPageState();
}

class _LandlordPageState extends State<LandlordPage> {
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
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(
                    context, '/login'); // navigate to login page
              },
            ),
          ],
        );
      },
    );
  }

  void openRegistrationPage() {
    setState(() {
      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => LandlordRegistration())));
      print('add details');
    });
  }

  int _currentIndex = 0;
  List screens = [HomePage(), Messages(), PersonalPage()];

  @override
  Widget build(BuildContext context) {
    final buttonStateProvider = Provider.of<ButtonStateProvider>(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Hi Landlord'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: buttonStateProvider.buttonState.isButtonEnabled
            ? () {
                openRegistrationPage();
              }
            : null,
        child: Icon(Icons.add),
      ),
      drawer: Drawer(
          backgroundColor: Colors.blue,
          child: ListView(
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
                  setState(() {
                    _showLogoutConfirmationDialog(context);
                  });
                },
                textColor: Colors.white,
              )
            ],
          )),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue,
          currentIndex: _currentIndex,
          unselectedItemColor: Colors.white70,
          selectedItemColor: Colors.white,
          onTap: (value) {
            setState(() {
              _currentIndex = value;
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
    );
  }
}
