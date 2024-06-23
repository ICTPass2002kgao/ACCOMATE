
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key,});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  
  TextEditingController txtEmail = TextEditingController();

  late FirebaseAuth _auth;
  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }

  Future<void> _resetPassword() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        },
      );
      await _auth.sendPasswordResetEmail(email: txtEmail.text);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Colors.blue[100],
          title: Text(
            'Password reset Email Sent',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          icon: Icon(Icons.verified_user_sharp, size: 50),
          iconColor: Colors.blue,
          content: Text(
            'A password reset email has been sent to ${txtEmail.text}. Please check your email and click on the link provided to reset your password. Once you have reset your password, you can return here to log in.',
          ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Okay'),
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                foregroundColor: WidgetStateProperty.all(Colors.white),
                backgroundColor: WidgetStateProperty.all(Colors.blue),
              ),
            ),
          ],
        ),
      );
      print('Password reset email sent to $txtEmail');
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Text('Reset password error',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          content: Text(e.message.toString()),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password?'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.blue[100],
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
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
                        padding: const EdgeInsets.all(7.0),
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
              TextField(
                controller: txtEmail,
                keyboardType: TextInputType.emailAddress,
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
                    hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 20,
              ),
              OutlinedButton(
                onPressed: () async {
                  txtEmail.text.isNotEmpty
                      ? await _resetPassword()
                      : showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                title: Text('Invalid Input',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                content: Text('Please provide a correct email'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Retry'),
                                    style: ButtonStyle(
                                        shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5))),
                                        foregroundColor: WidgetStatePropertyAll(
                                            Colors.white),
                                        backgroundColor: WidgetStatePropertyAll(
                                            Colors.red[300]),
                                        minimumSize: WidgetStatePropertyAll(
                                            Size(300, 50))),
                                  ),
                                ],
                              ));
                },
                child: Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                    foregroundColor: WidgetStatePropertyAll(Colors.blue),
                    backgroundColor: WidgetStatePropertyAll(Colors.blue),
                    minimumSize:
                        WidgetStatePropertyAll(Size(double.infinity, 50))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
