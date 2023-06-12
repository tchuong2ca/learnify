import 'package:flutter/material.dart';
import 'package:online_learning/common/colors.dart';
import 'package:online_learning/common/functions.dart';
import 'package:online_learning/common/widgets.dart';
import 'package:online_learning/screen/social_networking/newsfeed/view_photo.dart';
import '../../animation_page.dart';
import '../../../external/switch_page_animation/enum.dart';
import '../../../res/images.dart';


class NewsDetailPage extends StatelessWidget {
  Map<String, dynamic>? data;
  NewsDetailPage(this.data);

  @override
  Widget build(BuildContext context) {
    List<dynamic> listImage = data!['mediaUrl'];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8,),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 4,),
                      ClipOval(
                        child: loadPhoto.networkImage(data!['userAvatar']!=null?data!['userAvatar']:'', 50, 50),
                      ),
                      SizedBox(width: 4,),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            NeoText(data!['fullname']!=null?data!['fullname']:'', textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.black)),
                            NeoText(data!['timestamp']!=null?postedTime(data!['timestamp']):'', textStyle: TextStyle(fontSize: 12, color: AppColors.lightBlack)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: NeoText(data!['description']!=null?data!['description']:'', textStyle: TextStyle(color: AppColors.black, fontSize: 14,)),
                  ),
                  Wrap(
                    children: List.generate(listImage.length, (index) => InkWell(
                        onTap: ()=>  Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade, widget: MediaPageView(data!['mediaUrl'], index))),
                        child: Column(
                          children: [
                            listImage[index].toString().contains('mp4')?
                            Image.asset(Images.horizontalplaybtn,):
                            loadPhoto.imageNetworkWrapContent(listImage[index] != null ? listImage[index] : ''),
                            Divider()
                          ],
                        ))),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}