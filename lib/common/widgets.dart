import 'dart:io';

import 'package:flutter/material.dart';

import '../languages/languages.dart';
import '../res/images.dart';
import 'colors.dart';
import 'functions.dart';
Widget NeoText(String content, {textStyle, maxline, overFlow, textAlign}){
  return Text(
    content,
    style: textStyle,
    maxLines: maxline,
    textScaleFactor: 1.0,
    overflow: overFlow,
    textAlign: textAlign,
  );
}
// Widget LoadingView(){
//   return SpinKitCircle(
//     color: Colors.blue,
//     size: 75.0,
//   );
// }
Widget imageClipRRect({String? url,String? urlError,double? width, double? height, double? borderRadius, bool? fitCover}){
  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(borderRadius!=null?borderRadius:50)),
    child: url==null||url.isEmpty?
    Image.asset((urlError==null||urlError.isEmpty)?Images.tutorial1:urlError,width: width==null?64:width,
      height: height==null?64:height,):Image.network(url,
      width: width==null?64:width,
      height: height==null?64:height,
      fit: fitCover!=null&&fitCover?BoxFit.cover:BoxFit.fill,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Image(
          image: AssetImage(Images.tutorial1),
          width: width==null?64:width,
          height: height==null?64:height,
          fit: fitCover!=null&&fitCover?BoxFit.cover:BoxFit.fill,);
      },),
  );
}
CustomDialog(
    {required BuildContext context, IconData? iconData, String? title, required String content}){
  return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconData!=null?Icon(
                iconData,
                color: CommonColor.yellowDeep,
                size: 80,
              ):SizedBox(),
              title==null||title.isEmpty?SizedBox():NeoText(title, overFlow: TextOverflow.ellipsis, maxline: 2, textAlign: TextAlign.center, textStyle: TextStyle(fontSize: 16, color: CommonColor.black, fontWeight: FontWeight.bold)),
            ],
          ),
          content: NeoText(content, overFlow: TextOverflow.ellipsis, maxline: 2, textAlign: TextAlign.center, textStyle: TextStyle(fontSize: 14, color: CommonColor.black,)),

          actions: [
            MaterialButton(
              onPressed: ()=>Navigator.pop(context),
              child: NeoText(Languages.of(context).close),
            )
          ],
        );
      }
  );
}

showLoaderDialog(BuildContext context){
  AlertDialog alert=AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
      ],),
  );
  showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}
Widget itemCourseAdmin(BuildContext context, String title, String content, String imageLink,Function(bool click) onClickEdit, Function(bool click) onClickDelete, Function(String id) onClick){
  return InkWell(
    onTap: () => onClick(''),
    child: Container(
      height: 300,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: getWidthDevice(context)/2-16,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: CommonColor.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3),
            )
          ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageLoad.imageNetwork('$imageLink', 150, getWidthDevice(context)),
          SizedBox(height: 16,),
          NeoText('$title', textStyle: TextStyle(color: CommonColor.black, fontWeight: FontWeight.bold, fontSize: 16, overflow: TextOverflow.ellipsis), maxline: 2),
          SizedBox(height: 8,),
          NeoText(
              'GV: $content',
              textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: CommonColor.black,
              ),
              maxline: 2
          ),
          Spacer(),
          Container(
            width: getWidthDevice(context),
            margin: EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: CommonColor.blue,),
                  onPressed: ()=>onClickEdit(true),
                ),
                IconButton(
                  icon: Icon(Icons.delete_forever,color: CommonColor.blue,),
                  onPressed: ()=>onClickDelete(true),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
Widget itemCourse(BuildContext context, String title, String content, String imageLink, Function(String id) onClick){
  return InkWell(
    onTap: () => onClick(''),
    child: Container(
      height: 270,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: getWidthDevice(context)/2-16,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: CommonColor.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3),
            )
          ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageLoad.imageNetwork('$imageLink', 150, getWidthDevice(context)),
          SizedBox(height: 16,),
          NeoText('$title', textStyle: TextStyle(color: CommonColor.black, fontWeight: FontWeight.bold, fontSize: 16, overflow: TextOverflow.ellipsis), maxline: 2),
          SizedBox(height: 8,),
          NeoText(
              'GV: $content',
              textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: CommonColor.black,
              ),
              maxline: 2
          ),
        ],
      ),
    ),
  );
}
Widget itemCourseAdminHours(BuildContext context, String title, String content, String imageLink, String time, Function(bool click) onClickEdit, Function(bool click) onClickDelete, Function(String id) onClick){
  return InkWell(
    onTap: () => onClick(''),
    child: Container(
      height: 330,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width:getWidthDevice(context)/2-16,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: CommonColor.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3),
            )
          ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageLoad.imageNetwork('$imageLink', 150, getWidthDevice(context)),
          SizedBox(height: 16,),
          NeoText('$title', textStyle: TextStyle(color: CommonColor.black, fontWeight: FontWeight.bold, fontSize: 16, overflow: TextOverflow.ellipsis), maxline: 2),
          SizedBox(height: 8,),
          NeoText(
              'GV: $content',
              textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: CommonColor.black,
              ),
              maxline: 2
          ),
          Spacer(),
          SizedBox(height: 8,),
          NeoText(
              '${Languages.of(context).time}: $time',
              textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: CommonColor.black,
              ),
              maxline: 2
          ),
          Spacer(),
          Container(
            width: getWidthDevice(context),
            margin: EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: CommonColor.blue,),
                  onPressed: ()=>onClickEdit(true),
                ),
                IconButton(
                  icon: Icon(Icons.delete_forever,color: CommonColor.blue,),
                  onPressed: ()=>onClickDelete(true),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
Widget itemSeeMore(BuildContext context, String title, Function(String call) callback){
  return  Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(width: 8,),
      Expanded(child: NeoText(title, textStyle: TextStyle(color: CommonColor.blue, fontSize: 14, fontWeight: FontWeight.bold))),
      InkWell(
        onTap: ()=>callback(''),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NeoText(Languages.of(context).seeMore, textStyle: TextStyle(color: CommonColor.blue, fontWeight: FontWeight.bold)),
            Icon(Icons.double_arrow, color: CommonColor.blue,)
          ],
        ),
      ),
      SizedBox(width: 8,),
    ],
  );
}
Widget itemCourseHours(BuildContext context, String title, String content, String imageLink, Function(String id) onClick, String time, Function()onClickRegister, bool visiable){
  return InkWell(
    onTap: () => onClick(''),
    child: Container(
      height: 330,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: getWidthDevice(context)/2-16,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: CommonColor.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3),
            )
          ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageLoad.imageNetwork('$imageLink', 150, getWidthDevice(context)),
          SizedBox(height: 16,),
          NeoText('$title', textStyle: TextStyle(color: CommonColor.black, fontWeight: FontWeight.bold, fontSize: 16, overflow: TextOverflow.ellipsis), maxline: 2),
          SizedBox(height: 8,),
          NeoText(
              'GV: $content',
              textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: CommonColor.black,
              ),
              maxline: 2
          ),
          SizedBox(height: 8,),
          NeoText(
              '${Languages.of(context).time}: $time',
              textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: CommonColor.black,
              ),
              maxline: 1
          ),
          Spacer(),
          Visibility(
            visible: visiable,
            child: Container(
              width: getWidthDevice(context),
              margin: EdgeInsets.only(left: 8, right: 8),
              child: ElevatedButton(
                onPressed: ()=>onClickRegister(),
                child: NeoText(Languages.of(context).signUp),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

