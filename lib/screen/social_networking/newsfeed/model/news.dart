import 'package:json_annotation/json_annotation.dart';

part 'news.g.dart';

@JsonSerializable()
class News {
  String? name;
  String? content;
  String? hour;
  String? image;
  String? like;
  String? comment;

  News(this.name, this.content, this.hour, this.image, this.like, this.comment);

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);

  Map<String, dynamic> toJson() => _$NewsToJson(this);
}