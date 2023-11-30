// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last,

import 'dart:io' as Platform;
import 'dart:io';
import 'package:api_com/UpdatedApp/landlordoffersPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  final int contactDetails;
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
  List<XFile> selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFiles = [];

  Future<void> _pickWepAppImagesFunction() async {
    try {
      List<XFile>? result = await _picker.pickMultiImage(
        imageQuality: 50,
      );

      if (result != null && result.isNotEmpty) {
        setState(() {
          _imageFiles = result;
        });
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  final CollectionReference _imageCollection =
      FirebaseFirestore.instance.collection('images');

  Future<void> _uploadImages(List<XFile>? imageFiles) async {
    if (imageFiles == null || imageFiles.isEmpty) {
      // No images provided
      print('No images provided.');
      return;
    }

    List<String> imageUrls = [];

    try {
      for (XFile imageFile in imageFiles) {
        // Create a unique filename for each image
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        // Get a reference to the Firebase Storage bucket
        firebase_storage.Reference reference = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images/$fileName.jpg');

        // Upload the image to Firebase Storage
        await reference.putFile(File(imageFile.path));

        // Get the download URL of the uploaded image
        String downloadURL = await reference.getDownloadURL();

        // Add the download URL to the list
        imageUrls.add(downloadURL);
      }

      // Save the download URLs to Firestore
      await _imageCollection.add({
        'imageUrls': imageUrls,
      });
    } catch (e) {
      print('Error uploading images: $e');
    }
  }

  Future<void> _pickImages() async {
    List<XFile>? resultList = [];

    try {
      resultList = await ImagePicker().pickMultiImage(
        imageQuality: 85,
      );
    } catch (e) {
      print(e.toString());
    }

    if (!mounted) return;

    setState(() {
      selectedImages = resultList ?? [];
    });
  }

  String currentAddress = '';
  bool isLoading = true;
  late LatLng currentLocation;

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
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

  Map<String, bool> selectedPaymentsMethods = {
    'Nsfas': false,
    'Other External busary': false,
    'Self Pay': false,
  };
  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 450 ? double.infinity : 400;

    return Scaffold(
      appBar: AppBar(
        title: Text('Continue Registering'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: buttonWidth,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
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
                          hintText: 'Live Location'),
                    ),
                  ),
                  SizedBox(height: 5),
                  Tooltip(
                    message:
                        'This determines how ent should pay the accomodation',
                    child: ExpansionTile(
                      title: Text('Students Payment Methods'),
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
                          onPressed: MediaQuery.of(context).size.width < 1400
                              ? _pickImages
                              : _pickWepAppImagesFunction,
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
                        if (MediaQuery.of(context).size.width < 450)
                          Expanded(
                            child: GridView.builder(
                              scrollDirection: Axis.horizontal,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 4.0,
                              ),
                              itemCount: selectedImages.length,
                              itemBuilder: (context, index) {
                                return Image.file(
                                  File(selectedImages[index].path),
                                  height: 30,
                                  width: 30,
                                );
                              },
                            ),
                          )
                        else if (_imageFiles != null)
                          Column(
                            children: [
                              for (XFile imageFile in _imageFiles!)
                                Image.file(
                                  File(imageFile.path),
                                  height: 100,
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => OffersPage(
                                      selectedWepAppImages: _imageFiles,
                                      selectedPaymentsMethods:
                                          selectedPaymentsMethods,
                                      bringSelectedImages: selectedImages,
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
                    },
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
