import 'package:online_learning/screen/lesson/model/lesson.dart';

class ClassDetail {
  ClassDetail({
    this.idClassDetail,
    this.idClass,
    this.teacherName,
    this.imageLink,
    this.nameClass,
    this.describe,
    this.lesson,});

  ClassDetail.fromJson(dynamic json) {
    idClassDetail = json['idClassDetail'];
    idClass = json['idClass'];
    teacherName = json['teacherName'];
    imageLink = json['imageLink'];
    nameClass = json['nameClass'];
    describe = json['describe'];
    if (json['lesson'] != null) {
      lesson = [];
      json['lesson'].forEach((v) {
        lesson!.add(Lesson.fromJson(v));
      });
    }
  }
  String? idClassDetail;
  String? idClass;
  String? teacherName;
  String? imageLink;
  String? nameClass;
  String? describe;
  List<Lesson>? lesson;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idClassDetail'] = idClassDetail;
    map['idClass'] = idClass;
    map['teacherName'] = teacherName;
    map['imageLink'] = imageLink;
    map['nameClass'] = nameClass;
    map['describe'] = describe;
    if (lesson != null) {
      map['lesson'] = lesson!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}