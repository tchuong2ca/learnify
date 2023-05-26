import 'discuss.dart';

class LessonDetail {
  LessonDetail({
    this.lessonDetailId,
    this.lessonName,
    this.fileContent,
    this.videoLink,
    this.discuss});

  LessonDetail.fromJson(dynamic json) {
    lessonDetailId = json['idLessonDetail'];
    lessonName = json['nameLesson'];
    fileContent = json['fileContent'];
    videoLink = json['videoLink'];

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

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idLessonDetail'] = lessonDetailId;
    map['nameLesson'] = lessonName;
    map['fileContent'] = fileContent;
    map['videoLink'] = videoLink;
    if (discuss != null) {
      map['discuss'] = discuss!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}