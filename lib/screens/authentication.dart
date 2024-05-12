import 'package:easy_party/consts/colors.dart';
import 'package:easy_party/consts/fonts.dart';
import 'package:easy_party/provider/FirebaseAuth.dart';
import 'package:easy_party/provider/FirebaseStorage.dart';
import 'package:easy_party/provider/FirebaseStorageEvent.dart';
import 'package:easy_party/reusableWidgets/button.dart';
import 'package:easy_party/reusableWidgets/buttonWithIcon.dart';
import 'package:easy_party/reusableWidgets/input.dart';
import 'package:easy_party/reusableWidgets/inputWithIcon.dart';
import 'package:easy_party/screens/events.dart';
import 'package:easy_party/screens/registration.dart';
import 'package:easy_party/screens/select.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthntication>(context);

    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        backgroundColor: black,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12, 96, 12, 12),
                  child: Text('',style: arturo24green,),
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
              GestureDetector(
                onTap: () {
                  auth.login(
                      _emailController.text, _passwordController.text, context);
                },
                child: BaseButton(buttonText: 'Sign in', size: 0.6,),
              ),
              // GestureDetector(
              //   child: ButtonWithIcon(
              //     bgColor: bg,
              //     CompanyName: "Google",
              //     textStyle: comforta16black,
              //   ),
              //   onTap: (){
              //     auth.signInWithGoogle(context);
              //   },
              // ),
              // ButtonWithIcon(
              //     bgColor: black, CompanyName: "Apple", textStyle: comforta16white),
              GestureDetector(
                child: Text('If you don’t have an accaunt'),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Regestration()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final event = Provider.of<FirebaseStorage>(context);
    final storage = Provider.of<FirebaseStorage>(context);
    final auth = Provider.of<FirebaseAuthntication>(context);

    if (auth.user != null) {
      return AuthWrapper2();
    } else {
      context.go('/selectpage');
      return SelectPage();
    }
  }
}

class AuthWrapper2 extends StatelessWidget {
  const AuthWrapper2({super.key});

  @override
  Widget build(BuildContext context) {

    final event = Provider.of<FirebaseEvent>(context);
    final storage = Provider.of<FirebaseStorage>(context);

    storage.getUser();
    return StreamBuilder(
      stream: FlutterBranchSdk.listSession(),
      builder: (context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final deepLinkData = snapshot.data!;
          final inviteCode = deepLinkData['inviteCode'] as String?;
          if (inviteCode != null) {
            storage.eventInfo.clear();
            storage.addToProfile(inviteCode);
            storage.addUserToListEventsAndProfile(
              inviteCode,
              storage.userInfo.first.firstname,
              storage.userInfo.first.lastname,
              0,
            );
            print(inviteCode);
          }
          return Events();
        } else {
          return Events();
        }
      },
    );
  }
}

