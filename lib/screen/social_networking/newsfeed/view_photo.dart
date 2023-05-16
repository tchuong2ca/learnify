import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_learning/common/colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

import '../../../common/widgets.dart';

class MediaPageView extends StatefulWidget{
  List<dynamic>? _listImage;
  int? _postion;

  MediaPageView(this._listImage, this._postion);

  @override
  State createState() {
    return _PhotosPageView(_listImage, _postion);
  }
}

class _PhotosPageView extends State<MediaPageView>{
  List<dynamic>? _listMedia;
  int? _postion;
  late VideoPlayerController _videoController;
  _PhotosPageView(this._listMedia, this._postion);
  PageController? _controller;
  @override
  void initState() {
    _controller = PageController(initialPage: _postion!);

    _videoController = VideoPlayerController.network(_listMedia![_postion!])
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
      });
    _videoController.addListener(checkVideo);
  }
  void checkVideo(){
    // Implement your calls inside these conditions' bodies :

    if(_videoController.value.position == _videoController.value.duration) {
      setState(() {
        _videoController.play();
      });
    }

  }
  @override
  void dispose(){
    _controller?.dispose();
    _videoController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: AppColors.black,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [

            Expanded(child: Center(
              child:
              _listMedia![_postion!].toString().contains('mp4')?Container(
                margin: EdgeInsets.only(top: 52, bottom: 16),
                  // width: MediaQuery.of(context).size.width/4,
                  // height: (MediaQuery.of(context).size.width/4)/3*5,

                  child: _videoController.value.isInitialized
                      ? VideoPlayer(_videoController)
                      : const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  )
              )
              :PageView.builder(
                  itemCount: _listMedia!.length,
                  controller: _controller,
                  itemBuilder: (BuildContext context, int index) {
                    if(_listMedia![index] is File){
                      return _itemImageFile(_listMedia![index], _listMedia!,index);
                    }
                    return _itemImage(_listMedia![index], _listMedia!, index);
                  },
                  onPageChanged: (int index) {

                  }),
            ))
          ],),
      ),
    );
  }


  Widget _itemImage(String url, List listImg, int index){
    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: Center(
            child: new PhotoView(
              imageProvider: CachedNetworkImageProvider(url),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2,
            ),
          ),
        ),
        Align(alignment: Alignment.topLeft,
          child: Padding(padding: EdgeInsets.only(top: 50, left: 12),
            child: InkWell(
                highlightColor: AppColors.transparent,
                splashColor: AppColors.transparent,
                onTap: ()=>{
                  Navigator.of(context).pop(),
                },
                child:Icon(Icons.close,color: AppColors.white,)),),),
        Align(alignment: Alignment.topCenter,
          child: Padding(padding: EdgeInsets.only(top: 58),
            child: NeoText('${(index+1).toString()}/${listImg.length}',textStyle: TextStyle(color: AppColors.white)),),)
      ],
    );
  }

  Widget _itemImageFile(File url, List listImg, int index){
    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: Center(
            child: new PhotoView(
              imageProvider: FileImage(url),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2,
            ),
          ),
        ),
        Align(alignment: Alignment.topLeft,
          child: Padding(padding: EdgeInsets.only(top: 50, left: 12),
            child: InkWell(
                highlightColor: AppColors.transparent,
                splashColor: AppColors.transparent,
                onTap: ()=>{
                  Navigator.of(context).pop(),
                },
                child:Icon(Icons.close,color: AppColors.white,)),),),
        Align(alignment: Alignment.topCenter,
          child: Padding(padding: EdgeInsets.only(top: 58),
            child: NeoText('${(index+1).toString()}/${listImg.length}',textStyle: TextStyle(color: AppColors.white)),),)
      ],
    );
  }
}