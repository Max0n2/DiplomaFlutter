import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_party/models/eventModel.dart';
import 'package:easy_party/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseEvent extends ChangeNotifier {
  List<EventModel> eventsList = [];
  late String inviteCode;
  List inviteCodes = [];

  Future<List<EventModel>> getEvents() async {
    final docRefForUsers = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    DocumentSnapshot docForUser = await docRefForUsers.get();
    Map<String, dynamic> jsonData = docForUser.data() as Map<String, dynamic>;
    UserModel user = UserModel.fromFirestore(jsonData);

    eventsList.clear();
    inviteCodes.clear();

    inviteCodes.addAll(user.inviteCodes.map((event) => event['inviteCode']));
    if (inviteCodes.isEmpty) {
      return [];
    }

    for (var code in inviteCodes) {
      final docRef = FirebaseFirestore.instance.collection('event').doc(code);
      try {
        DocumentSnapshot doc = await docRef.get();
        if (doc.exists) {
          Map<String, dynamic> jsonData = doc.data() as Map<String, dynamic>;
          EventModel event = EventModel.fromFirestore(jsonData);

          if (!eventsList.any((e) => e.inviteCode == event.inviteCode)) {
            eventsList.add(event);
          }
        }
      } catch (e) {
        print('Error fetching user data: $e');
        return [];
      }
    }
    return eventsList;
  }


}