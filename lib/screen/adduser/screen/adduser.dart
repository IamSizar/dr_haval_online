import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../crud/crud.dart';
import '../../../crud/linkapi.dart';
import '../../../main.dart';

class adduser extends StatefulWidget {
  const adduser({super.key});

  @override
  State<adduser> createState() => _adduserState();
}

class _adduserState extends State<adduser> {
  TextEditingController _username = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _password = TextEditingController();
  String _id = '';
  String? user = sharedPref.getString("username");
  Crud _crud = new Crud();
  //get list data
  bool isloding = false;
  List listusers = [];
  listuser() async {
    listusers.clear();
    setState(() {
      isloding = true;
    });
    var response = await _crud.getRequest(Apiusers);
    setState(() {
      listusers.addAll(response);
    });
    isloding = false;
  }

  //update info user
  bool isupdate = false;
  userupdate(String id, String username, String phone, String password) async {
    setState(() {
      isloding = true;
    });
    var response = await _crud.getRequest(
        '${ApiupdateUser}?id=$id&username=$username&phone=$phone&password=$password');
    listusers.clear();
    _username.clear();
    _phone.clear();
    _password.clear();
    _id = '';
    isupdate = false;
    listuser();
    isloding = false;
  }

  //insert user
  insertuser(String username, String phone, String password) async {
    setState(() {
      isloding = true;
    });
    var response = await _crud.getRequest(
        '${ApiaddUser}?username=$username&phone=$phone&password=$password');
    listusers.clear();
    _username.clear();
    _phone.clear();
    _password.clear();
    _id = '';
    isupdate = false;
    listuser();
    isloding = false;
  }

  //delete
  deleteuser(String id) async {
    setState(() {
      isloding = true;
    });
    var response = await _crud.getRequest('${ApideleteUser}?id=$id');
    listusers.clear();
    listuser();
    isloding = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listuser();
  }

  @override
  Widget build(BuildContext context) {
    final heights = MediaQuery.of(context).size.height;
    final widths = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Row(
          children: [
            lefttcol(heights, widths),
            main(heights, widths),
          ],
        ));
  }

  SizedBox lefttcol(double heights, double widths) => SizedBox(
      height: heights,
      width: widths / 2.5,
      child: Container(
        padding: const EdgeInsets.only(top: 20, left: 20),
        decoration: const BoxDecoration(
          color: Color(0xffEFF7F8),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
          //boxShadow:[BoxShadow(color:Color(0xFFE4E4E4),blurRadius:3,)]
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Users',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontFamily: 'English3',
                    )),
                SizedBox(
                  height: 40,
                ),
                textfild('UserName', _username, widths),
                textfild('Phone', _phone, widths),
                textfild('Password', _password, widths),
                
                SizedBox(
                  height: 40,
                ),
                bt(_id, heights, widths),
              ]),
        ),
      ));

  SizedBox addcard(double heights, double widths) => SizedBox(
      height: heights / 1.13,
      child: ListView.builder(
          itemCount: listusers.length,
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: SizedBox(
                    height: 65,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffCEEBEE),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0xFFE4E4E4),
                                blurRadius: 2,
                                spreadRadius: 1,
                                offset: Offset(0, 4))
                          ]),
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(listusers[index]['username'],
                                            style: TextStyle(
                                              fontFamily: 'English3',
                                              color: Color(0xff0B0C14),
                                              fontSize: 20,
                                            )),
                                      ]),
                                  Row(children: [
                                    InkWell(
                                      onTap: () => setState(() {
                                        _id = listusers[index]['id'];
                                        _username.text =
                                            listusers[index]['username'];
                                        _phone.text = listusers[index]['phone'];
                                        _password.text =
                                            listusers[index]['password'];
                                        isupdate = true;
                                      }),
                                      child: Container(
                                          width: 80,
                                          height: 33,
                                          decoration: BoxDecoration(
                                              color: const Color(0xff0E9CAB),
                                              borderRadius:
                                                  BorderRadius.circular(28)),
                                          child: const Padding(
                                            padding: EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                top: 5,
                                                bottom: 5),
                                            child: Text(
                                              'Change',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      onTap: () =>
                                          deleteuser(listusers[index]['id']),
                                      child: Container(
                                          width: 80,
                                          height: 33,
                                          decoration: BoxDecoration(
                                              color: const Color(0xffFEAD5A),
                                              borderRadius:
                                                  BorderRadius.circular(28)),
                                          child: const Padding(
                                            padding: EdgeInsets.only(
                                                left: 20,
                                                right: 10,
                                                top: 5,
                                                bottom: 5),
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )),
                                    ),
                                  ])
                                ]),
                          ])),
                    )));
          }));

  Expanded main(double heights, double width) => Expanded(
          child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Users',
                  style: TextStyle(
                      color: Color(0xff0E9CAB),
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
              addcard(heights, width),
            ],
          ),
        ),
      ));

  InkWell bt(String id, double heights, double widge) => InkWell(
        onTap: () => isupdate
            ? userupdate(id, _username.text, _phone.text, _password.text)
            : insertuser(_username.text, _phone.text, _password.text),
        borderRadius: BorderRadius.circular(30),
        child: SizedBox(
            height: 45,
            width: widge / 6,
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xff0E9CAB),
                    borderRadius: BorderRadius.circular(30),
                    border:
                        Border.all(color: const Color(0xffCEEBEE), width: 1.5)),
                child: Center(
                    child: Text(isupdate ? 'Update' : 'Create',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'English2',
                        ))))),
      );

  Padding textfild(String pl, TextEditingController text, double width) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: SizedBox(
        height: 45,
        width: width / 3,
        child: CupertinoTextField(
            placeholderStyle: const TextStyle(color: Color(0xffbac8ACFD6)),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            cursorColor: const Color(0xff0E9CAB),
            cursorWidth: 2,
            placeholder: pl,
            controller: text,
            style: const TextStyle(
              color: Color(0xff666666),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            decoration: BoxDecoration(
                color: Color(0xffEFF7F8),
                border: Border.all(color: const Color(0xff0E9CAB), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFE4E4E4),
                    blurRadius: 3,
                  )
                ],
                borderRadius: BorderRadius.circular(30))),
      ),
    );
  }
}
