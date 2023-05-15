import 'discuss.dart';
import 'homework.dart';

class LessonDetail {
  LessonDetail({
    this.idLessonDetail,
    this.nameLesson,
    this.fileContent,
    this.videoLink,
    this.homework,
    this.discuss});

  LessonDetail.fromJson(dynamic json) {
    idLessonDetail = json['idLessonDetail'];
    nameLesson = json['nameLesson'];
    fileContent = json['fileContent'];
    videoLink = json['videoLink'];
    if (json['homework'] != null) {
      homework = [];
      json['homework'].forEach((v) {
        homework!.add(Homework.fromJson(v));
      });
    }
    if (json['discuss'] != null) {
      discuss = [];
      json['discuss'].forEach((v) {
        discuss!.add(Discuss.fromJson(v));
      });
    }
  }
  String? idLessonDetail;
  String? nameLesson;
  String? fileContent;
  String? videoLink;
  List<Homework>? homework;
  List<Discuss>? discuss;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idLessonDetail'] = idLessonDetail;
    map['nameLesson'] = nameLesson;
    map['fileContent'] = fileContent;
    map['videoLink'] = videoLink;
    if (homework != null) {
      map['homework'] = homework!.map((v) => v.toJson()).toList();
    }
    if (discuss != null) {
      map['discuss'] = discuss!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}