import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import '../../../common/keys.dart';
import '../../../common/state.dart';
import '../../course/model/course_model.dart';
import '../../course/model/my_class_model.dart';

part 'schedule_presenter.g.dart';

class SchedulePresenter = _SchedulePresenter with _$SchedulePresenter;
abstract class _SchedulePresenter with Store{
  @observable
  SingleState state = SingleState.LOADING;

  List<MyClassModel> onStageScheduleMon = [];
  List<MyClassModel> onStageScheduleTue = [];
  List<MyClassModel> onStageScheduleWed = [];
  List<MyClassModel> onStageScheduleThu = [];
  List<MyClassModel> onStageScheduleFri = [];
  List<MyClassModel> onStageScheduleSat = [];
  List<MyClassModel> onStageScheduleSun = [];
  List<MyClassModel> listMyClass = [];
  List<CourseModel> listCours = [];
  @action
  Future<List<MyClassModel>> getSchedule(String idTeacher, String role) async{
    state = SingleState.LOADING;
    List<MyClassModel> myClass=[];
    if(CommonKey.TEACHER==role){
      await FirebaseFirestore.instance.collection('class').where('idTeacher', isEqualTo:idTeacher).get().then((value) {
        value.docs.forEach((element) {
          MyClassModel myCla = MyClassModel.fromJson(element.data());
          myClass.add(myCla);
        });
        if(myClass.length>0){
          _mapDataDay(myClass);
          listMyClass=myClass;
          state = SingleState.HAS_DATA;
        }else{
          state = SingleState.NO_DATA;
        }
        return myClass;
      }).catchError((onError){
        state = SingleState.NO_DATA;
        throw(onError);
      });
    }else{
      await FirebaseFirestore.instance.collection('class').where('subscribe', arrayContains:idTeacher).get().then((value) {
        value.docs.forEach((element) {
          MyClassModel myCla = MyClassModel.fromJson(element.data());
          myClass.add(myCla);
        });
        if(myClass.length>0){
          _mapDataDay(myClass);
          listMyClass=myClass;
          state = SingleState.HAS_DATA;
        }else{
          state = SingleState.NO_DATA;
        }
        return myClass;
      }).catchError((onError){
        state = SingleState.NO_DATA;
        throw(onError);
      });
    }
    return myClass;
  }

  void _mapDataDay(List<MyClassModel> myClass){
    onStageScheduleMon = myClass.where((element) => CommonKey.MON==element.onStageMon).toList();
    onStageScheduleTue = myClass.where((element) => CommonKey.TUE==element.onStageTue).toList();
    onStageScheduleWed = myClass.where((element) => CommonKey.WED==element.onStageWed).toList();
    onStageScheduleThu = myClass.where((element) => CommonKey.THU==element.onStageThu).toList();
    onStageScheduleFri = myClass.where((element) => CommonKey.FRI==element.onStageFri).toList();
    onStageScheduleSat = myClass.where((element) => CommonKey.SAT==element.onStageSat).toList();
    onStageScheduleSun = myClass.where((element) => CommonKey.SUN==element.onStageSun).toList();
  }

  Future getCourse(String _role, String username) async{
    await FirebaseFirestore.instance.collection('course').where('idTeacher', isEqualTo: username).get().then((value){
      CourseModel course;
      value.docs.forEach((element) {
        course = CourseModel(element['idCourse'], element['idTeacher'], element['teacherName'], element['name']);
        listCours.add(course);
      });
    });
  }

  CourseModel getModelCourse(String idCourse){
    List<CourseModel> course = listCours.where((element) => element.getIdCourse==idCourse).toList();
    return course[0];
  }
}
