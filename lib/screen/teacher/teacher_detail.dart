import 'package:flutter/material.dart';

import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/widgets.dart';
import '../../external/flutter_rating_stars/flutter_rating_stars.dart';
import '../../languages/languages.dart';
import '../../res/images.dart';

class TeacherDetailUI extends StatefulWidget {
  Map<String, dynamic>? _data;
   TeacherDetailUI(this._data) ;

  @override
  State<TeacherDetailUI> createState() => _TeacherDetailUIState(_data);
}

class _TeacherDetailUIState extends State<TeacherDetailUI> {
  Map<String, dynamic>? _data;
  _TeacherDetailUIState(this._data);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0,),
      body: Column(
        children: [
          Expanded(child: SingleChildScrollView(
            child: Column(children: [
              Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(image: new AssetImage(Images.tabBar), fit: BoxFit.fill,),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: NeoText(_data!['fullname'],textStyle: TextStyle(fontSize: 30,color: AppColors.black) ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 8,bottom: 8,right:8,left: 8 ),
                      child: NeoText('Giáo viên môn ${_data!['specialize']}',textStyle: TextStyle(fontSize: 16,color: AppColors.black),maxline: 2),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8,right: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _itemDetail(
                              AssetImage(Images.book),'${Languages.of(context).specialize}:',_data!['specialize']!=null?_data!['specialize']:'',
                              AssetImage(Images.gmail),'${Languages.of(context).email}:',_data!['email']!=null?_data!['email']:''),
                          Padding(padding: EdgeInsets.all(10)),
                          _itemDetail(
                              AssetImage(Images.like),'5.0','',
                              AssetImage(Images.level),'${Languages.of(context).level}:',_data!['exp']!=null?_data!['exp']:'',value: 5.0),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      height: 120,
                      child:_data!['avatar'] == null
                          ? ClipRRect(child: Image.asset(Images.question_mark,width: 120,),borderRadius: BorderRadius.all(Radius.circular(5000)),)
                          : ClipRRect(child: Image.network(
                        _data!['avatar'].toString(),
                        width: 120,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return Image(
                            image: AssetImage(Images.question_mark),
                            width: 120, fit: BoxFit.cover,);
                        },
                        fit: BoxFit.cover,
                      ),borderRadius: BorderRadius.all(Radius.circular(5000))),),
                    SizedBox(height: 15,),
                    Container(
                      height: 138,
                      padding: EdgeInsets.only(top: 16,bottom: 16,right: 8,left: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.lightGrey
                                    .withOpacity(0.2),
                                spreadRadius: 1,
                                offset: Offset(0, 0))
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(Images.ratestar,width: 60,height: 46,),
                          _data!['exp'] != null?
                          NeoText('${_data!['exp']}',textStyle: TextStyle(fontSize: 16,color: AppColors.orange_primary),maxline: 1)
                              : NeoText('5+',textStyle: TextStyle(fontSize: 14,color: AppColors.orange_primary_2)),
                          NeoText('Kinh nghiệm',textStyle: TextStyle(fontSize: 14,color: AppColors.black))
                        ],),
                    )
                  ],
                ),
              ),

              Padding(
                  padding: const EdgeInsets.only(top:20,bottom: 10,right: 8,left: 8 ),
                  child: NeoText(Languages.of(context).teacherInfo,textStyle: TextStyle(fontSize: 20,color: AppColors.black))
              ),
              Container(
                margin: EdgeInsets.only(right: 8,left: 8,bottom: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(
                        Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(color: AppColors.lightGrey.withOpacity(0.2), spreadRadius: 1, offset: Offset(0, 0))]),
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                        alignment: Alignment.topCenter,
                        child: Text(_data!['intro'])
                    )
                ),
              ),

            ],),
          ))],
      ),
    );
  }
  Widget _itemDetail(AssetImage? image,String? skill,String? skillValue,AssetImage? image2,String? skill2,String? skillValue2,{double? value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Image(
                image: image!,
                width: 30,
                height: 30,
              ),
            ),
            value != null ?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NeoText(skill!,textStyle: TextStyle(fontSize: 14,color: AppColors.black)),
                Container(
                  padding: EdgeInsets.only(bottom: 4),
                  width:getWidthDevice(context)/2 - 50,
                  child: RatingStars(
                    value: value,
                    onValueChanged: (v) {
                      setState(() {
                        value = v;
                      });
                    },
                    starBuilder: (index, color) => Icon(Icons.star, color: color,size: 12),
                    starCount: 5,
                    starSize: 12,
                    maxValue: 5,
                    starSpacing: 4,
                    maxValueVisibility: false,
                    valueLabelVisibility: false,
                    animationDuration: Duration(milliseconds: 1000),
                    valueLabelPadding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    valueLabelMargin: const EdgeInsets.only(right: 0),
                    starOffColor: AppColors.orange,
                    starColor: AppColors.orange,
                  ),
                ),
              ],)
                :Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NeoText(skill!,textStyle: TextStyle(fontSize: 14,color: AppColors.black)),
                Container(
                    width:getWidthDevice(context)/2 - 50,
                    child: NeoText(skillValue!,textStyle: TextStyle(fontSize: 14,color: AppColors.black),maxline: 1)),
              ],)
          ],),
        SizedBox(height: 8,),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 2),
              child:Image(
                image: image2!,
                width: 30,
                height: 30,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NeoText(skill2!,textStyle: TextStyle(fontSize: 14,color: AppColors.black)),
                Container(
                    width:getWidthDevice(context)/2 - 50,
                    child: NeoText(skillValue2!,textStyle: TextStyle(fontSize: 14,color: AppColors.black),maxline: 1)),
              ],)
          ],),
      ],
    );
  }
}
