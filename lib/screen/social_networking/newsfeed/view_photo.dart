import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_learning/common/colors.dart';
import 'package:photo_view/photo_view.dart';

import '../../../common/widgets.dart';

class PhotosPageView extends StatefulWidget{
  List<dynamic>? _listImage;
  int? _postion;

  PhotosPageView(this._listImage, this._postion);

  @override
  State createState() {
    return _PhotosPageView(_listImage, _postion);
  }
}

class _PhotosPageView extends State<PhotosPageView>{
  List<dynamic>? _listImage;
  int? _postion;

  _PhotosPageView(this._listImage, this._postion);
  PageController? _controller;
  @override
  void initState() {
    _controller = PageController(initialPage: _postion!);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: CommonColor.black,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [

            Expanded(child: Center(
              child: PageView.builder(
                  itemCount: _listImage!.length,
                  controller: _controller,
                  itemBuilder: (BuildContext context, int index) {
                    if(_listImage![index] is File){
                      return _itemImageFile(_listImage![index], _listImage!,index);
                    }
                    return _itemImage(_listImage![index], _listImage!, index);
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
                highlightColor: CommonColor.transparent,
                splashColor: CommonColor.transparent,
                onTap: ()=>{
                  Navigator.of(context).pop(),
                },
                child:Icon(Icons.close,color: CommonColor.white,)),),),
        Align(alignment: Alignment.topCenter,
          child: Padding(padding: EdgeInsets.only(top: 58),
            child: NeoText('${(index+1).toString()}/${listImg.length}',textStyle: TextStyle(color: CommonColor.white)),),)
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
                highlightColor: CommonColor.transparent,
                splashColor: CommonColor.transparent,
                onTap: ()=>{
                  Navigator.of(context).pop(),
                },
                child:Icon(Icons.close,color: CommonColor.white,)),),),
        Align(alignment: Alignment.topCenter,
          child: Padding(padding: EdgeInsets.only(top: 58),
            child: NeoText('${(index+1).toString()}/${listImg.length}',textStyle: TextStyle(color: CommonColor.white)),),)
      ],
    );
  }
}