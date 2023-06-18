class Lesson {
  Lesson({
    this.lessonId,
    this.classDetailId,
    this.lessonName,
    this.isLive});

  Lesson.fromJson(dynamic json) {
    lessonId = json['lessonId'];
    classDetailId = json['classDetailId'];
    lessonName = json['lessonName'];
    isLive = json['isLive'];
  }
  String? lessonId;
  String? classDetailId;
  String? lessonName;
  String? isLive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lessonId'] = lessonId;
    map['classDetailId'] = classDetailId;
    map['lessonName'] = lessonName;
    map['isLive']=isLive;
    return map;
  }

}