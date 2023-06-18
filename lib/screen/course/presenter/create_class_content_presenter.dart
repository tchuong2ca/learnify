import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_learning/screen/course/model/class_detail.dart';
import 'package:online_learning/screen/course/model/course_model.dart';

import '../../../common/functions.dart';
import '../../../common/keys.dart';
import '../model/my_class_model.dart';

class CreateClassContentPresenter{
  Future<bool> createClassDetail(File fileImage, ClassDetail myClassDetail, CourseModel course, MyClassModel myClass) async{
    final metadata = SettableMetadata(contentType: "image/jpeg");

// Create a reference to the Firebase Storage bucket
    final storageRef = FirebaseStorage.instance.ref();

// Upload file and metadata to the path 'images/mountains.jpg'
    String link = "${CommonKey.COURSE}/${course.getCourseId}/${course.getCourseName}/${myClass.idClass}/class_detail.jpg";
    final uploadTask = storageRef
        .child(link)
        .putFile(fileImage, metadata);

// Listen for state changes, errors, and completion of the upload.
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async{
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
        // Handle unsuccessful uploads
          break;
        case TaskState.success:
        // Handle successful uploads on complete
          String url = await getLinkStorage(link);
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
            'imageLink': url,
            'lessons': lesson
          }).onError((error, stackTrace) => false);
          break;
      }
    });
    return true;
  }

  Future<bool> updateClassDetail(
      {File? fileImage, ClassDetail? myClassDetail,
        CourseModel? course, MyClassModel? myClass, String? linkImage}) async{
    if(fileImage!=null){
      final metadata = SettableMetadata(contentType: "image/jpeg");

// Create a reference to the Firebase Storage bucket
      final storageRef = FirebaseStorage.instance.ref();

// Upload file and metadata to the path 'images/mountains.jpg'
      String link = "${CommonKey.COURSE}/${course!.getCourseId}/${course.getCourseName}/${myClass!.idClass}/class_detail.jpg";
      final uploadTask = storageRef
          .child(link)
          .putFile(fileImage, metadata);

// Listen for state changes, errors, and completion of the upload.
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async{
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress =
                100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            print("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled");
            break;
          case TaskState.error:
          // Handle unsuccessful uploads
            break;
          case TaskState.success:
          // Handle successful uploads on complete
            String url = await getLinkStorage(link);
            List<Map<String, dynamic>> lesson =[];
            myClassDetail!.lessons!.forEach((element) {lesson.add(element.toJson());});
            _updateClassDetail(myClassDetail, course, myClass, url, lesson);
            break;
        }
      });
    }else{
      List<Map<String, dynamic>> lesson =[];
      myClassDetail!.lessons!.forEach((element) {lesson.add(element.toJson());});
      _updateClassDetail(myClassDetail, course!, myClass!, linkImage!, lesson);
    }
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