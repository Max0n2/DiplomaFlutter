import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_party/screens/authentication.dart';
import 'package:easy_party/screens/events.dart';
import 'package:easy_party/screens/select.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class FirebaseAuthntication with ChangeNotifier{
  User? _user;

  User? get user => _user;

  FirebaseAuthntication() {
    FirebaseAuth.instance.authStateChanges().listen(checkIfUserIsLoggiedIn);
  }

  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    User? user = googleUser as User?;
    if (user != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Events()));
    } else {}
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> login(String _emailController,
      String _passwordController, BuildContext context) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: _emailController, password: _passwordController);
    User? user = userCredential.user;

    if (user != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Events()));
    } else {}
    notifyListeners();
  }

  Future<void> registration(String _email, String _password, BuildContext context, String firstname, String lastname) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );


      Map<String, dynamic> toFirestore() {
        return {
          if (firstname != null) "firstname": firstname,
          if (lastname != null) "lastname": lastname,
        };
      }

      final docRef = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);

      Map<String, dynamic> userData = toFirestore();
      await docRef.set(userData);

      await docRef.update({
        'eventList': FieldValue.arrayUnion([])
      });

    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        print('Error: Invalid email address.');
      } else if (e.code == 'weak-password') {
        print('Error: Weak password.');
      } else if (e.code == 'email-already-in-use') {
        print('Error: Email already in use.');
      } else {
        print('Error: ${e.code} - ${e.message}');
      }

      return null;
    }

    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SelectPage()));
    notifyListeners();
  }


  Future<void> checkIfUserIsLoggiedIn(User? firebaseUser) async {
    _user = firebaseUser;
    notifyListeners();
  }
}

// Future<dynamic> signInWithApple() async {
//   final appleProvider = AppleAuthProvider();
//
//   UserCredential userCredential = await FirebaseAuth.instance.signInWithPopup(appleProvider);
//   // Keep the authorization code returned from Apple platforms
//   String? authCode = userCredential.additionalUserInfo?.authorizationCode;
//   // Revoke Apple auth token
//   await FirebaseAuth.instance.revokeTokenWithAuthorizationCode(authCode!);
// }