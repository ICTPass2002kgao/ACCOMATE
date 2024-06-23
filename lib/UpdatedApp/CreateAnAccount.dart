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

  void _continue() {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StudentOrLandlord(isLandlord: isLandlord, guest: false,)));
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
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ) // Show a loading indicator
          : Container(
              height: double.infinity,
              color: Colors.blue[100],
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Center(
                    child: Container(
                      width: buttonWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                        const Color.fromARGB(
                                            255, 187, 222, 251),
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
                          SizedBox(height: 10),
                          Text(
                            'You are creating as:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 15),
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
                          SizedBox(width: 15),
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
                          SizedBox(
                            height: 20,
                          ),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return Container(
                                      height: 500,
                                      child: AlertDialog(
                                        backgroundColor: Colors.blue[100],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        scrollable: true,
                                        title: Text('Term and conditions',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('1.Acceptance of Terms',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18)),
                                              SizedBox(height: 5),
                                              Text(
                                                  'By accessing or using the Accomate Accommodation Services, including the Accomate mobile application and associated platforms (collectively referred to as "the App"), you agree to comply with and be bound by the following terms and conditions.'),
                                              SizedBox(height: 10),
                                              Text(
                                                  '2.Landlord Responsibilities',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18)),
                                              SizedBox(height: 5),
                                              Text('a.Accurate Information',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                'Landlords must provide accurate and up-to-date information about the accommodation, including but not limited to rent, amenities, location, and availability.',
                                              ),
                                              SizedBox(height: 5),
                                              Text('b.Media Content',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Any images, amities, or media content related to the accommodation must accurately represent the property.'),
                                              SizedBox(height: 5),
                                              Text('c.Compliance with Laws',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Landlords must comply with all relevant local, state, and national laws related to housing and accommodation.'),
                                              SizedBox(height: 5),
                                              Text('d.Timely Responses',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Landlords should respond to students applications in a timely manner, providing necessary information and documentation promptly.'),
                                              SizedBox(height: 5),
                                              Text(
                                                  '3.Students Responsibilities',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text('a.Accurate Information',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Students must provide accurate and truthful information in their account registration.'),
                                              SizedBox(height: 5),
                                              Text('b.Compliance with Rules',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Students must abide by the rules and guidelines set by the landlord for the accommodation.'),
                                              SizedBox(height: 5),
                                              Text('c.Respectful Communication',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Students should communicate respectfully with landlords and other stakeholders involved in the application process.'),
                                              SizedBox(height: 5),
                                              Text('d.In-App Communication',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                  "Should student encounter any faulty/issue in the room or block, the student can share the issue in the application's chat page."),
                                              SizedBox(height: 5),
                                              Text('e.Privacy',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Students should be mindful of the privacy of others and handle personal information responsibly.'),
                                              SizedBox(height: 5),
                                              Text('4.Application Process',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text('a.Submission',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Students must submit their accommodation application through the Accomate platform, providing all required information.'),
                                              SizedBox(height: 5),
                                              Text('b.Fair Review',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Landlords should apply fair and non-discriminatory screening practices when considering students applications.'),
                                              SizedBox(height: 5),
                                              Text(
                                                  'c.POPI Act and Personal Information',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Landlords must comply with the POPI Act when collecting, processing, or storing Student personal information.'),
                                              SizedBox(height: 5),
                                              Text('d.Decision',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Landlords will make decisions based on the information provided by Students and communicate the outcome through the Accomate platform.'),
                                              SizedBox(height: 5),
                                              Text('e.Confirmation',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Successful Students should confirm their acceptance and adhere to the agreed-upon terms.'),
                                              SizedBox(height: 5),
                                              Text('5.Payments',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                'In terms of Payments, Landlords should pay R21 per month for each student that will apply & register on their accommodation using the app',
                                              ),
                                              SizedBox(height: 5),
                                              Text('6.POPI Act Compliance',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text('a.Consent',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                  'By using the App, students explicitly consent to the collection and processing of their personal information in compliance with the POPI Act.'),
                                              SizedBox(height: 5),
                                              Text('b.Data Security',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Accomate will implement reasonable measures to secure personal information in accordance with the POPI Act.'),
                                              SizedBox(height: 5),
                                              Text('c.Data Subject Rights',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Users have the right to access, correct, or delete their personal information as outlined in the POPI Act.'),
                                              SizedBox(height: 5),
                                              Text('7.Dispute Resolution',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text('a.Mediation',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                  ' In the event of disputes between landlords and Students, Accomate may offer mediation services to resolve conflicts.'),
                                              SizedBox(height: 5),
                                              Text('b.Legal Recourse',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Users retain the right to seek legal recourse for matters not resolved through mediation.'),
                                              SizedBox(height: 5),
                                              Text('8.Termination of Service',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Accomate reserves the right to terminate or suspend services for users who violate these terms and conditions.'),
                                              SizedBox(height: 5),
                                              Text('9.Changes to Terms',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Accomate reserves the right to modify these terms and conditions. Users will be notified of any changes, and continued use of the service constitutes acceptance of the modified terms.'),
                                              SizedBox(height: 5),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          Row(
                                            children: [
                                              Checkbox(
                                                activeColor: Colors.blue,
                                                value: isCheckboxChecked,
                                                onChanged: (value) {
                                                  setState(() {
                                                    isCheckboxChecked = value!;
                                                  });
                                                },
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isCheckboxChecked =
                                                        !isCheckboxChecked;
                                                  });
                                                },
                                                child: Text(
                                                  ' Agree with terms and conditions',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          ),
                                          OutlinedButton(
                                            onPressed: !isCheckboxChecked
                                                ? null
                                                : () => _continue(),
                                            child: Text('Agree'),
                                            style: ButtonStyle(
                                              shape: WidgetStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5))),
                                              foregroundColor:
                                                  WidgetStatePropertyAll(
                                                      Colors.white),
                                              backgroundColor:
                                                  !isCheckboxChecked
                                                      ? WidgetStatePropertyAll(
                                                          Color.fromARGB(255,
                                                              211, 211, 211))
                                                      : WidgetStatePropertyAll(
                                                          Colors.blue),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            child: Text(
                              'Get Started',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              foregroundColor:
                                  WidgetStatePropertyAll(Colors.white),
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.blue),
                              minimumSize: WidgetStatePropertyAll(
                                  Size(double.infinity, 50)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
