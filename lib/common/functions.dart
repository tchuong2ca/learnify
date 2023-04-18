import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
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
            toolbarColor: CommonColor.blue,
            toolbarWidgetColor: CommonColor.white,
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
String getDateWeek(int day){
  var d = DateTime.now();
  var weekDay = d.weekday;
  var date = d.subtract(Duration(days: weekDay-day));
  var formatterDate = DateFormat('dd/MM');
  String value = formatterDate.format(date);

  return value;
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

String getNameDateNow(){
  var now = DateTime.now();
  var formatterDate = DateFormat('EEEE').format(now);
  return formatterDate.toString();
}
List splitList(String content){
  return content.split(":");
}
Future<void> signOut(BuildContext context) async {
  await SharedPreferencesData.DeleteAll();
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
class ImageLoad{
  static Widget imageNetwork(String? url, double? h, double w) {
    return Container(
      height: h,
      width: w,
      // ignore: unnecessary_null_comparison
      child: url == null
          ? Image.asset(
        Images.tutorial1,
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
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
              ),
            );
          },
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Image(
              image: AssetImage(  Images.tutorial1,),
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
        Images.tutorial1,
        fit: BoxFit.cover,
      )
          : Image.network(
          url,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
              ),
            );
          },
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Image(
              image: AssetImage(  Images.tutorial1,),
              fit: BoxFit.cover,);
          }
      ),
    );
  }
}