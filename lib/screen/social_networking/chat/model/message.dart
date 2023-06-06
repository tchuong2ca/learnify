import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  String? message;
  String? linkImage;
  String? username;
  String? fullName;
  String? friendUsername;
  String? friendName;
  Timestamp? timestamp;
  String? avatar;

  Message(
      {this.message,
        this.linkImage,
        this.username,
        this.fullName,
        this.friendUsername,
        this.friendName,
        this.timestamp,
        this.avatar});

  Message.fromJson(dynamic json) {
    username = json['username'];
    fullName = json['fullname'];
    avatar = json['avatar'];
    message = json['message'];
    timestamp = json['timestamp'];
    friendUsername = json['friendUsername'];
    friendName = json['friendFullname'];
    linkImage = json['linkImage'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = username;
    map['fullname'] = fullName;
    map['avatar'] = avatar;
    map['message']=message;
    map['timestamp']=timestamp;
    map['friendUsername']=friendUsername;
    map['friendFullname']=friendName;
    map['linkImage']=linkImage;
    return map;
  }
}