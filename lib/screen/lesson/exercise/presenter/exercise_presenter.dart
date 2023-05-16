import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/homework.dart';
import '../../model/lesson_detail.dart';
import '../../model/questionAnswer.dart';

class ExercisePresenter{

  List<QA>initData(List<QA> listQA){
    List<QA> listQAResult = [];
    for(QA qa in listQA){
      qa.correct = false;
      listQAResult.add(qa);
    }
    return listQAResult;
  }

  List<QA> ResultSubmit(List<QA> listQA){
    List<QA> listQAResult = [];
    for(QA qa in listQA){
      if(qa.answer==qa.studentAnswer){
        qa.correct = true;
      }else{
        qa.correct = false;
      }
      listQAResult.add(qa);
    }
    return listQAResult;
  }

  int ScroreCorrect(List<QA> listQA){
    int totalCorrect = 0;
    for(QA qa in listQA){
      if(qa.correct==true){
        totalCorrect++;
      }
    }
    return totalCorrect;
  }
  double Score(List<QA> listQA){
    double total = 0.0;
    int totalCorect = ScroreCorrect(listQA);
    int lengthQA = listQA.length;
    total = totalCorect/lengthQA;
    return total;
  }

  void UpdateTotalLesson(LessonDetail lessonDetail, List<Homework> listHomework){
    Map<String, dynamic> data = lessonDetail.toJson();
    FirebaseFirestore.instance.collection('lesson_detail').doc(lessonDetail.idLessonDetail).set(data);
  }
}