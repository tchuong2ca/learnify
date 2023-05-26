import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_learning/screen/course/model/class_detail.dart';
import 'package:online_learning/screen/course/model/course_model.dart';
import 'package:online_learning/screen/course/model/my_class_model.dart';

import '../../../common/functions.dart';
import '../../../common/keys.dart';
import '../model/lesson_detail.dart';

class CreateLessonContentPresenter{
  String _url = '';
  Future<String> uploadPdfFile(File file, ClassDetail? myClassDetail,
      CourseModel? course, MyClassModel? myClass, String fileName) async{
    String path = '${CommonKey.COURSE}/${course!.getIdCourse}/${course.getNameCourse}/${myClass!.idClass}/$fileName';
    final reference = FirebaseStorage.instance.ref().child('$path');

    final uploadTask = await reference.putData(file.readAsBytesSync()).then((p0) {

    }).catchError((onError){
      return '';
    });

    _url = await getLinkStorage(path).then((value) => _url=value);

    return _url;
  }

  Future<bool> createLessonDetail(LessonDetail lessonDetail) async{
    Map<String, dynamic> data = lessonDetail.toJson();

    await FirebaseFirestore.instance.collection('lesson_detail').doc(lessonDetail.lessonDetailId)
        .set(data).catchError((onError)=> false);
    return true;
  }
  Future<void> addQuestionData(Map<String, dynamic>  questionData, String quizId, String questionId) async{
    await FirebaseFirestore.instance.collection("lesson_detail").doc(quizId).collection("QNA").doc(questionId).set(questionData).catchError((e){
      print(e.toString());
    });
  }
  Future<bool> updateLessonDetail(LessonDetail lessonDetail) async{
    List<Map<String, dynamic>> discuss =[];
    await FirebaseFirestore.instance.collection('lesson_detail').doc(replaceSpace(lessonDetail.lessonDetailId!)).update({
      'fileContent': lessonDetail.fileContent,
      'videoLink': lessonDetail.videoLink,
    }).then((value) => true).catchError((onError)=>false);
    return true;
  }
}