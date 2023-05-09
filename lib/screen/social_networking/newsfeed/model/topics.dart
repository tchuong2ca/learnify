import 'package:json_annotation/json_annotation.dart';
part 'topics.g.dart';

@JsonSerializable()
class Topics{
  String? key;
  String? name;
  List<dynamic>? collection;
  bool? isSelect = false;


  Topics({this.key, this.name, this.collection, this.isSelect});

  factory Topics.fromJson(Map<String, dynamic> json) => _$TopicsFromJson(json);

  Map<String, dynamic> toJson() => _$TopicsToJson(this);
}