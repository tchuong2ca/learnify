import 'package:online_learning/screen/lesson/model/lesson.dart';

class ClassDetail {
  ClassDetail({
    this.classDetailId,
    this.classId,
    this.teacherName,
    this.imageLink,
    this.className,
    this.describe,
    this.lessons,});

  ClassDetail.fromJson(dynamic json) {
    classDetailId = json['classDetailId'];
    classId = json['classId'];
    teacherName = json['teacherName'];
    imageLink = json['imageLink'];
    className = json['className'];
    describe = json['describe'];
    if (json['lessons'] != null) {
      lessons = [];
      json['lessons'].forEach((v) {
        lessons!.add(Lesson.fromJson(v));
      });
    }
  }
  String? classDetailId;
  String? classId;
  String? teacherName;
  String? imageLink;
  String? className;
  String? describe;
  List<Lesson>? lessons;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['classDetailId'] = classDetailId;
    map['classId'] = classId;
    map['teacherName'] = teacherName;
    map['imageLink'] = imageLink;
    map['className'] = className;
    map['describe'] = describe;
    if (lessons != null) {
      map['lessons'] = lessons!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}