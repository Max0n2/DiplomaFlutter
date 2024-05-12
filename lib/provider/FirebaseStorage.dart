import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_party/models/eventModel.dart';
import 'package:easy_party/models/productsModel.dart';
import 'package:easy_party/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorage with ChangeNotifier {
  List<UserModel> userInfo = [];
  List<EventModel> eventInfo = [];
  List inviteCodes = [];
  List<UserModelInEvent> usersInEvent = [];
  List<ProductsModel> productsInEvent = [];
  late String inviteCode;

  Future<List<UserModelInEvent>> getUsersFromEvent(String code) async {
    final docRef = FirebaseFirestore.instance.collection('event').doc(code).collection('users');
    final querySnapshot = await docRef.get();
    usersInEvent =  querySnapshot.docs.map((doc) => UserModelInEvent.fromFirestore(doc.data())).toList();
    return usersInEvent;
  }

  void newAddProductToEvent(
      String name, String price, String count, String inviteCode) async {
    Map<String, dynamic> eventProductsToFirestore() {
      return {
        if (name != null) "name": name,
        if (price != null) "price": double.parse(price),
        if (count != null) "count": double.parse(count),
        if (count != null)
          "fullPrice": double.parse(price) * double.parse(count),
      };
    }

    final docRef = FirebaseFirestore.instance
        .collection('event')
        .doc(inviteCode)
        .collection('products')
        .doc();

    Map<String, dynamic> eventData = eventProductsToFirestore();
    await docRef.set(eventData);
  }

  Stream<List<ProductsModel>> getProductsStream(String code) {
    StreamController<List<ProductsModel>> controller = StreamController<List<ProductsModel>>();

    FirebaseFirestore.instance.collection('event').doc(code).collection('products').snapshots().listen((querySnapshot) {
      List<ProductsModel> productsList = [];
      querySnapshot.docs.forEach((doc) {
        productsList.add(ProductsModel.fromFirestore(doc.data()));
      });
      controller.add(productsList);
    }, onError: (error) {
      controller.addError(error);
    });

    return controller.stream;
  }

  Future<List> getProducts(String code) async {
    List<ProductsModel> _productsInEvent = [];
    final docRef = FirebaseFirestore.instance.collection('event').doc(code).collection('products');
    final querySnapshot = await docRef.get();
    _productsInEvent = querySnapshot.docs.map((doc) => ProductsModel.fromFirestore(doc.data())).toList();
    return productsInEvent = _productsInEvent;
  }

  double calculateAllPrice() {
    double totalPrice = 0;
    productsInEvent.forEach((element) {
      totalPrice += element.fullPrice;
    });
    return totalPrice;
  }

  double calculateUserPrice() {
    double totalPrice = 0;
    productsInEvent.forEach((element) {
      totalPrice += element.fullPrice;
    });
    return totalPrice / usersInEvent.length;
  }

  void putUser(String firstname, String lastname) async {
    Map<String, dynamic> toFirestore() {
      return {
        if (firstname != null) "firstname": firstname,
        if (lastname != null) "lastname": lastname,
      };
    }

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    Map<String, dynamic> userData = toFirestore();
    await docRef.set(userData);
  }

  Future<List<UserModel>> getUser() async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    try {
      DocumentSnapshot doc = await docRef.get();
      Map<String, dynamic> jsonData = doc.data() as Map<String, dynamic>;
      UserModel user = UserModel.fromFirestore(jsonData);

      print('Info ${user.firstname} ${user.lastname}');

      userInfo.add(user);
      inviteCodes.addAll(user.inviteCodes.map((event) => event['inviteCode']));

      return userInfo;
    } catch (e) {
      print('Error fetching user data: $e');
      return [];
    }
  }

  void putEvent(String name, String place, Timestamp date, String firstname,
      String lastname, double money) async {
    String _inviteCode =
        '${DateTime.now().millisecondsSinceEpoch}${FirebaseAuth.instance.currentUser!.uid}';
    Map<String, dynamic> eventToFirestore() {
      return {
        if (name != null) "name": name,
        if (place != null) "place": place,
        if (date != null) "date": date.millisecondsSinceEpoch,
        if (inviteCode != null) "inviteCode": _inviteCode,
      };
    }

    Map<String, dynamic> userToFirestore() {
      return {
        if (firstname != null) "firstname": firstname,
        if (lastname != null) "lastname": lastname,
        if (money != null) "money": money,
      };
    }

    Map<String, dynamic> toFirestore() {
      return {
        if (inviteCode != null) "inviteCode": inviteCode,
      };
    }

    inviteCode = _inviteCode;

    final docRef =
        FirebaseFirestore.instance.collection('event').doc(inviteCode);

    final docRefEventList = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    final docRef2 =
    FirebaseFirestore.instance.collection('event').doc(inviteCode).collection('users');

    Map<String, dynamic> eventData = eventToFirestore();
    await docRef.set(eventData);

    Map<String, dynamic> inviteCodeData = toFirestore();
    await docRefEventList.update({
      'eventList': FieldValue.arrayUnion([inviteCodeData])
    });

    Map<String, dynamic> userData = userToFirestore();
    await docRef2.add(userData);
    notifyListeners();
  }

  void addProductToEvent(
      String name, String price, String count, String inviteCode) async {
    Map<String, dynamic> eventProductsToFirestore() {
      return {
        if (name != null) "name": name,
        if (price != null) "price": double.parse(price),
        if (count != null) "count": double.parse(count),
        if (count != null)
          "fullPrice": double.parse(price) * double.parse(count),
      };
    }

    final docRef =
        FirebaseFirestore.instance.collection('event').doc(inviteCode);

    Map<String, dynamic> userData = eventProductsToFirestore();
    await docRef.update({
      'productList': FieldValue.arrayUnion([userData])
    });
    notifyListeners();
  }

  Future<List> getEvent(String code) async {
    eventInfo.clear();
    final docRef = FirebaseFirestore.instance.collection('event').doc(code);
    try {
      DocumentSnapshot doc = await docRef.get();
      if (doc.exists) {
        Map<String, dynamic> jsonData = doc.data() as Map<String, dynamic>;
        EventModel event = EventModel.fromFirestore(jsonData);
        eventInfo.add(event);

        List<UserModelInEvent> _usersInEvent = [];
        final docRef = FirebaseFirestore.instance
            .collection('event')
            .doc(code)
            .collection('users');

        Stream<QuerySnapshot> snapshotStream = docRef.snapshots();

        snapshotStream.listen((querySnapshot) {
          _usersInEvent.clear();
          querySnapshot.docs.forEach((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            UserModelInEvent users = UserModelInEvent.fromFirestore(data);
            _usersInEvent.add(users);
            usersInEvent = _usersInEvent;
          });
        });


        return usersInEvent;
      } else {
        print('Document does not exist');
        return [];
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return [];
    }
  }

  void addToListEvents(String inviteCode, String firstname, String lastname,
      double money) async {

    final docRefUsertList =
        FirebaseFirestore.instance.collection('event').doc(inviteCode).collection('users');

    Map<String, dynamic> userToFirestore() {
      return {
        if (firstname != null) "firstname": firstname,
        if (lastname != null) "lastname": lastname,
        if (money != null) "money": money,
      };
    }
    Map<String, dynamic> userData = userToFirestore();
    await docRefUsertList.add(userData);
  }

  void addUserToListEventsAndProfile(String inviteCode, String firstname, String lastname,
      double money) async {

    final docRefUsertList =
    FirebaseFirestore.instance.collection('event').doc(inviteCode).collection('users');

    Map<String, dynamic> userToFirestore() {
      return {
        if (firstname != null) "firstname": firstname,
        if (lastname != null) "lastname": lastname,
        if (money != null) "money": money,
      };
    }


    Map<String, dynamic> userData = userToFirestore();
    await docRefUsertList.add(userData);
  }

  void addToProfile(String _inviteCode) async {
    final docRefUsertProfile =
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);

    Map<String, dynamic> toFirestore() {
      return {
        if (_inviteCode != null) "inviteCode": _inviteCode,
      };
    }

    Map<String, dynamic> inviteCodeData = toFirestore();
    await docRefUsertProfile.update({
      'eventList': FieldValue.arrayUnion([inviteCodeData])
    });
  }
}
