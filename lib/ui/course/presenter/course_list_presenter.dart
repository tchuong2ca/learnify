import 'package:cloud_firestore/cloud_firestore.dart';

class CourseListPresenter{
  void deleteCourse(String idCourse){
    FirebaseFirestore.instance.collection('course').doc(idCourse).delete();
  }
}