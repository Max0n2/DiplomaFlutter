import 'package:easy_party/consts/colors.dart';
import 'package:easy_party/consts/fonts.dart';
import 'package:flutter/material.dart';

class BaseInput extends StatelessWidget {
  const BaseInput({super.key, required this.Controller, required this.hintText, required this.labelText});

  final TextEditingController Controller;
  final String hintText;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        style: TextStyle(color: white),
        controller: Controller,
        decoration: InputDecoration(
          fillColor: black,
          filled: true,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          labelText: labelText,
          labelStyle: comforta24white,
          counterText: '',
          hintText: '$hintText',
          hintStyle: comforta16white,
        ),
        // errorText: alfa,
      ),
    );
  }
}
