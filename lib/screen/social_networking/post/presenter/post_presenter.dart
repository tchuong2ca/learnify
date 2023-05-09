
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
  List<ImageModel> getListImage(List<ImageModel> list, List<File> listFile){
    List<ImageModel> imageList = list;
    for(File f in listFile){
      imageList.add(ImageModel(fileImage: f));
    }
    return imageList;
  }

  String _url='';
  Future<String> upLoadImage(File file, String username) async{
    final metadata = SettableMetadata(contentType: "image/jpeg");
    final storageRef = FirebaseStorage.instance.ref();
    String path = 'social/$username/${getCurrentTime()}.jpg';
    await storageRef
        .child("$path")
        .putFile(file, metadata).whenComplete(() async{
      _url= await getLinkStorage(path).then((value) => _url=value);
    });
    return _url;
  }

  List<String> _imageList = [];
  Future<List<String>> getLink(List<ImageModel> listImage,Posts news)async{
    for(ImageModel model in listImage){
      String url = await upLoadImage(model.fileImage!, news.username!);
      _imageList.add(url);
    }
    return _imageList;
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

  Future<Info> getAccountInfor() async{
    dynamic user = await SharedPreferencesData.GetData(CommonKey.USER);
    Map<String, dynamic>json = jsonDecode(user.toString());

    Info person = Info(fullname: json['fullname'], avatar: json['avatar'],
     phone: json['phone']);
    return person;
  }

  List<ImageModel> getImageUpdate(List<dynamic> listImage){
    List<ImageModel> listImageModel = [];
    for(dynamic list in listImage){
      listImageModel.add(ImageModel(imageLink: list));
    }
    return listImageModel;
  }

  Future<bool> UpdatePost({required String idNews,required List<ImageModel> listModel, required List<dynamic> listLink,required String description, required Posts news})async{
    List<ImageModel> listModelFile = await listModel.where((element) => element.fileImage!=null).toList();
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