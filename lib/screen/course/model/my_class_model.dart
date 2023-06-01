class MyClassModel{
  String? idClass;
  String? idCourse;
  String? idTeacher;
  String? teacherName;
  String? onStageMon;
  String? onStageTue;
  String? onStageWed;
  String? onStageThu;
  String? onStageFri;
  String? onStageSat;
  String? onStageSun;
  String? price;
  String? nameClass;
  String? describe;
  String? startHours;
  String? imageLink;
  List<String>? subscribe;



  MyClassModel(
  {      this.idClass,
    this.idCourse,
    this.idTeacher,
    this.teacherName,
    this.onStageMon,
    this.onStageTue,
    this.onStageWed,
    this.onStageThu,
    this.onStageFri,
    this.onStageSat,
    this.onStageSun,
    this.price,
    this.nameClass,
    this.describe,
    this.startHours,
    this.imageLink,
    this.subscribe});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idCourse'] = idCourse;
    map['idTeacher'] = idTeacher;
    map['imageLink'] = imageLink;
    map['nameClass'] = nameClass;
    map['price'] = price;
    map['onStageMon'] = onStageMon;
    map['onStageTue'] = onStageTue;
    map['onStageWed'] = onStageWed;
    map['onStageThu'] = onStageThu;
    map['onStageFri'] = onStageFri;
    map['onStageSat'] = onStageSat;
    map['onStageSun'] = onStageSun;
    map['startHours'] = startHours;
    map['subscribe'] = subscribe;
    map['teacherName'] = teacherName;
    return map;
  }

  MyClassModel.fromJson(dynamic json) {
    idClass = json['idClass'];
    idCourse = json['idCourse'];
    idTeacher = json['idTeacher'];
    teacherName = json['teacherName'];
    onStageMon = json['onStageMon'];
    onStageTue = json['onStageTue'];
    onStageWed = json['onStageWed'];
    onStageThu = json['onStageThu'];
    onStageFri = json['onStageFri'];
    onStageSat = json['onStageSat'];
    onStageSun = json['onStageSun'];
    price = json['price'];
    nameClass = json['nameClass'];
    describe = json['describe'];
    startHours = json['startHours'];
    imageLink = json['imageLink'];
    subscribe = json['subscribe'] != null ? json['subscribe'].cast<String>() : [];
  }
}