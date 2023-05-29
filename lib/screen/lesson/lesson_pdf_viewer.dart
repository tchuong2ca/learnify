import 'package:flutter/material.dart';
import '../docs/view_PDF.dart';
class PdfViewerPage extends StatelessWidget{
  String? _url;
  PdfViewerPage(this._url);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: Stack(
        children: [
          PDFViewerFromUrl(url: _url!),
        ],
      ),
    );
  }
}