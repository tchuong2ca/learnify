import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_learning/screen/lesson/model/lesson_detail.dart';

import '../../../../common/functions.dart';
import '../../../../common/keys.dart';
import '../../../../storage/storage.dart';
import '../../model/discuss.dart';

class DiscussPresenter{

  Future<Map<String, dynamic>> getAccountInfo() async{
    dynamic user = await SharedPreferencesData.GetData(CommonKey.USER);
    Map<String, dynamic> userData = jsonDecode(user.toString());
    user = userData;
    return userData;
  }

  Future SendChat({required LessonDetail lessonDetail, required Discuss discuss, File? imageFile}) async{
    lessonDetail.discuss!.add(discuss);
    if(imageFile!=null){
      final metadata = SettableMetadata(contentType: "image/jpeg");
      final storageRef = FirebaseStorage.instance.ref();
      String path = 'discuss/${lessonDetail.nameLesson}/${discuss.name}/${getCurrentTime()}.jpg';
      await storageRef
          .child("$path")
          .putFile(imageFile, metadata).whenComplete(() async{
        discuss.imageLink = await getLinkStorage(path).then((value) => discuss.imageLink=value);
        PostData(lessonDetail);
      });
    }else{
      PostData(lessonDetail);
    }
  }

  void PostData(LessonDetail lessonDetail){
    List<Map<String, dynamic>> dataDiscuss =[];
    lessonDetail.discuss!.forEach((element) => dataDiscuss.add(element.toJson()));
    print(dataDiscuss);
    FirebaseFirestore.instance.collection('lesson_detail').doc(lessonDetail.idLessonDetail).update({
      'discuss': dataDiscuss
    });
  }
}