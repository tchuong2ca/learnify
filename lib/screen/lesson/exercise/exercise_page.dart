import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_learning/screen/lesson/exercise/presenter/exercise_presenter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../common/colors.dart';
import '../../../common/functions.dart';
import '../../../common/themes.dart';
import '../../../common/widgets.dart';
import '../../../languages/languages.dart';
import '../../../res/images.dart';
import '../model/lesson_detail.dart';
import '../model/questionAnswer.dart';

class ExercisePage extends StatefulWidget{

  List<QA>? _listQA;
  LessonDetail? _lessonDetail;
  ExercisePage(this._listQA, this._lessonDetail);

  @override
  State<StatefulWidget> createState() =>_ExercisePage();

}

class _ExercisePage extends State<ExercisePage>{
  List<QA>? _listQAStudent;
  ExercisePresenter? _presenter;
  @override
  void initState() {
    _listQAStudent = widget._listQA!;
    _presenter = ExercisePresenter();
    _listQAStudent = _presenter!.initData(_listQAStudent!);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: ()=>hideKeyboard(),
      child: Scaffold(
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
              decoration:  BoxDecoration(
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
                  Expanded(child: NeoText(Languages.of(context).exercise, textStyle: TextStyle(color: AppColors.blueLight, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                  ElevatedButton(
                      onPressed: (){
                        _listQAStudent=_presenter!.ResultSubmit(_listQAStudent!);
                        _checkValueAnswer(_presenter!.Score(_listQAStudent!));
                      },
                      child: NeoText(Languages.of(context).createNew, textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.white))),
                  SizedBox(width: 8,)
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: ListView.separated(
                  itemBuilder: (context, index)=>_itemQA(widget._listQA![index], index),
                  itemCount: widget._listQA!.length,
                  separatorBuilder: (context, index)=>Divider(),
                  shrinkWrap: true,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _itemQA(QA qa, int index){
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NeoText('${Languages.of(context).indexQA} ${index+1}: ', textStyle: TextStyle(color: AppColors.blue, fontSize: 14, fontWeight: FontWeight.bold)),
                Expanded(child: NeoText(qa.question!, textStyle: TextStyle(color: AppColors.blue, fontSize: 14, fontWeight: FontWeight.bold))),
              ],
            ),
            SizedBox(height: 8,),
            TextField(
              decoration: AppThemes.textFieldInputDecoration(hintText: Languages.of(context).answer, labelText: Languages.of(context).answer),
              onChanged: (value){
                qa.studentAnswer = value;
                setState(()=>null);
              },
            )
          ],
        ),
      ),
    );
  }

  _dialogAnswerResult(double number, String comment,String type){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.transparent,
        builder: (_) => Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: DraggableScrollableSheet(
              initialChildSize: 0.9,
              minChildSize: 0.2,
              maxChildSize: 0.90,
              builder: (BuildContext context, ScrollController scrollController) {
                return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16.0),
                            topRight: const Radius.circular(16.0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: ()=>Navigator.pop(context),
                              child: Icon(
                                Icons.remove,
                                color: Colors.grey[600],
                              ),
                            ),
                            Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            NeoText('${Languages.of(context).result} ${_presenter!.ScroreCorrect(_listQAStudent!)}/${widget._listQA!.length}'),
                                            NeoText('${Languages.of(context).resultCategory}: $type'),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 8,),
                                      LinearPercentIndicator(
                                        animation: true,
                                        percent: number,
                                        animationDuration: 2500,
                                        progressColor: AppColors.green,
                                        linearStrokeCap: LinearStrokeCap.roundAll,
                                        lineHeight: 26,
                                        barRadius: Radius.circular(16),
                                        center: NeoText('${number*100} %',),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16, bottom: 8.0),
                                        child: Center(child: NeoText(comment,)),
                                      ),
                                      // SizedBox(height: 16,),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount: _listQAStudent!.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return _itemAnswerResult(index, _listQAStudent![index]);
                                          }),
                                    ],
                                  ),
                                )
                            ),

                          ],
                        )
                    )
                );
              },
            )
        )
    );
  }

  _checkValueAnswer(double percentCorrect) async{
    late String correctDetail;
    String type='';
    if(percentCorrect <= 1 && percentCorrect >= 0.9){
      correctDetail = Languages.of(context).supperGood;
      type = Languages.of(context).exellent;
    }
    else if(percentCorrect >= 0.7 && percentCorrect < 0.9){
      correctDetail = Languages.of(context).wellDone;
      type = Languages.of(context).good;
    }
    else if(percentCorrect < 0.7 && percentCorrect >= 0.5){
      correctDetail = Languages.of(context).averageExam;
      type = Languages.of(context).goodless;
    }else{
      correctDetail = Languages.of(context).bad;
      type = Languages.of(context).low;
    }
    widget._lessonDetail!.homework![0].totalQA=percentCorrect*10;
    widget._lessonDetail!.homework![0].listQuestion=_listQAStudent;
    _presenter!.UpdateTotalLesson(widget._lessonDetail!, widget._lessonDetail!.homework!);
    _dialogAnswerResult(percentCorrect,correctDetail, type);
  }

  Widget _itemAnswerResult(int positon, QA answers){
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.only(top: 16, bottom: 16, left: 8, right: 8),
      decoration: BoxDecoration(
          color: AppColors.grayLight,
          borderRadius: BorderRadius.all(Radius.circular(16))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: AppColors.blue
                ),
                child: Center(child: NeoText('${positon+1}', textAlign: TextAlign.center, )),
              ),
              SizedBox(width: 4,),
              Expanded(child: NeoText('${Languages.of(context).indexQA} ${positon+1}:',  textStyle: TextStyle(fontSize: 14, color: AppColors.black, overflow: TextOverflow.ellipsis), maxline: 1)),
              Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: answers.correct!?AppColors.green:AppColors.redLight
                ),
                child: Center(child: NeoText('${answers.correct!?Languages.of(context).right:Languages.of(context).wrong}', textAlign: TextAlign.center, textStyle: TextStyle(fontSize: 14, color: AppColors.white))),
              ),
            ],
          ),
          SizedBox(height: 8,),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width/2-36,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8))
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NeoText('${Languages.of(context).answer}', textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4,),
                    NeoText('${answers.answer!}', textStyle:TextStyle(fontSize: 14, color: AppColors.black, overflow: TextOverflow.ellipsis), maxline: 1)
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width/2-36,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8))
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NeoText('${Languages.of(context).anwserHomework}', textStyle: TextStyle(fontSize: 14)),
                    SizedBox(height: 4,),
                    NeoText('${answers.studentAnswer!=null?answers.studentAnswer:''}', textStyle: TextStyle(fontSize: 14, color: AppColors.black, overflow: TextOverflow.ellipsis), maxline: 1)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
