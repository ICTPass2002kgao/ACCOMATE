// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:api_com/Accomodation_card.dart';
import 'package:api_com/accomodation_page.dart';
import 'package:api_com/global_variables.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final details = residencesCard;
  int isSelected = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transport Accomodations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
              width: 20,
            ),
            SizedBox(
              height: 300,
              width: double.infinity,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: details.length,
                  itemBuilder: (context, index) {
                    final accomodationData = details[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AccomodationPage(
                            residenceDetails: residencesCard[index],
                          );
                        }));
                      },
                      child: AccomodationCard(
                          accomodationName: accomodationData['name'] as String,
                          imagePath: accomodationData['imagePath'] as String),
                    );
                  }),
            ),
            SizedBox(height: 20),
            Text(
              'No-Transport Accomodations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 300,
              width: double.infinity,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: details.length,
                  itemBuilder: (context, index) {
                    final accomodationData = details[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AccomodationPage(
                            residenceDetails: residencesCard[index],
                          );
                        }));
                      },
                      child: AccomodationCard(
                          accomodationName: accomodationData['name'] as String,
                          imagePath: accomodationData['imagePath'] as String),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
