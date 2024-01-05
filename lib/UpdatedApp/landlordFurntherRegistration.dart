// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last,
import 'package:path/path.dart';
import 'dart:io' as Platform;
import 'dart:io';
import 'package:api_com/UpdatedApp/landlordoffersPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
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
    } else if (_pdfContractPath == '') {
      showError(context);
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
                      contractPath: _pdfContractPath,
                      contract: pdfContractFile,
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

  String _pdfContractPath = '';

  bool isFileChosen = false;
  File? pdfContractFile;
  Future<void> _pickSignedContract(context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        pdfContractFile = File(result.files.single.path!);
        setState(() {
          _pdfContractPath = pdfContractFile.toString();
          isFileChosen = true; // Set the flag to true when a file is chosen
        });
      } else {
        // No file chosen
        setState(() {
          isFileChosen = false;
        });
      }
    } catch (e) {
      _showErrorDialog(e.toString(), context);
    }
  }

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Container(
              width: buttonWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Icon(
                      Icons.maps_home_work_outlined,
                      size: 150,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: distanceController,
                    decoration: InputDecoration(
                        focusColor: Colors.blue,
                        fillColor: Color.fromARGB(255, 230, 230, 230),
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
                          focusColor: Colors.blue,
                          fillColor: Color.fromARGB(255, 230, 230, 230),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.location_on_outlined,
                            color: Colors.blue,
                          ),
                          hintText: 'Address e.g Province,Address'),
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
                  SizedBox(height: 5),
                  Container(
                    width: buttonWidth,
                    height: 50,
                    color: const Color.fromARGB(179, 236, 236, 236),
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
                  Container(
                    width: buttonWidth,
                    height: 50,
                    color: const Color.fromARGB(179, 236, 236, 236),
                    child: Row(
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            _pickSignedContract(context);
                            setState(() {
                              print(_pdfContractPath);
                            });
                          },
                          icon: Icon(Icons.file_present_outlined,
                              color: Colors.white),
                          label: Text(
                            'Add Contract',
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
                                  MaterialStatePropertyAll(Size(130, 50))),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: TextField(
                            readOnly: true, // Prevent manual editing
                            controller: TextEditingController(
                                text: basename(_pdfContractPath)),
                            decoration: InputDecoration(
                              disabledBorder: OutlineInputBorder(),
                              focusColor: Color.fromARGB(255, 230, 230, 230),
                              fillColor: Color.fromARGB(255, 230, 230, 230),
                              filled: true,
                              hintText: 'Upload contract',
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      checkLandlordDetails(context);
                    },
                    child: Text(
                      'Proceed',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                        foregroundColor: MaterialStatePropertyAll(Colors.blue),
                        backgroundColor: MaterialStatePropertyAll(Colors.blue),
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
        String street = placemarks.first.street ?? 'Unknown';
        String country = placemarks.first.administrativeArea ?? 'Unknown';

        txtLiveLocation.text = ' $country,${street}';
      }
    } catch (e) {
      print('Error fetching address: $e');
    }
  }
}
