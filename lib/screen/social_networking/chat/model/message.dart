import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  String? message;
  String? linkImage;
  String? username;
  String? fullName;
  String? usernameFriend;
  String? friendName;
  Timestamp? timestamp;
  String? avatar;

  Message(
      {this.message,
        this.linkImage,
        this.username,
        this.fullName,
        this.usernameFriend,
        this.friendName,
        this.timestamp,
        this.avatar});

  Message.fromJson(dynamic json) {
    username = json['username'];
    fullName = json['fullname'];
    avatar = json['avatar'];
    message = json['message'];
    timestamp = json['timestamp'];
    usernameFriend = json['usernameFriend'];
    friendName = json['fullnameFriend'];
    linkImage = json['linkImage'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = username;
    map['fullname'] = fullName;
    map['avatar'] = avatar;
    map['message']=message;
    map['timestamp']=timestamp;
    map['usernameFriend']=usernameFriend;
    map['fullnameFriend']=friendName;
    map['linkImage']=linkImage;
    return map;
  }
}