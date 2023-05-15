import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_learning/screen/course/model/class_detail.dart';
import 'package:online_learning/screen/course/model/course_model.dart';
import 'package:online_learning/screen/course/model/my_class_model.dart';

import '../../../common/functions.dart';
import '../../../common/keys.dart';
import '../model/lesson_detail.dart';

class LessonProductPresenter{
  String _url = '';
  Future<String> UploadFilePdf(File file, ClassDetail? myClassDetail,
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

  Future<bool> CreateLessonDetail(LessonDetail lessonDetail) async{
    Map<String, dynamic> data = lessonDetail.toJson();
    // List<Map<String, dynamic>> homework =[];
    // homeworkList.forEach((element) {homework.add(element.toJson());});
    await FirebaseFirestore.instance.collection('lesson_detail').doc(lessonDetail.idLessonDetail).set(/*{
      'idLessonDetail': lessonDetail.idLessonDetail,
      'nameLesson': lessonDetail.nameLesson,
      'fileContent': lessonDetail.fileContent,
      'videoLink': lessonDetail.videoLink,
      'homework': homework
    }*/data).catchError((onError)=> false);
    return true;
  }

  Future<bool> updateLessonDetail(LessonDetail lessonDetail) async{
    List<Map<String, dynamic>> discuss =[];
    List<Map<String, dynamic>> dataHomework =[];
    lessonDetail.homework!.forEach((element) => dataHomework.add(element.toJson()));
    await FirebaseFirestore.instance.collection('lesson_detail').doc(replaceSpace(lessonDetail.idLessonDetail!)).update({
      'fileContent': lessonDetail.fileContent,
      'videoLink': lessonDetail.videoLink,
      'homework':dataHomework,
    }).then((value) => true).catchError((onError)=>false);
    return true;
  }
}