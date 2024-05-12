import 'package:easy_party/consts/colors.dart';
import 'package:easy_party/reusableWidgets/button.dart';
import 'package:easy_party/screens/authentication.dart';
import 'package:easy_party/screens/registration.dart';
import 'package:flutter/material.dart';

class SelectPage extends StatelessWidget {
  const SelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              child: BaseButton(buttonText: "Sign up", size: 1)),
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Regestration()));
              },
              child: BaseButton(buttonText: "Sign in", size: 1)),
        ],
      ),
    ));
  }
}
