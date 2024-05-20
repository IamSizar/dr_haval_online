import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../crud/crud.dart';
import '../../../crud/linkapi.dart';
import '../../../main.dart';

class patientsdate extends StatefulWidget {
  const patientsdate({super.key});

  @override
  State<patientsdate> createState() => _patientsdateState();
}

class _patientsdateState extends State<patientsdate> {
  DateTime slectdate = DateTime.now();
  TextEditingController birthday = TextEditingController();
  TextEditingController _search = TextEditingController();
  String? user = sharedPref.getString("username");
  Crud _crud = new Crud();
//get list data
  bool isloding = false;
  List listpatient = [];
  listpatients(TextEditingController search) async {
    listpatient.clear();
    setState(() {
      isloding = true;
    });
    var response = _search.text != ""
        ? await _crud.getRequest(
            '${ApisearchPatientsdatesearchtwo}?phone=${search.text}')
        : await _crud.getRequest(Apipatientsdateindextwo);
    setState(() {
      listpatient.addAll(response);
    });
    isloding = false;
  }

  //update date
  dateupdatepatients(String id, String date) async {
    setState(() {
      isloding = true;
    });
    var response = await _crud
        .getRequest('${ApiupdatePatientsdate}?id=$id&attendance=$date');
    listpatient.clear();
    listpatients(_search);
    isloding = false;
  }

  //next to ready
  nexttoreadypatientsfellow(String username, String phone, String birthday,
      String gender, String price, String useradd) async {
    setState(() {
      isloding = true;
    });
    String timenow =
        DateTime.now().hour.toString() + ":" + DateTime.now().minute.toString();
    String datenow = DateTime.now().year.toString() +
        "-" +
        DateTime.now().month.toString() +
        "-" +
        DateTime.now().day.toString();
    var response = await _crud.getRequest(
        '${ApiinsertPatientsdatefellow}?username=$username&phone=$phone&birthday=$birthday&datenow=${datenow}&timenow=${timenow}&gender=$gender&price=0000&useradd=$useradd');
    listpatient.clear();
    listpatients(_search);
    isloding = false;
  }

  //delete
  deletepatients(String id) async {
    setState(() {
      isloding = true;
    });
    var response = await _crud.getRequest('${ApideletePatientsdate}?id=$id');
    listpatient.clear();
    listpatients(_search);
    isloding = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listpatients(_search);
  }

  @override
  Widget build(BuildContext context) {
    final heights = MediaQuery.of(context).size.height;
    final widths = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(children: [
        search('Search Number...', _search, widths),
        SizedBox(
          width: widths,
          height: MediaQuery.of(context).size.height / 1.19,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: MediaQuery.of(context).size.height / 215,
                mainAxisSpacing: 10),
            itemCount: listpatient.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: SizedBox(
                      height: 100,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
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
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '${listpatient[index]['username']}',
                                              style: const TextStyle(
                                                fontFamily: 'English3',
                                                color: Color(0xff0B0C14),
                                                fontSize: 18,
                                              )),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Text(
                                                '${listpatient[index]['phone']}',
                                                style: const TextStyle(
                                                  fontFamily: 'English3',
                                                  color: Color(0xff0B0C14),
                                                  fontSize: 12,
                                                )),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Text(
                                                '${listpatient[index]['dateadd']}',
                                                style: const TextStyle(
                                                  fontFamily: 'English3',
                                                  color: Color(0xff0B0C14),
                                                  fontSize: 12,
                                                )),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4.0),
                                            child: InkWell(
                                              onTap: () => showDialog(
                                                  context: context,
                                                  builder: (context) => showplus(
                                                      '${listpatient[index]['username']}',
                                                      '${listpatient[index]['phone']}',
                                                      '${listpatient[index]['attendance']}',
                                                      '${listpatient[index]['id']}',
                                                      widths)),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff8ACFD6),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            28)),
                                              ),
                                            ),
                                          ),
                                        ]),
                                    Column(children: [
                                      InkWell(
                                        onTap: () => nexttoreadypatientsfellow(
                                          '${listpatient[index]['username']}',
                                          '${listpatient[index]['phone']}',
                                          '${listpatient[index]['birthday']}',
                                          '${listpatient[index]['gender']}',
                                          '${listpatient[index]['price']}',
                                          '$user',
                                        ),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: const Color(0xff0E9CAB),
                                                borderRadius:
                                                    BorderRadius.circular(28)),
                                            child: const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 3,
                                                  bottom: 3),
                                              child: Row(children: [
                                                Text(
                                                  'Next',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                Icon(
                                                  Icons.navigate_next_rounded,
                                                  color: Colors.white,
                                                )
                                              ]),
                                            )),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ])
                                  ]),
                            ])),
                      )));
            },
          ),
        ),
      ]),
    );
  }

  Dialog showplus(
          String username, String phone, String date, String id, widths) =>
      Dialog(
          backgroundColor: Colors.transparent,
          child: SizedBox(
            height: 400,
            width: 300,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEFF7F8),
                borderRadius: BorderRadius.circular(50),
              ),
              child: inshow(username, phone, date, id, widths),
            ),
          ));

  Padding inshow(
          String username, String phone, String date, String id, widths) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: SizedBox(
                    height: 80,
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
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(username,
                                          style: const TextStyle(
                                            fontFamily: 'English3',
                                            color: Color(0xff0B0C14),
                                            fontSize: 20,
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 0),
                                        child: Text(phone,
                                            style: const TextStyle(
                                              fontFamily: 'English2',
                                              color: Color(0xff0B0C14),
                                              fontSize: 16,
                                            )),
                                      ),
                                    ]),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(date,
                                      style: const TextStyle(
                                        fontFamily: 'English2',
                                        color: Color(0xff0B0C14),
                                        fontSize: 16,
                                      )),
                                ),
                              ])),
                    ))),
            //
            textfild(date, birthday, widths),
            //

            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(40))),
                      backgroundColor:
                          const MaterialStatePropertyAll(Color(0xffFEAD5A)),
                      overlayColor:
                          const MaterialStatePropertyAll(Colors.grey)),
                  child: Container(
                    height: 50,
                    width: 100,
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    dateupdatepatients(id, birthday.text);
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(40))),
                      backgroundColor:
                          const MaterialStatePropertyAll(Color(0xff0E9CAB)),
                      overlayColor:
                          const MaterialStatePropertyAll(Colors.grey)),
                  child: Container(
                    height: 50,
                    width: 100,
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
              ),
            ]),
          ],
        ),
      );

  Padding textfild(String pl, TextEditingController text, double width) {
    birthday.text = pl;
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
            suffix: InkWell(
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
                          '${dateTime.year}-${int.parse(dateTime.month.toString()) < 10 ? '0' + dateTime.month.toString() : dateTime.month.toString()}-${int.parse(dateTime.day.toString()) < 10 ? '0' + dateTime.day.toString() : dateTime.day.toString()}';
                    });
                  }
                },
                child: const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.date_range_rounded,
                        size: 25, color: Color(0xff0E9CAB)))),
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

  Padding search(String pl, TextEditingController text, double width) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
      child: SizedBox(
        height: 45,
        width: width / 3,
        child: CupertinoTextField(
            placeholderStyle: const TextStyle(color: Color(0xffbac8ACFD6)),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            onSubmitted: (value) => listpatients(_search),
            onChanged: (value) => listpatients(_search),
            cursorColor: const Color(0xff0E9CAB),
            cursorWidth: 2,
            placeholder: pl,
            controller: text,
            style: const TextStyle(
              color: Color(0xff666666),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            suffix: const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.search, size: 25, color: Color(0xff0E9CAB))),
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
