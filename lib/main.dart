// import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:doctor/firebase_options.dart';
import 'package:doctor/firebasetest.dart';
import 'package:doctor/screen.dart';
import 'package:doctor/screen/login/screen/login.dart';
import 'package:doctor/screen/patients/screen/patients.dart';
import 'package:doctor/screenadmin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  sharedPref = await SharedPreferences.getInstance();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: const Color(0xFFE4E4E4),
    ),
    initialRoute: '/', //sharedPref.getString("token")==null?'/':'/screen',
    routes: {
      '/user': (context) => const screen(),
      '/admin': (context) => const screenadmin(),
      '/': (context) => const login(),
      '/r': (context) => const patients(),

      // '/': (context) => const firebasetest(),
    },
  ));
  // doWhenWindowReady(() {
  //   var iniSize = Size(1200, 720);
  //   appWindow.size = iniSize;
  //   appWindow.minSize = iniSize;
  //   appWindow.show();
  // });
}
