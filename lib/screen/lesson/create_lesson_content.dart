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
import '../../common/functions.dart';
import '../../common/keys.dart';
import '../../common/themes.dart';
import '../../common/widgets.dart';
import '../../languages/languages.dart';
import '../../res/images.dart';
import '../../storage/storage.dart';
import 'model/discuss.dart';
import 'model/lesson.dart';
import 'model/lesson_detail.dart';

class CreateLessonPage extends StatefulWidget {
  Lesson? _lesson;
  ClassDetail? _myClassDetail;
  CourseModel? _course;
  MyClassModel? _myClass;
  String? _keyFlow;
  LessonDetail? _lessonDetail;

  CreateLessonPage(this._lesson, this._keyFlow, this._course, this._myClass, this._myClassDetail, this._lessonDetail);

  @override
  State<CreateLessonPage> createState() => _CreateLessonPageState(_lesson, _keyFlow, _course, _myClass, _myClassDetail, _lessonDetail);
}

class _CreateLessonPageState extends State<CreateLessonPage> {
  Lesson? _lesson;
  String? _keyFlow;
  ClassDetail? _myClassDetail;
  CourseModel? _course;
  MyClassModel? _myClass;
  LessonDetail? _lessonDetail;
  _CreateLessonPageState(this._lesson, this._keyFlow, this._course, this._myClass, this._myClassDetail, this._lessonDetail);

  CreateLessonContentPresenter? _presenter;
  String _fileNameContent = '';
  String _fileContent = '';
  String _videoLink = '';
  String _fullname = '';
  String _avatar = '';
  TextEditingController _controllerUrlLink = TextEditingController();

  @override
  void initState() {
    _presenter = CreateLessonContentPresenter();
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
      body:Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            width: getWidthDevice(context),
            height: 52,
            decoration:  const BoxDecoration(
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
                const SizedBox(width: 8,),
                IconButton(onPressed: ()=>Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: AppColors.blue,)),
                const SizedBox(width: 8,),
                Expanded(child: NeoText(_lesson!.lessonName!=null?_lesson!.lessonName!:'', textStyle: const TextStyle(color: AppColors.lightBlue, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                ElevatedButton(
                    onPressed: (){
                      if(_videoLink.isEmpty){
                        CustomDialog(context: context, content: 'chưa có link');
                      }else if(_fileContent.isEmpty){
                        CustomDialog(context: context, content: 'chưa có file nội dung');
                      }
                      else{
                        if(CommonKey.EDIT!=_keyFlow){
                          Discuss? discuss = Discuss(name: _fullname, avatar: _avatar, timeStamp: getTimestamp(), content: Languages.of(context).youNeed, nameFeedback: '');
                          LessonDetail lessonDetail = LessonDetail(
                              lessonDetailId: replaceSpace(_lesson!.lessonId!),
                              fileContent: _fileContent,
                              lessonName: _lesson!.lessonName!,
                              videoLink: _videoLink,

                              discuss: [discuss]);
                          showLoaderDialog(context);
                          _presenter!.createLessonDetail(lessonDetail).then((value){
                            listenStatus(context, value);
                          });
                        }else{
                          LessonDetail lessonDetail = LessonDetail(lessonDetailId: replaceSpace(_lesson!.lessonId!), fileContent: _fileContent,
                              lessonName: _lesson!.lessonName!, videoLink: _videoLink,);
                          showLoaderDialog(context);
                          _presenter!.updateLessonDetail(lessonDetail).then((value){
                            listenStatus(context, value);
                          });
                        }
                      }
                    },
                    child: NeoText(Languages.of(context).createNew, textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.white))),
                const SizedBox(width: 8,)
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
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: NeoText('File bài giảng: $_fileNameContent', maxline: 2, overFlow: TextOverflow.ellipsis),
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
                                content: Row(
                                  children: [
                                    const CircularProgressIndicator(),
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
                              _fileContent = await _presenter!.uploadPdfFile(fileForFirebase, _myClassDetail, _course, _myClass, fileName).then((value) {
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

                ],
              ),
            ),
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
    _fileContent = _lessonDetail!.fileContent!;
    _fileNameContent = _fileContent;
    _videoLink = _lessonDetail!.videoLink!;
    _controllerUrlLink = TextEditingController(text: _videoLink);
    setState(()=>null);
  }
}
