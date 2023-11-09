// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AccomodationCardView extends StatelessWidget {
  const AccomodationCardView({super.key, required this.imagePath, required this.accomodationName});
  final String imagePath;
  final String accomodationName;
  

  @override
  Widget build(BuildContext context) {
    return  Container(
     
      decoration: BoxDecoration(
          color: Color.fromARGB(179, 231, 228, 228),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Center(
                  child: Image.asset(
                    imagePath,
                  
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  accomodationName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.verified,
                  color: Colors.blue[900],
                  size: 15,
                ),
              ],
            ),
            Text(
              'Available Now',
              style: TextStyle(color: Colors.green),
            )
          ],
        ),
      ),
    );
  }
}