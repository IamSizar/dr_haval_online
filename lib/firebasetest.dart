import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class firebasetest extends StatefulWidget {
  const firebasetest({super.key});

  @override
  State<firebasetest> createState() => _firebasetestState();
}

class _firebasetestState extends State<firebasetest> {
  TextEditingController email = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  addDatafirebase() async {
    CollectionReference users = firestore.collection('users');
    users.add({'email': email.text});
  }

  bool ison = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dr.Haval")),
      body: Column(
        children: [
          Container(
            child: TextField(
              decoration: InputDecoration(hintText: "Enter text"),
              controller: email,
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    // ison = !ison;
                    ison = !ison ? true : false;
                  });
                },
                child: Container(
                  height: 200,
                  child: Lottie.asset('assets/animation/on_off.json',
                      repeat: ison, animate: ison),
                ),
              ),
              Lottie.network(
                  'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json'),
            ],
          ),
          ElevatedButton(
              onPressed: () => addDatafirebase(), child: Text("Add")),
        ],
      ),
    );
  }
}
