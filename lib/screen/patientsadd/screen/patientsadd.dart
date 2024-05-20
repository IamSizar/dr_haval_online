import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';

import '../../../crud/crud.dart';
import '../../../crud/linkapi.dart';
import '../../../main.dart';

class patientsadd extends StatefulWidget {
  const patientsadd({super.key});

  @override
  State<patientsadd> createState() => _patientsaddState();
}

class _patientsaddState extends State<patientsadd> {
  TextEditingController _search = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController birthday = TextEditingController();
  TextEditingController dateready = TextEditingController();
  TextEditingController _price = TextEditingController();
  var status = '';
  var oldname = '';
  var oldphone = '';
  DateTime slectdate = DateTime.now();
  DateTime slectdateready = DateTime.now();
  bool gender = true;
  String? user = sharedPref.getString("username");
  Crud _crud = new Crud();
  String _dropdown_size = "---";
  void selectdrop_size(String? selectedvalue) {
    if (selectedvalue is String) {
      setState(() {
        _dropdown_size = selectedvalue;
      });
    }
  }

  addpatients() async {
    String timenow =
        DateTime.now().hour.toString() + ":" + DateTime.now().minute.toString();

    var response = await _crud.getRequest(
        '$Apipatientsadd?username=${_name.text}&phone=${_phone.text}&birthday=${birthday.text}&gender=${gender ? 1 : 0}&attendance=${dateready.text}&timenow=${timenow}&price=${_price.text}&useradd=$user&oldname=${oldname}&oldphone=${oldphone}');
    if (response['status'] == 'success') {
      setState(() {
        _search.clear();
      });
      print('1');
    }
    if (response['status'] == 'fempty') {
      // status = 'Please fill in all fields';
      print('3');
    }
    if (response['status'] == 'uhave') {
      setState(() {
        status = 'This patient already exists! AND Updated';
      });
      print('4');
    }
    if (response['status'] == 'enter only numbers') {
      setState(() {
        status = 'enter only numbers !';
      });
      print('5');
    }
    print(dateready.text);
    listpatient.clear();
    listpatients();
  }

  //get list data
  bool isloding = false;
  List listpatient = [];
  listpatients() async {
    setState(() {
      isloding = true;
    });
    var response = await _crud.getRequest(ApilistviewPatientsready);
    setState(() {
      listpatient.addAll(response);
    });
    isloding = false;
  }

  //delete
  deletepatients(String id) async {
    setState(() {
      isloding = true;
    });
    var response = await _crud.getRequest('${Apipatientsreadydelete}?id=$id');
    listpatient.clear();
    listpatients();
    isloding = false;
  }

  //Next to room
  nexttopatients(String id, String staite) async {
    setState(() {
      isloding = true;
    });
    var response = await _crud
        .getRequest('${Apipatientsready}?id=$id&readytoroom=$staite');
    listpatient.clear();
    listpatients();
    isloding = false;
  }

  //search old
  bool islodingsearch = false;
  List<String> _fruitOptions = <String>[];
  Map bb = {};
  listsearch() async {
    setState(() {
      islodingsearch = true;
    });
    var response = await _crud.getRequest('$Apipatientssearch');
    setState(() {
      for (var element in response) {
        _fruitOptions.add('${element['phone'] + " " + element['username']}');
        bb.addAll({
          '${element['phone'] + " " + element['username']}': [
            element['username'],
            element['phone'],
            element['birthday'],
            element['gender']
          ]
        });
      }
    });
    islodingsearch = false;
  }

  getrealydata(String phone) {
    setState(() {
      _name.text = bb[phone][0];
      oldname = bb[phone][0];
      oldphone = bb[phone][1];
      //4//////////////////
      _phone.text = bb[phone][1];
      birthday.text = bb[phone][2];
      gender = bb[phone][3].toString() == "1" ? true : false;
      dateready.text =
          '${DateTime.now().year}-${DateTime.now().month < 10 ? '0' + DateTime.now().month.toString() : DateTime.now().month.toString()}-${DateTime.now().day < 10 ? '0' + DateTime.now().day.toString() : DateTime.now().day.toString()}';
      _price.text = '20000';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(int.parse(DateTime.now().day.toString()) < 10
        ? '0' + DateTime.now().day.toString()
        : DateTime.now().day.toString());
    listpatients();
    listsearch();
    gender = true;
    _phone.text = "0750";
    birthday.text =
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
    dateready.text =
        '${DateTime.now().year}-${int.parse(DateTime.now().month.toString()) < 10 ? '0' + DateTime.now().month.toString() : DateTime.now().month.toString()}-${int.parse(DateTime.now().day.toString()) < 10 ? '0' + DateTime.now().day.toString() : DateTime.now().day.toString()}';
    _price.text = '20000';
  }

  @override
  Widget build(BuildContext context) {
    final heights = MediaQuery.of(context).size.height;
    final widths = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Row(
          children: [main(heights, widths), rightcol(heights, widths)],
        ));
  }

  SizedBox rightcol(double heights, double widths) => SizedBox(
      height: heights,
      width: widths / 3,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Container(
          padding: const EdgeInsets.only(top: 20, left: 20),
          decoration: BoxDecoration(
            color: Colors.transparent, borderRadius: BorderRadius.circular(18),
            //boxShadow:[BoxShadow(color:Color(0xFFE4E4E4),blurRadius:3,)]
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //notification_order(24,heights,widths),
                witinglist(),
                isloding ? SizedBox() : addcard(heights, widths),
                //  Divider(color:Colors.transparent,height:heights/6,),
                //pay(heights,widths)
              ]),
        ),
      ));

  Column witinglist() => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Waiting List',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.w600)),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xffCEEBEE),
                          borderRadius: BorderRadius.circular(18)),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 4, 20, 4),
                        child: Text('${listpatient.length}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                      )))
            ],
          ),
          InkWell(
              onTap: () {
                listpatient.clear();
                listpatients();
              },
              child: Icon(
                Icons.refresh,
                color: const Color(0xff0E9CAB),
              )),
          // Padding(padding: const EdgeInsets.all(8.0),
          // child: Container(decoration:BoxDecoration(color:const Color(0xffCEEBEE),borderRadius: BorderRadius.circular(18)),
          // child:const Padding(padding: EdgeInsets.fromLTRB(20,4,20,4),
          // child: Text('Follow Up',style:TextStyle(color:Color(0xff0E9CAB),fontSize:14,fontWeight:FontWeight.w600)),
          // )))
        ],
      );

  SizedBox addcard(double heights, double widths) => SizedBox(
      height: heights / 1.3,
      child: isloding
          ? CircularProgressIndicator()
          : ListView.builder(
              itemCount: listpatient.length,
              itemBuilder: (context, index) {
                final birthday =
                    DateTime.parse(listpatient[index]['birthday'].toString());
                final now = DateTime.now();
                Duration age = now.difference(birthday);
                int years = age.inDays ~/ 365;
                int months = (age.inDays % 365) ~/ 30;
                int days = (age.inDays % 365) % 30;
                String y = "", m = "", d = "";
                String agenow = "";
                y = years >= 1 ? '$years Years' : "";
                m = months >= 1 ? '$months Months' : "";
                d = days >= 1 ? '$days Days' : "";
                String bid = "$y $m $d";
                return Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: SizedBox(
                        height: 90,
                        child: Container(
                          decoration: BoxDecoration(
                              color: listpatient[index]['readytoroom'] != '0'
                                  ? const Color(0xffCEEBEE)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0xFFE4E4E4),
                                    blurRadius: 3,
                                    spreadRadius: 2,
                                    offset: Offset(0, 3))
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
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                    '${listpatient[index]['username'].toString()}',
                                                    style: TextStyle(
                                                      fontFamily: 'English3',
                                                      color: Color(0xff0B0C14),
                                                      fontSize: 16,
                                                    )),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                listpatient[index]['fellow']
                                                            .toString() ==
                                                        'No'
                                                    ? Text('')
                                                    : Text('( Fellow Up )',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'English3',
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    0,
                                                                    0),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 8),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(children: [
                                                      Text('Gender: ',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'English2',
                                                            color: Color(
                                                                0xff0B0C14),
                                                            fontSize: 12,
                                                          )),
                                                      Text(
                                                          '${listpatient[index]['gender'] == '1' ? "Male" : "female"}  ',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'English2',
                                                            color: Color(
                                                                0xff0E9CAB),
                                                            fontSize: 12,
                                                          )),
                                                    ]),
                                                    Row(children: [
                                                      Text('Age: ',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'English2',
                                                            color: Color(
                                                                0xff0B0C14),
                                                            fontSize: 12,
                                                          )),
                                                      Text(bid,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'English2',
                                                            color: Color(
                                                                0xff0E9CAB),
                                                            fontSize: 12,
                                                          )),
                                                    ]),
                                                  ]),
                                            )
                                          ]),
                                      Column(children: [
                                        Row(
                                          children: [
                                            InkWell(
                                                onTap: () => deletepatients(
                                                    listpatient[index]['id']),
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                )),
                                            InkWell(
                                              onTap: () => nexttopatients(
                                                  listpatient[index]['id'],
                                                  listpatient[index]
                                                      ['readytoroom']),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: listpatient[index][
                                                                  'readytoroom'] !=
                                                              '0'
                                                          ? const Color(
                                                              0xff0E9CAB)
                                                          : const Color(
                                                              0xffFEAD5A),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              28)),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        top: 4,
                                                        bottom: 4),
                                                    child: Row(children: [
                                                      Text(
                                                        '${listpatient[index]['readytoroom'] != '0' ? 'Next' : 'Waiting'}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .navigate_next_rounded,
                                                        color: Colors.white,
                                                      )
                                                    ]),
                                                  )),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 8),
                                          child: Text(
                                              '${listpatient[index]['timeready'].toString().substring(0, 5)}',
                                              style: TextStyle(
                                                fontFamily: 'English2',
                                                color: Color(0xff0B0C14),
                                                fontSize: 12,
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
        child: Column(children: [
          r1(width),
          SizedBox(
            height: heights / 12,
          ),
          card(heights, width),
        ]),
      ));

  Column r1(double width) {
    return Column(
      children: [
        searchtextfild('Search...', width),
        Text('${status}'),
      ],
    );
  }

  SizedBox card(double height, double width) {
    return SizedBox(
        height: height / 1.3,
        width: width / 3,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text(
                      'Add New',
                      style: TextStyle(
                          color: Color(0xff0E9CAB),
                          fontFamily: 'English2',
                          fontSize: 25),
                    ),
                  ),
                  Column(
                    children: [
                      textfild('Name Patientsadd...', _name, width),
                      textfild('Number Phone...', _phone, width),
                      textfild('Birthday...', birthday, width),
                      const SizedBox(
                        height: 20,
                      ),
                      genderr(),
                      textfild('Date of attendance...', dateready, width),
                      textfild('Price...', _price, width),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  bt(height, width)
                ]),
          ),
        ));
  }

  Row genderr() {
    return Row(children: [
      Row(children: [
        InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () => setState(() {
                  gender = true;
                }),
            child: Icon(gender ? Icons.circle_rounded : Icons.circle_outlined,
                color: const Color(0xff0E9CAB))),
        const Text('Male',
            style: TextStyle(
                color: Color(0xff0E9CAB), fontFamily: 'English2', fontSize: 16))
      ]),
      const SizedBox(
        width: 20,
      ),
      Row(
        children: [
          InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () => setState(() {
                    gender = false;
                  }),
              child: Icon(
                  gender != true ? Icons.circle_rounded : Icons.circle_outlined,
                  color: const Color(0xff0E9CAB))),
          const Text('Female',
              style: TextStyle(
                  color: Color(0xff0E9CAB),
                  fontFamily: 'English2',
                  fontSize: 16))
        ],
      ),
    ]);
  }

  Padding textfild(String pl, TextEditingController text, double width) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
            suffix: pl == 'Birthday...'
                ? InkWell(
                    onTap: () async {
                      final DateTime? dateTime = await showDatePicker(
                          builder: (context, child) => Theme(
                                data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary:
                                          Color(0xff0E9CAB), // <-- SEE HERE
                                      onPrimary: Colors.white, // <-- SEE HERE
                                      onSurface: Colors.black87, // <-- SEE HERE
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color(
                                            0xff0E9CAB), // button text color
                                      ),
                                    )),
                                child: child!,
                              ),
                          context: context,
                          initialDate: slectdate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(3000));
                      if (dateTime != null) {
                        setState(() {
                          slectdate = dateTime!;
                          birthday.text =
                              '${dateTime.year}-${dateTime.month}-${dateTime.day}';
                        });
                      }
                    },
                    child: const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.date_range_rounded,
                            size: 25, color: Color(0xff0E9CAB))))
                : pl == 'Date of attendance...'
                    ? InkWell(
                        onTap: () async {
                          final DateTime? dateTime = await showDatePicker(
                              context: context,
                              builder: (context, child) => Theme(
                                    data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary:
                                              Color(0xff0E9CAB), // <-- SEE HERE
                                          onPrimary:
                                              Colors.white, // <-- SEE HERE
                                          onSurface:
                                              Colors.black87, // <-- SEE HERE
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            foregroundColor: const Color(
                                                0xff0E9CAB), // button text color
                                          ),
                                        )),
                                    child: child!,
                                  ),
                              initialDate: slectdateready,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(3000));
                          if (dateTime != null) {
                            setState(() {
                              slectdateready = dateTime!;
                              dateready.text =
                                  '${dateTime.year}-${int.parse(dateTime.month.toString()) < 10 ? '0' + dateTime.month.toString() : dateTime.month.toString()}-${int.parse(dateTime.day.toString()) < 10 ? '0' + dateTime.day.toString() : dateTime.day.toString()}';
                            });
                          }
                        },
                        child: const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.date_range_rounded,
                                size: 25, color: Color(0xff0E9CAB))))
                    : const SizedBox(),
            decoration: BoxDecoration(
                color: Colors.white,
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

  SizedBox searchtextfild(String pl, double width) {
    return SizedBox(
        height: 45,
        width: width / 3,
        child: Autocomplete<String>(
          optionsBuilder: (TextEditingValue fruitTextEditingValue) {
            if (fruitTextEditingValue.text == '') {
              return const Iterable<String>.empty();
            }
            return _fruitOptions.where((String option) {
              return option.contains(fruitTextEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String value) {
            getrealydata(value);
            debugPrint('You just selected $value');
          },
          fieldViewBuilder: (context, textEditingController, focusNode,
                  onFieldSubmitted) =>
              CupertinoTextField(
                  placeholderStyle:
                      const TextStyle(color: Color(0xffbac8ACFD6)),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () {},
                  cursorColor: const Color(0xff0E9CAB),
                  cursorWidth: 2,
                  placeholder: pl,
                  controller: textEditingController,
                  focusNode: focusNode,
                  style: const TextStyle(
                    color: Color(0xff666666),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  suffix: const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(CupertinoIcons.search,
                          size: 25, color: Color(0xff0E9CAB))),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(color: const Color(0xff0E9CAB), width: 1),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFE4E4E4),
                          blurRadius: 3,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(30))),
        ));
  }

  InkWell bt(double heights, double widge) => InkWell(
        onTap: () {
          print(_name.text);
          print(_phone.text);
          addpatients();

          setState(() {
            _name.clear();
            _phone.clear();
            birthday.clear();
            dateready.clear();
            _price.clear();
            _phone.text = "0750";
            birthday.text =
                '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
            dateready.text =
                '${DateTime.now().year}-${int.parse(DateTime.now().month.toString()) < 10 ? '0' + DateTime.now().month.toString() : DateTime.now().month.toString()}-${int.parse(DateTime.now().day.toString()) < 10 ? '0' + DateTime.now().day.toString() : DateTime.now().day.toString()}';
            _price.text = '20000';
          });
        },
        borderRadius: BorderRadius.circular(30),
        child: SizedBox(
            height: heights / 15,
            width: widge,
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xff0E9CAB),
                    borderRadius: BorderRadius.circular(30),
                    border:
                        Border.all(color: const Color(0xffCEEBEE), width: 1.5)),
                child: const Center(
                    child: Text('Add New',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600))))),
      );
}
