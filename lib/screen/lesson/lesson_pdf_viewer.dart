import 'package:flutter/material.dart';

import '../../languages/languages.dart';
import '../docs/view_PDF.dart';
import 'exercise/exercise_page.dart';
import 'model/lesson_detail.dart';
import 'model/questionAnswer.dart';

class PdfViewerPage extends StatelessWidget{
  String? _url;
  List<QA>? _listQA;
  LessonDetail? _lessonDetail;
  PdfViewerPage(this._url, this._listQA, this._lessonDetail);

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
          _listQA==null||_lessonDetail==null?SizedBox():Positioned(
            bottom: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  ElevatedButton(child: Text(Languages.of(context).exercise),onPressed: (){ Navigator.push(context,
                      MaterialPageRoute(builder: (_)=>
                          //ExercisePage(_listQA, _lessonDetail)
                      ExercisePage()
                      ));},)
              // ButtonDefault(Languages.of(context).exercise, (data) {
              //   Navigator.push(context, MaterialPageRoute(builder: (_)=>ExercisePage(_listQA, _lessonDetail)));
              // }),
            ),
          )
        ],
      ),
    );
  }


}