import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_learning/screen/course/model/course_model.dart';
import '../../../common/keys.dart';
import '../../../storage/storage.dart';
import '../model/my_class_model.dart';

class CreateClassPresenter{
  Future<bool> createClass(File fileImage, CourseModel course, MyClassModel myClass) async{
    final metadata = SettableMetadata(contentType: "image/jpeg");

// Create a reference to the Firebase Storage bucket
    final storageRef = FirebaseStorage.instance.ref();

// Upload file and metadata to the path 'images/mountains.jpg'
    final uploadTask = storageRef
        .child("${CommonKey.COURSE}/${course.getCourseId}/${course.getCourseName}/${myClass.idClass}/class.jpg")
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
          String url = await getLinkAvatar(course.getCourseId!, course.getCourseName!, myClass.idClass!);
          FirebaseFirestore.instance
              .collection('class')
              .doc(myClass.idClass)
              .set({
            'idClass': myClass.idClass,
            'idCourse': course.getCourseId,
            'idTeacher': course.getTeacherId,
            'teacherName': course.getTeacherName,
            'price': myClass.price,
            'nameClass': myClass.nameClass,
            'describe': myClass.describe,
            'imageLink': url,
            'onStageMon': myClass.onStageMon,
            'onStageTue': myClass.onStageTue,
            'onStageWed': myClass.onStageWed,
            'onStageThu': myClass.onStageThu,
            'onStageFri': myClass.onStageFri,
            'onStageSat': myClass.onStageSat,
            'onStageSun': myClass.onStageSun,

            'startHours': myClass.startHours,
            'subscribe': [
              'admin'
            ]
          }).then((value) => true);
          break;
      }
    });
    return true;
  }

  Future<bool> updateClass({File? file, CourseModel? course, MyClassModel? myClass, String? url}) async{
    if(file!=null){
      final metadata = SettableMetadata(contentType: "image/jpeg");

// Create a reference to the Firebase Storage bucket
      final storageRef = FirebaseStorage.instance.ref();

// Upload file and metadata to the path 'images/mountains.jpg'
      final uploadTask = storageRef
          .child("${CommonKey.COURSE}/${course!.getCourseId}/${course.getCourseName}/${myClass!.idClass}/class.jpg")
          .putFile(file, metadata);

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
            String urlImage = await getLinkAvatar(course.getCourseId!, course.getCourseName!, myClass.idClass!);
            _updateClass(course, myClass, urlImage);
            break;
        }
      });
    }else{
      _updateClass(course!, myClass!, url!);
    }
    return true;
  }
  void _updateClass(CourseModel course, MyClassModel myClass, String url){
    FirebaseFirestore.instance.collection('class').doc(myClass.idClass)
        .update({
      'price': myClass.price,
      'nameClass': myClass.nameClass,
      'describe': myClass.describe,
      'imageLink': url,
      'onStageMon': myClass.onStageMon,
      'onStageTue': myClass.onStageTue,
      'onStageWed': myClass.onStageWed,
      'onStageThu': myClass.onStageThu,
      'onStageFri': myClass.onStageFri,
      'onStageSat': myClass.onStageSat,
      'onStageSun': myClass.onStageSun,
      'startHours': myClass.startHours
    });
  }

  Future<String> getLinkAvatar(String idCourse, String nameCourse, String idClass) async{
    final ref = FirebaseStorage.instance.ref().child("${CommonKey.COURSE}/$idCourse/$nameCourse/$idClass/class.jpg");
    String url = (await ref.getDownloadURL()).toString();
    return url;
  }

  void deleteClass(String idClass){
    FirebaseFirestore.instance.collection('class').doc(idClass).delete();
  }

  Future<String> getUserInfo() async{
    String phone = '';
    dynamic data = await SharedPreferencesData.getData(CommonKey.USER);
    if(data!=null){
      Map<String, dynamic>json = jsonDecode(data.toString());
      phone = json['phone']!=null?json['phone']:'';
    }
    return phone;
  }

  void classRegistration(String idClass, List<dynamic> userRegister, String idCourse){
    FirebaseFirestore.instance.collection('class').doc(idClass).update({
      'subscribe': userRegister
    });
    FirebaseFirestore.instance.collection('course').doc(idCourse).update({
      'subscribe':userRegister
    });
  }
}