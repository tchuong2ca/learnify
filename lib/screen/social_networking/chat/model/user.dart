import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String? username;
  String? fullname;
  String? userAvatar;
  bool? isOnline;
  Timestamp? timestamp;

  User(
      {this.username,
        this.fullname,
        this.userAvatar,
        this.isOnline,
        this.timestamp});

  User.fromJson(dynamic json) {
    username = json['username'];
    fullname = json['fullname'];
    userAvatar = json['userAvatar'];
    isOnline = json['isOnline'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = username;
    map['fullname'] = fullname;
    map['userAvatar'] = userAvatar;
    map['isOnline']=isOnline;
    map['timestamp']=timestamp;

    return map;
  }
}