class Lesson {
  Lesson({
    this.lessonId,
    this.idClassDetail,
    this.lessonName,
    this.isLive});

  Lesson.fromJson(dynamic json) {
    lessonId = json['lessonId'];
    idClassDetail = json['idClassDetail'];
    lessonName = json['lessonName'];
    isLive = json['isLive'];
  }
  String? lessonId;
  String? idClassDetail;
  String? lessonName;
  String? isLive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lessonId'] = lessonId;
    map['idClassDetail'] = idClassDetail;
    map['lessonName'] = lessonName;
    map['isLive']=isLive;
    return map;
  }

}