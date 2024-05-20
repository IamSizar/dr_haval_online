import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../crud/crud.dart';
import '../../../crud/linkapi.dart';
import '../../../main.dart';

class Investigations extends StatefulWidget {
  Investigations(
      {super.key,
      required this.username,
      required this.phone,
      required this.gender,
      required this.age,
      required this.hight,
      required this.weight});
  String username, phone, gender, age, hight, weight;
  @override
  State<Investigations> createState() => _InvestigationsState();
}

class _InvestigationsState extends State<Investigations> {
  late PdfViewerController _pdfViewerController;
  String pdflink = '';
  String? user = sharedPref.getString("username");
  Crud _crud = new Crud();

  //send pdf
  //late File _file;
  void getFile() {
    launchUrl(Uri.parse(
        '${Apiinsertpdf}?username=${widget.username}&phone=${widget.phone}&useradd=$user'));
  }

  List oldvistidata = [];
  bool isloding = false;
  getoldvisit(String username, String phone) async {
    oldvistidata.clear();
    setState(() {
      isloding = true;
    });
    var response = await _crud
        .getRequest('${Apiinvestigations}?username=$username&phone=$phone');
    setState(() {
      oldvistidata.addAll(response);
    });
    isloding = false;
  }

  slectpdf(String index) async {
    setState(() {
      pdflink =
          Apiinvestigationspath + oldvistidata[int.parse(index)]['pathreport'];
    });
  }

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    // TODO: implement initState
    super.initState();
    getoldvisit(widget.username, widget.phone);
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
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () => setState(() {
                          _pdfViewerController.zoomLevel = 2;
                        }),
                    icon: Icon(Icons.zoom_in_rounded)),
                IconButton(
                    onPressed: () => setState(() {
                          _pdfViewerController.zoomLevel = 1;
                        }),
                    icon: Icon(Icons.zoom_out_outlined)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SizedBox(
                  width: widths / 2.6,
                  height: heights / 1.1,
                  child: pdflink == ''
                      ? Center()
                      : SfPdfViewer.network(
                          pdflink,
                          controller: _pdfViewerController,
                        )),
            ),
          ],
        ),
      ));

  Expanded main(double heights, double width) => Expanded(
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
            SizedBox(
              height: 30,
            ),
            witinglist(width),
            listoldvistcard(heights, width),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: btback(heights, width),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: bt(heights, width),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            )
          ])));

  Column witinglist(double widths) => Column(
        children: [
          Text('Investigations',
              style: TextStyle(
                fontFamily: 'English2',
                color: Color(0xff0B0C14),
                fontSize: 28,
              )),
          const SizedBox(
            height: 30,
          ),
          info(),
          const SizedBox(
            height: 15,
          ),
        ],
      );

  InkWell bt(double heights, double widge) => InkWell(
        onTap: () => getFile(),
        borderRadius: BorderRadius.circular(30),
        child: SizedBox(
            height: 35,
            width: 100,
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xff0E9CAB),
                    borderRadius: BorderRadius.circular(30),
                    border:
                        Border.all(color: const Color(0xffCEEBEE), width: 1.5)),
                child: const Center(
                    child: Text('Emport',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'English2',
                        ))))),
      );

  InkWell btback(double heights, double widge) => InkWell(
        onTap: () => Navigator.pop(context),
        borderRadius: BorderRadius.circular(30),
        child: SizedBox(
            height: 35,
            width: 100,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                        color: const Color.fromARGB(255, 70, 70, 70),
                        width: 1.5)),
                child: const Center(
                    child: Text('Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'English2',
                        ))))),
      );
  Padding info() {
    return Padding(
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
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.username,
                            style: TextStyle(
                              fontFamily: 'English3',
                              color: Color(0xff0B0C14),
                              fontSize: 25,
                            )),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(children: [
                                        Text('Gender: ',
                                            style: TextStyle(
                                              fontFamily: 'English2',
                                              color: Color(0xff0B0C14),
                                              fontSize: 12,
                                            )),
                                        Text(widget.gender,
                                            style: TextStyle(
                                              fontFamily: 'English2',
                                              color: Color(0xff0E9CAB),
                                              fontSize: 12,
                                            )),
                                      ]),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Row(children: [
                                        Text('Age: ',
                                            style: TextStyle(
                                              fontFamily: 'English2',
                                              color: Color(0xff0B0C14),
                                              fontSize: 12,
                                            )),
                                        Text(widget.age,
                                            style: TextStyle(
                                              fontFamily: 'English2',
                                              color: Color(0xff0E9CAB),
                                              fontSize: 12,
                                            )),
                                      ]),
                                    ]),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(children: [
                                        Text('Hight: ',
                                            style: TextStyle(
                                              fontFamily: 'English2',
                                              color: Color(0xff0B0C14),
                                              fontSize: 12,
                                            )),
                                        Text('${widget.hight} cm',
                                            style: TextStyle(
                                              fontFamily: 'English2',
                                              color: Color(0xff0E9CAB),
                                              fontSize: 12,
                                            )),
                                      ]),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Row(children: [
                                        Text('Weight: ',
                                            style: TextStyle(
                                              fontFamily: 'English2',
                                              color: Color(0xff0B0C14),
                                              fontSize: 12,
                                            )),
                                        Text('${widget.weight} kg',
                                            style: TextStyle(
                                              fontFamily: 'English2',
                                              color: Color(0xff0E9CAB),
                                              fontSize: 12,
                                            )),
                                      ]),
                                    ]),
                              ),
                            ]),
                      ])),
            )));
  }

  SizedBox listoldvistcard(double height, double widths) => SizedBox(
      height: height / 1.8,
      width: 450,
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
                                  Text(oldvistidata[index]['dateaddreport'],
                                      style: TextStyle(
                                        fontFamily: 'English3',
                                        color: Color(0xff0B0C14),
                                        fontSize: 20,
                                      )),
                                  InkWell(
                                    onTap: () => slectpdf(index.toString()),
                                    child: Container(
                                        width: 150,
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
                                            'View examinations',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )),
                                  )
                                ]),
                          ])),
                    )));
          }));
}
