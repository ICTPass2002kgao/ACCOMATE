// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, sized_box_for_whitespace, use_build_context_synchronously, unnecessary_null_comparison, depend_on_referenced_packages, unnecessary_brace_in_string_interps

import 'dart:io';

import 'package:api_com/advanced_details.dart';
import 'package:api_com/advanced_details.dart';
import 'package:api_com/userData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class LandlordRegistration extends StatefulWidget {
  const LandlordRegistration({super.key});

  @override
  State<LandlordRegistration> createState() => _LandlordRegistrationState();
}

class _LandlordRegistrationState extends State<LandlordRegistration> {
  TextEditingController txtLiveLocation = TextEditingController();
  TextEditingController txtResName = TextEditingController();
  List<XFile> pickedImages = [];
  TextEditingController detailsController = TextEditingController();

  String currentAddress = '';
  bool isLoading = true;
  late GoogleMapController mapController;
  late LatLng currentLocation;
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    requestLocationPermission();

    loadData();
  }

  Future<void> getCurrentLocation() async {
    try {
      List<Location> locations = await locationFromAddress('Your Address');
      if (locations.isNotEmpty) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          locations.first.latitude,
          locations.first.longitude,
        );

        if (placemarks.isNotEmpty) {
          setState(() {
            currentLocation = LatLng(
              locations.first.latitude,
              locations.first.longitude,
            );
          });

          // txtLiveLocation.text = placemarks.first.street ?? '';
        } else {
          print('Placemark not found');
        }
      } else {
        print('Location not found');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      getCurrentLocation();
    } else {
      print('Location permission denied');
    }
  }

/*  Future<void> registerAccommodation() async {
    String name = nameController.text;
    String location = locationController.text;
    List<String> images = imagesController.text.split(',');
    String description = descriptionController.text;

    try {
      await _accommodationRegistrationService.registerAccommodation(
        name: name,
        location: location,
        images: images,
        description: description,
      );

      // Clear the text fields after successful registration
      nameController.clear();
      locationController.clear();
      imagesController.clear();
      descriptionController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Accommodation registered successfully!')),
      );
    } catch (e) {
      // Handle registration errors
      print('Error registering accommodation: $e');
    }
  }*/
  final RegistrationService _accommodationRegistrationService =
      RegistrationService();

  Future<void> registerAccommodation() async {
    String name = txtResName.text;
    String location = txtLiveLocation.text;
    List<String> images = pickedImages.map((file) => file.path).toList();
    String residenceDetails = detailsController.text;

    try {
      await _accommodationRegistrationService.registerAccommodation(
        name: name,
        location: location,
        images: images,
        residenceDetails: residenceDetails,
      );

      // Clear the text fields after successful registration
      txtResName.clear();
      txtLiveLocation.clear();

      // Optionally, you can show a success message or navigate to another page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Accommodation registered successfully!')),
      );
    } catch (e) {
      // The registration service already handles errors, but you can add additional handling here if needed
    }
  }
  // File? userImage;

  // Future<void> _getImage() async {
  //   final pickedFile =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     setState(() {
  //       userImage = File(pickedFile.path);
  //     });
  //   }
  // }

  Widget buildImagePreview() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: pickedImages.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.file(
            File(pickedImages[0].path),
            height: 40,
            width: 40,
          ),
        );
      },
    );
  }

  Future<void> _comfirmedRegistration(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Done'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    SizedBox(width: 10),
                    Container(
                        width: 200,
                        child: Text("Accomodation registered successfully")),
                    Icon(Icons.done, color: Colors.green, size: 40),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.green),
                foregroundColor: MaterialStatePropertyAll(Colors.green),
              ),
              child: Text(
                'Done',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await registerAccommodation();
                // ...
                Navigator.popUntil(
                    context, ModalRoute.withName('LandlordPage'));

                // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _agreeWithTermsAndConditions(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Comfirm the registration'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    Icon(Icons.warning, color: Colors.yellow, size: 40),
                    SizedBox(width: 5),
                    Container(
                        width: 200,
                        child: Text(
                            "Are you sure you're registering the residence?")),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
              ),
              onPressed: () {
                // Perform logout logic here
                // ...

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            SizedBox(width: 5),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue),
                foregroundColor: MaterialStatePropertyAll(Colors.blue),
              ),
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // Perform logout logic here
                // ...
                Navigator.of(context).pop();

                _comfirmedRegistration(context);

                // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Terms & Conditions'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Column(
                  children: [
                    SizedBox(width: 10),
                    Text('This are the terms and conditions of the app '),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue),
                foregroundColor: MaterialStatePropertyAll(Colors.blue),
              ),
              child: Text(
                'I Agree',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // Perform logout logic here
                // ...
                Navigator.of(context).pop();
                isLoading
                    ? Center(
                        child:
                            CircularProgressIndicator()) // Show a loading indicator
                    : _agreeWithTermsAndConditions(context);

                // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> loadData() async {
    // Simulate loading data
    await Future.delayed(Duration(seconds: 2));

    // Set isLoading to false when data is loaded
    setState(() {
      isLoading = false;
    });
  }

  String name = '';
  String location = '';
  List<String> images = [];
  String description = '';

// ... (Initialize controllers for text fields)

// Define a function to handle form submission

  final ImagePicker _imagePicker = ImagePicker();
  Future<void> pickImages() async {
    List<XFile>? pickedFiles = await _imagePicker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        pickedImages = pickedFiles;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonStateProvider = Provider.of<ButtonStateProvider>(context);
    double textBoxWidth =
        MediaQuery.of(context).size.width < 600 ? double.infinity : 400;
    double buttonWidth =
        MediaQuery.of(context).size.width < 600 ? double.infinity : 300;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Register your Residence'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Column(
                children: [
                  Icon(
                    Icons.maps_home_work_outlined,
                    size: 150,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: textBoxWidth,
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
                  TextField(
                    controller: detailsController,
                    decoration: InputDecoration(
                        focusColor: Colors.blue,
                        fillColor: Color.fromARGB(255, 230, 230, 230),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.maps_home_work_outlined,
                          color: Colors.blue,
                        ),
                        hintText: 'Residence offers'),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: textBoxWidth,
                    child: TextField(
                      readOnly: true,
                      controller: txtLiveLocation,
                      decoration: InputDecoration(
                          focusColor: Colors.blue,
                          fillColor: Color.fromARGB(255, 230, 230, 230),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.location_on_outlined,
                            color: Colors.blue,
                          ),
                          hintText: 'Live Location'),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () => isLoading
                        ? Center(
                            child:
                                CircularProgressIndicator()) // Show a loading indicator
                        : showLocationDialog(context),
                    icon: Icon(Icons.location_on_outlined, color: Colors.white),
                    label: Text(
                      'Get Location',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(Colors.blue),
                        backgroundColor: MaterialStatePropertyAll(Colors.blue),
                        minimumSize:
                            MaterialStatePropertyAll(Size(buttonWidth, 50))),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          await pickImages(); // Call method to pick images
                        },
                        icon: Icon(Icons.add_photo_alternate_outlined,
                            color: Colors.white),
                        label: Text(
                          'Add Images',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.blue),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue),
                            minimumSize:
                                MaterialStatePropertyAll(Size(100, 50))),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: buttonStateProvider.buttonState.isButtonEnabled
                        ? () {
                            isLoading
                                ? Center(
                                    child:
                                        CircularProgressIndicator()) // Show a loading indicator
                                : _showLogoutConfirmationDialog(context);
                            buttonStateProvider.disableButton();
                          }
                        : null,
                    child: Text(
                      'Proceed',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(Colors.blue),
                        backgroundColor: MaterialStatePropertyAll(Colors.blue),
                        minimumSize:
                            MaterialStatePropertyAll(Size(buttonWidth, 50))),
                  ),
                  SizedBox(height: 10),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showLocationDialog(BuildContext context) async {
    // Request location permissions
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      getCurrentLocation();
      print('Location permission denied');
      return;
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition();

    // Get address from coordinates
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      // Display the address in a text field
      if (placemarks.isNotEmpty) {
        String street = placemarks.first.street ?? 'Unknown';
        String address = placemarks.first.locality ?? 'Unknown';
        String country = placemarks.first.country ?? 'Unknown';
        txtLiveLocation.text = '${country} ,${address},${street}';
      }
    } catch (e) {
      print('Error fetching address: $e');
    }
  }
}

        // Show map in dialog (same as previous example)
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: Text('Current Location'),
        //       content: Container(
        //         height: 300,
        //         child: GoogleMap(
        //           initialCameraPosition: CameraPosition(
        //             target: LatLng(position.latitude, position.longitude),
        //             zoom: 15.0,
        //           ),
        //           markers: <Marker>[
        //             Marker(
        //               markerId: MarkerId('current-location'),
        //               position: LatLng(position.latitude, position.longitude),
        //               infoWindow: InfoWindow(title: 'Your Location'),
        //             ),
        //           ].toSet(),
        //         ),
        //       ),
        //       actions: [
        //         TextButton(
        //           onPressed: () => Navigator.of(context).pop(),
        //           child: Text('Close'),
        //         ),
        //       ],
        //     );
        //   },
        // );
