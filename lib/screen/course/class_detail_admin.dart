import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:online_learning/common/widgets.dart';
import 'package:online_learning/res/images.dart';
import 'package:online_learning/screen/course/model/my_class_model.dart';
import 'package:online_learning/screen/course/presenter/class_detail_presenter.dart';
import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/keys.dart';
import '../../common/state.dart';
import '../../external/switch_page_animation/enum.dart';
import '../../languages/languages.dart';
import '../animation_page.dart';
import '../lesson/lesson_page.dart';
import '../lesson/model/lesson.dart';
import 'create_class_content.dart';
import 'model/class_detail.dart';
import 'model/course_model.dart';

class ClassDetailAdminPage extends StatefulWidget {
  MyClassModel? _myClass;
  CourseModel? _course;
  String? _role;
  ClassDetailAdminPage(this._myClass, this._course, this._role);

  @override
  State<ClassDetailAdminPage> createState() => _ClassDetailAdminPageState(_myClass, _course, _role);
}

class _ClassDetailAdminPageState extends State<ClassDetailAdminPage> {
  MyClassModel? _myClass;
  CourseModel? _course;
  String? _role;
  String _content = '';
  _ClassDetailAdminPageState(this._myClass, this._course, this._role);
  Stream<QuerySnapshot>? _stream;
  ClassDetail? _myClassResult;
  ClassDetailAdminPresenter? _presenter;
  Map<String, dynamic>? _dataUser;
  @override
  void initState() {
    _presenter = ClassDetailAdminPresenter();
    _stream =  FirebaseFirestore.instance.collection('class_detail').where('idClass', isEqualTo: '${_myClass!.idClass!}').snapshots();
    getAccountInfo();
  }

  Future<void> getAccountInfo()async{
    _dataUser = await _presenter!.getUserInfo();
    setState(()=>null);
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
                IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back, color: AppColors.ultraRed,)),
                SizedBox(width: 8,),
                Expanded(child: NeoText(Languages.of(context).classDetails, textStyle: TextStyle(color: AppColors.ultraRed, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                CommonKey.MEMBER==_role?SizedBox():ElevatedButton(
                    onPressed: (){
                      AnimationDialog.generalDialog(context, AlertDialog(
                        title: const Text('Bạn thật sự muốn xóa ?'),

                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: const Text('Thôi'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: const Text('Xóa'),
                            onPressed: () {
                              if(_myClassResult!.idClassDetail!=null){
                                showLoaderDialog(context);
                                _presenter!.deleteLesson(_myClassResult!.idClassDetail!).then((value) {
                                  listenStatus(context, value);
                                });
                              }
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ));
                    },
                    child: NeoText(Languages.of(context).delete, textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.white))),
                SizedBox(width: 8,)
              ],
            ),
          ),

          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _stream,
                    builder: (context, snapshot){
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.ultraRed, size: 50),);
                      }else if(snapshot.hasError){
                        return notfound(Languages.of(context).noData);
                      }else if(!snapshot.hasData){
                        return notfound(Languages.of(context).noData);
                      }else{
                        snapshot.data!.docs.forEach((element) {
                          _myClassResult = ClassDetail.fromJson(element.data());
                        });
                        if(_myClassResult!=null){
                          _presenter!.loadData(true);
                        }

                        return _myClassResult!=null?Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _header(),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, bottom: 8),
                              child: NeoText(Languages.of(context).lessonList, textStyle: TextStyle(fontSize: 18, color: AppColors.black)),
                            ),
                            Wrap(
                              children: List.generate(_myClassResult!.lesson!.length, (index) => _lessonItems(_myClassResult!.lesson![index], _myClassResult!.idClassDetail!=null?_myClassResult!.idClassDetail!
                                  :"")),
                            )
                          ],
                        ):SizedBox();
                      }
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: Visibility(
        visible: CommonKey.TEACHER==_role||CommonKey.ADMIN==_role,
        child: FloatingActionButton(
            onPressed: ()=> Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade, widget: CreateClassContentUI(_myClass, _course, _presenter!.state==SingleState.HAS_DATA?CommonKey.EDIT:'',_presenter!.state==SingleState.HAS_DATA?_myClassResult:null))),
            child: Observer(
              builder: (_){
                if(_presenter!.state==SingleState.LOADING){
                  return Icon(Icons.add, color: AppColors.white,);
                }else if(_presenter!.state==SingleState.NO_DATA){
                  return Icon(Icons.add, color: AppColors.white,);
                }else{
                  return Icon(Icons.edit, color: AppColors.white,);
                }
              },
            )
        ),
      ),
    );
  }

  Widget _lessonItems(Lesson lesson, String classDetailId){
    return InkWell(
      onTap: ()=> Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade, widget: LessonPage(lesson, CommonKey.ADMIN, _myClassResult, _myClass, _course, _role, classDetailId))),
      child: Container(
        width: getWidthDevice(context),
        color: AppColors.white,
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 8,),
            Icon(Icons.circle_outlined, color: AppColors.ultraRed,),
            SizedBox(width: 4,),
            Expanded(child: NeoText('${lesson.lessonName}', textStyle: TextStyle(fontSize: 14, color: AppColors.ultraRed))),
            Icon(Icons.not_started, color: AppColors.ultraRed,),
            SizedBox(width: 8,),
          ],
        ),
      ),
    );
  }

  Widget _header(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        loadPhoto.networkImage(_myClassResult!.imageLink, getHeightDevice(context)/3, getWidthDevice(context)),
        SizedBox(height: 8,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: NeoText(_myClassResult!.nameClass!, textStyle: TextStyle(color: AppColors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(onPressed: ()=>null, icon: Icon(Icons.info, color: AppColors.ultraRed,)),
            Expanded(child: NeoText(Languages.of(context).info, textStyle: TextStyle(fontSize: 14, color: AppColors.ultraRed))),

          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 16, right: 16),
          child: NeoText(_myClassResult!.describe!=null?_myClassResult!.describe!:Languages.of(context).noData, textStyle: TextStyle(color: AppColors.ultraRed, fontSize: 16)),
        ),
        Divider(),
        SizedBox(height: 8,),
      ],
    );
  }
}
