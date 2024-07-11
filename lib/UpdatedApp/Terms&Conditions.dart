import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                            height: 500,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              scrollable: true,
                              title: Text('Term & conditions',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('1.Acceptance of Terms',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    SizedBox(height: 5),
                                    Text(
                                        'By accessing or using the Accomate Accommodation Services, including the Accomate mobile application and associated platforms (collectively referred to as "the App"), you agree to comply with and be bound by the following terms and conditions.'),
                                    SizedBox(height: 10),
                                    Text('2.Landlord Responsibilities',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
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
                                    Text('3.Students Responsibilities',
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
                                    Text('c.POPI Act and Personal Information',
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
                            ),
                          );
                       
                 
  }
}