class Lesson {
  Lesson({
    this.lessonId,
    this.idClassDetail,
    this.lessonName,
    this.status});

  Lesson.fromJson(dynamic json) {
    lessonId = json['lessonId'];
    idClassDetail = json['idClassDetail'];
    lessonName = json['lessonName'];
    status = json['status'];
  }
  String? lessonId;
  String? idClassDetail;
  String? lessonName;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lessonId'] = lessonId;
    map['idClassDetail'] = idClassDetail;
    map['lessonName'] = lessonName;
    map['status'] = status;
    return map;
  }

}