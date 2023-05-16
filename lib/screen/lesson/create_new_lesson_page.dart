import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_learning/screen/course/model/class_detail.dart';
import 'package:online_learning/screen/course/model/course_model.dart';
import 'package:online_learning/screen/course/model/my_class_model.dart';
import 'package:online_learning/screen/lesson/presenter/create_new_lesson_presenter.dart';

import '../../common/colors.dart';
import '../../common/dropdown.dart';
import '../../common/functions.dart';
import '../../common/keys.dart';
import '../../common/themes.dart';
import '../../common/widgets.dart';
import '../../languages/languages.dart';
import '../../res/images.dart';
import '../../storage/storage.dart';
import 'model/discuss.dart';
import 'model/homework.dart';
import 'model/lesson.dart';
import 'model/lesson_detail.dart';
import 'model/questionAnswer.dart';

class LessonProductPage extends StatefulWidget {
  Lesson? _lesson;
  ClassDetail? _myClassDetail;
  CourseModel? _course;
  MyClassModel? _myClass;
  String? _keyFlow;
  LessonDetail? _lessonDetail;

  LessonProductPage(this._lesson, this._keyFlow, this._course, this._myClass, this._myClassDetail, this._lessonDetail);

  @override
  State<LessonProductPage> createState() => _LessonProductPageState(_lesson, _keyFlow, _course, _myClass, _myClassDetail, _lessonDetail);
}

class _LessonProductPageState extends State<LessonProductPage> {
  Lesson? _lesson;
  String? _keyFlow;
  ClassDetail? _myClassDetail;
  CourseModel? _course;
  MyClassModel? _myClass;
  LessonDetail? _lessonDetail;
  _LessonProductPageState(this._lesson, this._keyFlow, this._course, this._myClass, this._myClassDetail, this._lessonDetail);

  LessonProductPresenter? _presenter;
  String _fileNameContent = '';
  String _fileContent = '';
  String _videoLink = '';
  String _fileNameQuestion = '';
  String _fileQuestion = '';
  String _fileAnswer = '';
  String _fileNameAnswer = '';
  List<Homework> _homeworkList = [Homework(idHomework: '1',listQuestion: [QA(id: '1')], worksheet: true, totalQA: 0.0)];
  List<String> _stringList = ['Có trắc nghiệm', 'Không trắc nghiệm'];
  String _select = '';
  String _fullname = '';
  String _avatar = '';
  TextEditingController _controllerUrlLink = TextEditingController();

  @override
  void initState() {
    _presenter = LessonProductPresenter();
    _select = _stringList[0];
    getDataUser();
    if(CommonKey.EDIT==_keyFlow){
      getDataEdit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
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
                Expanded(child: NeoText(_lesson!.lessonName!, textStyle: TextStyle(color: AppColors.blueLight, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                ElevatedButton(
                    onPressed: (){
                      if(_videoLink.isEmpty){
                        CustomDialog(context: context, content: 'chưa có link');
                      }else if(_fileContent.isEmpty){
                        CustomDialog(context: context, content: 'chưa có file nội dung');
                      }else if(_fileAnswer.isEmpty){
                        CustomDialog(context: context, content: 'Chưa có file đáp án');
                      }else if(_fileQuestion.isEmpty){
                        CustomDialog(context: context, content: 'Chưa có file câu hỏi');
                      }else{
                        if(CommonKey.EDIT!=_keyFlow){
                          Discuss? discuss = Discuss(name: _fullname, avatar: _avatar, timeStamp: getTimestamp(), content: Languages.of(context).youNeed, nameFeedback: '');
                          LessonDetail lessonDetail = LessonDetail(idLessonDetail: replaceSpace(_lesson!.lessonId!), fileContent: _fileContent,
                              nameLesson: _lesson!.lessonName!, videoLink: _videoLink, homework: _homeworkList, discuss: [discuss]);
                          showLoaderDialog(context);
                          _presenter!.CreateLessonDetail(lessonDetail).then((value){
                            listenStatus(context, value);
                          });
                        }else{
                          LessonDetail lessonDetail = LessonDetail(idLessonDetail: replaceSpace(_lesson!.lessonId!), fileContent: _fileContent,
                              nameLesson: _lesson!.lessonName!, videoLink: _videoLink, homework: _homeworkList);
                          showLoaderDialog(context);
                          _presenter!.updateLessonDetail(lessonDetail).then((value){
                            listenStatus(context, value);
                          });
                        }

                      }
                    },
                    child: NeoText(Languages.of(context).createNew, textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.white))),
                SizedBox(width: 8,)
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: NeoText('File nội dung: $_fileNameContent'),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_circle_up_sharp),
                          color: AppColors.blue,
                          onPressed: () async{
                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                            );
                            if(result!=null){
                              AlertDialog alert=AlertDialog(
                                content: new Row(
                                  children: [
                                    CircularProgressIndicator(),
                                    Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
                                  ],),
                              );
                              showDialog(barrierDismissible: false,
                                context:context,
                                builder:(BuildContext context){
                                  return alert;
                                },
                              );
                              PlatformFile file = result.files.first;
                              String fileName = result.files.first.name;
                              _fileNameContent = fileName;
                              final File fileForFirebase = File(file.path!);
                              _fileContent = await _presenter!.UploadFilePdf(fileForFirebase, _myClassDetail, _course, _myClass, fileName).then((value) {
                                Navigator.pop(context);
                                if(value.isEmpty){
                                  Fluttertoast.showToast(msg:Languages.of(context).onFailure);
                                }
                                return value;
                              });
                              setState(()=>null);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration: AppThemes.textFieldInputDecoration(labelText: Languages.of(context).linkExercise, hintText: Languages.of(context).linkExercise),
                      onChanged: (value)=>setState(()=> _videoLink=value),
                      controller: _controllerUrlLink,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: NeoText('${Languages.of(context).fileQuestion}: $_fileNameQuestion'),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_circle_up_sharp),
                          color: AppColors.blue,
                          onPressed: () async{
                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                            );
                            if(result!=null){
                              AlertDialog alert=AlertDialog(
                                content: new Row(
                                  children: [
                                    CircularProgressIndicator(),
                                    Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
                                  ],),
                              );
                              showDialog(barrierDismissible: false,
                                context:context,
                                builder:(BuildContext context){
                                  return alert;
                                },
                              );
                              PlatformFile file = result.files.first;
                              String fileName = result.files.first.name;
                              _fileNameQuestion = fileName;
                              final File fileForFirebase = File(file.path!);
                              _fileQuestion = await _presenter!.UploadFilePdf(fileForFirebase, _myClassDetail, _course, _myClass, fileName).then((value) {
                                Navigator.pop(context);
                                if(value.isEmpty){
                                  Fluttertoast.showToast(msg:Languages.of(context).onFailure);
                                }
                                return value;
                              });
                              _homeworkList[0].question=_fileQuestion;
                              setState(()=>null);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: NeoText('${Languages.of(context).fileAnswer}: $_fileNameAnswer'),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_circle_up_sharp),
                          color: AppColors.blue,
                          onPressed: () async{
                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                            );
                            if(result!=null){
                              AlertDialog alert=AlertDialog(
                                content: new Row(
                                  children: [
                                    CircularProgressIndicator(),
                                    Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
                                  ],),
                              );
                              showDialog(barrierDismissible: false,
                                context:context,
                                builder:(BuildContext context){
                                  return alert;
                                },
                              );
                              PlatformFile file = result.files.first;
                              String fileName = result.files.first.name;
                              _fileNameAnswer = fileName;
                              final File fileForFirebase = File(file.path!);
                              _fileAnswer = await _presenter!.UploadFilePdf(fileForFirebase, _myClassDetail, _course, _myClass, fileName).then((value) {
                                Navigator.pop(context);
                                if(value.isEmpty){
                                  Fluttertoast.showToast(msg:Languages.of(context).onFailure);
                                }
                                return value;
                              });
                              _homeworkList[0].answer=_fileAnswer;
                              setState(()=>null);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomDropDownBox(
                      value: _select,
                      itemsList: _stringList,
                      onChanged: (value){
                        _select = value;
                        if(_select!='Có trắc nghiệm'){
                          _homeworkList[0].listQuestion=null;
                          _homeworkList[0].worksheet=false;
                        }else{
                          _homeworkList[0] = Homework(idHomework: '1',listQuestion: [QA(id: '1',),]);
                          _homeworkList[0].question=_fileQuestion;
                          _homeworkList[0].answer = _fileAnswer;
                          _homeworkList[0].worksheet=true;
                        }
                        setState(()=>null);
                      },
                    ),
                  ),
                  _homeworkList[0].worksheet==true
                      ?Wrap(
                    children:  List.generate(_homeworkList[0].listQuestion!.length, (index) => _itemWorkSheet(_homeworkList[0].listQuestion![index], index)),
                  ):SizedBox()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _itemWorkSheet(QA qa, int index){
    String question='';
    String answer='';
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: AppThemes.textFieldInputDecoration(labelText: CommonKey.EDIT==_keyFlow?qa.question:Languages.of(context).question, hintText: CommonKey.EDIT==_keyFlow?qa.question:Languages.of(context).question),
              onChanged: (value)=>setState(()=> qa.question=value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: AppThemes.textFieldInputDecoration(labelText: CommonKey.EDIT==_keyFlow?qa.answer:Languages.of(context).answer, hintText: CommonKey.EDIT==_keyFlow?qa.answer:Languages.of(context).answer),
              onChanged: (value)=>setState(()=> qa.answer=value),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 8,),
              IconButton(icon: Icon(Icons.add), onPressed: () {   _homeworkList[0].listQuestion!.add(QA(id: '${index+2}'));
              setState((){

              });  },),
              IconButton(icon: Icon(Icons.delete),onPressed: (){
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Do you really want to delete ?'),

                      actions: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: Theme.of(context).textTheme.labelLarge,
                          ),
                          child: const Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: Theme.of(context).textTheme.labelLarge,
                          ),
                          child: const Text('Yep'),
                          onPressed: () {
                            _homeworkList[0].listQuestion!.remove(qa);
                            setState((){
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },),
              SizedBox(width: 8,)
            ],
          )
        ],
      ),
    );
  }

  Future<void> getDataUser() async{
    Map<String, dynamic> data;
    dynamic user = await SharedPreferencesData.GetData(CommonKey.USER);
    data = jsonDecode(user.toString());
    _fullname = data['fullname'];
    _avatar = data['avatar'];
  }

  Future<void> getDataEdit() async{
    _fileNameAnswer = _lessonDetail!.homework![0].answer!;
    _fileAnswer = _fileNameAnswer;
    _fileNameQuestion = _lessonDetail!.homework![0].question!;
    _fileQuestion = _fileNameQuestion;
    _fileContent = _lessonDetail!.fileContent!;
    _fileNameContent = _fileContent;
    _videoLink = _lessonDetail!.videoLink!;
    _homeworkList = _lessonDetail!.homework!;
    _homeworkList[0] = _lessonDetail!.homework![0];
    _homeworkList[0].question=_fileQuestion;
    _homeworkList[0].answer=_fileAnswer;
    _homeworkList[0].listQuestion=_lessonDetail!.homework![0].listQuestion;
    _controllerUrlLink = TextEditingController(text: _videoLink);
    setState(()=>null);
  }
}
