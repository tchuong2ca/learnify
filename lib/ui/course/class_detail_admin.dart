import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_learning/common/widgets.dart';
import 'package:online_learning/ui/course/model/my_class_model.dart';

import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/keys.dart';
import '../../common/state.dart';
import '../../languages/languages.dart';
import 'model/course_model.dart';

class ClassDetailAdminPage extends StatefulWidget {
    MyClassModel? _myClass;
  CourseModel? _course;
  String? _role;
  ClassDetailAdminPage(this._myClass, this._course, this._role);

  @override
  State<ClassDetailAdminPage> createState() => _ClassDetailAdminPageState();
}

class _ClassDetailAdminPageState extends State<ClassDetailAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Aloooo'),),
    );
  }
}


// class ClassDetailAdminPage extends StatefulWidget {
//   MyClassModel? _myClass;
//   CourseModel? _course;
//   String? _role;
//   ClassDetailAdminPage(this._myClass, this._course, this._role);
//
//   @override
//   State<ClassDetailAdminPage> createState() => _ClassDetailAdminPageState(_myClass, _course, _role);
// }
//
// class _ClassDetailAdminPageState extends State<ClassDetailAdminPage> {
//   MyClassModel? _myClass;
//   CourseModel? _course;
//   String? _role;
//   String _content = '';
//   _ClassDetailAdminPageState(this._myClass, this._course, this._role);
//   Stream<QuerySnapshot>? _stream;
//   MyClassDetail? _myClassResult;
//   ClassDetailAdminPresenter? _presenter;
//   Map<String, dynamic>? _dataUser;
//   @override
//   void initState() {
//     _presenter = ClassDetailAdminPresenter();
//     _stream =  FirebaseFirestore.instance.collection('class_detail').where('idClass', isEqualTo: '${_myClass!.idClass!}').snapshots();
//     getAccountInfor();
//   }
//
//   Future<void> getAccountInfor()async{
//     _dataUser = await _presenter!.getUserInfor();
//     setState(()=>null);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 0,
//         elevation: 0,
//       ),
//       body: Column(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // CustomAppBar(appType: CommonKey.MEMBER==_role?AppType.child:AppType.childFunction, title: Languages.of(context).classDetail, nameFunction: Languages.of(context).delete, callback: (value){
//           //   if(_myClassResult!.idClassDetail!=null){
//           //     showLoaderDialog(context);
//           //     _presenter!.DeleteClassDetail(_myClassResult!.idClassDetail!).then((value) {
//           //       listenStatus(context, value);
//           //     });
//           //   }
//           // }),
//           Expanded(
//             child: CustomScrollView(
//               slivers: [
//                 SliverFillRemaining(
//                   hasScrollBody: false,
//                   child: StreamBuilder<QuerySnapshot>(
//                     stream: _stream,
//                     builder: (context, snapshot){
//                       if(snapshot.connectionState==ConnectionState.waiting){
//                         return Center(child: Text('Loading'),);
//                       }else if(snapshot.hasError){
//                         return Center(child: Text('No data'),);
//                       }else if(!snapshot.hasData){
//                         return Center(child: Text('No data'),);
//                       }else{
//                         snapshot.data!.docs.forEach((element) {
//                           _myClassResult = MyClassDetail.fromJson(element.data());
//                         });
//                         if(_myClassResult!=null){
//                           _presenter!.loadData(true);
//                         }
//
//                         return _myClassResult!=null?Column(
//                           mainAxisSize: MainAxisSize.max,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _header(),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 8.0, bottom: 8),
//                               child: NeoText(Languages.of(context).lessionList, textStyle: TextStyle(fontSize: 18, color: CommonColor.black)),
//                             ),
//                             // Wrap(
//                             //   children: List.generate(_myClassResult!.lession!.length, (index) => _itemLession(_myClassResult!.lession![index])),
//                             // )
//                           ],
//                         ):SizedBox();
//                       }
//                     },
//                   ),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//       // floatingActionButton: Visibility(
//       //   visible: CommonKey.TEACHER==_role||CommonKey.ADMIN==_role,
//       //   child: FloatingActionButton(
//       //       onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ClassDetailProductPage(_myClass, _course, _presenter!.state==SingleState.HAS_DATA?CommonKey.EDIT:'',_presenter!.state==SingleState.HAS_DATA?_myClassResult:null))),
//       //       child: Observer(
//       //         builder: (_){
//       //           if(_presenter!.state==SingleState.LOADING){
//       //             return Icon(Icons.add, color: CommonColor.white,);
//       //           }else if(_presenter!.state==SingleState.NO_DATA){
//       //             return Icon(Icons.add, color: CommonColor.white,);
//       //           }else{
//       //             return Icon(Icons.edit, color: CommonColor.white,);
//       //           }
//       //         },
//       //       )
//       //   ),
//       // ),
//     );
//   }
//
//   // Widget _itemLession(Lession lession){
//   //   return InkWell(
//   //     onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>LessionAdminPage(lession, CommonKey.ADMIN, _myClassResult, _myClass, _course, _role))),
//   //     child: Container(
//   //       width: getWidthDevice(context),
//   //       color: CommonColor.white,
//   //       padding: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
//   //       child: Row(
//   //         mainAxisSize: MainAxisSize.max,
//   //         mainAxisAlignment: MainAxisAlignment.center,
//   //         crossAxisAlignment: CrossAxisAlignment.center,
//   //         children: [
//   //           SizedBox(width: 8,),
//   //           Icon(Icons.circle_outlined, color: CommonColor.blue,),
//   //           SizedBox(width: 4,),
//   //           Expanded(child: CustomText('${lession.nameLession}', textStyle: TextStyle(fontSize: 14, color: CommonColor.blue))),
//   //           Icon(Icons.access_time_filled, color: CommonColor.blue,),
//   //           SizedBox(width: 8,),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   Widget _header(){
//     return Column(
//       mainAxisSize: MainAxisSize.max,
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ImageLoad.imageNetwork(_myClassResult!.imageLink, getHeightDevice(context)/3, getWidthDevice(context)),
//         SizedBox(height: 8,),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: NeoText(_myClassResult!.nameClass!, textStyle: TextStyle(color: CommonColor.black, fontSize: 18, fontWeight: FontWeight.bold)),
//         ),
//         Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             IconButton(onPressed: ()=>null, icon: Icon(Icons.info, color: CommonColor.blue,)),
//             Expanded(child: NeoText(Languages.of(context).infor, textStyle: TextStyle(fontSize: 14, color: CommonColor.blue))),
//             TextButton(
//               onPressed: ()=>_showDialog(),
//               child: NeoText(Languages.of(context).rating, textStyle: TextStyle(fontSize: 14, color: CommonColor.orangeLight)),
//             ),
//             SizedBox(width: 8,),
//           ],
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 4, left: 16, right: 16),
//           child: NeoText(_myClassResult!.describe!=null?_myClassResult!.describe!:Languages.of(context).noData, textStyle: TextStyle(color: CommonColor.blue, fontSize: 16)),
//         ),
//         Divider(),
//         SizedBox(height: 8,),
//       ],
//     );
//   }
//
//   void _showDialog(){
//     showDialog(
//         context: context,
//         builder: (_)=>StatefulBuilder(builder: (_, setState)=>AlertDialog(
//           title: NeoText(_myClassResult!.describe!=null?_myClassResult!.describe!:Languages.of(context).noData, textStyle: TextStyle(color: CommonColor.blue, fontSize: 16)),
//           content: TextField(
//             onChanged: (value)=>setState(()=>_content=value),
//           ),
//           actions: [
//             // ButtonDefault(Languages.of(context).submitRating, (data) {
//             //   if(_content.isEmpty){
//             //     Fluttertoast.showToast(msg: 'Empty');
//             //     //showToast(Languages.of(context).contentEmpty);
//             //   }else{
//             //     _presenter!.CreateRating(_course!, _myClassResult, _content, _dataUser!);
//             //     Navigator.pop(context);
//             //   }
//             // })
//           ],
//         ))
//     );
//   }
// }