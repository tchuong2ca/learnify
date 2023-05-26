import 'package:cloud_firestore/cloud_firestore.dart';

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

  List<QA> listCorrectAnswers(List<QA> listQA){
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

  int scoreCalculate(List<QA> listQA){
    int totalCorrect = 0;
    for(QA qa in listQA){
      if(qa.correct==true){
        totalCorrect++;
      }
    }
    return totalCorrect;
  }
  double correctPercentage(List<QA> listQA){
    double total = 0.0;
    int numberOfCorrectAnswers = scoreCalculate(listQA);
    int numberOfQuestions = listQA.length;
    total = numberOfCorrectAnswers/numberOfQuestions;
    return total;
  }
  getQuestionData(String quizId) async{
    return await FirebaseFirestore.instance.collection("lesson_detail").doc(quizId).collection("QNA").get();
  }
  void update(LessonDetail lessonDetail){
    Map<String, dynamic> data = lessonDetail.toJson();
    FirebaseFirestore.instance.collection('lesson_detail').doc(lessonDetail.lessonDetailId).set(data);
  }
}