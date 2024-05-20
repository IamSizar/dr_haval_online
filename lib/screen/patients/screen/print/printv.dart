import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class printv extends StatelessWidget {
  printv(
      {super.key,
      required this.name,
      required this.pid,
      required this.phone,
      required this.date,
      required this.gender,
      required this.age,
      required this.height,
      required this.weight,
      required this.ofc,
      required this.dru,
      required this.dia,
      required this.chief,
      required this.tobe,
      required this.price});
  String name,
      phone,
      date,
      gender,
      age,
      height,
      weight,
      ofc,
      dru,
      dia,
      chief,
      tobe,
      price,
      pid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("omed")),
      body: PdfPreview(
        useActions: false,
        actions: [PdfPrintAction()],
        build: (format) => _generatePdf(format, "K | S"),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font_kurdi = await fontFromAssetBundle('assets/fonts/kurdi.ttf');
    final font1 = await fontFromAssetBundle('assets/fonts/Roboto-Medium.ttf');
    final font2 = await fontFromAssetBundle('assets/fonts/Roboto-Thin.ttf');
    final instagram = await imageFromAssetBundle('assets/images/instagram.png');
    final facebook = await imageFromAssetBundle('assets/images/facebook.png');
    final phone = await imageFromAssetBundle('assets/images/phone.png');
    final tiktok = await imageFromAssetBundle('assets/images/tiktok.png');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        margin: pw.EdgeInsets.all(0),
        build: (context) {
          return pw.Container(
              // color: PdfColor.fromHex("#FEF6EE"),
              padding: pw.EdgeInsets.all(20),
              child: pw.Column(
                children: [
                  pw.Center(
                      child: pw.Column(children: [
                    // pw.Text(
                    //   "Dr. Haval Abdullahllah",
                    //   style: pw.TextStyle(fontSize: 30, font: font1),
                    // ),
                    // pw.Text(
                    //   "Pediatrician",
                    //   style: pw.TextStyle(fontSize: 25, fontBold: font2),
                    // ),
                    // pw.Divider(
                    //   thickness: 1,
                    //   color: PdfColor.fromHex("#0E9CAB"),
                    // ),
                    pw.SizedBox(height: 140),

                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(this.name,
                                  style: pw.TextStyle(
                                      fontSize: 16, fontBold: font2)),
                              pw.Text(this.phone,
                                  style: pw.TextStyle(
                                      fontSize: 10, fontBold: font2)),
                            ],
                          ),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.Text(this.date,
                                    style: pw.TextStyle(
                                        fontSize: 10, fontBold: font2)),
                                pw.Text(
                                    "${DateFormat('h:mm a').format(DateTime.now())}",
                                    style: pw.TextStyle(
                                        fontSize: 10, fontBold: font2)),
                              ]),
                        ]),
                    pw.SizedBox(height: 5),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Row(children: [
                            pw.Text("Gender: ",
                                style: pw.TextStyle(
                                    fontSize: 10, fontBold: font2)),
                            pw.Text(this.gender,
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColor.fromHex("#0E9CAB"),
                                    fontBold: font2)),
                          ]),
                          pw.Row(children: [
                            pw.Text("Age: ",
                                style: pw.TextStyle(
                                    fontSize: 10, fontBold: font2)),
                            pw.Text(this.age,
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColor.fromHex("#0E9CAB"),
                                    fontBold: font2)),
                          ]),
                        ]),
                    pw.SizedBox(height: 5),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Row(children: [
                            pw.Text("hight: ",
                                style: pw.TextStyle(
                                    fontSize: 10, fontBold: font2)),
                            pw.Text(this.height + "cm",
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColor.fromHex("#0E9CAB"),
                                    fontBold: font2)),
                          ]),
                          pw.Row(children: [
                            pw.Text("weight: ",
                                style: pw.TextStyle(
                                    fontSize: 10, fontBold: font2)),
                            pw.Text(this.weight + "kg",
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColor.fromHex("#0E9CAB"),
                                    fontBold: font2)),
                          ]),
                          pw.Row(children: [
                            pw.Text("OFC: ",
                                style: pw.TextStyle(
                                    fontSize: 10, fontBold: font2)),
                            pw.Text(this.ofc + "cm",
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColor.fromHex("#0E9CAB"),
                                    fontBold: font2)),
                          ]),
                        ]),
                    pw.SizedBox(height: 5),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Row(children: [
                            pw.Text("Diagnosis: ",
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColors.red,
                                    fontBold: font2)),
                            pw.Text(this.dia,
                                style: pw.TextStyle(
                                    fontSize: 10, fontBold: font2)),
                          ])
                        ]),
                    pw.SizedBox(height: 20),
                    pw.SizedBox(
                      height: 250,
                      width: 380,
                      child: pw.Container(
                        decoration: pw.BoxDecoration(
                            // color: PdfColors.blue100,
                            borderRadius:
                                pw.BorderRadius.all(pw.Radius.circular(32))),
                        child: pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text("Chief complaint: ",
                                      style: pw.TextStyle(
                                          fontSize: 15,
                                          color: PdfColor.fromHex("#0E9CAB"),
                                          fontBold: font2)),
                                  pw.SizedBox(height: 5),
                                  pw.RichText(
                                    text: pw.TextSpan(text: this.chief),
                                  ),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  pw.Text("To be admitted to: ",
                                      style: pw.TextStyle(
                                          fontSize: 10,
                                          color: PdfColor.fromHex("#0E9CAB"),
                                          fontBold: font2)),
                                  pw.Text(this.tobe,
                                      style: pw.TextStyle(
                                          fontSize: 10, fontBold: font2)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        children: [
                          // pw.Row(children: [
                          //   pw.SizedBox(
                          //       height: 14, width: 14, child: pw.Image(phone)),
                          //   pw.Text(" 0751 841 5955",
                          //       style: pw.TextStyle(
                          //           fontSize: 14, fontBold: font2)),
                          // ]
                          // ),
                          pw.Row(
                            children: [
                              pw.Row(
                                children: [
                                  pw.Row(
                                    children: [
                                      pw.SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: pw.Image(facebook),
                                      ),
                                      pw.Text(
                                        " drhavalbinavi",
                                        style: pw.TextStyle(
                                            fontSize: 10, fontBold: font2),
                                      ),
                                    ],
                                  ),
                                  pw.SizedBox(width: 20),
                                  pw.Row(
                                    children: [
                                      pw.SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: pw.Image(tiktok)),
                                      pw.Text(" dr.haval",
                                          style: pw.TextStyle(
                                              fontSize: 10, fontBold: font2)),
                                      pw.SizedBox(width: 20),
                                    ],
                                  ),
                                ],
                              ),
                              pw.SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: pw.Image(instagram)),
                              pw.Text(
                                " dr.haval_abdullah_muhammed",
                                style:
                                    pw.TextStyle(fontSize: 10, fontBold: font2),
                              ),
                            ],
                          ),
                        ]),
                    pw.SizedBox(height: 5),
                  ]))
                  // pw.SizedBox(
                  //   width: double.infinity,
                  //   child: pw.FittedBox(
                  //     child: pw.Text(title, style: pw.TextStyle(font: font)),
                  //   ),
                  // ),
                  // pw.SizedBox(height: 20),
                  // pw.Flexible(child: pw.FlutterLogo())
                ],
              ));
        },
      ),
    );

    return pdf.save();
  }
}
