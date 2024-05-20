import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../crud/crud.dart';
import '../../../crud/linkapi.dart';
import '../../../main.dart';

class dashbord extends StatefulWidget {
  const dashbord({super.key});

  @override
  State<dashbord> createState() => _dashbordState();
}

class _dashbordState extends State<dashbord> {
  var valid = '';
  var slectdataend = DateTime.now().toString().substring(0, 10);
  var slectdatastart = DateTime.now().toString().substring(0, 10);
  TextEditingController _price = TextEditingController();
  TextEditingController _note = TextEditingController();
  DateTime slectdate = DateTime.now();
  // String _slecttime = '${DateTime.now().year}-${DateTime.now().month}-1';
  //time search
  DateTime slectdatesech = DateTime.now();
  String _slecttimesech = DateTime.now().toString().substring(0, 10);
  bool actionwork = true;

  String? user = sharedPref.getString("username");
  Crud _crud = new Crud();
  //get list data eraning
  bool isloding = false;
  Map listeranings = {};
  listeraning(var S, var E) async {
    listeranings.clear();
    setState(() {
      isloding = true;
    });
    var response =
        await _crud.getRequest('${Apiearnings}?date=${S}&dateend=${E}');
    setState(() {
      listeranings.addAll(response);
    });
    isloding = false;
  }

  //archif work
  List listworks = [];
  listwork() async {
    listworks.clear();
    setState(() {
      isloding = true;
    });
    var response = await _crud
        .getRequest('${ApiearningsGetweredate}?date=$_slecttimesech');
    setState(() {
      listworks.addAll(response);
    });
    isloding = false;
  }

  //insert in & ex
  insertinex(String username, String description, String price) async {
    setState(() {
      isloding = true;
    });
    var response = await _crud.getRequest(
        '${actionwork ? ApiearningsIncome : ApiearningsExpenses}?username=$username&description=$description&price=$price');
    listeranings.clear();
    listworks.clear();
    listeraning('', '');
    listwork();
    isloding = false;
    if (response['status'] == 'empty') {
      valid = 'please fill the field';
    }
    if (response['status'] == 'enter only numbers') {
      valid = 'enter only numbers please !';
    }
    if (response['status'] == 'success') {
      _note.clear();
      _price.clear();
    }
  }

  //delete
  deleteuser(String id) async {
    setState(() {
      isloding = true;
    });
    var response = await _crud.getRequest('${ApideleteUser}?id=$id');
    listeranings.clear();
    listeraning('', '');
    isloding = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listeraning('', '');
    listwork();
  }

  @override
  Widget build(BuildContext context) {
    final heights = MediaQuery.of(context).size.height;
    final widths = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Row(
          children: [
            main(heights, widths),
            lefttcol(heights, widths),
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
              topLeft: Radius.circular(50), bottomLeft: Radius.circular(50)),
          //boxShadow:[BoxShadow(color:Color(0xFFE4E4E4),blurRadius:3,)]
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                timessearch(heights, widths),
                addcard(heights, widths),
              ]),
        ),
      ));

  SizedBox addcard(double heights, double widths) => SizedBox(
      height: heights / 1.13,
      child: ListView.builder(
          itemCount: listworks.length,
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: SizedBox(
                    // height: 63,
                    child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xffEFF7F8),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: listworks[index]['type'] == 'income'
                              ? const Color(0xff0E9CAB)
                              : listworks[index]['type'] == 'expenses'
                                  ? const Color(0xffFFC1C1)
                                  : Colors.blue,
                          width: 2)),
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(children: [
                                Text(
                                    '${listworks[index]['dateadd'] == null ? listworks[index]['dateready'] : listworks[index]['dateadd']}',
                                    style: TextStyle(
                                      fontFamily: 'English2',
                                      color: Color(0xff0B0C14),
                                      fontSize: 16,
                                    )),
                                Container(
                                  child: Text(
                                      '${listworks[index]['description'] == null ? listworks[index]['username'] : listworks[index]['description']}',
                                      style: TextStyle(
                                        fontFamily: 'English2',
                                        color: Color(0xff0B0C14),
                                        fontSize: 20,
                                      )),
                                ),
                              ]),
                              Text('${listworks[index]['price']}',
                                  style: TextStyle(
                                    fontFamily: 'English2',
                                    color: Color(0xff0B0C14),
                                    fontSize: 20,
                                  )),
                            ]),
                      ])),
                )));
          }));

  // SizedBox addcard(double heights, double widths) => SizedBox(height:heights/1.13,
  // child:ListView.builder(itemBuilder:(context, index) {
  // return Padding(padding: const EdgeInsets.only(top:10,left:10,right:10),
  // child: SizedBox(height:63,child:Container(
  // decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(30),
  // boxShadow:const [BoxShadow(color:Color(0xFFE4E4E4),blurRadius:2,spreadRadius:1,offset: Offset(0, 4))]),
  // child: Padding(padding: const EdgeInsets.all(15.0),
  // child: Column(children: [
  // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
  // const Text('2023-12-23',style:TextStyle(fontFamily:'English3',color:Color(0xff0B0C14),fontSize:20,)),
  // Container(width:120,height:33,decoration:BoxDecoration(color:const Color(0xffFEAD5A),borderRadius:BorderRadius.circular(28)),
  // child:const Padding(padding: EdgeInsets.only(left:20,right:10,top:5,bottom:5),
  // child: Text('View invoice',style:TextStyle(color:Colors.white),),
  // ))
  // ]),
  // ])),
  // )));
  // }));

  Expanded main(double heights, double width) => Expanded(
          child: Padding(
        padding: EdgeInsets.only(right: width / 10, left: width / 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Earnings',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Kurdi')),
                times(heights, width),
              ]),
              Text('IQD ${listeranings['total']}',
                  style: TextStyle(
                      color: Colors.black, fontSize: 40, fontFamily: 'Kurdi')),
              const SizedBox(
                height: 40,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                cardex('Income', '${listeranings['pincome']}',
                    const Color(0xff0E9CAB), width),
                cardex('Expenses', '${listeranings['pexpenses']}',
                    const Color(0xffFFC1C1), width),
              ]),
              const SizedBox(
                height: 40,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                slectaction(
                    'Income', actionwork, const Color(0xff0E9CAB), width),
                slectaction(
                    'Expenses', actionwork, const Color(0xffFFC1C1), width),
              ]),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textfild('Price', actionwork, _price, width),
                  bt(heights, actionwork, width),
                ],
              ),
              Text('${valid}'),
              textfildarya('Note...', actionwork, _note, width)
            ],
          ),
        ),
      ));

  Container cardex(String title, String money, Color color, double width) {
    return Container(
      height: 100,
      width: width / 7,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
          border: Border.all(color: color, width: 2)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.circle, color: color),
            const SizedBox(
              width: 10,
            ),
            Text(title,
                style: const TextStyle(
                    color: Colors.black, fontSize: 20, fontFamily: 'English2')),
          ],
        ),
        Text(money,
            style: const TextStyle(
                color: Colors.black, fontSize: 26, fontFamily: 'Kurdi')),
      ]),
    );
  }

  InkWell slectaction(String title, bool baction, Color color, double width) {
    return InkWell(
      borderRadius: BorderRadius.circular(21),
      onTap: () => setState(() {
        actionwork = title == 'Income' ? true : false;
      }),
      child: Container(
        height: 40,
        width: width / 7,
        decoration: BoxDecoration(
            color: baction && title == 'Income'
                ? const Color(0xff0E9CAB)
                : !baction && title != 'Income'
                    ? const Color(0xffFFC1C1)
                    : Colors.white,
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: color, width: 2)),
        child: Center(
            child: Text(title,
                style: TextStyle(
                    color: baction && title == 'Income'
                        ? Colors.white
                        : !baction && title != 'Income'
                            ? Colors.white
                            : Colors.black,
                    fontSize: 18,
                    fontFamily: 'English3'))),
      ),
    );
  }

  InkWell times(double heights, double widge) => InkWell(
        onTap: () async {
          final DateTimeRange? dateTime = await showDateRangePicker(
              builder: (context, child) => Theme(
                    data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xff0E9CAB), // <-- SEE HERE
                          onPrimary: Colors.white, // <-- SEE HERE
                          onSurface: Colors.black87, // <-- SEE HERE
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor:
                                const Color(0xff0E9CAB), // button text color
                          ),
                        )),
                    child: child!,
                  ),
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(3000));
          if (dateTime != null) {
            setState(() {
              slectdataend =
                  '${dateTime.end.year}-${dateTime.end.month}-${dateTime.end.day}';
              slectdatastart =
                  '${dateTime.start.year}-${dateTime.start.month}-${dateTime.start.day}';
            });
            listeraning(slectdatastart, slectdataend);
          }
        },
        borderRadius: BorderRadius.circular(30),
        child: SizedBox(
            height: 40,
            width: widge / 7,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border:
                        Border.all(color: const Color(0xff0E9CAB), width: 1)),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(slectdatastart + ' - ' + slectdataend,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'English2',
                        )),
                    const Icon(
                      Icons.arrow_drop_down_rounded,
                      color: Color(0xff0E9CAB),
                      size: 40,
                    )
                  ],
                )))),
      );

  InkWell timessearch(double heights, double widge) => InkWell(
        onTap: () async {
          final DateTime? dateTime = await showDatePicker(
              builder: (context, child) => Theme(
                    data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xff0E9CAB), // <-- SEE HERE
                          onPrimary: Colors.white, // <-- SEE HERE
                          onSurface: Colors.black87, // <-- SEE HERE
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor:
                                const Color(0xff0E9CAB), // button text color
                          ),
                        )),
                    child: child!,
                  ),
              context: context,
              initialDate: slectdatesech,
              firstDate: DateTime(2000),
              lastDate: DateTime(3000));
          if (dateTime != null) {
            setState(() {
              slectdatesech = dateTime!;
              _slecttimesech =
                  '${dateTime.year}-${dateTime.month}-${dateTime.day}';
              listwork();
            });
          }
        },
        borderRadius: BorderRadius.circular(30),
        child: SizedBox(
            height: 40,
            width: widge / 7,
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xffEFF7F8),
                    borderRadius: BorderRadius.circular(30),
                    border:
                        Border.all(color: const Color(0xff0E9CAB), width: 1)),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_slecttimesech,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'English2',
                        )),
                    const Icon(
                      Icons.arrow_drop_down_rounded,
                      color: Color(0xff0E9CAB),
                      size: 40,
                    )
                  ],
                )))),
      );

  InkWell bt(double heights, bool baction, double widge) => InkWell(
        onTap: () => insertinex(user!, _note.text, _price.text),
        borderRadius: BorderRadius.circular(30),
        child: SizedBox(
            height: 45,
            width: widge / 7.2,
            child: Container(
                decoration: BoxDecoration(
                    color: baction
                        ? const Color(0xff0E9CAB)
                        : const Color(0xffFFC1C1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                        color: baction
                            ? const Color(0xffCEEBEE)
                            : const Color(0xffFFC1C1),
                        width: 1.5)),
                child: const Center(
                    child: Text('Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'English2',
                        ))))),
      );

  Padding textfild(
      String pl, bool baction, TextEditingController text, double width) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: SizedBox(
        height: 45,
        width: width / 7.2,
        child: CupertinoTextField(
            placeholderStyle: TextStyle(
                color: baction
                    ? const Color(0xffbac8ACFD6)
                    : const Color(0xffFFC1C1)),
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
                color: Colors.white,
                border: Border.all(
                    color: baction
                        ? const Color(0xff0E9CAB)
                        : const Color(0xffFFC1C1),
                    width: 1),
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

  Padding textfildarya(
      String pl, bool baction, TextEditingController text, double width) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: SizedBox(
        height: 100,
        width: width / 3,
        child: CupertinoTextField(
            placeholderStyle: TextStyle(
                color: baction
                    ? const Color(0xffbac8ACFD6)
                    : const Color(0xffFFC1C1)),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            cursorColor:
                baction ? const Color(0xff0E9CAB) : const Color(0xffFFC1C1),
            cursorWidth: 2,
            placeholder: pl,
            controller: text,
            style: const TextStyle(
              color: Color(0xff666666),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: baction
                        ? const Color(0xff0E9CAB)
                        : const Color(0xffFFC1C1),
                    width: 1),
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
