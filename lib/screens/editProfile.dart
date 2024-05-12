import 'package:easy_party/consts/colors.dart';
import 'package:easy_party/provider/FirebaseStorage.dart';
import 'package:easy_party/reusableWidgets/button.dart';
import 'package:easy_party/reusableWidgets/input.dart';
import 'package:easy_party/reusableWidgets/inputWithIcon.dart';
import 'package:easy_party/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key, required this.firstname, required this.lastname});

  final String firstname;
  final String lastname;

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<FirebaseStorage>(context);

    final TextEditingController _firstnameController = TextEditingController(text: storage.userInfo.first.firstname);
    final TextEditingController _lastnameController = TextEditingController(text: storage.userInfo.first.lastname);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: black,
          ),
          backgroundColor: bgreen,
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(90)),
                    child: Image(
                      height: MediaQuery.of(context).size.width * 0.35,
                      width: MediaQuery.of(context).size.width * 0.35,
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://www.news10.com/wp-content/uploads/sites/64/2022/07/Cat.jpg?w=2560&h=1440&crop=1'),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
