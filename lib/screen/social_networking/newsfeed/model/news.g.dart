
part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) => News(
  json['name'] as String?,
  json['content'] as String?,
  json['hour'] as String?,
  json['image'] as String?,
  json['like'] as String?,
  json['comment'] as String?,
);

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
  'name': instance.name,
  'content': instance.content,
  'hour': instance.hour,
  'image': instance.image,
  'like': instance.like,
  'comment': instance.comment,
};