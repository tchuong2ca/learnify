import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_learning/screen/course/model/class_detail.dart';
import 'package:online_learning/screen/course/model/course_model.dart';
import 'package:online_learning/screen/course/model/my_class_model.dart';

import '../../../common/functions.dart';
import '../../../common/keys.dart';
import '../model/lesson.dart';
import '../model/lesson_detail.dart';

class CreateLessonContentPresenter{
  String _url = '';
  Future<String> uploadPdfFile(File file,
      CourseModel? course, MyClassModel? myClass, String fileName) async{
    String path = '${CommonKey.COURSE}/${course!.getCourseId}/${course.getCourseName}/${myClass!.idClass}/$fileName';
    final reference = FirebaseStorage.instance.ref().child('$path');

    final uploadTask = await reference.putData(file.readAsBytesSync()).then((p0) {

    }).catchError((onError){
      return '';
    });

    _url = await getLinkStorage(path).then((value) => _url=value);

    return _url;
  }

  Future<bool> createLessonContent(LessonContent lessonContent) async{
    Map<String, dynamic> data = lessonContent.toJson();

    await FirebaseFirestore.instance.collection('lesson_list').doc(lessonContent.lessonDetailId)
        .set(data).catchError((onError)=> false);
    return true;
  }
  Future<void> addQuestionData(Map<String, dynamic>  questionData, String quizId, String questionId) async{
    await FirebaseFirestore.instance.collection("lesson_list").doc(quizId).collection("QNA").doc(questionId).set(questionData).catchError((e){
      print(e.toString());
    });
  }
  Future<bool> updateLessonDetail(LessonContent lessonDetail) async{
    List<Map<String, dynamic>> discuss =[];
    await FirebaseFirestore.instance.collection('lesson_list').doc(replaceSpace(lessonDetail.lessonDetailId!)).update({
      'fileContent': lessonDetail.fileContent,
      'videoLink': lessonDetail.videoLink,
      'isLive':lessonDetail.isLive
    }).then((value) => true).catchError((onError)=>false);
    return true;

  }
  void updateLessonStatus(String classDetailId,List<Lesson>? lessonList){
    List<Map<String, dynamic>> lesson =[];
    lessonList!.forEach((element) {lesson.add(element.toJson());});

    FirebaseFirestore.instance
        .collection('class_detail')
        .doc(classDetailId)
        .update({

      'lessons': lesson
    }).onError((error, stackTrace) => false);
  }
}