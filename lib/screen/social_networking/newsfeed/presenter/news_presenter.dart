import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_learning/common/colors.dart';

import '../../../../common/functions.dart';
import '../../../../common/keys.dart';
import '../../../../common/state.dart';
import '../../../../storage/storage.dart';

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mobx/mobx.dart';
part 'news_presenter.g.dart';

class NewsPresenter = _NewsPresenter with _$NewsPresenter;

abstract class _NewsPresenter with Store {
  @observable
  SingleState state = SingleState.NO_DATA;
  @observable
  SingleState stateSent = SingleState.HAS_DATA;
  @observable
  SingleState stateTopic = SingleState.NO_DATA;
  @observable
  SingleState stateUser = SingleState.LOADING;
  final picker = ImagePicker();
  File? imageFile;


  List<XFile>? images;
  File? mediaUrl;

  @action
  Future<String> getPost(bool camera, BuildContext context) async {
    state = SingleState.LOADING;
    final ImagePicker _picker = ImagePicker();
    images = await _picker.pickMultiImage();
    try {
      PickedFile? pickedFile = await picker.getImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
      );
      File? croppedFile;
      await ImageCropper().cropImage(
        sourcePath: pickedFile!.path,
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
      ).then((value) => {
        mediaUrl = File(croppedFile!.path),
      });
    } catch (e) {}
    return mediaUrl!.path;
  }

  @action
  Future<void> choosePhotoFromGallery(BuildContext context) async {
    state = SingleState.LOADING;
    cropImage(context,
            (value) => {
          if (value == null)
            {
              if (imageFile == null)
                {
                  state = SingleState.NO_DATA,
                }
              else
                {
                  state = SingleState.HAS_DATA,
                }
            }
          else
            {
              imageFile = value,
              state = SingleState.HAS_DATA,
            }
        },
        'GALLERY');
  }



  Future<Map<String, dynamic>> getUserInfo() async{
    dynamic user = await SharedPreferencesData.getData(CommonKey.USER);
    Map<String, dynamic> userData = jsonDecode(user.toString());
    user = userData;
    return userData;
  }

  void deletePost(String idNews){
    FirebaseFirestore.instance.collection('news').doc(idNews).delete();
  }
}
