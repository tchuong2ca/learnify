
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_learning/screen/personal/model/info.dart';

import '../../../../common/functions.dart';
import '../../../../common/keys.dart';
import '../../../../storage/storage.dart';
import '../model/image.dart';
import '../model/posts.dart';

class PostPresenter {
  List<FileModel> getFileList(List<FileModel> list, List<File> listFile){
    List<FileModel> fileList = list;
    for(File f in listFile){
      fileList.add(FileModel(fileImage: f));
    }
    return fileList;
  }

  List<String> _fileList = [];
  Future<List<String>> getLink(List<FileModel> fileList,Posts news)async{
    for(FileModel model in fileList){
      String url = await uploadFile(model.fileImage!, news.username!);
      _fileList.add(url);
    }
    return _fileList;
  }
  String _url='';
  Future<String> uploadFile(File file, String username) async{
    final metadata = SettableMetadata(contentType: getFileExtension(file.path)=='.mp4'?"video/mp4":"image/jpeg");
    final storageRef = FirebaseStorage.instance.ref();
    String path = getFileExtension(file.path)=='.mp4'?'social/$username/${getCurrentTime()}.mp4':'social/$username/${getCurrentTime()}.jpg';
    await storageRef
        .child("$path")
        .putFile(file, metadata).whenComplete(() async{
      _url= await getLinkStorage(path).then((value) => _url=value);
    });
    return _url;
  }



  Future<bool> createNewPost( List<String> imageList, Posts news) async{

    DateTime currentPhoneDate = DateTime.now(); //DateTime
    Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
    CollectionReference postNews = FirebaseFirestore.instance.collection('news');
    postNews.add(
        {
          "comments": 0,
          "description": news.description,
          "fullname": news.fullname,
          "mediaUrl": imageList,
          "timestamp": myTimeStamp,
          "userAvatar": news.userAvatar,
          "username": news.username,
          "user_likes": []
        }
    ).then((value) {
      postNews.doc(value.id).update({"id": value.id});
    }).catchError((onError)=>false);
    return true;
  }

  Future<Info> getAccountInfo() async{
    dynamic user = await SharedPreferencesData.getData(CommonKey.USER);
    Map<String, dynamic>json = jsonDecode(user.toString());

    Info person = Info(fullname: json['fullname'], avatar: json['avatar'],
     phone: json['phone']);
    return person;
  }

  List<FileModel> getImageUpdate(List<dynamic> listImage){
    List<FileModel> listImageModel = [];
    for(dynamic list in listImage){
      listImageModel.add(FileModel(imageLink: list));
    }
    return listImageModel;
  }

  Future<bool> updatePost({required String idNews,required List<FileModel> listModel, required List<dynamic> listLink,required String description, required Posts news})async{
    List<FileModel> listModelFile = await listModel.where((element) => element.fileImage!=null).toList();
    if(listModelFile.length>0){
      List<String> listLinkImage = await getLink(listModelFile, news);
      listLink.addAll(listLinkImage);
      print(listLink);
    }

    await FirebaseFirestore.instance.collection('news').doc(idNews).update({
      'mediaUrl': listLink,
      'description': description
    }).whenComplete(() => true).catchError((onError)=> false);
    return true;
  }
}