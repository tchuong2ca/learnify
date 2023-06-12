import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import '../../../common/state.dart';

part 'teacher_presenter.g.dart';

class TeacherPresenter = _TeacherPresenter with _$TeacherPresenter;
abstract class _TeacherPresenter with Store{
  @observable
  SingleState state = SingleState.LOADING;

  @action
  void lock(String id) {
    FirebaseFirestore.instance.collection('users').doc(id).update({
      'isLocked': true
    }).whenComplete(() => state=SingleState.HAS_DATA);
  }
}