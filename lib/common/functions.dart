import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../res/images.dart';
import '../restart.dart';
import '../storage/storage.dart';
import 'colors.dart';
import 'keys.dart';
double getWidthDevice(BuildContext context){
  return MediaQuery.of(context).size.width;
}

double getHeightDevice(BuildContext context){
  return MediaQuery.of(context).size.height;
}
String replaceSpace(String content){
  return content.replaceAll(" ", "");
}
bool validateEmail(String? value) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty || !regex.hasMatch(value))
    return false;
  else
    return true;
}
String getCurrentTime() {
  DateTime now = DateTime.now();
  int time=now.millisecondsSinceEpoch;
  return "$time";
}
void hideKeyboard(){
  FocusManager.instance.primaryFocus?.unfocus();
}
Future<void> cropImage(BuildContext context,Function (File?) onResult, String type) async {
  final pickedImage =
  await ImagePicker().getImage(source: CommonKey.CAMERA==type?ImageSource.camera : ImageSource.gallery);
  if(pickedImage==null){
    onResult(null);
  }else {
    CroppedFile? croppedFile =  await ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: AppColors.ultraRed,
            toolbarWidgetColor: AppColors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    if (croppedFile != null) {
      onResult(File(croppedFile.path));
    }
  }
}

String getYoutubeId(String url){
  String? id = YoutubePlayer.convertUrlToId(url);
  return id!;
}
String getDateWeek(int day){
  var d = DateTime.now();
  var weekDay = d.weekday;
  var date = d.subtract(Duration(days: weekDay-day));
  var formatterDate = DateFormat('dd/MM');
  String value = formatterDate.format(date);

  return value;
}
Future<void> selectFile(Function (List<File>?) onSelectFile, String type) async {
  if(CommonKey.CAMERA==type){
    final photo = await ImagePicker().getImage(source:ImageSource.camera);
    if(photo==null){
      onSelectFile(null);
    }else {
      List<File> listPhoto = [];
      listPhoto.add(File(photo.path));
      onSelectFile(listPhoto);
    }

  }
  else if('VIDEO'==type){
    final galleryVideo  = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if(galleryVideo ==null){
      onSelectFile(null);
    }else {
      List<File> galleryListVideo = [];
      galleryListVideo.add(File(galleryVideo .path));
      onSelectFile(galleryListVideo);
    }

  }
  else{
    final image = await ImagePicker().pickMultiImage();
    if(image==null){
      onSelectFile(null);
    }else {
      if(image.isNotEmpty){
        List<File> listImage =[];
        for(XFile i in image){
          listImage.add(File(i.path));
        }
        onSelectFile(listImage);
      }
    }
  }
}
String postedTime(Timestamp? timestamp) {
  if(timestamp==null) return "";
  var now = DateTime.now();
  var format = DateFormat('HH:mm a');
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + ' ngày trước';
    } else {
      time = diff.inDays.toString() + ' ngày trước';
    }
  } else {
    if (diff.inDays == 7) {
      time = (diff.inDays / 7).floor().toString() + ' tuần trước';
    } else {
      time = (diff.inDays / 7).floor().toString() + ' tuần trước';
    }
  }
  return time;
}
String splitSpace(String content){
  var data = content.split(" ");
  return data[0];
}
Future<String> getLinkStorage(String link) async{
  final ref = FirebaseStorage.instance.ref().child("${link}");
  String url = (await ref.getDownloadURL()).toString();
  return url;
}
String splitSpaceEnd(String content){
  var data = content.split(" ");
  return data[data.length-1];
}
String getDateNow(){
  var now = DateTime.now();
  var formatterDate = DateFormat('dd/MM');
  String actualDate = formatterDate.format(now);
  return actualDate;
}
Timestamp getTimestamp(){
  DateTime currentDate = DateTime.now(); //DateTime
  Timestamp myTimeStamp = Timestamp.fromDate(currentDate);
  return myTimeStamp;
}
String getNameDateNow(){
  var now = DateTime.now();
  var formatterDate = DateFormat('EEEE').format(now);
  return formatterDate.toString();
}
List splitList(String content){
  return content.split(":");
}
String getFileExtension(String fileName) {
  return "." + fileName.split('.').last;
}
Future<void> signOut(BuildContext context) async {
  await SharedPreferencesData.reset();
  await FirebaseAuth.instance.signOut();
  RestartPage.restartApp(context);
}
void listenStatus(BuildContext context, bool value){
  Navigator.pop(context);
  if(value){
    Navigator.pop(context);
    Fluttertoast.showToast(msg: 'Okela');
  }else{
    Fluttertoast.showToast(msg: 'Lỗi');
  }
}
class loadPhoto{
  static Widget networkImage(String? url, double? h, double w) {
    return Container(
      height: h,
      width: w,
      // ignore: unnecessary_null_comparison
      child: url == null
          ? Image.asset(
        Images.photo_notfound,
        height: h,
        width: w,
        fit: BoxFit.cover,
      )
          : Image.network(
          url,
          height: h,
          fit: BoxFit.fill,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(
              child:

              LoadingAnimationWidget.staggeredDotsWave(
                color: AppColors.ultraRed,
                size: 25,
              )
            );
          },
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Image(
              image: AssetImage(  Images.photo_notfound,),
              height: h, fit: BoxFit.fill,);
          }
      ),
    );
  }

  static Widget imageNetworkWrapContent(String? url) {
    return Container(
      // ignore: unnecessary_null_comparison
      child: url == null||url.isEmpty
          ? Image.asset(
        Images.photo_notfound,
        fit: BoxFit.cover,
      )
          : Image.network(
          url,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(
              child:
              LoadingAnimationWidget.staggeredDotsWave(
                color: AppColors.ultraRed,
                size: 25,
              )
            );
          },
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Image(
              image: AssetImage(  Images.photo_notfound,),
              fit: BoxFit.cover,);
          }
      ),
    );
  }
}
String replaceKey(String content, String keyFlow){
  return content.replaceAll(keyFlow, "");
}