import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:online_learning/screen/course/model/class_detail.dart';

import '../../../common/keys.dart';
import '../../../common/state.dart';
import '../../../storage/storage.dart';

part 'class_detail_presenter.g.dart';

class ClassDetailAdminPresenter = _ClassDetailAdminPresenter with _$ClassDetailAdminPresenter;
abstract class _ClassDetailAdminPresenter with Store{
  @observable
  SingleState state = SingleState.LOADING;

  @action
  Future loadData(bool value) async{
    state = SingleState.LOADING;
    bool result = await value;
    if(result){
      state = SingleState.HAS_DATA;
    }else{
      state = SingleState.NO_DATA;
    }
  }

  Future<bool> DeleteClassDetail(String idClass)async{
    await FirebaseFirestore.instance
        .collection('class_detail')
        .doc(idClass).delete().then((value) => true).catchError((onError)=>false);
    return true;
  }

  Future<Map<String, dynamic>> getUserInfor() async{
    dynamic user = await SharedPreferencesData.GetData(CommonKey.USER);
    Map<String, dynamic> userData = jsonDecode(user.toString());
    user = userData;
    return userData;
  }

  void CreateRating( _course,  ClassDetail?_myClassResult, String content, Map<String, dynamic> data){
    FirebaseFirestore.instance.collection('ratings').doc(_myClassResult!.idClass).set({
      "idCourse": _course.getIdCourse,
      "idClass": _myClassResult.idClass,
      "comment":content,
      "nameClass": _myClassResult.nameClass,
      "username": data['phone'],
      "fullname": data['fullname'],
      "avatar":data['avatar'],
      "role":data['role']
    });
  }
}