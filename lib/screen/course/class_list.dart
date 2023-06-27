import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:online_learning/screen/course/model/course_model.dart';
import 'package:online_learning/screen/course/model/my_class_model.dart';
import 'package:online_learning/screen/course/presenter/create_class_presenter.dart';
import 'package:online_learning/screen/animation_page.dart';
import '../../../external/switch_page_animation/enum.dart';
import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/keys.dart';
import '../../common/widgets.dart';
import '../../languages/languages.dart';
import '../../res/images.dart';
import 'class_detail.dart';
import 'create_class_ui.dart';

class ClassList extends StatefulWidget {
  final CourseModel? _course;
  String? _role;
  String? _keyFlow;
  bool? _owned;
  ClassList(this._course, this._role, this._keyFlow, this._owned);

  @override
  State<ClassList> createState() => _ClassListState(_course, _role, _keyFlow, _owned);
}

class _ClassListState extends State<ClassList> {
  final CourseModel? _course;
  String? _role;
  String _username='';
  String? _keyFlow;
  bool? _owned;
  _ClassListState(this._course, this._role, this._keyFlow, this._owned);
  Stream<QuerySnapshot>? _stream;
  CreateClassPresenter? _presenter;
  @override
  void initState() {
    _presenter = CreateClassPresenter();
    if(_course==null){
      _stream = FirebaseFirestore.instance.collection('class').snapshots();
    }else{
      _stream = FirebaseFirestore.instance.collection('class').where('idCourse', isEqualTo: _course!.getCourseId).snapshots();
    }
    getUserInfo();
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
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.tabBar),
                fit: BoxFit.fill,
              ),
            ),
            child:
            Stack(
              fit: StackFit.expand,
              children: [
                Center(child: NeoText('Danh sách lớp học', textStyle: TextStyle(color: AppColors.ultraRed, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                Positioned(child:  IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: AppColors.ultraRed,)),left: 0,)
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
                          return Center(child: LoadingAnimationWidget.staggeredDotsWave(
                          color: AppColors.ultraRed,
                            size: 50,
                          ),);
                        }else if(snapshot.hasError){
                          return Center(child: Text('No data'),);
                        }else{
                          return Wrap(
                            children:snapshot.data!.docs.map((e) {
                              Map<String, dynamic> data = e.data()! as Map<String, dynamic>;
                              List<dynamic> register = data['subscribe'];
                              return (CommonKey.TEACHER==_role||CommonKey.ADMIN==_role)?cardWithAdminRole(context, data['nameClass'], data['teacherName'],
                                  data['imageLink'], '${
                                      CommonKey.MON==data['onStageMon']
                                          ? Languages.of(context).monday
                                          :CommonKey.TUE==data['onStageTue']
                                          ? Languages.of(context).tuesday
                                          :CommonKey.WED==data['onStageWed']
                                          ? Languages.of(context).wednesday
                                          :CommonKey.THU==data['onStageThu']
                                          ? Languages.of(context).thursday
                                          :CommonKey.FRI==data['onStageFri']
                                          ? Languages.of(context).friday
                                          :CommonKey.SAT==data['onStageSat']
                                          ? Languages.of(context).saturday
                                          :Languages.of(context).sunday
                                  } - ${data['startHours']}',
                                  '${
                                      CommonKey.SUN==data['onStageSun']
                                          ? Languages.of(context).sunday
                                          :CommonKey.SAT==data['onStageSat']
                                          ? Languages.of(context).saturday
                                          :CommonKey.FRI==data['onStageFri']
                                          ? Languages.of(context).friday
                                          :CommonKey.THU==data['onStageThu']
                                          ? Languages.of(context).thursday
                                          :CommonKey.WED==data['onStageWed']
                                          ? Languages.of(context).wednesday
                                          :CommonKey.TUE==data['onStageTue']
                                          ? Languages.of(context).tuesday
                                          :Languages.of(context).monday
                                  } - ${data['startHours']}',
                                      data['price'],
                                      (onClickEdit) =>  Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade, widget: CreateClassUI(_course, CommonKey.EDIT, data, data['idCourse'],data['idTeacher'],data['teacherName']))),
                                      (onClickDelete){
                                        AnimationDialog.generalDialog(context, AlertDialog(
                                          title: const Text('Bạn muốn xóa lớp này'),

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
                                                _presenter!.deleteClass(data['idClass']);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ));
                                      },
                                      (click){
                                        _username==data['idTeacher']||_role==CommonKey.ADMIN?Navigator.push(context, AnimationPage().pageTransition(
                                            type: PageTransitionType.fade,
                                            widget: ClassDetailPage(MyClassModel(idClass: data['idClass'],
                                                teacherName: data['teacherName'],
                                                className: data['nameClass'],imageLink: data['imageLink']), _course, _role, ))):Fluttertoast.showToast(msg: Languages.of(context).accessDenied);
                                      },
                                  _username==data['idTeacher']||_role==CommonKey.ADMIN?true:false)
                                  :card(context, data['nameClass'], data['teacherName'], data['imageLink'], (id) => {
                                register.contains(_username)
                                    ? Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade, widget: ClassDetailPage(MyClassModel(idClass: data['idClass'], teacherName: data['teacherName'], className: data['nameClass'], imageLink: data['imageLink']), _course, _role, )))
                                    :Fluttertoast.showToast(msg: 'Bạn phải đăng ký lớp học')
                              },'${CommonKey.MON==data['onStageMon']
                                      ? Languages.of(context).monday
                                      :CommonKey.TUE==data['onStageTue']
                                      ? Languages.of(context).tuesday
                                      :CommonKey.WED==data['onStageWed']
                                      ? Languages.of(context).wednesday
                                      :CommonKey.THU==data['onStageThu']
                                      ? Languages.of(context).thursday
                                      :CommonKey.FRI==data['onStageFri']
                                      ? Languages.of(context).friday
                                      :CommonKey.SAT==data['onStageSat']
                                      ? Languages.of(context).saturday
                                      :Languages.of(context).sunday
                              } - ${data['startHours']}',
                                  '${
                                      CommonKey.SUN==data['onStageSun']
                                          ? Languages.of(context).sunday
                                          :CommonKey.SAT==data['onStageSat']
                                          ? Languages.of(context).saturday
                                          :CommonKey.FRI==data['onStageFri']
                                          ? Languages.of(context).friday
                                          :CommonKey.THU==data['onStageThu']
                                          ? Languages.of(context).thursday
                                          :CommonKey.WED==data['onStageWed']
                                          ? Languages.of(context).wednesday
                                          :CommonKey.TUE==data['onStageTue']
                                          ? Languages.of(context).tuesday
                                          :Languages.of(context).monday
                                  } - ${data['startHours']}',data['price'],
                                      () {
                                if(!register.contains(_username)){
                                  register.add(_username);
                                  _presenter!.classRegistration(data['idClass'], register, data['idCourse']);
                                }
                              },register.contains(_username)?false:true);
                            }).toList(),
                          );
                        }
                      },
                    )
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: Visibility(
        visible: CommonKey.ADMIN==_role&&_course!=null||CommonKey.TEACHER==_role&&_course!=null&&_owned==true,
        child: FloatingActionButton(
          onPressed: ()=> Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade, widget: CreateClassUI(_course,'',null,'','',''))),
          child: Icon(Icons.add, color: AppColors.white,),
        ),
      ),
    );
  }

  Future<void> getUserInfo() async{
    _username = await _presenter!.getUserInfo();
    setState(()=>null);
    if(CommonKey.MEMBER==_role&&'DASHBOARD'==_keyFlow){
      _stream=FirebaseFirestore.instance.collection('class').where('subscribe', arrayContains: _username).snapshots();
      print(_username);
    }

  }
}
