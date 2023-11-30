// ignore_for_file: avoid_print, use_rethrow_when_possible

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Accommodation {
  final String name;
  final String location;
  final List<String> images;
  final String residenceDetails;

  Accommodation({
    required this.name,
    required this.location,
    required this.images,
    required this.residenceDetails,
  });
}

class RegistrationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> registerAccommodation({
    required String name,
    required String location,
    required List<String> images,
    required String residenceDetails,
  }) async {
    try {
      List<String> imageUrls = await _uploadImagesToStorage(images);
      await _firestore.collection('accommodations').add({
        'name': name,
        'location': location,
        'images': imageUrls,
        'residenceDetails': residenceDetails,
      });
    } catch (e) {
      print('Error registering accommodation: $e');
      // Handle registration errors
      rethrow; // Rethrow the error for the caller to handle if needed
    }
  }

  Future<List<String>> _uploadImagesToStorage(List<String> imagePaths) async {
    List<String> imageUrls = [];

    try {
      for (String path in imagePaths) {
        File imageFile = File(path);

        String imageName = DateTime.now().millisecondsSinceEpoch.toString();
        String imagePath = 'images/$imageName.jpg';

        // Upload the image to Firebase Storage
        await _firebaseStorage.ref(imagePath).putFile(imageFile);

        // Get the download URL for the uploaded image
        String downloadUrl =
            await _firebaseStorage.ref(imagePath).getDownloadURL();

        imageUrls.add(downloadUrl);
      }
    } catch (e) {
      print('Error uploading images: $e');
      throw Exception('Error uploading images');
    }

    return imageUrls;
  }
}

//Student registration class

class StudentRegistrationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> registerUser({
    required String name,
    required String surname,
    required String email,
    required String id,
    required String password,
    required String contact,
    required String studentNumber,
    required String userType,
    required String pdfPath, // Path to the PDF file
    required String imagePath, // Path to the image file
  }) async {
    try {
      // Step 1: Create the user in Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 2: Upload PDF to Firebase Storage
      String pdfUrl = await _uploadFileToStorage(pdfPath, 'pdfs');

      // Step 3: Upload Image to Firebase Storage
      String imageUrl = await _uploadFileToStorage(imagePath, 'images');

      // Step 4: Save user details in Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'name': name,
        'surname': surname,
        'password': password,
        'email': email,
        'userType': userType,
        'contact': contact,
        'studentNumber': studentNumber,
        'pdfUrl': pdfUrl,
        'imageUrl': imageUrl,
      });

      // Step 5: Send email verification
      try {
        await userCredential.user!.sendEmailVerification();
        print('Email sent successfully');
      } catch (e) {
        print('Error sending email: $e');
      }

      // Step 6: Sign out the user (optional)
      await _auth.signOut();
    } catch (e) {
      print('Error registering user: $e');
      // Handle registration errors
    }
  }

  Future<DocumentSnapshot> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve and return user data from Firestore
      DocumentSnapshot userSnapshot = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();
      return userSnapshot;
    } catch (e) {
      print('Error logging in: $e');
      throw e; // Rethrow the exception for handling in the UI
    }
  }

  Future<String> _uploadFileToStorage(
      String filePath, String storageFolder) async {
    try {
      Reference storageReference = _storage
          .ref()
          .child('$storageFolder/${DateTime.now().millisecondsSinceEpoch}');
      UploadTask uploadTask = storageReference.putFile(File(filePath));
      await uploadTask.whenComplete(() => null);
      return await storageReference.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      // Handle file upload errors
      return '';
    }
  }
}
