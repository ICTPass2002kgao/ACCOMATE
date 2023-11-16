// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LandlordRegistration extends StatefulWidget {
  const LandlordRegistration({super.key});

  @override
  State<LandlordRegistration> createState() => _LandlordRegistrationState();
}

class _LandlordRegistrationState extends State<LandlordRegistration> {
  TextEditingController txtResName = TextEditingController();
  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        // Update the text field with the current location
        txtResName.text =
            'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _requestLocationWithAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Permission'),
          content:
              Text('This app needs access to your location for some features.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _requestLocationPermission();
              },
              child: Text('Allow'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    print('Location Permission Status: $status');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register your Residence'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            MediaQuery.of(context).size.width < 600
                ? Column(
                    children: [
                      SizedBox(height: 20),
                      Icon(
                        Icons.maps_home_work_outlined,
                        size: 100,
                        color: Colors.blue,
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        child: TextField(
                          controller: txtResName,
                          decoration: InputDecoration(
                              focusColor: Colors.blue,
                              fillColor: Color.fromARGB(255, 230, 230, 230),
                              filled: true,
                              prefixIcon: Icon(
                                Icons.maps_home_work_outlined,
                                color: Colors.blue,
                              ),
                              hintText: 'Name of residence'),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: () async {
                          await _requestLocationWithAlertDialog(context);
                        },
                        icon: Icon(Icons.location_on_outlined,
                            color: Colors.white),
                        label: Text(
                          'Request Location',
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
                      SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: () {
                          _getLocation();
                        },
                        icon: Icon(Icons.location_on_outlined,
                            color: Colors.white),
                        label: Text(
                          'Get Location',
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
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Proceed',
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
                    ],
                  )
                : Center(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Icon(Icons.lock_person, size: 100, color: Colors.blue),
                        SizedBox(height: 20),
                        Container(
                          width: 310,
                          child: TextField(
                            controller: txtResName,
                            decoration: InputDecoration(
                                focusColor: Colors.blue,
                                fillColor: Color.fromARGB(255, 230, 230, 230),
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.blue,
                                ),
                                hintText: 'Name of residence'),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: Text(
                            'Proceed',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.blue),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.blue),
                              minimumSize:
                                  MaterialStatePropertyAll(Size(320, 50))),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _getLocation();
                            });
                          },
                          child: Text(
                            'Get Location',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.blue),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.blue),
                              minimumSize:
                                  MaterialStatePropertyAll(Size(320, 50))),
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
