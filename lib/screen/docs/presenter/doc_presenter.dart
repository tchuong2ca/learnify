import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../common/functions.dart';
import '../../../common/keys.dart';
import '../../../storage/storage.dart';
import '../model/doc_content.dart';


class CreateDocPresenter{

  Future<String> uploadPDFFile(File file, String fileName) async{
    String url = '';
    String path = '${CommonKey.DOCUMENT}/${fileName}/${getCurrentTime()}/$fileName';
    final reference = FirebaseStorage.instance.ref().child('$path');

    final uploadTask = await reference.putData(file.readAsBytesSync()).then((p0) {

    }).catchError((onError){
      return url;
    });

    url = await getLinkStorage(path).then((value) => url=value);

    return url;
  }

  Future<bool> createDoc({required File imageFile, required DocContent document}) async{
    final metadata = SettableMetadata(contentType: "image/jpeg");
    final storageRef = FirebaseStorage.instance.ref();
    String path = '${CommonKey.DOCUMENT}/${document.name}/${document.id}/${getCurrentTime()}..jpg';
    await storageRef
        .child("$path")
        .putFile(imageFile, metadata).whenComplete(() async{
      document.imageUrl = await getLinkStorage(path).then((value) => document.imageUrl=value);
      Map<String, dynamic> data = document.toJson();
      FirebaseFirestore.instance.collection('documents').doc(document.id).set(data).whenComplete(() => true);
    });
    return true;
  }

  Future<Map<String, dynamic>> getAccountInfor() async{
    dynamic user = await SharedPreferencesData.GetData(CommonKey.USER);
    Map<String, dynamic> userData = jsonDecode(user.toString());
    user = userData;
    return userData;
  }

  void DeleteDoc(DocContent document){
    FirebaseFirestore.instance.collection('documents').doc(document.id).delete();
  }


  Future<bool> updateDocContent({File? imageFile, required DocContent document}) async{
    if(imageFile!=null){
      final metadata = SettableMetadata(contentType: "image/jpeg");
      final storageRef = FirebaseStorage.instance.ref();
      String path = '${CommonKey.DOCUMENT}/${document.name}/${document.id}/${getCurrentTime()}..jpg';
      await storageRef
          .child("$path")
          .putFile(imageFile, metadata).whenComplete(() async{
        document.imageUrl = await getLinkStorage(path).then((value) => document.imageUrl=value);
      });
    }
    List<Map<String, dynamic>> dataDocument =[];
    document.docsList!.forEach((element) => dataDocument.add(element.toJson()));
    await FirebaseFirestore.instance.collection('documents').doc(document.id).update({
      'imageUrl': document.imageUrl,
      'name': document.name,
      'docsList':dataDocument
    });
    return true;
  }
}