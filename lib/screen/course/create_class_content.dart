
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_learning/common/widgets.dart';
import 'package:online_learning/screen/course/class_detail.dart';
import 'package:online_learning/screen/course/model/class_detail.dart';
import 'package:online_learning/screen/course/model/course_model.dart';
import 'package:online_learning/screen/course/model/my_class_model.dart';
import 'package:online_learning/screen/course/presenter/create_class_content_presenter.dart';
import 'package:online_learning/screen/lesson/model/lesson.dart';

import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/keys.dart';
import '../../common/themes.dart';
import '../../languages/languages.dart';
import '../../res/images.dart';
import '../../storage/lessonList.dart';
import '../../storage/storage.dart';

class CreateClassContentUI extends StatefulWidget {
  MyClassModel? _myClass;
  CourseModel? _course;
  String? _keyFlow;
  ClassDetail? _myClassResult;
  CreateClassContentUI(this._myClass, this._course, this._keyFlow, this._myClassResult);

  @override
  State<CreateClassContentUI> createState() => _CreateClassContentUIState(_myClass, _course, _keyFlow, _myClassResult);
}

class _CreateClassContentUIState extends State<CreateClassContentUI> {
  MyClassModel? _myClass;
  CourseModel? _course;
  String? _keyFlow;
  ClassDetail? _myClassResult;
  _CreateClassContentUIState(this._myClass, this._course, this._keyFlow, this._myClassResult);

  String _detailClassId = ''; String _idClass = ''; String _teacherName = '';
  String _imageLink = ''; String _className = ''; String _describe = '';
  List<Lesson> _lessonList = [];
  File? _fileImage;
  CreateClassContentPresenter? _presenter;
  TextEditingController _lessonIdController = TextEditingController();
  TextEditingController _describeController = TextEditingController();
  int _indexLength = 0;

  @override
  void initState() {
    _className = _myClass!.nameClass!;
    _detailClassId = CommonKey.CLASS_DETAIL+getCurrentTime();
    _lessonList.add(Lesson());
    _presenter = CreateClassContentPresenter();
    if(CommonKey.EDIT==_keyFlow){
      _lessonIdController = TextEditingController(text: _myClassResult!.classDetailId);
      _describeController = TextEditingController(text: _myClassResult!.describe);
      _lessonList = _myClassResult!.lessons!;
      _imageLink = _myClass!.imageLink!;
      _detailClassId=_myClassResult!.classDetailId!;
      _className=_myClassResult!.className!;
      _indexLength = _myClassResult!.lessons!.length;
      _describe = _myClassResult!.describe!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: ()=>hideKeyboard(),
        child: Column(
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
                  IconButton(onPressed: (){
                    print(_lessonList);
                    lessonList = _lessonList;
                    Navigator.pop(context);
                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ClassDetailAdminPage(_myClass, _course,'ADMIN', _lessonList)));

                  }, icon: Icon(Icons.arrow_back, color: AppColors.ultraRed,)),
                  SizedBox(width: 8,),
                  Expanded(child: NeoText(Languages.of(context).createClassContent, textStyle: TextStyle(color: AppColors.ultraRed, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                  ElevatedButton(
                      onPressed: (){
                       if( _lessonList.isNotEmpty){
                         // if(_fileImage==null&&CommonKey.EDIT!=_keyFlow){
                         //   Fluttertoast.showToast(msg:Languages.of(context).imageNull);
                         // }else{
                         //
                         // }
                         showLoaderDialog(context);
                         ClassDetail classDetail = ClassDetail(classDetailId: replaceSpace(_detailClassId), classId: _myClass!.idClass,
                             teacherName: _myClass!.teacherName, className: _className,
                             describe: _describe, lessons: _lessonList);
                         CommonKey.EDIT!=_keyFlow?_presenter!.createClassDetail(classDetail, _course!, _myClass!, _myClass!.imageLink!).then((value){
                           listenStatus(context, value);
                         })
                             :
                         // _fileImage!=null?
                         _presenter!.updateClassDetail(myClass: _myClass, myClassDetail: classDetail, course: _course, classDetailPhotoUrl: _myClass!.imageLink).then((value) {
                           listenStatus(context, value);
                         });
                         //     :_presenter!.updateClassDetail(myClass: _myClass, myClassDetail: classDetail, course: _course, linkImage: _imageLink).then((value) {
                         //   listenStatus(context, value);
                         // });
                         lessonList = _lessonList;
                       }
                       else{
                         Fluttertoast.showToast(msg: 'Chưa thêm buổi học nào');
                       }
                      },
                      child: NeoText(_keyFlow==CommonKey.EDIT?'Cập nhật':Languages.of(context).createNew, textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.white))),
                  SizedBox(width: 8,)
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // InkWell(
                    //   onTap: () => cropImage(context, (p0) => setState(()=>_fileImage=p0!), ''),
                    //   child: Center(child: _fileImage!=null?Image(image: FileImage(_fileImage!),width: 150/3*4, height: 150,):(!_imageLink.isEmpty?loadPhoto.networkImage(_imageLink, 150, 150/3*4):Image.asset(Images.pick_photo, width: 150/3*4, height: 150,))),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        decoration: AppThemes.textFieldInputDecoration(labelText: Languages.of(context).describeClass, hintText: Languages.of(context).describeClass),
                        onChanged: (value)=>setState(()=> _describe=value),
                        maxLines: 4,
                        controller: _describeController,
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _lessonList.length,
                      itemBuilder: (context, index) => _itemLesson(_lessonList[index], index),
                    ),
                    SizedBox(height: 8,),
                    Center(
                      child: IconButton(icon: Icon(Icons.add),onPressed: (){
                      setState(() {
                        _lessonList.add(Lesson(isLive: 'false'));
                      });
                      },)
                    ),
                    SizedBox(height: 16,)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _itemLesson(Lesson lesson, int index){

    if(CommonKey.EDIT!=_keyFlow){
      lesson.classDetailId = _detailClassId;
      lesson.lessonId = CommonKey.LESSON+getCurrentTime();
    }
    if(lesson.lessonId==null){
      lesson.classDetailId = _detailClassId;
      lesson.lessonId = CommonKey.LESSON+getCurrentTime();
    }
    lesson.classDetailId = _detailClassId;
    TextEditingController idController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    if(CommonKey.EDIT==_keyFlow){
      if(lesson.classDetailId!=null){
        idController = TextEditingController(text: lesson.lessonId);
        nameController = TextEditingController(text: lesson.lessonName);
      }
    }
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 3),
            )
          ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          (CommonKey.EDIT==_keyFlow&&_indexLength>index)?Padding(
            padding: EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 16),
            child: NeoText(lesson.lessonName!=null?lesson.lessonName!:'', textStyle: TextStyle(fontSize: 14, color: AppColors.black)),
          ):SizedBox(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: AppThemes.textFieldInputDecoration(labelText: Languages.of(context).lessonName, hintText: Languages.of(context).lessonName),
              onChanged: (value)=>setState(() {
                lesson.lessonName = value;
              }),
            ),
          ),

          Center(child: TextButton(child: Text(Languages.of(context).delete), onPressed: (){
            setState(()=>_lessonList.remove(lesson));
          }, ))
        ],
      ),
    );
  }
}