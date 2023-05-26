import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_learning/common/widgets.dart';
import 'package:online_learning/screen/teacher/presenter/teacher_presenter.dart';
import 'package:online_learning/screen/teacher/teacher_detail.dart';

import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/keys.dart';
import '../../languages/languages.dart';
import '../../res/images.dart';
import 'add_new_teacher_ui.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
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
    _streamTeacher = FirebaseFirestore.instance.collection('users').where('role', isEqualTo: CommonKey.TEACHER).where('isLocked', isEqualTo: false).snapshots();
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
      CommonKey.ADMIN==widget._role ? Container(
            width: getWidthDevice(context),
            height: 52,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.background_tutorial),
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
                Expanded(child: NeoText( Languages.of(context).teacher, textStyle: TextStyle(color: AppColors.lightBlue, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>AddNewTeacherUI(null, widget._role)));
                    },
                    child: NeoText('Thêm giáo viên', textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.white))),
                SizedBox(width: 8,)
              ],
            ),
          ):  Container(
        width: getWidthDevice(context),
        height: 52,
        decoration: const BoxDecoration(
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
            Expanded(child: NeoText(Languages.of(context).teacher, textStyle: TextStyle(color: AppColors.lightBlue, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
            SizedBox(width: 52,)
          ],
        ),
      ),
          Expanded(
            child: SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                stream: _streamTeacher!,
                builder: (context, snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.lightBlue, size: 50),);
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
                            Navigator.push(context, MaterialPageRoute(builder: (_)=>TeacherDetailUI(data)));
                          },
                          child: Card(
                            margin: EdgeInsets.all(8),
                            child: Container(
                              width: getWidthDevice(context)/2-16,
                              height:  CommonKey.ADMIN==widget._role?getHeightDevice(context)*0.35+8:getHeightDevice(context)*0.25+8,
                              padding: EdgeInsets.all(8),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  loadPhoto.networkImage(data['avatar'], getWidthDevice(context)/4, getWidthDevice(context)/2-32),
                                  SizedBox(height: 8,),
                                  NeoText('GV: ${data['fullname']}', textStyle: TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis), maxline: 2, textAlign: TextAlign.center),
                                  SizedBox(height: 8,),
                                  NeoText('Kinh nghiệm: ${data['exp']}', textStyle: TextStyle(fontSize: 12, overflow: TextOverflow.fade), maxline: 2),
                                  SizedBox(height: 8,),
                                  NeoText('Chuyên môn: ${data['specialize']}', textStyle: TextStyle(fontSize: 12, overflow: TextOverflow.fade), maxline: 2),
                                  //SizedBox(height: 8,),
                                  //(data['intro'], textStyle: TextStyle(fontSize: 12, overflow: TextOverflow.fade), maxline: 3),
                                  Spacer(),
                                  CommonKey.ADMIN==widget._role?Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (_)=>AddNewTeacherUI(data, widget._role)));
                                  },

                                        icon: Icon(
                                          Icons.edit,
                                          color: AppColors.blue,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: (){
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text('Are you sure?'),
                                              content: Text('Do you want to block this user?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(false),
                                                  child: Text('No'),
                                                ),
                                                TextButton(
                                                  onPressed: (){
                                                    _presenter!.lookAccount(data['phone']);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Yes'),
                                                ),
                                              ],
                                            ),
                                          );

                                        },
                                        icon: Icon(
                                          Icons.lock_open_sharp,
                                          color: AppColors.blue,
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