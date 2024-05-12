import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_party/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseStorageUsers with ChangeNotifier {

  // Future<void> uploadImage() async {
  //   Directory appDocDir = await getApplicationDocumentsDirectory();
  //   String filePath = '${appDocDir.absolute}/file-to-upload.png';
  //   File file = File(filePath);
  //
  //   // final ImagePicker picker = ImagePicker();
  //   // XFile? _imageFile = await picker.pickImage(source: ImageSource.gallery);
  //
  //   if (file != null) {
  //     try {
  //       // File imageFile = File(_imageFile.path);
  //       print(imageFile);
  //
  //       var snapshot = await FirebaseStorage.instance
  //           .ref()
  //           .child('profile_photos/${DateTime.now().millisecondsSinceEpoch}')
  //           .putFile(imageFile);
  //
  //       String downloadUrl = await snapshot.ref.getDownloadURL();
  //
  //       print(downloadUrl);
  //     } catch (e) {
  //       print('Error uploading image: $e');
  //     }
  //   }
  //   notifyListeners();
  // }


  void putUserToEvent(String firstname, String lastname, double money, String inviteCode) async {
    Map<String, dynamic> toFirestore() {
      return {
        if (firstname != null) "firstname": firstname,
        if (lastname != null) "lastname": lastname,
        if (lastname != null) "money": money,
      };
    }

    final docRef =
    FirebaseFirestore.instance.collection('event').doc(inviteCode).collection('users').doc();

    Map<String, dynamic> userData = toFirestore();
    await docRef.set(userData);
  }

  // Future<List<UserModelInEvent>> getUsersFromEvent(String code) async {
  //   List<UserModelInEvent> _usersInEvent = [];
  //   final docRef = FirebaseFirestore.instance.collection('event').doc(code).collection('users');
  //   final querySnapshot = await docRef.get();
  //   _usersInEvent = await querySnapshot.docs.map((doc) => UserModelInEvent.fromFirestore(doc.data())).toList();
  //   return usersInEvent = _usersInEvent;
  // }

}