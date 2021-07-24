import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class DetailQuize extends StatefulWidget {
  String title;
  String description;
  String urlfile;

  DetailQuize({this.title, this.description, this.urlfile});
  @override
  State<StatefulWidget> createState() => DetailQuizeState();
}

class DetailQuizeState extends State<DetailQuize> {
  bool isdownload = false;
  PDFDocument doc;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: isdownload == true
            ? Container(
                width: width,
                height: height,
                child: PDFViewer(
                  document: doc,
                ))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      widget.title,
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    padding: EdgeInsets.all(15),
                    child: Text(
                      widget.description,
                      style: TextStyle(fontSize: 17),
                      textAlign: TextAlign.justify,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.download_sharp),
                      onPressed: () async {
                        doc = await PDFDocument.fromURL(widget.urlfile);
                        setState(() {
                          isdownload = !isdownload;
                        });
                      }),
                ],
              ),
      ),
    );
  }
}
