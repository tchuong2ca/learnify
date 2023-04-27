class DocInfo{
  String? id;
  String? fileName;
  String? fileUrl;

  DocInfo({this.id, this.fileName, this.fileUrl});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['nameFile'] = fileName;
    map['linkFile'] = fileUrl;
    return map;
  }

  DocInfo.fromJson(dynamic json) {
    id = json['id'];
    fileName = json['nameFile'];
    fileUrl = json['linkFile'];
  }
}