import 'doc_info.dart';

class DocContent{
  String? id;
  String? imageUrl;
  String? name;
  String? teacher;
  String? createdBy;
  List<DocInfo>? docsList;


  DocContent({this.id, this.imageUrl, this.name, this.docsList, this.teacher, this.createdBy});

  DocContent.fromJson(dynamic json) {
    id = json['id'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    teacher = json['teacher'];
    createdBy = json['createdBy'];
    if (json['docsList'] != null) {
      docsList = [];
      json['docsList'].forEach((v) {
        docsList!.add(DocInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['imageUrl'] = imageUrl;
    map['name'] = name;
    map['teacher']=teacher;
    map['createdBy'] = createdBy;
    if (docsList != null) {
      map['docsList'] = docsList!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}