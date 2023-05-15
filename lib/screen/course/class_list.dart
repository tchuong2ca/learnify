import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_learning/screen/course/model/course_model.dart';
import 'package:online_learning/screen/course/model/my_class_model.dart';
import 'package:online_learning/screen/course/presenter/create_class_presenter.dart';

import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/keys.dart';
import '../../common/widgets.dart';
import '../../languages/languages.dart';
import '../../res/images.dart';
import 'class_detail_admin.dart';
import 'create_class_ui.dart';

class ClassList extends StatefulWidget {
  final CourseModel? _class;
  String? _role;
  String? _keyFlow;
  ClassList(this._class, this._role, this._keyFlow);

  @override
  State<ClassList> createState() => _ClassListState(_class, _role, _keyFlow);
}

class _ClassListState extends State<ClassList> {
  final CourseModel? _course;
  String? _role;
  String _username='';
  String? _keyFlow;
  _ClassListState(this._course, this._role, this._keyFlow);
  Stream<QuerySnapshot>? _stream;
  CreateClassPresenter? _presenter;
  @override
  void initState() {
    _presenter = CreateClassPresenter();
    if(_course==null){
      _stream = FirebaseFirestore.instance.collection('class').snapshots();
    }else{
      _stream = FirebaseFirestore.instance.collection('class').where('idCourse', isEqualTo: _course!.getIdCourse).snapshots();
    }
    getUserInfor();
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
                Center(child: NeoText('Lớp học của toi', textStyle: TextStyle(color: CommonColor.blueLight, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                Positioned(child:  IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: CommonColor.blue,)),left: 0,)
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
                          return Center(child: Text('Loading'),);
                        }else if(snapshot.hasError){
                          return Center(child: Text('No data'),);
                        }else{
                          return Wrap(
                            children:snapshot.data!.docs.map((e) {
                              Map<String, dynamic> data = e.data()! as Map<String, dynamic>;
                              List<dynamic> register = data['subscribe'];
                              return (CommonKey.TEACHER==_role||CommonKey.ADMIN==_role)?itemCourseAdminHours(context, data['nameClass'], data['teacherName'],
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
                                      (onClickEdit) => Navigator.push(context, MaterialPageRoute(builder: (_)=>CreateClassUI(_course, CommonKey.EDIT, data))),
                                      (onClickDelete){
                                        showDialog<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Do you really want to delete this class ?'),

                                              actions: <Widget>[
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    textStyle: Theme.of(context).textTheme.labelLarge,
                                                  ),
                                                  child: const Text('Nu'),
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
                                                    _presenter!.deleteClass(data['idClass']);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      (click) => Navigator.push(context, MaterialPageRoute(builder: (_)=>ClassDetailAdminPage(MyClassModel(idClass: data['idClass'], teacherName: data['teacherName'], nameClass: data['nameClass']), _course, _role))))
                                  :itemCourseHours(context, data['nameClass'], data['teacherName'], data['imageLink'], (id) => {
                                register.contains(_username)
                                    ?Navigator.push(context, MaterialPageRoute(builder: (_)=>ClassDetailAdminPage(MyClassModel(idClass: data['idClass'], teacherName: data['teacherName'], nameClass: data['nameClass']), _course, _role)))
                                    :Fluttertoast.showToast(msg: 'require class')
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
                                  } - ${data['startHours']}',
                                      () {
                                if(!register.contains(_username)){
                                  register.add(_username);
                                  _presenter!.RegisterClass(data['idClass'], register, data['idCourse']);
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
        visible: CommonKey.ADMIN==_role||CommonKey.TEACHER==_role,
        child: FloatingActionButton(
          onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>CreateClassUI(_course,'',null))),
          child: Icon(Icons.add, color: CommonColor.white,),
        ),
      ),
    );
  }

  Future<void> getUserInfor() async{
    _username = await _presenter!.getUserInfo();
    setState(()=>null);
    if(CommonKey.MEMBER==_role&&'DASHBOARD'==_keyFlow){
      _stream=FirebaseFirestore.instance.collection('class').where('subscribe', arrayContains: _username).snapshots();
      print(_username);
    }

  }
}
