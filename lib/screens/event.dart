import 'package:easy_party/consts/colors.dart';
import 'package:easy_party/consts/fonts.dart';
import 'package:easy_party/modals/addNewProductModal.dart';
import 'package:easy_party/models/productsModel.dart';
import 'package:easy_party/models/userModel.dart';
import 'package:easy_party/provider/FirebaseStorage.dart';
import 'package:easy_party/provider/FirebaseStorageEvent.dart';
import 'package:easy_party/provider/FirebaseStorageUsers.dart';
import 'package:easy_party/provider/FirebaseTest.dart';
import 'package:easy_party/reusableWidgets/button.dart';
import 'package:easy_party/reusableWidgets/input.dart';
import 'package:easy_party/reusableWidgets/inputForAddNewItem.dart';
import 'package:easy_party/reusableWidgets/numberInput.dart';
import 'package:easy_party/screens/members.dart';
import 'package:easy_party/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class Event extends StatelessWidget {
  const Event({
    super.key,
    // required this.name,
    // required this.place,
    required this.inviteCode,
    required this.indexValue,
    // required this.date,
  });

  // final String name;
  // final String place;
  final String inviteCode;
  final int indexValue;

  // final int date;

  // final List<UserModelInEvent> users;

  @override
  Widget build(BuildContext context) {
    final f = new DateFormat('HH:mm yyyy-MM-dd');

    final storage = Provider.of<FirebaseStorage>(context);
    final user = Provider.of<FirebaseStorageUsers>(context);
    final event = Provider.of<FirebaseEvent>(context);
    final test = Provider.of<FirebaseTest>(context);


    return SafeArea(
      child: Scaffold(
        backgroundColor: black,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              context.go('/events');
            },
          ),
          iconTheme: IconThemeData(
            color: white,
          ),
          title: Text(
            event.eventsList[indexValue].name,
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
        bottomNavigationBar: GestureDetector(
          child: BaseButton(buttonText: 'Add new item', size: 0.8),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return addNewProductModal(
                    inviteCode: inviteCode,
                  );
                });
          },
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: Future.wait([
              storage.getEvent(inviteCode),
              storage.getProducts(inviteCode),
              storage.getUsersFromEvent(inviteCode),
            ]),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${f.format(DateTime.fromMillisecondsSinceEpoch(event.eventsList[indexValue].date))}',
                      style: comforta16white,
                    ),
                    Text("${storage.calculateAllPrice().toString()}",
                        style: comforta24white),
                    GestureDetector(
                        onTap: () async {
                          try {
                            // Create BranchUniversalObject
                            BranchUniversalObject buo = BranchUniversalObject(
                              canonicalIdentifier: 'content/123',
                              title: 'Invite to event',
                              imageUrl: 'https://cdn-icons-png.flaticon.com/512/5234/5234972.png',
                              contentDescription: 'Thats a your invite to my event',
                              keywords: ['tag1', 'tag2'],
                              publiclyIndex: true,
                              locallyIndex: true,
                              contentMetadata: BranchContentMetaData()..addCustomMetadata('inviteCode', event.eventsList[indexValue].inviteCode),
                            );

                            // Define BranchLinkProperties
                            BranchLinkProperties lp = BranchLinkProperties(
                              campaign: 'content 123',
                            );

                            // Generate short URL
                            BranchResponse? response =
                            await FlutterBranchSdk.getShortUrl(
                                buo: buo, linkProperties: lp);

                            // Check if response is successful
                            if (response != null && response.success) {
                              Share.share("${response.result}");
                              print('Link generated: ${response.result}');
                              // Share.share(response.result);
                            } else {
                              // Handle error
                              print(
                                  'Error : ${response?.errorCode} - ${response?.errorMessage}');
                            }
                          } catch (e) {
                            print('Error: $e');
                          }
                        },
                        child: BaseButton(
                            buttonText: "Share event link", size: 0.7)),
                    Text(
                      event.eventsList[indexValue].place,
                      style: comforta16white,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Members",
                            style: comforta16white,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (contex) => MembersPage(
                                    name: event.eventsList.first.name,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'View All',
                              style: comforta12grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // рядок перед списком юзерів
                    Container(
                      height: 150,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: storage.usersInEvent.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: purple,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(90)),
                                        child: Image(
                                          height:
                                          MediaQuery.of(context).size.width *
                                              0.15,
                                          width: MediaQuery.of(context).size.width *
                                              0.15,
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              'https://www.news10.com/wp-content/uploads/sites/64/2022/07/Cat.jpg?w=2560&h=1440&crop=1'),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        storage.usersInEvent[index].firstname,
                                        style: comforta16grey,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
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
                    ), // список юзерів
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Items",
                            style: comforta16white,
                          ),
                          Text(
                            storage.productsInEvent.length.toString(),
                            style: comforta12grey,
                          ),
                        ],
                      ),
                    ),
                    // рядочк перед списком предментів
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: StreamBuilder<List<ProductsModel>>(
                        stream: storage.getProductsStream(inviteCode),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                              child: Text('No products available'),
                            );
                          } else {
                            List<ProductsModel> products = snapshot.data!;
                            return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: products.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (index < products.length) {
                                  // Ось ваш код елемента списку
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: purple,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.symmetric(vertical: 12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                                '${products[index].name}',
                                                style: comforta16white),
                                            Column(
                                              children: [
                                                Text(
                                                    '${products[index].fullPrice}',
                                                    style: comforta16white),
                                                Text(
                                                  '${products[index].count}',
                                                  style: comforta12grey,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return SizedBox();
                                }
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
