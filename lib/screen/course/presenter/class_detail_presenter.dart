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

  Future<bool> deleteClassDetail(String classId)async{
    await FirebaseFirestore.instance
        .collection('class_detail')
        .doc(classId).delete().then((value) => true).catchError((onError)=>false);
    return true;
  }
  Future<bool> deleteLesson(String lessonId) async{
    await FirebaseFirestore.instance.collection('lesson_list').doc(lessonId).delete()
        .then((value) => true).catchError((onError)=>false);
    return true;

  }

  Future<Map<String, dynamic>> getUserInfo() async{
    dynamic user = await SharedPreferencesData.getData(CommonKey.USER);
    Map<String, dynamic> userData = jsonDecode(user.toString());
    user = userData;
    return userData;
  }

}