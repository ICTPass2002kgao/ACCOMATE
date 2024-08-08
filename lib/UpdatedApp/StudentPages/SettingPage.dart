import 'package:animated_card/animated_card.dart';
import 'package:api_com/UpdatedApp/Accomate%20pages/Functions.dart';
import 'package:api_com/UpdatedApp/Sign-Page/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  TextEditingController messageController = TextEditingController();

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Colors.white,
          title: Text('Logout',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    Icon(Icons.warning_outlined, color: Colors.red, size: 40),
                    SizedBox(width: 10),
                    Expanded(child: Text('Are you sure you want to logout?')),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop();
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    loadData();
    _loadUserData();
  }

  late User? _user;
  Map<String, dynamic>? _userData;

  Future<void> _loadUserData() async {
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('Students')
        .doc(_user?.uid)
        .get();
    setState(() {
      _userData = userDataSnapshot.data() as Map<String, dynamic>?;
    });
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
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => Container(
          height: 350,
          width: 250,
          child: AlertDialog(
            title: Text(
              'Successful Response',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            content: Text(
              e.toString(),
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: Text('okay'),
                style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                    backgroundColor: WidgetStatePropertyAll(Colors.blue),
                    minimumSize:
                        WidgetStatePropertyAll(Size(double.infinity, 50))),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _sendHelpMessage() async {
    try {
      showDialog(
        context: context, // Prevent user from dismissing the dialog
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        },
      );
      String studentUserId = _user!.uid;
      String helpCenterId = 'dWKl2xV0gggWQyQycWm52lS3Hpk1';
      await FirebaseFirestore.instance
          .collection('Help Team')
          .doc(helpCenterId)
          .collection('studentHelpMessage')
          .doc(studentUserId)
          .set({
        'message': messageController.text,
        'userId': studentUserId,
        'email': _userData?['email'] ?? '',
        'name': _userData?['name'] ?? '',
        'surname': _userData?['surname'] ?? '',
      });
      sendEmail(
          'accomatehelpcenter@gmail.com', // help center's email
          'Reported Issue',
          'Goodday Accomate help center officer,\nYou have a there is an issue reported by ${_userData?['surname'] ?? ''} ${_userData?['name'] ?? ''}. \nUser\'s Issue:\n${messageController.text}\n\n\n\n\n\n\n\n\n\nBest Regards\nYours Accomate');

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
                title: Text(
                  'Help Sent successfully',
                  style: TextStyle(fontSize: 15),
                ),
                content: Text(
                    'Accomate help center will try to troubleshoot & solve your reported issue.'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        messageController.text = '';
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text('Done'),
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                          backgroundColor: WidgetStatePropertyAll(Colors.green),
                          minimumSize: WidgetStatePropertyAll(
                              Size(double.infinity, 50)))),
                ],
              ));
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadData() async {
    await Future.delayed(Duration(seconds: 2));
    _loadUserData();
  }

  final TermsAndConditions termsAndConditions = TermsAndConditions();
  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 500;
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Container(
        width: buttonWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.policy_outlined, color: Colors.blue[900]),
                title: Text('Terms & conditions'),
                onTap: () {
                  termsAndConditions.showTermsAndConditions(context);
                },
                textColor: Colors.blue[900],
              ),
              
              SizedBox(height: 5),
              ListTile(
                leading: Icon(Icons.info_outline, color: Colors.blue[900]),
                title: Text('Help Center'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return AnimatedCard(
                          direction: AnimatedCardDirection.bottom,
                          child: AlertDialog(
                            title: Center(
                              child: Text('Contact Us',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.blue)),
                            ),
                            scrollable: true,
                            content: Container(
                              height: 250,
                              child: Column(
                                children: [
                                  Text('We will send feedback soon.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.grey)),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 400,
                                    child: TextField(
                                      maxLines: 6,
                                      controller: messageController,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "Tell us how we can help"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            actions: [
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  messageController.text.isEmpty ||
                                          messageController.text.length < 10
                                      ? showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: Text(
                                                  'Error',
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                content: Text(
                                                    'The issue cannot be resolved'),
                                                actions: <Widget>[
                                                  TextButton(
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Okay'),
                                                      style: ButtonStyle(
                                                          shape: WidgetStatePropertyAll(
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          5))),
                                                          foregroundColor:
                                                              WidgetStatePropertyAll(
                                                                  Colors.blue[
                                                                      900]),
                                                          backgroundColor:
                                                              WidgetStatePropertyAll(
                                                                  Colors.green),
                                                          minimumSize:
                                                              WidgetStatePropertyAll(
                                                                  Size(
                                                                      double
                                                                          .infinity,
                                                                      50)))),
                                                ],
                                              ))
                                      : _sendHelpMessage();
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.blue,
                                ),
                                label: Text(
                                  "Send",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
                textColor: Colors.blue[900],
              ),
             
              SizedBox(height: 5),
               ListTile(
                leading: Icon(Icons.logout_outlined, color: Colors.blue[900]),
                title: Text(_user?.uid != null ? 'Logout' : 'Go to login'),
                onTap: () { 
                  _user?.uid != null
                      ? _showLogoutConfirmationDialog(context)
                      : Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                },
                textColor: Colors.blue[900],
              )
            ],
          ),
        ),
      ),
    );
  }
}
