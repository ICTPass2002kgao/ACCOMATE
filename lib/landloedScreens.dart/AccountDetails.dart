// ignore_for_file: prefer_const_constructors, unnecessary_brace_in_string_interps, sized_box_for_whitespace

import 'package:api_com/userData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountDetails extends StatelessWidget {
  const AccountDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData2>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          color: const Color.fromARGB(179, 231, 231, 231),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (userData.resImage != null)
                  Container(
                    width: double.infinity,
                    child: Image.file(
                      userData.resImage!,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(height: 20),
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Text(
                    userData.resName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.verified,
                    color: Colors.blue[900],
                    size: 15,
                  ),
                ]),
                SizedBox(height: 10),
                Text(
                  'Location: ${userData.resLocation}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Available Now',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.green,
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
