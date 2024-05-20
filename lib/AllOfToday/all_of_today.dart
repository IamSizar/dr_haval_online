import 'package:doctor/screen/patients/screen/print/printv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../crud/crud.dart';
import '../../../crud/linkapi.dart';
import '../../../main.dart';
import 'Investigations.dart';

class AllOfToday extends StatefulWidget {
  final pdata;

  const AllOfToday({super.key, this.pdata});

  @override
  State<AllOfToday> createState() => _AllOfTodayState();
}

class _AllOfTodayState extends State<AllOfToday> {
  var name1 = '';
  TextEditingController _length = TextEditingController();
  TextEditingController _Weight = TextEditingController();
  TextEditingController _OFC = TextEditingController();
  TextEditingController _Drug = TextEditingController();
  TextEditingController _Diagnosis = TextEditingController();
  TextEditingController _note = TextEditingController();
  TextEditingController birthday = TextEditingController();
  String slectdataend = DateTime.now().toString().substring(0, 10);
  String slectdatastart = DateTime.now().toString().substring(0, 10);
  bool myDialog = false;
  bool haveList = false;
  String listidp = '';
  String name = '';
  String pid = '';
  String phone = '';
  String gender = '';
  String age = '';
  String dateready = '';
  String timeready = '';
  String price = '';
  String birthdayy = '';
  DateTime slectdate = DateTime.now();
  String _slecttime =
      '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
  //time search
  DateTime slectdatesech = DateTime.now();
  String _slecttimesech = '${DateTime.now().year}-${DateTime.now().month}-1';
  bool actionwork = true;
  String? user = sharedPref.getString("username");
  Crud _crud = new Crud();
  bool isloding = false;
  List listpatient = [];
  listpatients(String datestart, String dateend) async {
    setState(() {
      isloding = true;
    });
    var response = await _crud.getRequest(
        '${ListviewPatientsMinus}?startdate=${datestart}&enddate=${dateend}');
    setState(() {
      listpatient.addAll(response);
    });
    isloding = false;
  }

  String _dropdown = "---------";
  void selectdrop(String? selectedvalue) {
    if (selectedvalue is String) {
      setState(() {
        _dropdown = selectedvalue;
        // _dropdown=='all'?refresh():getCategory();
      });
    }
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
                  '${dateTime.end.year}-${dateTime.end.month < 10 ? '0' + dateTime.end.month.toString() : dateTime.end.month}-${dateTime.end.day < 10 ? '0' + dateTime.end.day.toString() : dateTime.end.day}';
              slectdatastart =
                  '${dateTime.start.year}-${dateTime.start.month < 10 ? '0' + dateTime.start.month.toString() : dateTime.start.month}-${dateTime.start.day < 10 ? '0' + dateTime.start.day.toString() : dateTime.start.day}';
              listpatient.clear();
              listpatients(slectdatastart, slectdataend);
            });

            print(slectdatastart + ' - ' + slectdataend);
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

  String bid = "";
  calculaterAge(DateTime birthday) {
    DateTime now = DateTime.now();
    Duration age = now.difference(birthday);
    int years = age.inDays ~/ 365;
    int months = (age.inDays % 365) ~/ 30;
    int days = (age.inDays % 365) % 30;
    String y = "", m = "", d = "";
    setState(() {
      y = years >= 1 ? '$years Years' : "";
      m = months >= 1 ? '$months Months' : "";
      d = days >= 1 ? '$days Days' : "";
      bid = "$y $m $d";
    });
  }
  // AllOfTodayNextVisit

  allOfTodayNextVisit(var Nname, var Ngender, var Nphone, var Ndate) async {
    var response = await _crud.getRequest(
        '${AllOfTodayNextVisit}/?name=${Nname}&gender=${Ngender}&phone=${Nphone}&dateready=${Ndate}');
    print(response);
  }

  //Next to room
  nexttopatients(String id, String index, String staite, bool room) async {
    setState(() {
      isloding = true;
    });
    if (room) {
      var response = await _crud
          .getRequest('${Apipatientsready}?id=$id&readytoroom=$staite');
    }
    isloding = false;
    setState(() {
      final year =
          DateTime.parse(listpatient[int.parse(index)]['birthday'].toString());
      calculaterAge(year);
      birthdayy = '${listpatient[int.parse(index)]['birthday']}';
      name = '${listpatient[int.parse(index)]['username']}';
      pid = '${listpatient[int.parse(index)]['id']}';
      phone = '${listpatient[int.parse(index)]['phone']}';
      gender =
          '${listpatient[int.parse(index)]['gender'] == '1' ? "Male" : "female"}';
      age = bid;
      price = '${listpatient[int.parse(index)]['price']}';
      dateready = '${listpatient[int.parse(index)]['dateready']}';
      timeready =
          '${listpatient[int.parse(index)]['timeready'].toString().substring(0, 5)}';
      _length.text = '${listpatient[int.parse(index)]['Hight']}';
      _Weight.text = '${listpatient[int.parse(index)]['Weight']}';
      _OFC.text = '${listpatient[int.parse(index)]['OFC']}';
      _Drug.text = '${listpatient[int.parse(index)]['drugallergy']}';
      _Diagnosis.text = '${listpatient[int.parse(index)]['diagnosis']}';
      _note.text = '${listpatient[int.parse(index)]['chiefcomplaint']}';
      birthday.text = '${listpatient[int.parse(index)]['tobeadmittedto']}';
    });
    listpatient.clear();
    listpatients(slectdatastart, slectdataend);
    getoldvisit(name, phone, pid);
  }

  //next day
  prient(bool aa) async {
    launchUrl(Uri.parse(
        '${Apiprent}?username=$name&phone=$phone&age=${age}&gender=${gender}&attendance=${aa ? dateready : _slecttimesech}&price=$price&Hight=${_length.text}&Weight=${_Weight.text}&readytoroom=0&OFC=${_OFC.text}&drugallergy=${_Drug.text}&diagnosis=${_Diagnosis.text}&chiefcomplaint=${_note.text}&tobeadmittedto=${_dropdown.toString()}&useradd=$user'));
  }

// clears

  clears() async {
    setState(() {
      name = '';
      pid = '';
      phone = '';
      gender = '';
      age = '';
      dateready = '';
      timeready = '';
      price = '';
      birthdayy = '';
      _length.text = '';
      _Weight.text = '';
      _OFC.text = '';
      _Drug.text = '';
      _Diagnosis.text = '';
      _note.text = '';
      birthday.text = '';
    });
  }

  oldvisitifhave() async {
    var response = await _crud.getRequest(
        '${linkServerName}/oldvisit/ifhaveold/index.php?username=${name}&phone=${phone}&dateready=${dateready}');
    if (response['status'] == 'success') {
      print('success');
    } else {
      print('failed');
    }
  }

  //next day
  oldvisits() async {
    var response = await _crud.getRequest(
        '${linkServerName}/oldvisit/index.php?username=${name}&phone=${phone}&birthday=${birthdayy}&gender=${gender}&price=${price}&hight=${_length.text}&weight=${_Weight.text}&readytoroom=0&dateready=${dateready}&timeready=${timeready}&OFC=${_OFC.text}&drugallergy=${_Drug.text}&diagnosis=${_Diagnosis.text}&chiefcomplaint=${_note.text}&tobeadmittedto=${_dropdown.toString()}&useradd=$user');
    if (response['status'] == 'success') {
      print('success');
    } else {
      print('failed');
    }
  }

  updatedata(
    String poldid,
    String uphight,
    String upwight,
    String upOFC,
    String updragullergy,
    String updiagnosis,
    String upchiefcomplaint,
  ) async {
    var response = await _crud.getRequest(
        '${linkServerName}/alloftoday/update/?pold_id=${poldid}&hight=${uphight}&weight=${upwight}&OFC=${upOFC}&drugallergy=${updragullergy}&diagnosis=${updiagnosis}&chiefcomplaint=${upchiefcomplaint}');
  }

  nextdaypatients(bool aa) async {
    setState(() {
      isloding = true;
    });
    //prient(aa);
    showDialog(
      context: context,
      builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          child: SizedBox(
              height: 400,
              width: 300,
              child: printv(
                  name: name,
                  phone: phone,
                  pid: pid,
                  age: age,
                  gender: gender,
                  date: dateready,
                  height: "${_length.text}",
                  weight: "${_Weight.text}",
                  ofc: "${_OFC.text}",
                  dru: "${_Drug.text}",
                  dia: "${_Diagnosis.text}",
                  chief: "${_note.text}",
                  tobe: "${_dropdown.toString()}",
                  price: "${price}"))),
    );
    var response = await _crud.getRequest(
        '${aa ? ApiinsertPatientsready : ApiinsertPatientsreadynexttime}?username=$name&phone=$phone&birthday=${birthdayy}&gender=${gender == 'Male' ? 1 : 0}&attendance=${aa ? dateready : _slecttimesech}&price=$price&Hight=${_length.text}&Weight=${_Weight.text}&readytoroom=0&OFC=${_OFC.text}&drugallergy=${_Drug.text}&diagnosis=${_Diagnosis.text}&chiefcomplaint=${_note.text}&tobeadmittedto=${_dropdown.toString()}&useradd=$user');
    isloding = false;
    setState(() {
      name = '';
      pid = '';
      phone = '';
      gender = '';
      age = '';
      dateready = '';
      timeready = '';
      _length.text = '';
      _Weight.text = '';
      _OFC.text = '';
      _Drug.text = '';
      _Diagnosis.text = '';
      _note.text = '';
      birthday.text = '';
    });
    listpatient.clear();
    listpatients(slectdatastart, slectdataend);
  }

  deletePaintent(String id) async {
    setState(() {
      isloding = true;
    });
    var response =
        await _crud.getRequest('${linkServerName}/i2.php?patients_id=${id}');
    return response;
  }

  //old vist
  List oldvistidata = [];
  getoldvisit(String username, String phone, String pid) async {
    oldvistidata.clear();
    setState(() {
      isloding = true;
    });
    var response = await _crud
        .getRequest('${Apipatientsvisit}?username=$username&phone=$phone');
    setState(() {
      oldvistidata.addAll(response);
    });
    isloding = false;
  }

  oldvistpatients(String index) async {
    setState(() {
      final year =
          DateTime.parse(oldvistidata[int.parse(index)]['birthday'].toString());
      final timenow = DateTime.now();
      String bid = (timenow.year - year.year) != 0
          ? '${timenow.year - year.year} Year'
          : (timenow.month - year.month) != 0
              ? '${timenow.month - year.month} Month'
              : '${timenow.day - year.day} Day';
      birthdayy = '${oldvistidata[int.parse(index)]['birthday']}';
      name = '${oldvistidata[int.parse(index)]['username']}';
      pid = '${oldvistidata[int.parse(index)]['id']}';
      phone = '${oldvistidata[int.parse(index)]['phone']}';
      gender =
          '${oldvistidata[int.parse(index)]['gender'] == '1' ? "Male" : "female"}';
      age = bid;
      price = '${oldvistidata[int.parse(index)]['price']}';
      dateready = '${oldvistidata[int.parse(index)]['dateready']}';
      timeready =
          '${oldvistidata[int.parse(index)]['timeready'].toString().substring(0, 5)}';
      _length.text = '${oldvistidata[int.parse(index)]['Hight']}';
      _Weight.text = '${oldvistidata[int.parse(index)]['Weight']}';
      _OFC.text = '${oldvistidata[int.parse(index)]['OFC']}';
      _Drug.text = '${oldvistidata[int.parse(index)]['drugallergy']}';
      _Diagnosis.text = '${oldvistidata[int.parse(index)]['diagnosis']}';
      _note.text = '${oldvistidata[int.parse(index)]['chiefcomplaint']}';
      birthday.text = '${oldvistidata[int.parse(index)]['tobeadmittedto']}';
    });
    listpatient.clear();
    listpatients(slectdatastart, slectdataend);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listpatients(slectdatastart, slectdataend);
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
              children: [witinglist(), addcard(heights, widths)]),
        ),
      ));

  Expanded main(double heights, double width) => Expanded(
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            Container(
              width: width / 2.5,
              height: heights / 1.03,
              decoration: const BoxDecoration(
                color: Color(0xFFFEF6EE),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 10, 22, 10),
                child: haveList == false
                    ? Text('')
                    : Column(children: [
                        Column(
                          children: [
                            Text('Dr. Haval Abdullah',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: width / 30,
                                  fontFamily: 'kurdi',
                                )),
                            Text('Pediatrician',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: width / 40,
                                    fontFamily: 'English1',
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const Divider(
                          color: Color(0xff0E9CAB),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name1,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: width / 70,
                                        fontFamily: 'kurdi',
                                      )),
                                  Text(phone,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: width / 90,
                                          fontFamily: 'English1',
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(dateready,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: width / 80,
                                          fontFamily: 'English1',
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(timeready,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: width / 80,
                                          fontFamily: 'English1',
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ]),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Row(children: [
                                        const Text('Gender: ',
                                            style: TextStyle(
                                              fontFamily: 'English2',
                                              color: Color(0xff0B0C14),
                                              fontSize: 12,
                                            )),
                                        Text(gender,
                                            style: const TextStyle(
                                              fontFamily: 'English2',
                                              color: Color(0xff0E9CAB),
                                              fontSize: 12,
                                            )),
                                      ]),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      Row(children: [
                                        const Text('Age: ',
                                            style: TextStyle(
                                              fontFamily: 'English2',
                                              color: Color(0xff0B0C14),
                                              fontSize: 12,
                                            )),
                                        Text(bid,
                                            style: const TextStyle(
                                              fontFamily: 'English2',
                                              color: Color(0xff0E9CAB),
                                              fontSize: 12,
                                            )),
                                      ]),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(children: [
                                    Row(children: [
                                      const Text('Hight | length: ',
                                          style: TextStyle(
                                            fontFamily: 'English2',
                                            color: Color(0xff0B0C14),
                                            fontSize: 12,
                                          )),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              width: 30,
                                              height: 10,
                                              child: TextField(
                                                controller: _length,
                                                style: const TextStyle(
                                                    fontFamily: 'English2',
                                                    fontSize: 14,
                                                    color: Color(0xff0E9CAB)),
                                                cursorColor: Color(0xff0E9CAB),
                                                decoration:
                                                    const InputDecoration
                                                        .collapsed(
                                                        hintText:
                                                            'Text here...',
                                                        hintStyle: TextStyle(
                                                          fontFamily:
                                                              'English2',
                                                          fontSize: 10,
                                                        )),
                                              )),
                                          const Text('cm',
                                              style: TextStyle(
                                                fontFamily: 'English2',
                                                color: Color(0xff0E9CAB),
                                                fontSize: 12,
                                              )),
                                        ],
                                      ),
                                    ]),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Row(children: [
                                      const Text('Weight: ',
                                          style: TextStyle(
                                            fontFamily: 'English2',
                                            color: Color(0xff0B0C14),
                                            fontSize: 12,
                                          )),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                                width: 30,
                                                height: 10,
                                                child: TextField(
                                                  controller: _Weight,
                                                  style: const TextStyle(
                                                      fontFamily: 'English2',
                                                      fontSize: 14,
                                                      color: Color(0xff0E9CAB)),
                                                  cursorColor:
                                                      Color(0xff0E9CAB),
                                                  decoration:
                                                      const InputDecoration
                                                          .collapsed(
                                                          hintText:
                                                              'Text here...',
                                                          hintStyle: TextStyle(
                                                            fontFamily:
                                                                'English2',
                                                            fontSize: 10,
                                                          )),
                                                )),
                                            const Text('kg',
                                                style: TextStyle(
                                                  fontFamily: 'English2',
                                                  color: Color(0xff0E9CAB),
                                                  fontSize: 12,
                                                )),
                                          ]),
                                    ]),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Row(children: [
                                      const Text('OFC: ',
                                          style: TextStyle(
                                            fontFamily: 'English2',
                                            color: Color(0xff0B0C14),
                                            fontSize: 12,
                                          )),
                                      Row(children: [
                                        SizedBox(
                                            width: 30,
                                            height: 10,
                                            child: TextField(
                                              controller: _OFC,
                                              style: const TextStyle(
                                                  fontFamily: 'English2',
                                                  fontSize: 14,
                                                  color: Color(0xff0E9CAB)),
                                              cursorColor:
                                                  const Color(0xff0E9CAB),
                                              decoration: const InputDecoration
                                                  .collapsed(
                                                  hintText: 'Text here...',
                                                  hintStyle: TextStyle(
                                                    fontFamily: 'English2',
                                                    fontSize: 10,
                                                  )),
                                            )),
                                        const Text('cm',
                                            style: TextStyle(
                                              fontFamily: 'English2',
                                              color: Color(0xff0E9CAB),
                                              fontSize: 12,
                                            )),
                                      ]),
                                    ]),
                                  ])
                                ]),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => Investigations(
                                                username: name,
                                                phone: phone,
                                                gender: gender,
                                                age: age,
                                                hight: _length.text,
                                                weight: _Weight.text,
                                              ))),
                                  child: Container(
                                      height: 30,
                                      width: 90,
                                      decoration: BoxDecoration(
                                          color: const Color(0xffFEAD5A),
                                          borderRadius:
                                              BorderRadius.circular(28)),
                                      child: const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            'Investigations',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      )),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => showplusold(
                                        'old vist',
                                        name,
                                        phone,
                                        gender,
                                        age,
                                        _length.text,
                                        _Weight.text,
                                        width),
                                  ),
                                  child: Container(
                                      height: 30,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          color: const Color(0xffFEAD5A),
                                          borderRadius:
                                              BorderRadius.circular(28)),
                                      child: const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            'Old Visits',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      )),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                const Text('Drug allergy: ',
                                    style: TextStyle(
                                      fontFamily: 'English2',
                                      color: Colors.redAccent,
                                      fontSize: 14,
                                    )),
                                SizedBox(
                                    width: 120,
                                    height: 15,
                                    child: TextField(
                                      controller: _Drug,
                                      style: const TextStyle(
                                        fontFamily: 'English2',
                                        fontSize: 14,
                                      ),
                                      cursorColor: Colors.redAccent,
                                      decoration:
                                          const InputDecoration.collapsed(
                                              hintText: 'Text here...',
                                              hintStyle: TextStyle(
                                                fontFamily: 'English2',
                                                fontSize: 10,
                                              )),
                                    ))
                              ]),
                              Row(children: [
                                const Text('Diagnosis: ',
                                    style: TextStyle(
                                      fontFamily: 'English2',
                                      color: Colors.redAccent,
                                      fontSize: 14,
                                    )),
                                SizedBox(
                                    width: 120,
                                    height: 15,
                                    child: TextField(
                                      controller: _Diagnosis,
                                      style: const TextStyle(
                                        fontFamily: 'English2',
                                        fontSize: 14,
                                      ),
                                      cursorColor: Colors.redAccent,
                                      decoration:
                                          const InputDecoration.collapsed(
                                              hintText: 'Text here...',
                                              hintStyle: TextStyle(
                                                fontFamily: 'English2',
                                                fontSize: 10,
                                              )),
                                    ))
                              ])
                            ]),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: heights / 2.08,
                          width: width / 2.5,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32))),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Chief complaint:',
                                      style: TextStyle(
                                        fontFamily: 'English2',
                                        color: Color(0xff0E9CAB),
                                        fontSize: 14,
                                      )),
                                  Center(
                                      child: SizedBox(
                                          width: width / 3,
                                          height: heights / 3,
                                          child: TextField(
                                            controller: _note,
                                            maxLines: 10,
                                            cursorColor:
                                                const Color(0xff0E9CAB),
                                            decoration: const InputDecoration(
                                              hintText: 'pless text here...',
                                              border: InputBorder.none,
                                            ),
                                          ))),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('To be admitted to:',
                                              style: TextStyle(
                                                fontFamily: 'English2',
                                                color: Color(0xff0E9CAB),
                                                fontSize: 14,
                                              )),
                                          Container(
                                              height: 30,
                                              padding: const EdgeInsets.only(
                                                  right: 20,
                                                  left: 20,
                                                  top: 1,
                                                  bottom: 1),
                                              child: DropdownButton(
                                                  items: const [
                                                    DropdownMenuItem(
                                                      value: '---------',
                                                      child: Text('---------'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'Emergency dep',
                                                      child:
                                                          Text('Emergency dep'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'The ward',
                                                      child: Text('The ward'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'NICU dep',
                                                      child: Text('NICU dep'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value:
                                                          'Hivi pediatrician teaching hospital',
                                                      child: Text(
                                                          'Hivi pediatrician teaching hospital'),
                                                    ),
                                                  ],
                                                  style: const TextStyle(
                                                      color: Color(0xff666666),
                                                      fontSize: 12,
                                                      fontFamily: 'kurdi'),
                                                  value: _dropdown,
                                                  onChanged: selectdrop,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  elevation: 2,
                                                  icon: const Icon(
                                                    Icons
                                                        .arrow_drop_down_rounded,
                                                    color: Color(0xff666666),
                                                  ),
                                                  underline: const Text('')))
                                        ],
                                      ),
                                      Row(children: [
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  showplus('title', width),
                                            );
                                          },
                                          child: Container(
                                              width: 80,
                                              height: 33,
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffFEAD5A),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          28)),
                                              child: const Center(
                                                  child: Text(
                                                'Next visit',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            // oldvisits();
                                            nextdaypatients(true);
                                            // print(name);
                                            // deletePaintent(listidp);
                                            // clears();
                                            // print(listidp);
                                            updatedata(
                                                listidp,
                                                _length.text,
                                                _Weight.text,
                                                _OFC.text,
                                                _Drug.text,
                                                _Diagnosis.text,
                                                _note.text);

                                            setState(() {
                                              haveList = false;
                                              _slecttimesech =
                                                  '${DateTime.now().year}-${DateTime.now().month}-1';
                                            });
                                            listpatient.clear();
                                            listpatients(
                                                slectdatastart, slectdataend);
                                          },
                                          child: Container(
                                              width: 80,
                                              height: 33,
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xff0E9CAB),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          28)),
                                              child: const Center(
                                                  child: Text(
                                                'Done',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))),
                                        ),
                                      ]),
                                    ],
                                  )
                                ]),
                          ),
                        )
                      ]),
              ),
            )
          ])));

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
                  '${dateTime.year}-${int.parse(dateTime.month.toString()) < 10 ? '0' + dateTime.month.toString() : dateTime.month.toString()}-${int.parse(dateTime.day.toString()) < 10 ? '0' + dateTime.day.toString() : dateTime.day.toString()}';
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

  Column witinglist() => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('All Of Today ',
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
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                        child: Text('${listpatient.length}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                      ))),
            ],
          ),
          times(3000.2, 3000.9),
          // InkWell(
          //     onTap: () {
          //       listpatient.clear();
          //       listpatients(slectdatastart, slectdataend);
          //       setState(() {
          //         haveList = false;
          //       });
          //     },
          //     child: Icon(
          //       Icons.refresh,
          //       color: const Color(0xff0E9CAB),
          //     )),
          const SizedBox(
            height: 30,
          )
        ],
      );

  InkWell bt(double heights, double widge) => InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(30),
        child: SizedBox(
            height: 45,
            width: widge / 7.2,
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xff0E9CAB),
                    borderRadius: BorderRadius.circular(30),
                    border:
                        Border.all(color: const Color(0xffCEEBEE), width: 1.5)),
                child: const Center(
                    child: Text('Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'English2',
                        ))))),
      );

  SizedBox addcard(double heights, double widths) => SizedBox(
      height: heights / 1.3,
      child: ListView.builder(
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
            bid = "$y $m $d";
            return InkWell(
              onTap: () {
                setState(() {
                  haveList = true;
                  listidp = listpatient[index]['id'].toString();
                  name1 = listpatient[index]['username'].toString();
                  phone = listpatient[index]['phone'].toString();
                  dateready = listpatient[index]['dateready'].toString();
                  timeready = listpatient[index]['timeready'].toString();
                  gender = listpatient[index]['gender'].toString();
                  if (gender == '1') {
                    gender = 'Male';
                  } else {
                    gender = 'Female';
                  }
                  // print(gender);
                  _length.text = listpatient[index]['Hight'].toString();
                  _Weight.text = listpatient[index]['Weight'].toString();
                  _OFC.text = listpatient[index]['OFC'].toString();
                  _Drug.text = listpatient[index]['drugallergy'].toString();
                  _Diagnosis.text = listpatient[index]['diagnosis'].toString();
                  _note.text = listpatient[index]['chiefcomplaint'].toString();
                  bid = "$y $m $d";
                });

                // nexttopatients(listpatient[index]['id'], index.toString(),
                //     listpatient[index]['readytoroom'], false);
              },
              child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: SizedBox(
                      height: 100,
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
                                  spreadRadius: 3,
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
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '${listpatient[index]['username'].toString()}',
                                              style: const TextStyle(
                                                fontFamily: 'English3',
                                                color: Color(0xff0B0C14),
                                                fontSize: 18,
                                              )),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Row(children: [
                                              Row(children: [
                                                const Text('Gender: ',
                                                    style: TextStyle(
                                                      fontFamily: 'English2',
                                                      color: Color(0xff0B0C14),
                                                      fontSize: 12,
                                                    )),
                                                Text(
                                                    gender == '1'
                                                        ? 'Male'
                                                        : 'Female',
                                                    style: const TextStyle(
                                                      fontFamily: 'English2',
                                                      color: Color(0xff0E9CAB),
                                                      fontSize: 12,
                                                    )),
                                              ]),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Row(children: [
                                                const Text('Age: ',
                                                    style: TextStyle(
                                                      fontFamily: 'English2',
                                                      color: Color(0xff0B0C14),
                                                      fontSize: 12,
                                                    )),
                                                Text(bid,
                                                    style: const TextStyle(
                                                      fontFamily: 'English2',
                                                      color: Color(0xff0E9CAB),
                                                      fontSize: 12,
                                                    )),
                                              ]),
                                            ]),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Row(children: [
                                              Row(children: [
                                                const Text('Hight: ',
                                                    style: TextStyle(
                                                      fontFamily: 'English2',
                                                      color: Color(0xff0B0C14),
                                                      fontSize: 12,
                                                    )),
                                                Text(
                                                    '${listpatient[index]['Hight'].toString()}cm',
                                                    style: const TextStyle(
                                                      fontFamily: 'English2',
                                                      color: Color(0xff0E9CAB),
                                                      fontSize: 12,
                                                    )),
                                              ]),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Row(children: [
                                                const Text('Weight: ',
                                                    style: TextStyle(
                                                      fontFamily: 'English2',
                                                      color: Color(0xff0B0C14),
                                                      fontSize: 12,
                                                    )),
                                                Text(
                                                    '${listpatient[index]['Weight'].toString()}kg',
                                                    style: const TextStyle(
                                                      fontFamily: 'English2',
                                                      color: Color(0xff0E9CAB),
                                                      fontSize: 12,
                                                    )),
                                              ]),
                                            ]),
                                          ),
                                        ]),
                                  ]),
                            ])),
                      ))),
            );
          }));

  Dialog showplus(String title, widths) => Dialog(
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: 100,
        width: 500,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEFF7F8),
            borderRadius: BorderRadius.circular(30),
          ),
          child: inshow(title, widths),
        ),
      ));

  Padding inshow(String title, widths) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(children: [
                const Text(
                  'You Can Visit Us ',
                  style: TextStyle(color: Color(0xff0E9CAB)),
                ),
                timessearch(widths, widths),
              ]),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    oldvisitifhave();
                    // nextdaypatients(false);  F

                    // print(name); F
                    // deletePaintent(pid); F
                    // clears(); F
                    setState(() {
                      // listpatient.clear();
                      haveList = false;
                      listpatients(slectdatastart, slectdataend);
                      // print(_slecttimesech);
                      // print(gender);
                      // print(name1);
                      // print(phone);
                    });
                    allOfTodayNextVisit(name1, gender, phone, _slecttimesech);
                    _slecttimesech =
                        '${DateTime.now().year}-${DateTime.now().month}-1';
                  },
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(40))),
                      backgroundColor:
                          const MaterialStatePropertyAll(Color(0xff0E9CAB)),
                      overlayColor:
                          const MaterialStatePropertyAll(Colors.grey)),
                  child: Container(
                    height: 30,
                    width: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(40)),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'kurdi'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(40))),
                      backgroundColor:
                          const MaterialStatePropertyAll(Color(0xffFEAD5A)),
                      overlayColor:
                          const MaterialStatePropertyAll(Colors.grey)),
                  child: Container(
                    height: 30,
                    width: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(40)),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'kurdi'),
                    ),
                  ),
                ),
              ])
            ],
          ),
        ),
      );

//alert old report user

  Dialog showplusold(String title, String username, String phone, String gender,
          String age, String hight, String weight, widths) =>
      Dialog(
          backgroundColor: Colors.transparent,
          child: SizedBox(
            height: 500,
            width: 350,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEFF7F8),
                borderRadius: BorderRadius.circular(50),
              ),
              child: inshowold(
                  title, username, phone, gender, age, hight, weight, widths),
            ),
          ));

  Padding inshowold(String title, String username, String phone, String gender,
          String age, String hight, String weight, widths) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: SizedBox(
                    // height: 105,
                    width: 340,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0xFFE4E4E4),
                                blurRadius: 3,
                                spreadRadius: 3,
                                offset: Offset(0, 3))
                          ]),
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(username,
                                    style: const TextStyle(
                                      fontFamily: 'English3',
                                      color: Color(0xff0B0C14),
                                      fontSize: 23,
                                    )),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(children: [
                                                const Text('Gender: ',
                                                    style: TextStyle(
                                                      fontFamily: 'English2',
                                                      color: Color(0xff0B0C14),
                                                      fontSize: 12,
                                                    )),
                                                Text(gender,
                                                    style: const TextStyle(
                                                      fontFamily: 'English2',
                                                      color: Color(0xff0E9CAB),
                                                      fontSize: 12,
                                                    )),
                                              ]),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Row(children: [
                                                const Text('Age: ',
                                                    style: TextStyle(
                                                      fontFamily: 'English2',
                                                      color: Color(0xff0B0C14),
                                                      fontSize: 12,
                                                    )),
                                                Text(age,
                                                    style: const TextStyle(
                                                      fontFamily: 'English2',
                                                      color: Color(0xff0E9CAB),
                                                      fontSize: 12,
                                                    )),
                                              ]),
                                            ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(children: [
                                                const Text('Hight: ',
                                                    style: TextStyle(
                                                      fontFamily: 'English2',
                                                      color: Color(0xff0B0C14),
                                                      fontSize: 12,
                                                    )),
                                                Text('${hight} cm',
                                                    style: const TextStyle(
                                                      fontFamily: 'English2',
                                                      color: Color(0xff0E9CAB),
                                                      fontSize: 12,
                                                    )),
                                              ]),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Row(children: [
                                                const Text('Weight: ',
                                                    style: TextStyle(
                                                      fontFamily: 'English2',
                                                      color: Color(0xff0B0C14),
                                                      fontSize: 12,
                                                    )),
                                                Text('${weight} kg',
                                                    style: const TextStyle(
                                                      fontFamily: 'English2',
                                                      color: Color(0xff0E9CAB),
                                                      fontSize: 12,
                                                    )),
                                              ]),
                                            ]),
                                      ),
                                    ]),
                              ])),
                    ))),
            //
            const Text('Old Visits List',
                style: TextStyle(
                  fontFamily: 'English1',
                  color: Color(0xff0B0C14),
                  fontSize: 26,
                )),
            listoldvistcard(widths),
            //
          ],
        ),
      );

  SizedBox listoldvistcard(double widths) => SizedBox(
      height: 300,
      child: ListView.builder(
          itemCount: oldvistidata.length,
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: SizedBox(
                    height: 63,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0xFFE4E4E4),
                                blurRadius: 2,
                                spreadRadius: 1,
                                offset: Offset(0, 4))
                          ]),
                      child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${oldvistidata[index]['dateadd']}',
                                      style: const TextStyle(
                                        fontFamily: 'English3',
                                        color: Color(0xff0B0C14),
                                        fontSize: 20,
                                      )),
                                  InkWell(
                                    onTap: () =>
                                        oldvistpatients(index.toString()),
                                    child: Container(
                                        width: 120,
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
                                            'View invoice',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )),
                                  )
                                ]),
                          ])),
                    )));
          }));

  Padding textfild(String pl, TextEditingController text, double width) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: SizedBox(
        height: 45,
        width: width / 7.2,
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

  Padding textfildarya(String pl, TextEditingController text, double width) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: SizedBox(
        height: 100,
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
}







// import 'package:doctor/screen/patients/screen/print/printv.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../../crud/crud.dart';
// import '../../../crud/linkapi.dart';
// import '../../../main.dart';
// import 'Investigations.dart';

// class AllOfToday extends StatefulWidget {
//   final pdata;

//   const AllOfToday({super.key, this.pdata});

//   @override
//   State<AllOfToday> createState() => _AllOfTodayState();
// }

// class _AllOfTodayState extends State<AllOfToday> {
//   TextEditingController _length = TextEditingController();
//   TextEditingController _Weight = TextEditingController();
//   TextEditingController _OFC = TextEditingController();
//   TextEditingController _Drug = TextEditingController();
//   TextEditingController _Diagnosis = TextEditingController();
//   TextEditingController _note = TextEditingController();
//   TextEditingController birthday = TextEditingController();
//   bool sizarLoad = false;
//   var listidp = '';
//   bool listhave = false;
//   String name = '';
//   String pid = '';
//   String phone = '';
//   String gender = '';
//   String age = '';
//   String dateready = '';
//   String timeready = '';
//   String price = '';
//   String birthdayy = '';
//   DateTime slectdate = DateTime.now();
//   String _slecttime =
//       '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
//   //time search
//   DateTime slectdatesech = DateTime.now();
//   String _slecttimesech = '${DateTime.now().year}-${DateTime.now().month}-1';
//   bool actionwork = true;
//   String? user = sharedPref.getString("username");
//   Crud _crud = new Crud();
//   bool isloding = false;
//   List listpatient = [];
//   listpatients() async {
//     setState(() {
//       sizarLoad = true;
//       isloding = true;
//     });
//     var response = await _crud.getRequest(ListviewPatientsMinus);
//     setState(() {
//       listpatient.addAll(response);
//     });
//     isloding = false;
//     sizarLoad = false;
//   }

//   String _dropdown = "---------";
//   void selectdrop(String? selectedvalue) {
//     if (selectedvalue is String) {
//       setState(() {
//         _dropdown = selectedvalue;
//         // _dropdown=='all'?refresh():getCategory();
//       });
//     }
//   }

//   String bid = "";
//   calculaterAge(DateTime birthday) {
//     DateTime now = DateTime.now();
//     Duration age = now.difference(birthday);
//     int years = age.inDays ~/ 365;
//     int months = (age.inDays % 365) ~/ 30;
//     int days = (age.inDays % 365) % 30;
//     String y = "", m = "", d = "";
//     setState(() {
//       y = years >= 1 ? '$years Years' : "";
//       m = months >= 1 ? '$months Months' : "";
//       d = days >= 1 ? '$days Days' : "";
//       bid = "$y $m $d";
//     });
//   }

//   //Next to room
//   nexttopatients(String id, String index, String staite, bool room) async {
//     setState(() {
//       isloding = true;
//     });
//     if (room) {
//       var response =
//           await _crud.getRequest('${alloftodatid}?id=$id&readytoroom=$staite');
//     }
//     isloding = false;
//     setState(() {
//       final year =
//           DateTime.parse(listpatient[int.parse(index)]['birthday'].toString());
//       calculaterAge(year);
//       birthdayy = '${listpatient[int.parse(index)]['birthday']}';
//       name = '${listpatient[int.parse(index)]['username']}';
//       pid = '${listpatient[int.parse(index)]['id']}';
//       phone = '${listpatient[int.parse(index)]['phone']}';
//       gender =
//           '${listpatient[int.parse(index)]['gender'] == '1' ? "Male" : "female"}';
//       age = bid;
//       price = '${listpatient[int.parse(index)]['price']}';
//       dateready = '${listpatient[int.parse(index)]['dateready']}';
//       timeready =
//           '${listpatient[int.parse(index)]['timeready'].toString().substring(0, 5)}';
//       _length.text = '${listpatient[int.parse(index)]['Hight']}';
//       _Weight.text = '${listpatient[int.parse(index)]['Weight']}';
//       _OFC.text = '${listpatient[int.parse(index)]['OFC']}';
//       _Drug.text = '${listpatient[int.parse(index)]['drugallergy']}';
//       _Diagnosis.text = '${listpatient[int.parse(index)]['diagnosis']}';
//       _note.text = '${listpatient[int.parse(index)]['chiefcomplaint']}';
//       birthday.text = '${listpatient[int.parse(index)]['tobeadmittedto']}';
//     });
//     listpatient.clear();
//     listpatients();
//     getoldvisit(name, phone, pid);
//   }

//   //next day
//   prient(bool aa) async {
//     launchUrl(Uri.parse(
//         '${Apiprent}?username=$name&phone=$phone&age=${age}&gender=${gender}&attendance=${aa ? dateready : _slecttimesech}&price=$price&Hight=${_length.text}&Weight=${_Weight.text}&readytoroom=0&OFC=${_OFC.text}&drugallergy=${_Drug.text}&diagnosis=${_Diagnosis.text}&chiefcomplaint=${_note.text}&tobeadmittedto=${_dropdown.toString()}&useradd=$user'));
//   }

// // clears

//   clears() async {
//     setState(() {
//       name = '';
//       pid = '';
//       phone = '';
//       gender = '';
//       age = '';
//       dateready = '';
//       timeready = '';
//       price = '';
//       birthdayy = '';
//       _length.text = '';
//       _Weight.text = '';
//       _OFC.text = '';
//       _Drug.text = '';
//       _Diagnosis.text = '';
//       _note.text = '';
//       birthday.text = '';
//     });
//   }

//   //next day
//   nextdaypatients(bool aa) async {
//     setState(() {
//       isloding = true;
//     });
//     //prient(aa);
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//           backgroundColor: Colors.transparent,
//           child: SizedBox(
//               height: 400,
//               width: 300,
//               child: printv(
//                   name: name,
//                   phone: phone,
//                   pid: pid,
//                   age: age,
//                   gender: gender,
//                   date: dateready,
//                   height: "${_length.text}",
//                   weight: "${_Weight.text}",
//                   ofc: "${_OFC.text}",
//                   dru: "${_Drug.text}",
//                   dia: "${_Diagnosis.text}",
//                   chief: "${_note.text}",
//                   tobe: "${_dropdown.toString()}",
//                   price: "${price}"))),
//     );
//     var response = await _crud.getRequest(
//         '${aa ? ApiinsertPatientsready : ApiinsertPatientsreadynexttime}?username=$name&phone=$phone&birthday=${birthdayy}&gender=${gender == 'Male' ? 1 : 0}&attendance=${aa ? dateready : _slecttimesech}&price=$price&Hight=${_length.text}&Weight=${_Weight.text}&readytoroom=0&OFC=${_OFC.text}&drugallergy=${_Drug.text}&diagnosis=${_Diagnosis.text}&chiefcomplaint=${_note.text}&tobeadmittedto=${_dropdown.toString()}&useradd=$user');
//     isloding = false;
//     setState(() {
//       name = '';
//       pid = '';
//       phone = '';
//       gender = '';
//       age = '';
//       dateready = '';
//       timeready = '';
//       _length.text = '';
//       _Weight.text = '';
//       _OFC.text = '';
//       _Drug.text = '';
//       _Diagnosis.text = '';
//       _note.text = '';
//       birthday.text = '';
//     });
//     listpatient.clear();
//     listpatients();
//   }

//   deletePaintent(String id) async {
//     setState(() {
//       isloding = true;
//     });
//     var response =
//         await _crud.getRequest('${linkServerName}/i2.php?patients_id=${id}');
//     return response;
//   }

//   //old vist
//   List oldvistidata = [];
//   getoldvisit(String username, String phone, String pid) async {
//     oldvistidata.clear();
//     setState(() {
//       isloding = true;
//     });
//     var response = await _crud
//         .getRequest('${Apipatientsvisit}?username=$username&phone=$phone');
//     setState(() {
//       oldvistidata.addAll(response);
//     });
//     isloding = false;
//   }

//   oldvistpatients(String index) async {
//     setState(() {
//       final year =
//           DateTime.parse(oldvistidata[int.parse(index)]['birthday'].toString());
//       final timenow = DateTime.now();
//       String bid = (timenow.year - year.year) != 0
//           ? '${timenow.year - year.year} Year'
//           : (timenow.month - year.month) != 0
//               ? '${timenow.month - year.month} Month'
//               : '${timenow.day - year.day} Day';
//       birthdayy = '${oldvistidata[int.parse(index)]['birthday']}';
//       name = '${oldvistidata[int.parse(index)]['username']}';
//       pid = '${oldvistidata[int.parse(index)]['id']}';
//       phone = '${oldvistidata[int.parse(index)]['phone']}';
//       gender =
//           '${oldvistidata[int.parse(index)]['gender'] == '1' ? "Male" : "female"}';
//       age = bid;
//       price = '${oldvistidata[int.parse(index)]['price']}';
//       dateready = '${oldvistidata[int.parse(index)]['dateready']}';
//       timeready =
//           '${oldvistidata[int.parse(index)]['timeready'].toString().substring(0, 5)}';
//       _length.text = '${oldvistidata[int.parse(index)]['Hight']}';
//       _Weight.text = '${oldvistidata[int.parse(index)]['Weight']}';
//       _OFC.text = '${oldvistidata[int.parse(index)]['OFC']}';
//       _Drug.text = '${oldvistidata[int.parse(index)]['drugallergy']}';
//       _Diagnosis.text = '${oldvistidata[int.parse(index)]['diagnosis']}';
//       _note.text = '${oldvistidata[int.parse(index)]['chiefcomplaint']}';
//       birthday.text = '${oldvistidata[int.parse(index)]['tobeadmittedto']}';
//     });
//     listpatient.clear();
//     listpatients();
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     listpatients();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final heights = MediaQuery.of(context).size.height;
//     final widths = MediaQuery.of(context).size.width;
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: Row(
//           children: [
//             lefttcol(heights, widths),
//             main(heights, widths),
//           ],
//         ));
//   }

//   SizedBox lefttcol(double heights, double widths) => SizedBox(
//       height: heights,
//       width: widths / 2.5,
//       child: Container(
//         padding: const EdgeInsets.only(top: 20, left: 20),
//         decoration: const BoxDecoration(
//           color: Color(0xffEFF7F8),
//           borderRadius: BorderRadius.only(
//               topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
//           //boxShadow:[BoxShadow(color:Color(0xFFE4E4E4),blurRadius:3,)]
//         ),
//         child: Padding(
//           padding: const EdgeInsets.only(right: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               witinglist(),
//               addcard(heights, widths),
//             ],
//           ),
//         ),
//       ));

//   InkWell timessearch(double heights, double widge) => InkWell(
//         onTap: () async {
//           final DateTime? dateTime = await showDatePicker(
//               builder: (context, child) => Theme(
//                     data: Theme.of(context).copyWith(
//                         colorScheme: const ColorScheme.light(
//                           primary: Color(0xff0E9CAB), // <-- SEE HERE
//                           onPrimary: Colors.white, // <-- SEE HERE
//                           onSurface: Colors.black87, // <-- SEE HERE
//                         ),
//                         textButtonTheme: TextButtonThemeData(
//                           style: TextButton.styleFrom(
//                             foregroundColor:
//                                 const Color(0xff0E9CAB), // button text color
//                           ),
//                         )),
//                     child: child!,
//                   ),
//               context: context,
//               initialDate: slectdatesech,
//               firstDate: DateTime(2000),
//               lastDate: DateTime(3000));
//           if (dateTime != null) {
//             setState(() {
//               slectdatesech = dateTime!;
//               _slecttimesech =
//                   '${dateTime.year}-${int.parse(dateTime.month.toString()) < 10 ? '0' + dateTime.month.toString() : dateTime.month.toString()}-${int.parse(dateTime.day.toString()) < 10 ? '0' + dateTime.day.toString() : dateTime.day.toString()}';
//             });
//           }
//         },
//         borderRadius: BorderRadius.circular(30),
//         child: SizedBox(
//             height: 40,
//             width: widge / 7,
//             child: Container(
//                 decoration: BoxDecoration(
//                     color: const Color(0xffEFF7F8),
//                     borderRadius: BorderRadius.circular(30),
//                     border:
//                         Border.all(color: const Color(0xff0E9CAB), width: 1)),
//                 child: Center(
//                     child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(_slecttimesech,
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 18,
//                           fontFamily: 'English2',
//                         )),
//                     const Icon(
//                       Icons.arrow_drop_down_rounded,
//                       color: Color(0xff0E9CAB),
//                       size: 40,
//                     )
//                   ],
//                 )))),
//       );

//   Column witinglist() => Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text('all of today patients',
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 26,
//                       fontWeight: FontWeight.w600)),
//               Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                       decoration: BoxDecoration(
//                           color: const Color(0xffCEEBEE),
//                           borderRadius: BorderRadius.circular(18)),
//                       child: Padding(
//                         padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
//                         child: Text('${listpatient.length}',
//                             style: const TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w600)),
//                       ))),
//             ],
//           ),
//           InkWell(
//               onTap: () {
//                 setState(() {
//                   listpatients();

//                   listpatient.clear();
//                 });
//               },
//               child: Icon(
//                 Icons.refresh,
//                 color: const Color(0xff0E9CAB),
//               )),
//           const SizedBox(
//             height: 30,
//           )
//         ],
//       );

//   InkWell bt(double heights, double widge) => InkWell(
//         onTap: () {},
//         borderRadius: BorderRadius.circular(30),
//         child: SizedBox(
//           height: 45,
//           width: widge / 7.2,
//           child: Container(
//             decoration: BoxDecoration(
//                 color: const Color(0xff0E9CAB),
//                 borderRadius: BorderRadius.circular(30),
//                 border: Border.all(color: const Color(0xffCEEBEE), width: 1.5)),
//             child: const Center(
//               child: Text(
//                 'Add',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontFamily: 'English2',
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//   //--------------------------------------------------------

//   SizedBox addcard(double heights, double widths) => SizedBox(
//       height: heights / 1.3,
//       child: ListView.builder(
//           itemCount: listpatient.length,
//           itemBuilder: (context, index) {
//             final birthday =
//                 DateTime.parse(listpatient[index]['birthday'].toString());
//             final now = DateTime.now();
//             Duration age = now.difference(birthday);
//             int years = age.inDays ~/ 365;
//             int months = (age.inDays % 365) ~/ 30;
//             int days = (age.inDays % 365) % 30;
//             String y = "", m = "", d = "";
//             String agenow = "";
//             y = years >= 1 ? '$years Years' : "";
//             m = months >= 1 ? '$months Months' : "";
//             d = days >= 1 ? '$days Days' : "";
//             bid = "$y $m $d";
//             return InkWell(
//               onTap: () {
//                 setState(() {
//                   listhave = true;
//                   // var listid = listpatient[index]['id'].toString();
//                   // print('IDDDDDDDDDDDDDDDD = $listid');
//                   // listidp = listpatient[index]['id'].toString();
//                 });
//                 nexttopatients(listpatient[index]['id'], index.toString(),
//                     listpatient[index]['readytoroom'], false);
//               },
//               child: Padding(
//                   padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
//                   child: SizedBox(
//                       // height: 100,
//                       child: Container(
//                     decoration: BoxDecoration(
//                         color: listpatient[index]['readytoroom'] != '0'
//                             ? const Color(0xffCEEBEE)
//                             : Colors.white,
//                         borderRadius: BorderRadius.circular(30),
//                         boxShadow: const [
//                           BoxShadow(
//                               color: Color(0xFFE4E4E4),
//                               blurRadius: 3,
//                               spreadRadius: 3,
//                               offset: Offset(0, 4))
//                         ]),
//                     child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(children: [
//                           Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                           '${listpatient[index]['username'].toString()}',
//                                           style: const TextStyle(
//                                             fontFamily: 'English3',
//                                             color: Color(0xff0B0C14),
//                                             fontSize: 18,
//                                           )),
//                                       Text(
//                                           '${listpatient[index]['id'].toString()}',
//                                           style: const TextStyle(
//                                             fontFamily: 'English3',
//                                             color: Color(0xff0B0C14),
//                                             fontSize: 18,
//                                           )),
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 4),
//                                         child: Row(children: [
//                                           Row(children: [
//                                             const Text('Gender: ',
//                                                 style: TextStyle(
//                                                   fontFamily: 'English2',
//                                                   color: Color(0xff0B0C14),
//                                                   fontSize: 12,
//                                                 )),
//                                             Text(
//                                                 '${listpatient[index]['gender'] == '1' ? "Male" : "female"} ',
//                                                 style: const TextStyle(
//                                                   fontFamily: 'English2',
//                                                   color: Color(0xff0E9CAB),
//                                                   fontSize: 12,
//                                                 )),
//                                           ]),
//                                           const SizedBox(
//                                             width: 10,
//                                           ),
//                                           Row(children: [
//                                             const Text('Age: ',
//                                                 style: TextStyle(
//                                                   fontFamily: 'English2',
//                                                   color: Color(0xff0B0C14),
//                                                   fontSize: 12,
//                                                 )),
//                                             Text(bid,
//                                                 style: const TextStyle(
//                                                   fontFamily: 'English2',
//                                                   color: Color(0xff0E9CAB),
//                                                   fontSize: 12,
//                                                 )),
//                                           ]),
//                                         ]),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 4),
//                                         child: Row(children: [
//                                           Row(children: [
//                                             const Text('Hight: ',
//                                                 style: TextStyle(
//                                                   fontFamily: 'English2',
//                                                   color: Color(0xff0B0C14),
//                                                   fontSize: 12,
//                                                 )),
//                                             Text(
//                                                 '${listpatient[index]['Hight'].toString()}cm',
//                                                 style: const TextStyle(
//                                                   fontFamily: 'English2',
//                                                   color: Color(0xff0E9CAB),
//                                                   fontSize: 12,
//                                                 )),
//                                           ]),
//                                           const SizedBox(
//                                             width: 10,
//                                           ),
//                                           Row(children: [
//                                             const Text('Weight: ',
//                                                 style: TextStyle(
//                                                   fontFamily: 'English2',
//                                                   color: Color(0xff0B0C14),
//                                                   fontSize: 12,
//                                                 )),
//                                             Text(
//                                                 '${listpatient[index]['Weight'].toString()}kg',
//                                                 style: const TextStyle(
//                                                   fontFamily: 'English2',
//                                                   color: Color(0xff0E9CAB),
//                                                   fontSize: 12,
//                                                 )),
//                                           ]),
//                                         ]),
//                                       ),
//                                     ]),
//                               ]),
//                         ])),
//                   ))),
//             );
//           }));
// //----------------------------------------------

//   Expanded main(
//     double heights,
//     double width,
//   ) =>
//       Expanded(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: width / 2.5,
//                 height: heights / 1.03,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFFEF6EE),
//                 ),
//                 child: listhave == false
//                     ? Text('')
//                     : Padding(
//                         padding: const EdgeInsets.fromLTRB(22, 10, 22, 10),
//                         child: Column(children: [
//                           Column(
//                             children: [
//                               Text('Dr. Haval Abdullah',
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: width / 30,
//                                     fontFamily: 'kurdi',
//                                   )),
//                               Text('Pediatrician',
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: width / 40,
//                                       fontFamily: 'English1',
//                                       fontWeight: FontWeight.w600)),
//                             ],
//                           ),
//                           const Divider(
//                             color: Color(0xff0E9CAB),
//                           ),
//                           Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text("dafa",
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: width / 70,
//                                           fontFamily: 'kurdi',
//                                         )),
//                                     Text(phone,
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: width / 90,
//                                             fontFamily: 'English1',
//                                             fontWeight: FontWeight.w600)),
//                                   ],
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     Text(dateready,
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: width / 80,
//                                             fontFamily: 'English1',
//                                             fontWeight: FontWeight.w600)),
//                                     const SizedBox(
//                                       width: 20,
//                                     ),
//                                     Text(timeready,
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: width / 80,
//                                             fontFamily: 'English1',
//                                             fontWeight: FontWeight.w600)),
//                                   ],
//                                 ),
//                               ]),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Row(children: [
//                                           const Text('Gender: ',
//                                               style: TextStyle(
//                                                 fontFamily: 'English2',
//                                                 color: Color(0xff0B0C14),
//                                                 fontSize: 12,
//                                               )),
//                                           Text(
//                                               listpatient[0]['gender']
//                                                   .toString(),
//                                               style: const TextStyle(
//                                                 fontFamily: 'English2',
//                                                 color: Color(0xff0E9CAB),
//                                                 fontSize: 12,
//                                               )),
//                                         ]),
//                                         const SizedBox(
//                                           width: 50,
//                                         ),
//                                         Row(children: [
//                                           const Text('Age: ',
//                                               style: TextStyle(
//                                                 fontFamily: 'English2',
//                                                 color: Color(0xff0B0C14),
//                                                 fontSize: 12,
//                                               )),
//                                           Text(age,
//                                               style: const TextStyle(
//                                                 fontFamily: 'English2',
//                                                 color: Color(0xff0E9CAB),
//                                                 fontSize: 12,
//                                               )),
//                                         ]),
//                                       ],
//                                     ),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     Row(children: [
//                                       Row(children: [
//                                         const Text('Hight | length: ',
//                                             style: TextStyle(
//                                               fontFamily: 'English2',
//                                               color: Color(0xff0B0C14),
//                                               fontSize: 12,
//                                             )),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           children: [
//                                             SizedBox(
//                                                 width: 30,
//                                                 height: 10,
//                                                 child: TextField(
//                                                   controller: _length,
//                                                   style: const TextStyle(
//                                                       fontFamily: 'English2',
//                                                       fontSize: 14,
//                                                       color: Color(0xff0E9CAB)),
//                                                   cursorColor:
//                                                       Color(0xff0E9CAB),
//                                                   decoration:
//                                                       const InputDecoration
//                                                           .collapsed(
//                                                           hintText:
//                                                               'Text here...',
//                                                           hintStyle: TextStyle(
//                                                             fontFamily:
//                                                                 'English2',
//                                                             fontSize: 10,
//                                                           )),
//                                                 )),
//                                             const Text('cm',
//                                                 style: TextStyle(
//                                                   fontFamily: 'English2',
//                                                   color: Color(0xff0E9CAB),
//                                                   fontSize: 12,
//                                                 )),
//                                           ],
//                                         ),
//                                       ]),
//                                       const SizedBox(
//                                         width: 20,
//                                       ),
//                                       Row(children: [
//                                         const Text('Weight: ',
//                                             style: TextStyle(
//                                               fontFamily: 'English2',
//                                               color: Color(0xff0B0C14),
//                                               fontSize: 12,
//                                             )),
//                                         Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             children: [
//                                               SizedBox(
//                                                   width: 30,
//                                                   height: 10,
//                                                   child: TextField(
//                                                     controller: _Weight,
//                                                     style: const TextStyle(
//                                                         fontFamily: 'English2',
//                                                         fontSize: 14,
//                                                         color:
//                                                             Color(0xff0E9CAB)),
//                                                     cursorColor:
//                                                         Color(0xff0E9CAB),
//                                                     decoration:
//                                                         const InputDecoration
//                                                             .collapsed(
//                                                             hintText:
//                                                                 'Text here...',
//                                                             hintStyle:
//                                                                 TextStyle(
//                                                               fontFamily:
//                                                                   'English2',
//                                                               fontSize: 10,
//                                                             )),
//                                                   )),
//                                               const Text('kg',
//                                                   style: TextStyle(
//                                                     fontFamily: 'English2',
//                                                     color: Color(0xff0E9CAB),
//                                                     fontSize: 12,
//                                                   )),
//                                             ]),
//                                       ]),
//                                       const SizedBox(
//                                         width: 20,
//                                       ),
//                                       Row(children: [
//                                         const Text('OFC: ',
//                                             style: TextStyle(
//                                               fontFamily: 'English2',
//                                               color: Color(0xff0B0C14),
//                                               fontSize: 12,
//                                             )),
//                                         Row(children: [
//                                           SizedBox(
//                                               width: 30,
//                                               height: 10,
//                                               child: TextField(
//                                                 controller: _OFC,
//                                                 style: const TextStyle(
//                                                     fontFamily: 'English2',
//                                                     fontSize: 14,
//                                                     color: Color(0xff0E9CAB)),
//                                                 cursorColor:
//                                                     const Color(0xff0E9CAB),
//                                                 decoration:
//                                                     const InputDecoration
//                                                         .collapsed(
//                                                         hintText:
//                                                             'Text here...',
//                                                         hintStyle: TextStyle(
//                                                           fontFamily:
//                                                               'English2',
//                                                           fontSize: 10,
//                                                         )),
//                                               )),
//                                           const Text('cm',
//                                               style: TextStyle(
//                                                 fontFamily: 'English2',
//                                                 color: Color(0xff0E9CAB),
//                                                 fontSize: 12,
//                                               )),
//                                         ]),
//                                       ]),
//                                     ])
//                                   ]),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   InkWell(
//                                     onTap: () => Navigator.push(
//                                         context,
//                                         CupertinoPageRoute(
//                                             builder: (context) =>
//                                                 Investigations(
//                                                   username: name,
//                                                   phone: phone,
//                                                   gender: gender,
//                                                   age: age,
//                                                   hight: _length.text,
//                                                   weight: _Weight.text,
//                                                 ))),
//                                     child: Container(
//                                         height: 30,
//                                         width: 90,
//                                         decoration: BoxDecoration(
//                                             color: const Color(0xffFEAD5A),
//                                             borderRadius:
//                                                 BorderRadius.circular(28)),
//                                         child: const Center(
//                                           child: Padding(
//                                             padding: EdgeInsets.all(5),
//                                             child: Text(
//                                               'Investigations',
//                                               style: TextStyle(
//                                                   color: Colors.white),
//                                             ),
//                                           ),
//                                         )),
//                                   ),
//                                   const SizedBox(
//                                     height: 10,
//                                   ),
//                                   InkWell(
//                                     onTap: () => showDialog(
//                                       context: context,
//                                       builder: (context) => showplusold(
//                                           'old vist',
//                                           name,
//                                           phone,
//                                           gender,
//                                           age,
//                                           _length.text,
//                                           _Weight.text,
//                                           width),
//                                     ),
//                                     child: Container(
//                                         height: 30,
//                                         width: 80,
//                                         decoration: BoxDecoration(
//                                             color: const Color(0xffFEAD5A),
//                                             borderRadius:
//                                                 BorderRadius.circular(28)),
//                                         child: const Center(
//                                           child: Padding(
//                                             padding: EdgeInsets.all(5),
//                                             child: Text(
//                                               'Old Visits',
//                                               style: TextStyle(
//                                                   color: Colors.white),
//                                             ),
//                                           ),
//                                         )),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(children: [
//                                   const Text('Drug allergy: ',
//                                       style: TextStyle(
//                                         fontFamily: 'English2',
//                                         color: Colors.redAccent,
//                                         fontSize: 14,
//                                       )),
//                                   SizedBox(
//                                       width: 120,
//                                       height: 10,
//                                       child: TextField(
//                                         controller: _Drug,
//                                         style: const TextStyle(
//                                           fontFamily: 'English2',
//                                           fontSize: 14,
//                                         ),
//                                         cursorColor: Colors.redAccent,
//                                         decoration:
//                                             const InputDecoration.collapsed(
//                                                 hintText: 'Text here...',
//                                                 hintStyle: TextStyle(
//                                                   fontFamily: 'English2',
//                                                   fontSize: 10,
//                                                 )),
//                                       ))
//                                 ]),
//                                 Row(children: [
//                                   const Text('Diagnosis: ',
//                                       style: TextStyle(
//                                         fontFamily: 'English2',
//                                         color: Colors.redAccent,
//                                         fontSize: 14,
//                                       )),
//                                   SizedBox(
//                                       width: 120,
//                                       height: 10,
//                                       child: TextField(
//                                         controller: _Diagnosis,
//                                         style: const TextStyle(
//                                           fontFamily: 'English2',
//                                           fontSize: 14,
//                                         ),
//                                         cursorColor: Colors.redAccent,
//                                         decoration:
//                                             const InputDecoration.collapsed(
//                                                 hintText: 'Text here...',
//                                                 hintStyle: TextStyle(
//                                                   fontFamily: 'English2',
//                                                   fontSize: 10,
//                                                 )),
//                                       ))
//                                 ])
//                               ]),
//                           const SizedBox(
//                             height: 15,
//                           ),
//                           Container(
//                             height: heights / 2.08,
//                             width: width / 2.5,
//                             decoration: const BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(32))),
//                             child: Padding(
//                               padding: const EdgeInsets.all(14.0),
//                               child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text('Chief complaint:',
//                                         style: TextStyle(
//                                           fontFamily: 'English2',
//                                           color: Color(0xff0E9CAB),
//                                           fontSize: 14,
//                                         )),
//                                     Center(
//                                         child: SizedBox(
//                                             width: width / 3,
//                                             height: heights / 3,
//                                             child: TextField(
//                                               controller: _note,
//                                               maxLines: 10,
//                                               cursorColor:
//                                                   const Color(0xff0E9CAB),
//                                               decoration: const InputDecoration(
//                                                 hintText: 'pless text here...',
//                                                 border: InputBorder.none,
//                                               ),
//                                             ))),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             const Text('To be admitted to:',
//                                                 style: TextStyle(
//                                                   fontFamily: 'English2',
//                                                   color: Color(0xff0E9CAB),
//                                                   fontSize: 14,
//                                                 )),
//                                             Container(
//                                                 height: 30,
//                                                 padding: const EdgeInsets.only(
//                                                     right: 20,
//                                                     left: 20,
//                                                     top: 1,
//                                                     bottom: 1),
//                                                 child: DropdownButton(
//                                                     items: const [
//                                                       DropdownMenuItem(
//                                                         value: '---------',
//                                                         child:
//                                                             Text('---------'),
//                                                       ),
//                                                       DropdownMenuItem(
//                                                         value: 'Emergency dep',
//                                                         child: Text(
//                                                             'Emergency dep'),
//                                                       ),
//                                                       DropdownMenuItem(
//                                                         value: 'The ward',
//                                                         child: Text('The ward'),
//                                                       ),
//                                                       DropdownMenuItem(
//                                                         value: 'NICU dep',
//                                                         child: Text('NICU dep'),
//                                                       ),
//                                                       DropdownMenuItem(
//                                                         value:
//                                                             'Hivi pediatrician teaching hospital',
//                                                         child: Text(
//                                                             'Hivi pediatrician teaching hospital'),
//                                                       ),
//                                                     ],
//                                                     style: const TextStyle(
//                                                         color:
//                                                             Color(0xff666666),
//                                                         fontSize: 12,
//                                                         fontFamily: 'kurdi'),
//                                                     value: _dropdown,
//                                                     onChanged: selectdrop,
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             8),
//                                                     elevation: 2,
//                                                     icon: const Icon(
//                                                       Icons
//                                                           .arrow_drop_down_rounded,
//                                                       color: Color(0xff666666),
//                                                     ),
//                                                     underline: const Text('')))
//                                           ],
//                                         ),
//                                         Row(children: [
//                                           InkWell(
//                                             onTap: () => showDialog(
//                                               context: context,
//                                               builder: (context) =>
//                                                   showplus('title', width),
//                                             ),
//                                             child: Container(
//                                                 width: 80,
//                                                 height: 33,
//                                                 decoration: BoxDecoration(
//                                                     color:
//                                                         const Color(0xffFEAD5A),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             28)),
//                                                 child: const Center(
//                                                     child: Text(
//                                                   'Next visit',
//                                                   style: TextStyle(
//                                                       color: Colors.white),
//                                                 ))),
//                                           ),
//                                           const SizedBox(
//                                             width: 5,
//                                           ),
//                                           InkWell(
//                                             onTap: () {
//                                               nextdaypatients(true);

//                                               deletePaintent(pid);
//                                               // clears();
//                                               setState(() {
//                                                 listpatient.clear();
//                                                 listpatients();
//                                               });
//                                             },
//                                             child: Container(
//                                                 width: 80,
//                                                 height: 33,
//                                                 decoration: BoxDecoration(
//                                                     color:
//                                                         const Color(0xff0E9CAB),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             28)),
//                                                 child: const Center(
//                                                     child: Text(
//                                                   'Doneee',
//                                                   style: TextStyle(
//                                                       color: Colors.white),
//                                                 ))),
//                                           ),
//                                         ]),
//                                       ],
//                                     )
//                                   ]),
//                             ),
//                           )
//                         ]),
//                       ),
//               )
//             ],
//           ),
//         ),
//       );

//   Dialog showplus(String title, widths) => Dialog(
//       backgroundColor: Colors.transparent,
//       child: SizedBox(
//         height: 100,
//         width: 350,
//         child: Container(
//           decoration: BoxDecoration(
//             color: const Color(0xFFEFF7F8),
//             borderRadius: BorderRadius.circular(30),
//           ),
//           child: inshow(title, widths),
//         ),
//       ));

//   Padding inshow(String title, widths) => Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Column(children: [
//               const Text(
//                 'You Can Visit Us ',
//                 style: TextStyle(color: Color(0xff0E9CAB)),
//               ),
//               timessearch(widths, widths),
//             ]),
//             Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//               TextButton(
//                 onPressed: () => nextdaypatients(false),
//                 style: ButtonStyle(
//                     shape: MaterialStatePropertyAll(ContinuousRectangleBorder(
//                         borderRadius: BorderRadius.circular(40))),
//                     backgroundColor:
//                         const MaterialStatePropertyAll(Color(0xff0E9CAB)),
//                     overlayColor: const MaterialStatePropertyAll(Colors.grey)),
//                 child: Container(
//                   height: 30,
//                   width: 80,
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                       color: Colors.transparent,
//                       borderRadius: BorderRadius.circular(40)),
//                   child: const Text(
//                     'Done',
//                     style: TextStyle(
//                         color: Colors.white, fontSize: 18, fontFamily: 'kurdi'),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 style: ButtonStyle(
//                     shape: MaterialStatePropertyAll(ContinuousRectangleBorder(
//                         borderRadius: BorderRadius.circular(40))),
//                     backgroundColor:
//                         const MaterialStatePropertyAll(Color(0xffFEAD5A)),
//                     overlayColor: const MaterialStatePropertyAll(Colors.grey)),
//                 child: Container(
//                   height: 30,
//                   width: 80,
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                       color: Colors.transparent,
//                       borderRadius: BorderRadius.circular(40)),
//                   child: const Text(
//                     'Cancel',
//                     style: TextStyle(
//                         color: Colors.white, fontSize: 18, fontFamily: 'kurdi'),
//                   ),
//                 ),
//               ),
//             ])
//           ],
//         ),
//       );

// //alert old report user

//   Dialog showplusold(String title, String username, String phone, String gender,
//           String age, String hight, String weight, widths) =>
//       Dialog(
//           backgroundColor: Colors.transparent,
//           child: SizedBox(
//             height: 500,
//             width: 350,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: const Color(0xFFEFF7F8),
//                 borderRadius: BorderRadius.circular(50),
//               ),
//               child: inshowold(
//                   title, username, phone, gender, age, hight, weight, widths),
//             ),
//           ));

//   Padding inshowold(String title, String username, String phone, String gender,
//           String age, String hight, String weight, widths) =>
//       Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Padding(
//                 padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
//                 child: SizedBox(
//                     height: 105,
//                     width: 340,
//                     child: Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(30),
//                           boxShadow: const [
//                             BoxShadow(
//                                 color: Color(0xFFE4E4E4),
//                                 blurRadius: 3,
//                                 spreadRadius: 3,
//                                 offset: Offset(0, 3))
//                           ]),
//                       child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(username,
//                                     style: const TextStyle(
//                                       fontFamily: 'English3',
//                                       color: Color(0xff0B0C14),
//                                       fontSize: 23,
//                                     )),
//                                 Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 4),
//                                         child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               Row(children: [
//                                                 const Text('Gender: ',
//                                                     style: TextStyle(
//                                                       fontFamily: 'English2',
//                                                       color: Color(0xff0B0C14),
//                                                       fontSize: 12,
//                                                     )),
//                                                 Text(gender,
//                                                     style: const TextStyle(
//                                                       fontFamily: 'English2',
//                                                       color: Color(0xff0E9CAB),
//                                                       fontSize: 12,
//                                                     )),
//                                               ]),
//                                               const SizedBox(
//                                                 width: 10,
//                                               ),
//                                               Row(children: [
//                                                 const Text('Age: ',
//                                                     style: TextStyle(
//                                                       fontFamily: 'English2',
//                                                       color: Color(0xff0B0C14),
//                                                       fontSize: 12,
//                                                     )),
//                                                 Text(age,
//                                                     style: const TextStyle(
//                                                       fontFamily: 'English2',
//                                                       color: Color(0xff0E9CAB),
//                                                       fontSize: 12,
//                                                     )),
//                                               ]),
//                                             ]),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 4),
//                                         child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               Row(children: [
//                                                 const Text('Hight: ',
//                                                     style: TextStyle(
//                                                       fontFamily: 'English2',
//                                                       color: Color(0xff0B0C14),
//                                                       fontSize: 12,
//                                                     )),
//                                                 Text('${hight} cm',
//                                                     style: const TextStyle(
//                                                       fontFamily: 'English2',
//                                                       color: Color(0xff0E9CAB),
//                                                       fontSize: 12,
//                                                     )),
//                                               ]),
//                                               const SizedBox(
//                                                 width: 10,
//                                               ),
//                                               Row(children: [
//                                                 const Text('Weight: ',
//                                                     style: TextStyle(
//                                                       fontFamily: 'English2',
//                                                       color: Color(0xff0B0C14),
//                                                       fontSize: 12,
//                                                     )),
//                                                 Text('${weight} kg',
//                                                     style: const TextStyle(
//                                                       fontFamily: 'English2',
//                                                       color: Color(0xff0E9CAB),
//                                                       fontSize: 12,
//                                                     )),
//                                               ]),
//                                             ]),
//                                       ),
//                                     ]),
//                               ])),
//                     ))),
//             //
//             const Text('Old Visits List',
//                 style: TextStyle(
//                   fontFamily: 'English1',
//                   color: Color(0xff0B0C14),
//                   fontSize: 26,
//                 )),
//             listoldvistcard(widths),
//             //
//           ],
//         ),
//       );

//   SizedBox listoldvistcard(double widths) => SizedBox(
//       height: 300,
//       child: ListView.builder(
//           itemCount: oldvistidata.length,
//           itemBuilder: (context, index) {
//             return Padding(
//                 padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
//                 child: SizedBox(
//                     height: 63,
//                     child: Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(30),
//                           boxShadow: const [
//                             BoxShadow(
//                                 color: Color(0xFFE4E4E4),
//                                 blurRadius: 2,
//                                 spreadRadius: 1,
//                                 offset: Offset(0, 4))
//                           ]),
//                       child: Padding(
//                           padding: const EdgeInsets.all(15.0),
//                           child: Column(children: [
//                             Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text('${oldvistidata[index]['dateadd']}',
//                                       style: const TextStyle(
//                                         fontFamily: 'English3',
//                                         color: Color(0xff0B0C14),
//                                         fontSize: 20,
//                                       )),
//                                   InkWell(
//                                     onTap: () =>
//                                         oldvistpatients(index.toString()),
//                                     child: Container(
//                                         width: 120,
//                                         height: 33,
//                                         decoration: BoxDecoration(
//                                             color: const Color(0xffFEAD5A),
//                                             borderRadius:
//                                                 BorderRadius.circular(28)),
//                                         child: const Padding(
//                                           padding: EdgeInsets.only(
//                                               left: 20,
//                                               right: 10,
//                                               top: 5,
//                                               bottom: 5),
//                                           child: Text(
//                                             'View invoice',
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           ),
//                                         )),
//                                   )
//                                 ]),
//                           ])),
//                     )));
//           }));

//   Padding textfild(String pl, TextEditingController text, double width) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//       child: SizedBox(
//         height: 45,
//         width: width / 7.2,
//         child: CupertinoTextField(
//             placeholderStyle: const TextStyle(color: Color(0xffbac8ACFD6)),
//             keyboardType: TextInputType.text,
//             textInputAction: TextInputAction.done,
//             cursorColor: const Color(0xff0E9CAB),
//             cursorWidth: 2,
//             placeholder: pl,
//             controller: text,
//             style: const TextStyle(
//               color: Color(0xff666666),
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//             ),
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(color: const Color(0xff0E9CAB), width: 1),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Color(0xFFE4E4E4),
//                     blurRadius: 3,
//                   )
//                 ],
//                 borderRadius: BorderRadius.circular(30))),
//       ),
//     );
//   }

//   Padding textfildarya(String pl, TextEditingController text, double width) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//       child: SizedBox(
//         height: 100,
//         width: width / 3,
//         child: CupertinoTextField(
//             placeholderStyle: const TextStyle(color: Color(0xffbac8ACFD6)),
//             keyboardType: TextInputType.text,
//             textInputAction: TextInputAction.done,
//             cursorColor: const Color(0xff0E9CAB),
//             cursorWidth: 2,
//             placeholder: pl,
//             controller: text,
//             style: const TextStyle(
//               color: Color(0xff666666),
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//             ),
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(color: const Color(0xff0E9CAB), width: 1),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Color(0xFFE4E4E4),
//                     blurRadius: 3,
//                   )
//                 ],
//                 borderRadius: BorderRadius.circular(30))),
//       ),
//     );
//   }
// }
