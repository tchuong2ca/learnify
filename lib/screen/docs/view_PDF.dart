import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/widgets.dart';
import '../../res/images.dart';

class PDFViewerFromUrl extends StatelessWidget {
  const PDFViewerFromUrl({Key? key, required this.url, required this.name}) : super(key: key);

  final String url;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF From Url'),
        toolbarHeight: 0,
      ),
      body: Column(
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
                IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back, color: CommonColor.blue,)),
                SizedBox(width: 8,),
                Expanded(child: NeoText(name, textStyle: TextStyle(color: CommonColor.blueLight, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                SizedBox(width: 52,)
              ],
            ),
          ),
          Expanded(
            child: const PDF().fromUrl(
              url,
              placeholder: (double progress) => Center(child: Text('$progress %')),
              errorWidget: (dynamic error) => Center(child: Text(error.toString())),
            ),
          ),
        ],
      ),
    );
  }
}