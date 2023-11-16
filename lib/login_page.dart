// ignore_for_file: unnecessary_const, prefer_const_constructors, avoid_unnecessary_containers, sort_child_properties_last, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print

import 'package:api_com/Registration_page.dart';
import 'package:api_com/student_page.dart';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  void registerPage() {
    setState(() {
      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => RegistrationOption())));
    });
  }

  void studentLogin() {
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => StudentPage())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 50, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(children: [
            MediaQuery.of(context).size.width < 480
                ? Column(
                    children: [
                      Icon(Icons.lock_person, size: 150, color: Colors.blue),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.all(0.0),
                        child: TextField(
                          controller: txtEmail,
                          decoration: InputDecoration(
                              focusColor: Colors.blue,
                              fillColor: Color.fromARGB(255, 230, 230, 230),
                              filled: true,
                              prefixIcon: Icon(
                                Icons.mail_outline,
                                color: Colors.blue,
                              ),
                              hintText: 'Enter your email'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0, top: 10),
                        child: TextField(
                          controller: txtPassword,
                          decoration: InputDecoration(
                              focusColor: Colors.blue,
                              fillColor: Color.fromARGB(255, 230, 230, 230),
                              filled: true,
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.blue,
                              ),
                              hintText: 'Password'),
                          obscureText: true,
                          obscuringCharacter: '*',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Forgot Password ?',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                                decorationStyle: TextDecorationStyle.solid),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          studentLogin();
                        },
                        child: Text(
                          'Sign-in',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.blue),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue),
                            minimumSize: MaterialStatePropertyAll(
                                Size(double.infinity, 50))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Or sign-in with',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  print('Apple');
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    'assets/apple_logo.png',
                                    width: 70,
                                  ),
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                                onTap: () {
                                  print('Google');
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    'assets/Google_icon.png',
                                    width: 70,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          registerPage();
                        },
                        child: Text(
                          "Register Here",
                          style: TextStyle(color: Colors.blue, fontSize: 18),
                        ),
                      )
                    ],
                  )
                : Center(
                    child: Container(
                      width: 300,
                      child: Column(
                        children: [
                          Icon(Icons.lock_person,
                              size: 150, color: Colors.blue),
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Container(
                              width: 400,
                              child: TextField(
                                controller: txtEmail,
                                decoration: InputDecoration(
                                    focusColor: Colors.blue,
                                    fillColor:
                                        Color.fromARGB(255, 230, 230, 230),
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.mail_outline,
                                      color: Colors.blue,
                                    ),
                                    hintText: 'Enter your email'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 0, top: 10),
                            child: Container(
                              width: 400,
                              child: TextField(
                                controller: txtPassword,
                                decoration: InputDecoration(
                                    focusColor: Colors.blue,
                                    fillColor:
                                        Color.fromARGB(255, 230, 230, 230),
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.blue,
                                    ),
                                    hintText: 'Password'),
                                obscureText: true,
                                obscuringCharacter: '*',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Forgot Password ?',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 15,
                                    decorationStyle: TextDecorationStyle.solid),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextButton(
                            onPressed: () {
                              studentLogin();
                            },
                            child: Text(
                              'Sign-in',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.blue),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.blue),
                                minimumSize:
                                    MaterialStatePropertyAll(Size(400, 50))),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Or sign-in with',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      print('Apple');
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        'assets/apple_logo.png',
                                        width: 70,
                                      ),
                                    )),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      print('Google');
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        'assets/Google_icon.png',
                                        width: 70,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              registerPage();
                            },
                            child: Text(
                              "Register Here",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 18),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
          ]),
        ),
      ),
    );
  }
}
/*Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.blue),
                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                ),   
                onPressed: (){}, 
                icon: Icon(Icons.favorite_border,
                color: Colors.white,), 
                label: Text('Add to Favorites',
                style: TextStyle(
                color: Colors.white,
                fontSize: 18),
                
                ), ),
                

              
                ],
              ) */