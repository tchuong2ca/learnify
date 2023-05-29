import 'package:cloud_firestore/cloud_firestore.dart';

class EditQuizPresenter{


  getQuestionData(String quizId) async{
    return await FirebaseFirestore.instance.collection("lesson_detail").doc(quizId).collection("QNA").get();
  }
  Future<void> deleteQuestionData(String quizId, String questionId) async{
    return await FirebaseFirestore.instance.collection("lesson_detail").doc(quizId).collection("QNA").doc(questionId).delete().catchError((e){
      print(e.toString());
    });
  }
  Future<void> updateQuestionData(Map<String, dynamic> questionData, String quizId, String questionId) async{
    await FirebaseFirestore.instance.collection("lesson_detail").doc(quizId).collection("QNA").doc(questionId).update(questionData).catchError((e){
      print(e.toString());
    });
  }
  Future<void> deleteQuizData(String quizId) async{
    await FirebaseFirestore.instance.collection("lesson_detail").doc(quizId).delete().catchError((e){
      print(e.toString());
    });
  }
}