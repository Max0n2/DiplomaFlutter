import 'package:easy_party/consts/colors.dart';
import 'package:easy_party/consts/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseInputWithIcon extends StatelessWidget {
  const BaseInputWithIcon({super.key, required this.Controller, required this.hintText, required this.iconName, required this.labelText});

  final TextEditingController Controller;
  final String hintText;
  final IconData iconName;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: Controller,
        decoration: InputDecoration(
          prefixIcon: Icon(iconName),
          iconColor: black,
          fillColor: lgreen,
          filled: true,
          labelText: labelText,
          labelStyle: comforta24black,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30),
          ),
          counterText: '',
          hintText: '$hintText',
          hintStyle: comforta16black,
        ),
        // errorText: alfa,
      ),
    );
  }
}
