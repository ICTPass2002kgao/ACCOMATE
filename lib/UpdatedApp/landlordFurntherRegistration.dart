// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last,

import 'dart:io';
import 'package:api_com/UpdatedApp/landlordoffersPage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:permission_handler/permission_handler.dart';

class LandlordFurtherRegistration extends StatefulWidget {
  final String accomodationName;
  final String landlordEmail;
  final String password;

  final String contactDetails;
  final bool isLandlord;
  const LandlordFurtherRegistration(
      {super.key,
      required this.password,
      required this.accomodationName,
      required this.contactDetails,
      required this.landlordEmail,
      required this.isLandlord});

  @override
  State<LandlordFurtherRegistration> createState() =>
      _LandlordFurtherRegistrationState();
}

class _LandlordFurtherRegistrationState
    extends State<LandlordFurtherRegistration> {
  TextEditingController txtLiveLocation = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  void showError(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Text('Missing information',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        content: Text('Please make sure you provide the missing information'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Okay'),
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
                foregroundColor: MaterialStatePropertyAll(Colors.white),
                backgroundColor: MaterialStatePropertyAll(Colors.red[300]),
                minimumSize:
                    MaterialStatePropertyAll(Size(double.infinity, 50))),
          ),
        ],
      ),
    );
  }

//  &&
//          &&
//        &&
//
  void checkLandlordDetails(context) {
    if (txtLiveLocation.text == '') {
      showError(context);
    } else if (_imageFile == null) {
      showError(context);
    } else if (distanceController.text == '') {
      showError(context);
    } else if (selectedPaymentsMethods.isEmpty) {
      showError(context);
    } else {
      setState(() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => OffersPage(
                      selectedPaymentsMethods: selectedPaymentsMethods,
                      imageFile: _imageFile,
                      location: txtLiveLocation.text,
                      password: widget.password,
                      contactDetails: widget.contactDetails,
                      isLandlord: widget.isLandlord,
                      accomodationName: widget.accomodationName,
                      landlordEmail: widget.landlordEmail,
                      distance: distanceController.text,
                    ))));
        print(widget.isLandlord);
        print(widget.accomodationName);
        print(widget.landlordEmail);
      });
    }
  }

  List<XFile> selectedImages = [];

  String currentAddress = '';
  bool isLoading = true;
  late LatLng currentLocation;

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
  }

  bool isFileChosen = false;
  File? pdfContractFile;

  void _showErrorDialog(String errorMessage, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Text(
          'Error Occurred',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        content: Text(
          errorMessage,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              )),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    try {
      List<Location> locations = await locationFromAddress(
        'address',
      );
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

  Map<String, bool> selectedPaymentsMethods = {
    'Nsfas': false,
    'Other External busary': true,
    'Self Pay': false,
  };

  XFile? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    XFile? selectedImage = await ImagePicker()
        .pickImage(source: source, preferredCameraDevice: CameraDevice.rear);

    setState(() {
      _imageFile = selectedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 400;

    return Scaffold(
      appBar: AppBar(
        title: Text('Continue Registering(2/3)'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        color: Colors.blue[100],
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
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
                                  const Color.fromARGB(255, 187, 222, 251),
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
                    TextField(
                      controller: distanceController,
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
                            Icons.location_pin,
                            color: Colors.blue,
                          ),
                          hintText: 'Distance to Campus e.g 4km'),
                    ),
                    SizedBox(height: 5),
                    Tooltip(
                      message:
                          'Click on get location button to get your current location',
                      child: TextField(
                        controller: txtLiveLocation,
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
                              Icons.location_on_outlined,
                              color: Colors.blue,
                            ),
                            hintText:
                                'Address e.g Country,Province,City,street,PostalCode'),
                      ),
                    ),
                    SizedBox(height: 5),
                    Tooltip(
                      message:
                          'This determines how ent should pay the accomodation',
                      child: ExpansionTile(
                        title: Text(
                          'Students Payment Methods',
                          style: TextStyle(
                              color: selectedPaymentsMethods.isEmpty
                                  ? Colors.red
                                  : Colors.black),
                        ),
                        children:
                            selectedPaymentsMethods.keys.map((paymentMethod) {
                          return CheckboxListTile(
                            title: Text(paymentMethod),
                            value:
                                selectedPaymentsMethods[paymentMethod] ?? false,
                            onChanged: (value) {
                              setState(() {
                                selectedPaymentsMethods[paymentMethod] =
                                    value ?? false;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 5),
                    TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible:
                              false, // Prevent user from dismissing the dialog
                          builder: (BuildContext context) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );
                        showLocationDialog(context);
                      },
                      icon:
                          Icon(Icons.location_on_outlined, color: Colors.white),
                      label: Text(
                        'Get Location',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.blue),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blue),
                          minimumSize:
                              MaterialStatePropertyAll(Size(buttonWidth, 50))),
                    ),
                    SizedBox(height: 5),
                    Container(
                      color: Colors.blue[50],
                      width: buttonWidth,
                      height: 50,
                      child: Row(
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              _pickImage(ImageSource.gallery);
                            },
                            icon: Icon(Icons.add_photo_alternate_outlined,
                                color: Colors.white),
                            label: Text(
                              'Add Profile',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            style: ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.blue),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.blue),
                                minimumSize:
                                    MaterialStatePropertyAll(Size(130, 50))),
                          ),
                          SizedBox(width: 5),
                          if (_imageFile != null)
                            Image.file(
                              File(
                                _imageFile!.path,
                              ),
                              fit: BoxFit.cover,
                              height: 45,
                              width: 50,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        checkLandlordDetails(context);
                      },
                      child: Text(
                        'Proceed',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.blue),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blue),
                          minimumSize:
                              MaterialStatePropertyAll(Size(buttonWidth, 50))),
                    ),
                    SizedBox(height: 10)
                  ],
                ),
              ),
            ),
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
      // ignore: use_build_context_synchronously

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      // Display the address in a text field
      Navigator.of(context).pop();
      if (placemarks.isNotEmpty) {
        String city = placemarks.first.subLocality ?? 'Unknown';
        String postalCode = placemarks.first.postalCode ?? 'Unknown';
        String street = placemarks.first.street ?? 'Unknown';
        String province = placemarks.first.administrativeArea ?? 'Unknown';

        String country = placemarks.first.country ?? 'Unknown';

        txtLiveLocation.text =
            '$country, $province, $city, $street, $postalCode';
      }
    } catch (e) {
      print('Error fetching address: $e');
    }
  }
}
