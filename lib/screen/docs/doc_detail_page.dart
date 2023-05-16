import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:online_learning/screen/docs/model/doc_content.dart';
import 'package:online_learning/screen/docs/model/doc_info.dart';
import 'package:online_learning/screen/docs/view_PDF.dart';

import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/widgets.dart';

import '../../languages/languages.dart';
import '../../res/images.dart';


class DocDetailsPage extends StatefulWidget {
  DocContent? _document;

  DocDetailsPage(this._document);

  @override
  State<DocDetailsPage> createState() => _DocDetailsPageState();
}

class _DocDetailsPageState extends State<DocDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: getWidthDevice(context),
            height: 52,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.tabBar),
                fit: BoxFit.fill,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 8,),
                IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back, color: AppColors.blue,)),
                SizedBox(width: 8,),
                Expanded(child: NeoText(widget._document!.name!, textStyle: TextStyle(color: AppColors.blueLight, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                SizedBox(width: 52,)
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                loadPhoto.networkImage(widget._document!.imageUrl, getHeightDevice(context)*0.3, getWidthDevice(context)),
                SizedBox(height: 8,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NeoText('${Languages.of(context).teacher}: ${widget._document!.teacher}', textStyle: TextStyle(fontSize: 14, color: AppColors.black)),
                ),
                Divider(),
                SizedBox(height: 8,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    children: List.generate(widget._document!.docsList!.length, (index) => _itemDoc(widget._document!.docsList![index])),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _itemDoc(DocInfo doc){
    return InkWell(
      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>PDFViewerFromUrl(url: doc.fileUrl!, name: doc.fileName!))),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.document_scanner,
                color: AppColors.blue,
              ),
              SizedBox(width: 4,),
              Expanded(child: NeoText(doc.fileName!, textStyle: TextStyle(fontSize: 12, color: AppColors.blue, overflow: TextOverflow.ellipsis), maxline: 1)),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}

