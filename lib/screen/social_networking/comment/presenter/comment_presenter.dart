
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_learning/screen/social_networking/comment/model/comment_model.dart';

import '../../../../common/functions.dart';
import '../../../../common/keys.dart';

class CommentPresenter{
  Future sendMessage({required String idNews,required Comment comment, File? imageFile, required type}) async{
    if(imageFile!=null){
      final metadata = SettableMetadata(contentType: "image/jpeg");
      final storageRef = FirebaseStorage.instance.ref();
      String path = 'comment/${idNews}/${comment.name}/${getCurrentTime()}.jpg';
      await storageRef
          .child("$path")
          .putFile(imageFile, metadata).whenComplete(() async{
        comment.imageLink = await getLinkStorage(path).then((value) => comment.imageLink=value);
        CommonKey.UPDATE_CHILD==type
            ?updateCommentReply(comment, idNews)
            :_postComment(comment, idNews);
      });
    }else{
      CommonKey.UPDATE_CHILD==type
          ?updateCommentReply(comment, idNews)
          :_postComment(comment, idNews);
    }
  }


  Future<String> getPhotoLink({required String idNews,required Comment comment, required File imageFile}) async{
    String linkUrl = '';
    final metadata = SettableMetadata(contentType: "image/jpeg");
    final storageRef = FirebaseStorage.instance.ref();
    String path = 'comment/${idNews}/${comment.name}/${getCurrentTime()}.jpg';
    await storageRef
        .child("$path")
        .putFile(imageFile, metadata).whenComplete(() async{
      linkUrl = await getLinkStorage(path).then((value) => comment.imageLink=value);
    });
    return linkUrl;
  }
  void _postComment(Comment comment, String idNews){
    Map<String, dynamic> commentList = comment.toJson();
    FirebaseFirestore.instance.collection('comment').doc(idNews).collection(idNews).add(commentList).then((value) {
      FirebaseFirestore.instance.collection('comment').doc(idNews).collection(idNews).doc(value.id).update({
        'id':value.id
      });
    });
  }

  void updateCommentReply(Comment comment, String idNews){
    List<Map<String, dynamic>> listComment = [];
    comment.listComment!.forEach((element) => listComment.add(element.toJson()));
    FirebaseFirestore.instance.collection('comment').doc(idNews).collection(idNews).doc(comment.id).update({
      'listComment': listComment
    });
  }

  void deleteComment(Comment comment, String idNews){
    FirebaseFirestore.instance.collection('comment').doc(idNews).collection(idNews).doc(comment.id).delete();
  }
}