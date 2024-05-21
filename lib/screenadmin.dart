import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/AllOfToday/all_of_today.dart';
import 'package:doctor/screen/adduser/screen/adduser.dart';
import 'package:doctor/screen/dashbord/screen/dashbord.dart';
import 'package:doctor/screen/patients/screen/patients.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class screenadmin extends StatefulWidget {
  const screenadmin({super.key});

  @override
  State<screenadmin> createState() => _screenadminState();
}

class _screenadminState extends State<screenadmin> {
  bool isSwitched = false;
  var getswitch = '';
  Map bt = {
    'Patients': 'Patients',
    'Add User': 'Add User',
    'Dashbord': 'Dashbord',
    'AllOfToday': 'AllOfToday'
  };
  String buton = 'Patients';
  showScreen(String nameScreen) {
    if (nameScreen == 'Patients') {
      return const patients();
    } else if (nameScreen == 'Add User') {
      return const adduser();
    } else if (nameScreen == 'Dashbord') {
      return const dashbord();
    } else if (nameScreen == 'AllOfToday') {
      return const AllOfToday();
    }
  }

  testbool() async {
    DocumentSnapshot come =
        await FirebaseFirestore.instance.collection('come').doc('admin').get();
    setState(() {
      getswitch = come['switch'].toString();
    });
    if (getswitch == 'true') {
      setState(() {
        isSwitched = true;
      });
    } else {
      setState(() {
        isSwitched = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    testbool();
    super.initState();
  }

  updateSwitch() async {
    CollectionReference Update = FirebaseFirestore.instance.collection('come');
    await Update.doc('admin').update({'switch': isSwitched});
  }

  @override
  Widget build(BuildContext context) {
    final heights = MediaQuery.of(context).size.height;
    final widths = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: buton != 'Dashbord'
            ? Color(0xffEFF7F8)
            : Colors.white, //Color(0xFFF5F5F5)
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
                      button_menu(
                          'Patients', CupertinoIcons.timer, Color(0xff0E9CAB)),
                      button_menu('Add User', Icons.person, Color(0xff0E9CAB)),
                      button_menu(
                          'Dashbord', Icons.dashboard, Color(0xff0E9CAB)),
                      button_menu('AllOfToday',
                          Icons.calendar_view_month_rounded, Color(0xff0E9CAB)),
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
                                  (doc) => Switch(
                                      activeColor:
                                          Color.fromARGB(255, 255, 0, 0),
                                      value: doc['switch'].toString() == 'true'
                                          ? isSwitched = true
                                          : isSwitched = false,
                                      onChanged: (value) {
                                        setState(() {
                                          isSwitched = value;
                                        });
                                        // print(isSwitched);
                                        updateSwitch();
                                      }),
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
                  SizedBox()
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
