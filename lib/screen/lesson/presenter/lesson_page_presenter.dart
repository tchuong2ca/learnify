import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:online_learning/screen/lesson/model/lesson.dart';

import '../../../common/functions.dart';
import '../../../common/state.dart';
import '../model/lesson_detail.dart';
part 'lesson_page_presenter.g.dart';
class LessonPagePresenter = _LessonPagePresenter with _$LessonPagePresenter;

abstract class _LessonPagePresenter with Store{
  @observable
  SingleState state = SingleState.LOADING;
  LessonContent? detail;
  @action
  Future getLessonDetail(Lesson lesson) async{
    state = SingleState.LOADING;
    await FirebaseFirestore.instance.collection('lesson_list').doc(replaceSpace(lesson.lessonId!)).get().then((value) {
      if(value.exists){
        detail = LessonContent.fromJson(value.data());
        if(detail!=null){
          state = SingleState.HAS_DATA;
        }else{
          state = SingleState.NO_DATA;
        }

      }else{
        state = SingleState.NO_DATA;

      }
    }).catchError((onError) {
      state = SingleState.NO_DATA;});

  }
}