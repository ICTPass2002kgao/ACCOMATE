import 'dart:io';

import 'package:flutter/material.dart';

class UserData2 with ChangeNotifier {
  String resName = '';
  String resLocation = '';

  File? resImage;
  String moreDetails = '';

  void setData(
    String newName,
    int resLocation,
    String newDetails,
    File newImage,
  ) {
    resName = newName;
    resLocation = resLocation;
    moreDetails = newDetails;
    resImage = newImage;
    notifyListeners();
  }
}

class UserData with ChangeNotifier {
  String studentName = '';
  String studentSurname = '';
  int studentNumber = 0;
  int contactNumber = 0;

  void setData(
    String newName,
    int newStudentNumber,
    String newStudentSurname,
    int newContactNumber,
  ) {
    studentName = newName;
    studentSurname = newStudentSurname;
    studentNumber = newStudentNumber;
    contactNumber = newContactNumber;
    notifyListeners();
  }
}

class Residence {
  String name;

  String moreDetails;
  String status;
  String location;
  final List<String> images;

  Residence({
    required this.images,
    required this.name,
    required this.moreDetails,
    required this.status,
    required this.location,
  });
}

class ResData extends ChangeNotifier {
  List<Residence> residences = [];

  void addResidence(Residence residence) {
    residences.add(residence);
    notifyListeners();
  }
}

class ButtonState {
  bool isButtonEnabled;

  ButtonState({required this.isButtonEnabled});
}

class ButtonStateProvider with ChangeNotifier {
  ButtonState _buttonState = ButtonState(isButtonEnabled: true);

  ButtonState get buttonState => _buttonState;

  void disableButton() {
    _buttonState = ButtonState(isButtonEnabled: false);
    notifyListeners();
  }
}
