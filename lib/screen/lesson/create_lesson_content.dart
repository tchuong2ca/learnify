import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_learning/screen/course/model/class_detail.dart';
import 'package:online_learning/screen/course/model/course_model.dart';
import 'package:online_learning/screen/course/model/my_class_model.dart';
import 'package:online_learning/screen/lesson/lesson_page.dart';
import 'package:online_learning/screen/lesson/presenter/create_new_lesson_presenter.dart';
import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/keys.dart';
import '../../common/themes.dart';
import '../../common/widgets.dart';
import '../../languages/languages.dart';
import '../../res/images.dart';
import '../../storage/lessonList.dart';
import '../../storage/storage.dart';
import 'model/discuss.dart';
import 'model/lesson.dart';
import 'model/lesson_detail.dart';

class CreateLessonPage extends StatefulWidget {
  Lesson? _lesson;
  CourseModel? _course;
  MyClassModel? _myClass;
  String? _keyFlow;
  LessonContent? _lessonDetail;
  String? _classDetailId;
  int? _index;
  CreateLessonPage(this._lesson, this._keyFlow, this._course, this._myClass,  this._lessonDetail, this._classDetailId, this._index);

  @override
  State<CreateLessonPage> createState() => _CreateLessonPageState(_lesson, _keyFlow, _course, _myClass, _lessonDetail,_classDetailId, _index);
}

class _CreateLessonPageState extends State<CreateLessonPage> {
  Lesson? _lesson;
  String? _keyFlow;
  CourseModel? _course;
  MyClassModel? _myClass;
  LessonContent? _lessonDetail;
  String? _classDetailId;
  int? _index;
  _CreateLessonPageState(this._lesson, this._keyFlow, this._course, this._myClass, this._lessonDetail, this._classDetailId, this._index);

  CreateLessonContentPresenter? _presenter;
  String _fileNameContent = '';
  String _fileContent = '';
  String _videoLink = '';
  String _fullname = '';
  String _avatar = '';
  bool _isLive =false;
  int _tabTextIndexSelected=0;
  List<String> _listTextTabToggle = ["Buổi học thường", "Buổi học live"];
  TextEditingController _controllerUrlLink = TextEditingController();
  List<Lesson> _lessonList =[];
  @override
  void initState() {
    _presenter = CreateLessonContentPresenter();
    getDataUser();
    if(CommonKey.EDIT==_keyFlow){
      getDataEdit();
    }
    _lessonList = lessonList;
    _lessonList!=null?_lessonList[_index!].isLive='false':null;
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
                IconButton(onPressed: ()=>Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: AppColors.ultraRed,)),
                const SizedBox(width: 8,),
                Expanded(child: NeoText(_lesson!.lessonName!=null?_lesson!.lessonName!:'', textStyle: const TextStyle(color: AppColors.ultraRed, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                ElevatedButton(
                    onPressed: (){
                      if(_videoLink.isEmpty){
                        customDialog(context: context, content: 'chưa có link');
                      }else if(_fileContent.isEmpty){
                        customDialog(context: context, content: 'chưa có file bài giảng');
                      }
                      else{ 
                        if(CommonKey.EDIT!=_keyFlow){
                          Discuss? discuss = Discuss(name: _fullname, avatar: _avatar, timeStamp: getTimestamp(), content: Languages.of(context).askAQuestion, feedbackName: '');
                          LessonContent lessonContent = LessonContent(
                              lessonDetailId: replaceSpace(_lesson!.lessonId!),
                              fileContent: _fileContent,
                              lessonName: _lesson!.lessonName!,
                              videoLink: _videoLink,
                              isLive: _isLive,
                              discuss: [discuss]);
                          showLoaderDialog(context);
                          _presenter!.createLessonContent(lessonContent).then((value){
                            _presenter!.updateLessonStatus(_classDetailId!,  _lessonList!=null? _lessonList!:null);
                            if(value){
                              Navigator.pop(context);
                              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LessonPage()))
                              Fluttertoast.showToast(msg: 'Okela');
                            }else{
                              Fluttertoast.showToast(msg: 'Lỗi');
                            }
                          });

                        }else{
                          LessonContent lessonContent = LessonContent(lessonDetailId: replaceSpace(_lesson!.lessonId!), fileContent: _fileContent,
                              lessonName: _lesson!.lessonName!, videoLink: _videoLink,isLive: _isLive);
                          showLoaderDialog(context);
                          _presenter!.updateLessonDetail(lessonContent).then((value){
                           _presenter!.updateLessonStatus(_classDetailId!, _lessonList!=null?_lessonList!:null);
                            listenStatus(context, value);
                          });
                        }
                      }
                    },
                    child: NeoText(CommonKey.EDIT!=_keyFlow?Languages.of(context).createNew:Languages.of(context).confirm, textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.white))),
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
                          color: AppColors.ultraRed,
                          onPressed: () async{
                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                            );
                            if(result!=null){
                              AnimationDialog.generalDialog(context, AlertDialog(
                                content: Row(
                                  children: [
                                    const CircularProgressIndicator(),
                                    Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
                                  ],),
                              ));
                              PlatformFile file = result.files.first;
                              String fileName = result.files.first.name;
                              _fileNameContent = fileName;
                              final File fileForFirebase = File(file.path!);
                              _fileContent = await _presenter!.uploadPdfFile(fileForFirebase, _course, _myClass, fileName).then((value) {
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
                      child: Center(
                        child: FlutterToggleTab(

                          width: 85,
                          height: 50,
                          selectedIndex: _tabTextIndexSelected,
                          selectedBackgroundColors: _tabTextIndexSelected==0?[AppColors.lightBlue]:[AppColors.ultraRed],
                          selectedTextStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                          unSelectedTextStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                          labels: _listTextTabToggle,
                          icons:[Icons.tv, Icons.live_tv],
                          selectedLabelIndex: (index) {
                            setState(() {
                              _tabTextIndexSelected = index;
                              index==0?_isLive=false:_isLive=true;
                              if(index==0){
                                _lessonList!=null?_lessonList![_index!].isLive='false':null;
                              }
                              else{
                                _lessonList!=null?_lessonList![_index!].isLive='true':null;
                              }
                            });
                          },
                          isScroll: false,
                        ),
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration: AppThemes.textFieldInputDecoration(labelText: _tabTextIndexSelected==0?'Link youtube tĩnh':'Link youtube live', hintText: _tabTextIndexSelected==0?'Link youtube tĩnh':'Link youtube live'),
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
    dynamic user = await SharedPreferencesData.getData(CommonKey.USER);
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
