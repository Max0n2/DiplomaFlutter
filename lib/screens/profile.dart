import 'dart:io';

import 'package:easy_party/consts/colors.dart';
import 'package:easy_party/consts/fonts.dart';
import 'package:easy_party/provider/FirebaseAuth.dart';
import 'package:easy_party/provider/FirebaseStorage.dart';
import 'package:easy_party/provider/FirebaseStorageUsers.dart';
import 'package:easy_party/reusableWidgets/button.dart';
import 'package:easy_party/reusableWidgets/input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthntication>(context);
    final storage = Provider.of<FirebaseStorage>(context);
    final users = Provider.of<FirebaseStorageUsers>(context);

    final TextEditingController _firstnameController = TextEditingController(text: storage.userInfo.first.firstname);
    final TextEditingController _lastnameController = TextEditingController(text: storage.userInfo.first.lastname);

    return SafeArea(
      child: Scaffold(
        backgroundColor: black,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: white,
          ),
          backgroundColor: bgreen,
          centerTitle: true,
          flexibleSpace: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(),
              Padding(
                padding: EdgeInsets.all(3),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(90)),
                    child: Image(
                      height: MediaQuery
                          .of(context)
                          .size
                          .width * 0.1,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.1,
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://www.news10.com/wp-content/uploads/sites/64/2022/07/Cat.jpg?w=2560&h=1440&crop=1'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: FutureBuilder(
          future: storage.getUser(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {

                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(90)),
                            child: Image(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.35,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.35,
                              fit: BoxFit.cover,
                              image: NetworkImage('https://www.news10.com/wp-content/uploads/sites/64/2022/07/Cat.jpg?w=2560&h=1440&crop=1'),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        '${storage.userInfo.isNotEmpty ? storage.userInfo.first.firstname : ''} ${storage.userInfo.isNotEmpty ? storage.userInfo.first.lastname : ''}', style: comforta24black,),
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
                          storage.putUser(
                              _firstnameController.text, _lastnameController.text);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (contex) => Profile(),
                            ),
                          );
                        },
                        child: BaseButton(buttonText: 'Save', size: 0.8),
                      ),
                      GestureDetector(
                        onTap: () {
                          storage.userInfo.clear();
                          auth.logout(context);
                        },
                        child: BaseButton(buttonText: 'Log out', size: 0.8),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
