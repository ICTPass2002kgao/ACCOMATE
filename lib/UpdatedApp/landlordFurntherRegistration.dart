// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

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
  final String distance;
  final String password;

  final int contactDetails;
  final bool isLandlord;
  const LandlordFurtherRegistration(
      {super.key,
      required this.password,
      required this.accomodationName,
      required this.contactDetails,
      required this.landlordEmail,
      required this.distance,
      required this.isLandlord});

  @override
  State<LandlordFurtherRegistration> createState() =>
      _LandlordFurtherRegistrationState();
}

class _LandlordFurtherRegistrationState
    extends State<LandlordFurtherRegistration> {
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

  List<String> selectedProducts = [];
  List<String> availableProducts = [
    'Product A',
    'Product B',
    'Product C',
    'Product D'
  ];

  void _showAddProductDialog() {
    String newProduct = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Product'),
          content: TextField(
            onChanged: (value) {
              newProduct = value;
            },
            decoration: InputDecoration(labelText: 'Product Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (newProduct.isNotEmpty) {
                    availableProducts.add(newProduct);
                  }
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

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
                  SizedBox(height: 5),
                  Tooltip(
                    message:
                        'Click on get location button to get your current location',
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
                  SizedBox(height: 5),
                  Tooltip(
                    child: Text(
                      'Payment Method',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    message:
                        'This tells a student how they will be able to pay',
                  ),
                  Row(
                    children: [
                      Checkbox(value: false, onChanged: (val) {}),
                      Text('Nsfas')
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Checkbox(value: false, onChanged: (val) {}),
                      Text('Bursary')
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Checkbox(value: false, onChanged: (val) {}),
                      Text('Self Pay')
                    ],
                  ),
                  SizedBox(height: 5),
                  TextButton.icon(
                    onPressed: () {},
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
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          //async {
                          // await pickImages(); // Call method to pick images
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
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => OffersPage(
                                      location: txtLiveLocation.text,
                                      password: widget.password,
                                      contactDetails: widget.contactDetails,
                                      isLandlord: widget.isLandlord,
                                      accomodationName: widget.accomodationName,
                                      landlordEmail: widget.landlordEmail,
                                      distance: widget.distance,
                                    ))));
                        print(widget.isLandlord);
                        print(widget.accomodationName);
                        print(widget.landlordEmail);
                        print(widget.distance);
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
