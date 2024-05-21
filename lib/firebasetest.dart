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

  FirebaseFirestore drhaval = FirebaseFirestore.instance;
  addDatafirebase() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.add({'email': email.text});
  }

  bool ison = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("come").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Lottie.asset("assets/animation/nit02.json"),
            );
          } else {
            return ListView(
              children: snapshot.data!.docs
                  .map((doc) => ListTile(
                        title: Text(doc['switch'].toString()),
                      ))
                  .toList(),
            );
          }
          // ...
        },
      ),
    );
  }
}


// StreamBuilder(
//           stream: drhaval.collection('come').snapshots(),
//           builder: (context, snapshot) {
//             final List = [];
//             return ListView.builder(itemBuilder: (context, index) {
//               return Text('${List[index]}');
//             });
//           },
//         ),