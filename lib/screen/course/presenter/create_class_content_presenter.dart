import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_learning/screen/course/model/class_detail.dart';
import 'package:online_learning/screen/course/model/course_model.dart';

import '../../../common/functions.dart';
import '../../../common/keys.dart';
import '../model/my_class_model.dart';

class CreateClassContentPresenter{
  Future<bool> createClassDetail( ClassDetail myClassDetail, CourseModel course, MyClassModel myClass, String classDetailPhotoUrl) async{
    List<Map<String, dynamic>> lesson =[];
    myClassDetail.lessons!.forEach((element) {lesson.add(element.toJson());});
    FirebaseFirestore.instance
        .collection('class_detail')
        .doc(myClassDetail.classDetailId)
        .set({
      'classDetailId': myClassDetail.classDetailId,
      'classId': myClassDetail.classId,
      'teacherName': course.getTeacherName,
      'className': myClassDetail.className,
      'describe': myClassDetail.describe,
      'imageLink': classDetailPhotoUrl,
      'lessons': lesson
    }).onError((error, stackTrace) => false);
    //break;
    return true;
  }

  Future<bool> updateClassDetail(
      { ClassDetail? myClassDetail,
        CourseModel? course, MyClassModel? myClass, String? linkImage, String? classDetailPhotoUrl}) async{
    List<Map<String, dynamic>> lesson =[];
    myClassDetail!.lessons!.forEach((element) {lesson.add(element.toJson());});
    _updateClassDetail(myClassDetail, course!, myClass!, classDetailPhotoUrl!, lesson);

    return true;
  }

  void _updateClassDetail(ClassDetail myClassDetail, CourseModel course, MyClassModel myClass, String linkImage, List<Map<String, dynamic>> lesson){
    FirebaseFirestore.instance
        .collection('class_detail')
        .doc(myClassDetail.classDetailId)
        .update({
      'describe': myClassDetail.describe,
      'imageLink': linkImage,
      'lessons': lesson
    }).onError((error, stackTrace) => false);
  }
}