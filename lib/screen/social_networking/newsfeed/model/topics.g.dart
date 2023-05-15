
part of 'topics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Topics _$TopicsFromJson(Map<String, dynamic> json) => Topics(
  key: json['key'] as String?,
  name: json['name'] as String?,
  collection: json['collection'] as List<dynamic>?,
  isSelect: json['isSelect'] as bool?,
);

Map<String, dynamic> _$TopicsToJson(Topics instance) => <String, dynamic>{
  'key': instance.key,
  'name': instance.name,
  'collection': instance.collection,
  'isSelect': instance.isSelect,
};