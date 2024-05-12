import 'package:easy_party/consts/colors.dart';
import 'package:easy_party/consts/fonts.dart';
import 'package:easy_party/provider/FirebaseStorage.dart';
import 'package:easy_party/reusableWidgets/button.dart';
import 'package:easy_party/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MembersPage extends StatelessWidget {
  const MembersPage({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {

    final storage = Provider.of<FirebaseStorage>(context);


    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: white,
            ),
            title: Text(
              name,
              style: comforta15white,
            ),
            backgroundColor: black,
            centerTitle: true,
            flexibleSpace: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(),
                Padding(
                  padding: EdgeInsets.all(3),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (contex) => Profile(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(90)),
                        child: Image(
                          height: MediaQuery.of(context).size.width * 0.1,
                          width: MediaQuery.of(context).size.width * 0.1,
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              'https://www.news10.com/wp-content/uploads/sites/64/2022/07/Cat.jpg?w=2560&h=1440&crop=1'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: black,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: storage.usersInEvent.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: purple,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(90)),
                              child: Image(
                                height: MediaQuery.of(context).size.width * 0.15,
                                width: MediaQuery.of(context).size.width * 0.15,
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    'https://www.news10.com/wp-content/uploads/sites/64/2022/07/Cat.jpg?w=2560&h=1440&crop=1'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Text("${storage.usersInEvent[index].firstname} ${storage.usersInEvent[index].lastname}",
                              style: comforta16white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Text(
                              "${storage.calculateUserPrice().toString()}",
                              overflow: TextOverflow.ellipsis,
                              style: comforta16white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          GestureDetector(
            child: BaseButton(
                buttonText: 'Share event link', size: 0.8),
            onTap: () {},
          )
        ],
      ),
    ));
  }
}
