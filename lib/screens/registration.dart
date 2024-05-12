import 'package:easy_party/consts/colors.dart';
import 'package:easy_party/consts/fonts.dart';
import 'package:easy_party/provider/FirebaseStorage.dart';
import 'package:easy_party/reusableWidgets/button.dart';
import 'package:easy_party/reusableWidgets/input.dart';
import 'package:easy_party/reusableWidgets/inputWithIcon.dart';
import 'package:easy_party/screens/authentication.dart';
import 'package:easy_party/screens/editProfile.dart';
import 'package:easy_party/screens/events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/FirebaseAuth.dart';

class Regestration extends StatelessWidget {
  const Regestration({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthntication>(context);
    final storage = Provider.of<FirebaseStorage>(context);

    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _firstnameController = TextEditingController();
    final TextEditingController _lastnameController = TextEditingController();


    return SafeArea(
      child: Scaffold(
        backgroundColor: black,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '',
                      style: arturo24green,
                    ),
                  ),
                ),
                BaseInput(
                  Controller: _emailController,
                  hintText: _emailController.text,
                  labelText: 'Email',
                ),
                BaseInput(
                  Controller: _passwordController,
                  hintText: _passwordController.text,
                  labelText: 'Password',
                ),
                BaseInput(
                    Controller: _firstnameController,
                    hintText: '',
                    labelText: 'Firstname'),
                BaseInput(
                    Controller: _lastnameController,
                    hintText: '',
                    labelText: 'Lastname'),
                GestureDetector(
                  onTap: () {
                    auth.registration(
                        _emailController.text, _passwordController.text, context, _firstnameController.text, _lastnameController.text);
                    storage.putUser(
                        _firstnameController.text, _lastnameController.text);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Events()));
                  },
                  child: BaseButton(
                    buttonText: 'Regestration',
                    size: 0.6,
                  ),
                ),
                GestureDetector(
                  child: Text('If you have an accaunt'),
                  onTap: () {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => Login()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
