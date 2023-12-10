// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, sized_box_for_whitespace

import 'package:api_com/UpdatedApp/either_landlord_or_student.dart';
import 'package:flutter/material.dart';

class RegistrationOption extends StatefulWidget {
  const RegistrationOption({super.key});

  @override
  State<RegistrationOption> createState() => _RegistrationOptionState();
}

class _RegistrationOptionState extends State<RegistrationOption> {
  bool isLandlord = true;
  bool isLoading = true;
  bool isCheckboxChecked = false;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    // Simulate loading data
    await Future.delayed(Duration(seconds: 1));

    // Set isLoading to false when data is loaded
    setState(() {
      isLoading = false;
    });
  }

  void _disabledButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => StudentOrLandlord(isLandlord: isLandlord)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 400;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          "Accomate",
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            ) // Show a loading indicator
          : SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Center(
                  child: Container(
                    width: buttonWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Icon(
                            Icons.person_add,
                            size: 200,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'You are creating as:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Radio(
                              activeColor: Colors.blue,
                              value: true,
                              groupValue: isLandlord,
                              onChanged: (value) {
                                setState(() {
                                  isLandlord = true;
                                });
                              },
                            ),
                            Text('Landlord'),
                          ],
                        ),
                        SizedBox(width: 16),
                        Row(
                          children: [
                            Radio(
                              activeColor: Colors.blue,
                              value: false,
                              groupValue: isLandlord,
                              onChanged: (value) {
                                setState(() {
                                  isLandlord = false;
                                });
                              },
                            ),
                            Text('Student'),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CheckboxListTile(
                          activeColor: Colors.blue,
                          value: isCheckboxChecked,
                          onChanged: (value) {
                            setState(() {
                              isCheckboxChecked = value!;
                            });
                          },
                          title: Text('Agree with terms & conditions'),
                          tileColor: Colors.white,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: !isCheckboxChecked
                              ? null
                              : () => _disabledButton(),
                          child: Text(
                            'Get Started',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.blue),
                            backgroundColor: !isCheckboxChecked
                                ? MaterialStatePropertyAll(
                                    Color.fromARGB(255, 211, 211, 211))
                                : MaterialStatePropertyAll(Colors.blue),
                            minimumSize: MaterialStatePropertyAll(
                                Size(double.infinity, 50)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
