import 'discuss.dart';

class LessonContent {
  LessonContent({
    this.lessonDetailId,
    this.lessonName,
    this.fileContent,
    this.videoLink,
    this.discuss,
    this.isLive});

  LessonContent.fromJson(dynamic json) {
    lessonDetailId = json['lessonDetailId'];
    lessonName = json['lessonName'];
    fileContent = json['fileContent'];
    videoLink = json['videoLink'];
    isLive = json['isLive'];

    if (json['discuss'] != null) {
      discuss = [];
      json['discuss'].forEach((v) {
        discuss!.add(Discuss.fromJson(v));
      });
    }
  }
  String? lessonDetailId;
  String? lessonName;
  String? fileContent;
  String? videoLink;
  List<Discuss>? discuss;
  bool? isLive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lessonDetailId'] = lessonDetailId;
    map['lessonName'] = lessonName;
    map['fileContent'] = fileContent;
    map['videoLink'] = videoLink;
    map['isLive'] = isLive;
    if (discuss != null) {
      map['discuss'] = discuss!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}