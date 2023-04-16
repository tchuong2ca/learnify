import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_learning/common/widgets.dart';
import 'package:online_learning/ui/teacher/presenter/teacher_presenter.dart';

import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/keys.dart';

class TeacherPage extends StatefulWidget {
  String? _role;

  TeacherPage(this._role);

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {

  Stream<QuerySnapshot>? _streamTeacher;
  TeacherPresenter? _presenter;

  @override
  void initState() {
    _streamTeacher = FirebaseFirestore.instance.collection('users').where('role', isEqualTo: CommonKey.TEACHER).where('isLooked', isEqualTo: false).snapshots();
    _presenter = TeacherPresenter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CommonKey.ADMIN==widget._role
          //     ?CustomAppBar(appType: AppType.childFunction, title: Languages.of(context).teacher, nameFunction: Languages.of(context).teacherAdd, callback: (value){
          //   Navigator.push(context, MaterialPageRoute(builder: (_)=>TeacherAddPage(null, widget._role)));
          // },)
          //     :CustomAppBar(appType: AppType.child, title: Languages.of(context).teacher),
          Expanded(
            child: SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                stream: _streamTeacher!,
                builder: (context, snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return Center(child: Text('Loading...'),);
                  }else if(snapshot.hasError){
                    return Center(child: Text('No data...'),);
                  }else if(!snapshot.hasData){
                    return Center(child: Text('No data...'),);
                  }else{
                    return Wrap(
                      alignment: WrapAlignment.center,
                      children: snapshot.data!.docs.map((e) {
                        Map<String, dynamic> data = e.data() as Map<String, dynamic>;
                        return InkWell(
                          onTap: (){
                            // if(CommonKey.ADMIN!=widget._role){
                            //   Navigator.push(context, MaterialPageRoute(builder: (_)=>TeacherAddPage(data, widget._role)));
                            // }
                          },
                          child: Card(
                            margin: EdgeInsets.all(8),
                            child: Container(
                              width: getWidthDevice(context)/2-16,
                              height:  CommonKey.ADMIN==widget._role?getHeightDevice(context)*0.35+8:getHeightDevice(context)*0.3+8,
                              padding: EdgeInsets.all(8),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ImageLoad.imageNetwork(data['avatar'], getWidthDevice(context)/4, getWidthDevice(context)/2-32),
                                  SizedBox(height: 8,),
                                  NeoText('GV: ${data['fullname']}', textStyle: TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis), maxline: 2, textAlign: TextAlign.center),
                                  SizedBox(height: 8,),
                                  NeoText('Đ/c: ${data['address']}', textStyle: TextStyle(fontSize: 12, overflow: TextOverflow.fade), maxline: 2),
                                  SizedBox(height: 8,),
                                  NeoText('Chức vụ: ${data['office']}', textStyle: TextStyle(fontSize: 12, overflow: TextOverflow.fade), maxline: 2),
                                  SizedBox(height: 8,),
                                  NeoText(data['describe'], textStyle: TextStyle(fontSize: 12, overflow: TextOverflow.fade), maxline: 3),
                                  Spacer(),
                                  CommonKey.ADMIN==widget._role?Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        onPressed: (){
                                    //Navigator.push(context, MaterialPageRoute(builder: (_)=>TeacherAddPage(data, widget._role))),
                                  },

                                        icon: Icon(
                                          Icons.edit,
                                          color: CommonColor.blue,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: (){
                                          _presenter!.lookAccount(data['phone']);
                                        },
                                        icon: Icon(
                                          Icons.lock_open_sharp,
                                          color: CommonColor.blue,
                                        ),
                                      ),
                                    ],
                                  ):SizedBox()
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}