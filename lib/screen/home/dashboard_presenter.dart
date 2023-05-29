
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:online_learning/screen/course/model/course_model.dart';

import '../../common/keys.dart';
import '../../common/state.dart';
import '../../storage/storage.dart';

part 'dashboard_presenter.g.dart';

class DashboardPresenter = _DashboardPresenter with _$DashboardPresenter;

abstract class _DashboardPresenter with Store {
  @observable
  bool seeMore = false;
  @observable
  SingleState stateBanner = SingleState.LOADING;
  @observable
  SingleState stateMenu = SingleState.LOADING;
  @observable
  bool height = false;
  @action
  void onSeeMoreClick(){
    seeMore = !seeMore;
  }
  @action
  bool setHeight(value){
    height = value;
    return height;
  }
  CourseModel? classModel;
  Future<CourseModel> getClass(String idUser) async{
    classModel=CourseModel('', '', '', '');
    await FirebaseFirestore.instance.collection('course').where('subscribe', arrayContains: idUser).get().then((value) {
      value.docs.forEach((element) {
        classModel = CourseModel(element['idCourse'], element['idTeacher'], element['teacherName'], element['name']);
      });
    });
    print(classModel);
    return classModel!;
}
  void classRegistration(String idClass, List<dynamic> userRegister, String idCourse){
    FirebaseFirestore.instance.collection('class').doc(idClass).update({
      'subscribe': userRegister
    });
    FirebaseFirestore.instance.collection('course').doc(idCourse).update({
      'subscribe':userRegister
    });
  }
  Future<CourseModel> getCourse(String idCourse) async{
    CourseModel course=CourseModel('', '', '', '');
    await FirebaseFirestore.instance.collection('course').where('idCourse', isEqualTo: idCourse).get().then((value) {
      value.docs.forEach((element) {
        course = CourseModel(element['idCourse'], element['idTeacher'], element['teacherName'], element['name']);
      });
    });
    print(course);
    return course;
  }
  Map<String, dynamic>? user;
  Future<Map<String, dynamic>> getUserInfo() async{
    dynamic user = await SharedPreferencesData.getData(CommonKey.USER);
    Map<String, dynamic> userData = jsonDecode(user.toString());
    user = userData;
    return userData;
  }
}