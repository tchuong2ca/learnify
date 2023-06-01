class Lesson {
  Lesson({
    this.lessonId,
    this.idClassDetail,
    this.lessonName,});

  Lesson.fromJson(dynamic json) {
    lessonId = json['lessonId'];
    idClassDetail = json['idClassDetail'];
    lessonName = json['lessonName'];
  }
  String? lessonId;
  String? idClassDetail;
  String? lessonName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lessonId'] = lessonId;
    map['idClassDetail'] = idClassDetail;
    map['lessonName'] = lessonName;
    return map;
  }

}