import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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

Widget imageClipRRect({String? url,String? urlError,double? width, double? height, double? borderRadius, bool? fitCover}){
  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(borderRadius!=null?borderRadius:50)),
    child: url==null||url.isEmpty?
    Image.asset((urlError==null||urlError.isEmpty)?Images.photo_notfound:urlError,width: width==null?64:width,
      height: height==null?64:height,):Image.network(url,
      width: width==null?64:width,
      height: height==null?64:height,
      fit: fitCover!=null&&fitCover?BoxFit.cover:BoxFit.fill,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Image(
          image: AssetImage(Images.photo_notfound),
          width: width==null?64:width,
          height: height==null?64:height,
          fit: fitCover!=null&&fitCover?BoxFit.cover:BoxFit.fill,);
      },),
  );
}
customDialog(
    {required BuildContext context, IconData? iconData, String? title, required String content}){
  return
    AnimationDialog.generalDialog(context,
      AlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconData!=null? Icon(
      Icons.error_outline,
        color: Colors.red,
        size: 50.0,
      ):SizedBox(),
          title==null||title.isEmpty?SizedBox():NeoText(title, overFlow: TextOverflow.ellipsis, maxline: 2, textAlign: TextAlign.center, textStyle: TextStyle(fontSize: 16, color: AppColors.black, fontWeight: FontWeight.bold)),
        ],
      ),
      content: NeoText(content, overFlow: TextOverflow.ellipsis, maxline: 2, textAlign: TextAlign.center, textStyle: TextStyle(fontSize: 14, color: AppColors.black,)),

      actions: [
        MaterialButton(
          onPressed: ()=>Navigator.pop(context),
          child: NeoText(Languages.of(context).close),
        )
      ],
    )
      ,);
}

showLoaderDialog(BuildContext context){
 return Center(
   child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.ultraRed, size: 50)
 );
}
Widget itemCourseAdmin(BuildContext context, String title, String content, String imageLink,Function(bool click) onClickEdit, Function(bool click) onClickDelete, Function(String id) onClick, bool owned){
  return InkWell(
    onTap: () => onClick(''),
    child: Container(
      height: 300,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: getWidthDevice(context)/2-16,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: AppColors.white,
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
          loadPhoto.networkImage('$imageLink', 150, getWidthDevice(context)),
          SizedBox(height: 16,),
          NeoText('$title', textStyle: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 16, overflow: TextOverflow.ellipsis), maxline: 2),
          SizedBox(height: 8,),
          NeoText(
              'GV: $content',
              textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: AppColors.black,
              ),
              maxline: 2
          ),
          owned==true?Spacer():SizedBox(),
          owned==true?Container(
            width: getWidthDevice(context),
            margin: EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: AppColors.ultraRed,),
                  onPressed: ()=>onClickEdit(true),
                ),
                IconButton(
                  icon: Icon(Icons.delete_forever,color: AppColors.ultraRed,),
                  onPressed: ()=>onClickDelete(true),
                )
              ],
            ),
          ):SizedBox()
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
          color: AppColors.white,
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
          loadPhoto.networkImage('$imageLink', 150, getWidthDevice(context)),
          SizedBox(height: 16,),
          NeoText('$title', textStyle: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 16, overflow: TextOverflow.ellipsis), maxline: 2),
          SizedBox(height: 8,),
          NeoText(
              'GV: $content',
              textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: AppColors.black,
              ),
              maxline: 2
          ),
        ],
      ),
    ),
  );
}
Widget cardWithAdminRole(BuildContext context, String title, String content, String imageLink, String firstDay,String secondDay, String price, Function(bool click) onClickEdit, Function(bool click) onClickDelete, Function(String id) onClick, bool? owned){
  String _salePrice = '';
  _salePrice =price==''?'':(double.parse(price)-double.parse(price)/100*20).round().toString();
  return InkWell(
    onTap: () => onClick(''),
    child: Container(
      height: owned==true?350:300,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width:getWidthDevice(context)/2-16,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: AppColors.white,
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
          loadPhoto.networkImage('$imageLink', 150, getWidthDevice(context)),
          SizedBox(height: 16,),
          NeoText('$title', textStyle: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 16, overflow: TextOverflow.ellipsis), maxline: 2),
          SizedBox(height: 8,),
          NeoText(
              'GV: $content',
              textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: AppColors.black,
              ),
              maxline: 2
          ),
          owned==true?Spacer():SizedBox(),
          SizedBox(height: 8,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NeoText( '${Languages.of(context).time}: ', textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: AppColors.black,
              ),maxline: 1),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NeoText(
                      '$firstDay',
                      textStyle: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.black,
                      ),
                      maxline: 1
                  ),
                  NeoText(
                      '$secondDay',
                      textStyle: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.black,
                      ),
                      maxline: 1
                  ),
                ],
              )
            ],
          ),
      price==''?SizedBox():Text.rich(TextSpan(
        text: 'Giá: ',
        children: <TextSpan>[
          new TextSpan(
            text: '\ $price',
            style: new TextStyle(
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          new TextSpan(
              text: ' \ $_salePrice VNĐ',
              style: TextStyle(fontSize: 12, color: AppColors.ultraRed)
          ),
        ],
      )),
          owned==true?Spacer():SizedBox(),
          owned==true?Container(
            width: getWidthDevice(context),
            margin: EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: AppColors.ultraRed,),
                  onPressed: ()=>onClickEdit(true),
                ),
                IconButton(
                  icon: Icon(Icons.delete_forever,color: AppColors.ultraRed,),
                  onPressed: ()=>onClickDelete(true),
                )
              ],
            ),
          ):SizedBox()
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
      Expanded(child: NeoText(title, textStyle: TextStyle(color: AppColors.ultraRed, fontSize: 14, fontWeight: FontWeight.bold))),
      InkWell(
        onTap: ()=>callback(''),
        child:
        Image.asset(Images.more, height: 25,)
      ),
      SizedBox(width: 8,),
    ],
  );
}
Widget card(BuildContext context, String title, String content, String imageLink, Function(String id) onClick, String firstDay,String secondDay,String price, Function()onClickRegister, bool visiable){
  String _salePrice = '';
  _salePrice =price==''?'':(double.parse(price)-double.parse(price)/100*20).round().toString();
  return InkWell(
    onTap: () => onClick(''),
    child: Container(
      height: 350,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: getWidthDevice(context)/2-16,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: AppColors.white,
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
          loadPhoto.networkImage('$imageLink', 150, getWidthDevice(context)),
          SizedBox(height: 16,),
          NeoText('$title', textStyle: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 16, overflow: TextOverflow.ellipsis), maxline: 2),
          SizedBox(height: 8,),
          NeoText(
              'GV: $content',
              textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: AppColors.black,
              ),
              maxline: 2
          ),
          SizedBox(height: 8,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NeoText( '${Languages.of(context).time}: ', textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: AppColors.black,
              ),maxline: 1),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NeoText(
                      '$firstDay',
                      textStyle: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.black,
                      ),
                      maxline: 1
                  ),
                  NeoText(
                      '$secondDay',
                      textStyle: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.black,
                      ),
                      maxline: 1
                  ),
                ],
              )
            ],
          ),
      price==''?SizedBox():Text.rich(TextSpan(
        text: 'Giá: ',
        children: <TextSpan>[
          new TextSpan(
            text: '\ $price',
            style: new TextStyle(
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          new TextSpan(
              text: ' \ $_salePrice VNĐ',
              style: TextStyle(fontSize: 12, color: AppColors.ultraRed)
          ),
        ],
      )),
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
class StayingAliveWidget extends StatefulWidget{
  Widget child;

  StayingAliveWidget({required this.child});

  @override
  State<StatefulWidget> createState() => _StayingAliveState();

}

class _StayingAliveState extends State<StayingAliveWidget>  with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  _StayingAliveState();

  @override
  bool get wantKeepAlive => true;


}
Widget notfound(String mess){
  return Column(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Image.asset('${Images.photo_notfound}', ),
      SizedBox(height: 8,),
      NeoText(mess, textStyle: TextStyle(color: AppColors.grey, fontSize: 20))
    ],
  );
}
Widget button(BuildContext context, String label, buttonWidth, buttonColor){
  return Container(
    padding: EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(30)
    ),
    alignment: Alignment.center,
    width: buttonWidth,
    child: Text(
      label,
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
}
