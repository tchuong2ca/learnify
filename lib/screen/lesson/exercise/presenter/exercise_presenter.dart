import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/lesson_detail.dart';

class ExercisePresenter{
  getQuestionData(String quizId) async{
    return await FirebaseFirestore.instance.collection("lesson_detail").doc(quizId).collection("QNA").get();
  }
  void update(LessonContent lessonDetail){
    Map<String, dynamic> data = lessonDetail.toJson();
    FirebaseFirestore.instance.collection('lesson_detail').doc(lessonDetail.lessonDetailId).set(data);
  }
}