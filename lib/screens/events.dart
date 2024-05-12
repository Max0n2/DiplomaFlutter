import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_party/consts/colors.dart';
import 'package:easy_party/consts/fonts.dart';
import 'package:easy_party/provider/FirebaseStorage.dart';
import 'package:easy_party/provider/FirebaseStorageEvent.dart';
import 'package:easy_party/provider/FirebaseTest.dart';
import 'package:easy_party/reusableWidgets/button.dart';
import 'package:easy_party/reusableWidgets/input.dart';
import 'package:easy_party/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' as fos;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Events extends StatelessWidget {
  const Events({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<FirebaseStorage>(context);
    final event = Provider.of<FirebaseEvent>(context);
    final test = Provider.of<FirebaseTest>(context);

    final TextEditingController _eventNameController = TextEditingController();
    final TextEditingController _eventPlaceController = TextEditingController();
    final TextEditingController _inviteCodeController = TextEditingController();
    final controller = fos.MapController.withPosition(
      initPosition: fos.GeoPoint(
        latitude: 47.4358055,
        longitude: 8.4737324,
      ),
    );

    DateTime date = DateTime.now();
    final f = new DateFormat('yyyy-MM-dd HH:mm');

    void openGoogleMaps(double latitude, double longitude) async {
      final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }



    return SafeArea(
      child: Scaffold(
        backgroundColor: black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: bgreen,
          centerTitle: true,
          title: FutureBuilder(
            future: storage.getUser(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(),);
              } else {
                return Column(
                  children: [
                    Text(
                      'Welcome ${storage.userInfo.first.firstname}',
                      style: comforta16white,
                    ),
                    Text('Greate nice day for planning your leisure', style: comforta10grey,),
                  ],
                );
              }
            },
          ),
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
        body: Column(
          children: [
            Expanded(
              flex: 9,
              child: RefreshIndicator(
                onRefresh: () async {
                  storage.usersInEvent.clear();
                  storage.inviteCodes.clear();
                  event.eventsList.clear();
                  event.getEvents();
                },
                child: FutureBuilder(
                  future: event.getEvents(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                      // Image.asset("assets/images/Racoon.gif")
                    } else {
                      return ListView.builder(
                          itemCount: event.eventsList.length,
                            itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: purple,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.2,
                                          height: MediaQuery.of(context).size.height * 0.15,
                                          child: fos.OSMFlutter(
                                            controller: controller,
                                            osmOption: fos.OSMOption(
                                              zoomOption: fos.ZoomOption(initZoom: 3),
                                              markerOption: fos.MarkerOption(
                                                defaultMarker: fos.MarkerIcon(
                                                  icon: Icon(
                                                    Icons.person_pin_circle,
                                                    color: blue,
                                                    size: 56,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        context.go('/event/${event.eventsList[index].inviteCode}/${index}');
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (contex) => Event(
                                        //       inviteCode: storage.eventInfo[index].inviteCode, name: storage.eventInfo[index].name, place: storage.eventInfo[index].place, date: storage.eventInfo[index].date,
                                        //     ),
                                        //   ),
                                        // );
                                      },
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              '${f.format(DateTime.fromMillisecondsSinceEpoch(event.eventsList[index].date))}',
                                              style: comforta16white,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              '${event.eventsList[index].name}',
                                              style: comforta24black,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              "${event.eventsList[index].place}",
                                              overflow: TextOverflow.ellipsis,
                                              style: comforta16white,
                                            ),
                                          ),

                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0))),
                              content: Container(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      BaseInput(
                                          Controller: _inviteCodeController,
                                          hintText: '',
                                          labelText: 'Invite code'),
                                      GestureDetector(
                                          onTap: () {
                                            storage.addToListEvents(_inviteCodeController.text, storage.userInfo.first.firstname, storage.userInfo.first.lastname, 0);
                                          },
                                          child: BaseButton(
                                              buttonText: 'Add event',
                                              size: 0.8)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: BaseButton(
                      buttonText: 'Add event',
                      size: 0.4,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: black,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0))),
                              content: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      BaseInput(
                                          Controller: _eventNameController,
                                          hintText: '',
                                          labelText: 'Name'),
                                      BaseInput(
                                          Controller: _eventPlaceController,
                                          hintText: '',
                                          labelText: 'Place'),
                                      GestureDetector(
                                          onTap: () {
                                            showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2101),
                                            ).then((selectedDate) {
                                              // After selecting the date, display the time picker.
                                              if (selectedDate != null) {
                                                showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now(),
                                                ).then((selectedTime) {
                                                  // Handle the selected date and time here.
                                                  if (selectedTime != null) {
                                                    DateTime selectedDateTime =
                                                        DateTime(
                                                      selectedDate.year,
                                                      selectedDate.month,
                                                      selectedDate.day,
                                                      selectedTime.hour,
                                                      selectedTime.minute,
                                                    );
                                                    date = selectedDateTime;
                                                  }
                                                });
                                              }
                                            });
                                          },
                                          child: BaseButton(
                                              buttonText: 'Select Date',
                                              size: 0.8)),
                                      GestureDetector(
                                        onTap: () async {
                                          storage.putEvent(
                                              _eventNameController.text,
                                              _eventPlaceController.text,
                                              Timestamp.fromDate(date),
                                              storage.userInfo.first.firstname,
                                              storage.userInfo.first.lastname,
                                              0
                                          );
                                          storage.addToListEvents(_inviteCodeController.text, storage.userInfo.first.firstname, storage.userInfo.first.lastname, 0);
                                          Navigator.of(context).pop();
                                        },
                                        child: BaseButton(
                                            buttonText: 'Create event',
                                            size: 0.8),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: BaseButton(
                      buttonText: 'Create event',
                      size: 0.45,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
