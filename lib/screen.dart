import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/screen/patientsadd/screen/patientsadd.dart';
import 'package:doctor/screen/patientsdate/screen/patientsdate.dart';
import 'package:doctor/screen/patientsold/screen/patientsoldd.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';

class screen extends StatefulWidget {
  const screen({super.key});

  @override
  State<screen> createState() => _screenState();
}

class _screenState extends State<screen> {
  String comming = '';
  var haveRing = false;
  Map bt = {
    'Patients Add': 'Patients Add',
    'Patients Date': 'Patients Date',
    'Patients Old': 'Patients Old'
  };
  updateSwitch() async {
    CollectionReference Update = FirebaseFirestore.instance.collection('come');
    await Update.doc('admin').update({'switch': 'false'});
  }

  String buton = 'Patients Add';
  showScreen(String nameScreen) {
    if (nameScreen == 'Patients Add') {
      return const patientsadd();
    } else if (nameScreen == 'Patients Date') {
      return const patientsdate();
    } else if (nameScreen == 'Patients Old') {
      return const patientsoldd();
    }
  }

  final player = AudioPlayer();
  getNotif(bool start) {
    player.play(
      AssetSource(
        'sound/sound02.mp3',
      ),
    );
    if (start == true) {
      player.onPlayerComplete.listen((event) {
        player.play(
          AssetSource('sound/sound02.mp3'),
        );
      });
    }
    if (start == false) {
      player.stop();
    }
  }

  common() async {
    DocumentSnapshot come =
        await FirebaseFirestore.instance.collection('come').doc('admin').get();
    setState(() {
      comming = come['switch'].toString();
    });
    print(comming);
  }

  @override
  Widget build(BuildContext context) {
    final heights = MediaQuery.of(context).size.height;
    final widths = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white, //Color(0xFFF5F5F5)
        body: Row(
          children: [left_menu(widths, heights), con_all()],
        ));
  }

  Expanded con_all() => Expanded(
          child: Container(
        color: const Color(0xFFE4E4E4),
        child: showScreen(buton),
      ));

  SizedBox left_menu(double widths, double heights) => SizedBox(
      width: widths / 9,
      height: heights,
      child: Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xff0E9CAB),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    topRight: Radius.circular(50)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFE4E4E4),
                    blurRadius: 3,
                  )
                ]),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                            height: 100,
                            width: 100,
                            child: SvgPicture.asset('assets/images/logo.svg')),
                      ), //ClipRRect(child:Image.asset('assets/images/1.png'))),
                      button_menu('Patients Add', CupertinoIcons.home,
                          Color(0xff0E9CAB)),
                      button_menu(
                          'Patients Date', Icons.date_range, Color(0xff0E9CAB)),
                      button_menu('Patients Old', Icons.reorder_outlined,
                          Color(0xff0E9CAB)),
                    ],
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("come")
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text(''),
                          );
                        } else {
                          return ListView(
                            children: snapshot.data!.docs
                                .map(
                                  (doc) => doc['switch'].toString() == 'true'
                                      ? GestureDetector(
                                          onLongPress: () {
                                            updateSwitch();
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 100,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  border: Border.all(
                                                      color: Color(0xff0E9CAB),
                                                      width: 2),
                                                ),
                                                child: Lottie.asset(
                                                  'assets/animation/not22.json',
                                                ),
                                              ),
                                              Container(child: getNotif(true))
                                            ],
                                          ),
                                        )
                                      : Container(
                                          child: getNotif(false),
                                        ),
                                )
                                .toList(),
                          );
                        }
                        // ...
                      },
                    ),
                  ),
                  button_menu(
                      'Logout', Icons.logout_outlined, Color(0xff0E9CAB)),
                  const SizedBox(
                    height: 100,
                  ),
                ]),
          )));

  Padding button_menu(
    String title,
    IconData icon,
    Color border,
  ) {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SizedBox(
          height: 80,
          width: 60,
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: buton == title ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  focusColor: Colors.amber,
                  onTap: () => title == 'Logout'
                      ? Navigator.pop(context)
                      : setState(() {
                          buton = bt[title];
                        }),
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(icon,
                                size: 30,
                                color: buton == title ? border : Colors.white),
                            // Text('',style:TextStyle(color:buton==title?border:Colors.white,fontSize:12),)
                          ])))),
        ));
  }
}
