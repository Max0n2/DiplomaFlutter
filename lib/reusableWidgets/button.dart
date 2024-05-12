import 'package:easy_party/consts/colors.dart';
import 'package:easy_party/consts/fonts.dart';
import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  const BaseButton({
    super.key, required this.buttonText, required this.size,
  });

  final String buttonText;
  final num size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13.5),
      child: Container(
        width: MediaQuery.of(context).size.width * size,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: blue,
        ),
        child: Center(
          child: Text(
            buttonText,
            style: comforta24black,
          ),
        ),
      ),
    );
  }
}