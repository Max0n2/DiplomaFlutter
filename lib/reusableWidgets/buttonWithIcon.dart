import 'package:easy_party/consts/colors.dart';
import 'package:easy_party/consts/fonts.dart';
import 'package:flutter/material.dart';

class ButtonWithIcon extends StatelessWidget {
  const ButtonWithIcon({super.key, required this.bgColor, required this.CompanyName, required this.textStyle});

  final Color bgColor;
  final String CompanyName;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.5),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: black),
            bottom: BorderSide(color: black),
            left: BorderSide(color: black),
            right: BorderSide(color: black),
          ),
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: bgColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(child: Image.asset('assets/images/${CompanyName}.png'), width: 29, height: 59,),
            Text(
              'Sign in with ${CompanyName}',
              style: textStyle,
            )
          ],
        ),
      ),
    );
  }
}
