import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_learning/common/widgets.dart';
import 'package:online_learning/screen/social_networking/newsfeed/presenter/news_presenter.dart';
import 'package:online_learning/screen/social_networking/newsfeed/view_photo.dart';

import '../../../common/colors.dart';
import '../../../common/functions.dart';
import '../../../common/keys.dart';
import '../../../common/menu_enum.dart';
import '../../../external/switch_page_animation/enum.dart';
import '../../../languages/languages.dart';
import '../../../res/images.dart';
import '../../animation_page.dart';
import '../../personal/personal_page.dart';
import '../chat/chat_list.dart';
import '../chat/chat_room.dart';
import '../comment/comment_page.dart';
import '../post/post_page.dart';
import 'news_detail.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
class NewsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NewsPage();
  }

}

class _NewsPage extends State<NewsPage>{
  Stream<QuerySnapshot>? _stream;
  Stream<DocumentSnapshot>? _streamUser;
  String _username = '';
  Map<String, dynamic>? _userData;
  NewsPresenter? _presenter;
  @override
  void initState() {
    _stream = FirebaseFirestore.instance.collection('news').orderBy('timestamp',descending: true).snapshots();
    _presenter = NewsPresenter();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: getWidthDevice(context),
            height: 52,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.tabBar),
                fit: BoxFit.fill,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 8,),
               IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: AppColors.ultraRed,)),
                SizedBox(width: 8,),
                Expanded(child: NeoText(Languages.of(context).qa, textStyle: TextStyle(color: AppColors.ultraRed, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                IconButton(
                  onPressed:()=> Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade, widget: ChatListPage(_userData))),
                  icon: Icon(Icons.message, color: AppColors.ultraRed,),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  StreamBuilder<QuerySnapshot>(
                    stream: _stream,
                    builder: (context, snapshot){
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.ultraRed, size: 50),);
                      }else if(snapshot.hasError){
                        return Center(child: Text('No data...'),);
                      }else{
                        return Wrap(
                          children: snapshot.data!.docs.map((DocumentSnapshot document) {
                            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                            return StayingAliveWidget(child: _newsItem(data));
                          }).toList(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _header(){
    return StreamBuilder<DocumentSnapshot>(
      stream: _streamUser,
      builder: (context, snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return SizedBox();
        }else if(snapshot.hasError){
          return SizedBox();
        } else if(!snapshot.hasData){
          return SizedBox();
        }else{
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          //print(data);
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(width: 8,),
                  InkWell(child:   ClipOval(
                    child: loadPhoto.networkImage(data['avatar']!=null?data['avatar']:'', 50, 50),
                  ),onTap: (){
                     Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade, widget: PersonalPage(data['role']!)));
                  },),
                  SizedBox(width: 8.0,),
                  InkWell(onTap: (){
                     Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade, widget: PostPage('',null)));
                  },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: getWidthDevice(context)-66,
                      height: 50,
                      //color: AppColors.orangePeel,
                      child: NeoText(Languages.of(context).whatsinyourmind, textStyle: TextStyle(fontSize: 14, color: AppColors.black)),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 8,),
            ],
          );
        }
      },
    );
  }

  Widget _newsItem(Map<String, dynamic> data){
    List<dynamic> listImage = data['mediaUrl'];
    List<dynamic> likes = data['user_likes'];
    bool isLike = false;
    if (likes.length > 0) {
      for (int i = 0; i < likes.length; i++) {
        if (likes[i] == _username) {
          isLike = true;
        }
      }
    }
    int _likeCounter = likes.length;
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 4,),
              ClipOval(
                child: loadPhoto.networkImage(data['userAvatar']!=null?data['userAvatar']:'', 50, 50),
              ),
              SizedBox(width: 4,),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    NeoText(data['fullname']!=null?data['fullname']:'', textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.black)),
                    NeoText(data['timestamp']!=null?postedTime(data['timestamp']):'', textStyle: TextStyle(fontSize: 12, color: AppColors.lightBlack)),
                  ],
                ),
              ),
              data['username']!=null && data['username'] == _username
                  ?PopupMenuButton<MenuEnum>(
                itemBuilder: (context)=>[
                  PopupMenuItem(
                    child: NeoText(
                        Languages.of(context).edit,
                        textStyle: TextStyle(fontSize: 12)
                    ),
                    value: MenuEnum.UPDATE,
                  ),
                  PopupMenuItem(
                    child: NeoText(
                        Languages.of(context).delete,
                        textStyle: TextStyle(fontSize: 12)
                    ),
                    value: MenuEnum.DELETE,
                  ),
                ],
                onSelected: (value){
                  switch(value){
                    case MenuEnum.UPDATE:
                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=>PostPage(CommonKey.EDIT, data)));
                      break;
                    case MenuEnum.DELETE:
                      _presenter!.deletePost(data['id']);
                      break;
                  }
                },
                icon: Icon(
                  Icons.more_vert_sharp,
                  color: AppColors.ultraRed,
                ),
              )
                  :IconButton(
                icon: Icon(
                  Icons.chat_outlined,
                  color: AppColors.ultraRed,
                ),
                onPressed: (){
                   Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade, widget: ChatRoomPage(_userData, data)));
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: NeoText(data['description']!=null?data['description']:'', textStyle: TextStyle(color: AppColors.black, fontSize: 14,)),
          ),
          listImage.length==1
              ? InkWell(
              onTap: (){
                 Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade, widget: MediaPageView(data['mediaUrl'], 0)));
              },
              child:
              listImage[0].toString().contains('mp4')?
                  Image.asset(Images.horizontalplaybtn):
              loadPhoto.imageNetworkWrapContent(
                  listImage[0] != null ? listImage[0] : ''))
              :listImage.length==2?InkWell(
            onTap: (){
               Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade, widget: NewsDetailPage(data)));
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                listImage[0].toString().contains('mp4')?
                Image.asset(Images.horizontalplaybtn,  width: getWidthDevice(context)/2-16,height: getHeightDevice(context)/4,):loadPhoto.networkImage(listImage[0]!=null?listImage[0]:'', getHeightDevice(context)/4, getWidthDevice(context)/2-16),
                Spacer(),
                listImage[1].toString().contains('mp4')?
                Image.asset(Images.horizontalplaybtn, width: getWidthDevice(context)/2-16,height: getHeightDevice(context)/4,):loadPhoto.networkImage(listImage[1]!=null?listImage[1]:'', getHeightDevice(context)/4, getWidthDevice(context)/2-16),
              ],
            ),
          ): listImage.length==3?InkWell(
            onTap: (){
               Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade, widget: NewsDetailPage(data)));
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                listImage[0].toString().contains('mp4')?
                Image.asset(Images.horizontalplaybtn, height: getHeightDevice(context)/2,fit: BoxFit.fill,width: getWidthDevice(context)/2-16,):loadPhoto.networkImage(listImage[0]!=null?listImage[0]:'', getHeightDevice(context)/2, getWidthDevice(context)/2-16),
                Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    listImage[1].toString().contains('mp4')?
                    Image.asset(Images.horizontalplaybtn,fit: BoxFit.fill, height: getHeightDevice(context)/4-4,width: getWidthDevice(context)/2-16,):loadPhoto.networkImage(listImage[1]!=null?listImage[1]:'', getHeightDevice(context)/4-4, getWidthDevice(context)/2-16),
                    SizedBox(height: 8,),
                    listImage[2].toString().contains('mp4')?
                    Image.asset(Images.horizontalplaybtn,fit: BoxFit.fill,height: getHeightDevice(context)/4-4,width: getWidthDevice(context)/2-16,):loadPhoto.networkImage(listImage[2]!=null?listImage[2]:'', getHeightDevice(context)/4-4, getWidthDevice(context)/2-16),
                  ],
                ),
              ],
            ),
          ):InkWell(
            onTap: (){
               Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade, widget: NewsDetailPage(data)));
            },
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    listImage[0].toString().contains('mp4')?
                    Image.asset(Images.horizontalplaybtn, height: getHeightDevice(context)/5,width: getWidthDevice(context)/2-16,):loadPhoto.networkImage(listImage[0]!=null?listImage[0]:'', getHeightDevice(context)/5, getWidthDevice(context)/2-16),
                    Spacer(),
                    listImage[1].toString().contains('mp4')?
                    Image.asset(Images.horizontalplaybtn, height: getHeightDevice(context)/5,width: getWidthDevice(context)/2-16,):loadPhoto.networkImage(listImage[1]!=null?listImage[1]:'', getHeightDevice(context)/5, getWidthDevice(context)/2-16),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    listImage[2].toString().contains('mp4')?
                    Image.asset(Images.horizontalplaybtn,height: getHeightDevice(context)/5,width: getWidthDevice(context)/2-16,):loadPhoto.networkImage(listImage[2]!=null?listImage[2]:'', getHeightDevice(context)/5, getWidthDevice(context)/2-16),
                    Spacer(),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        listImage[3].toString().contains('mp4')?
                        Image.asset(Images.horizontalplaybtn, height: getHeightDevice(context)/5,width: getWidthDevice(context)/2-16,):loadPhoto.networkImage(listImage[3]!=null?listImage[3]:'', getHeightDevice(context)/5, getWidthDevice(context)/2-16),
                        NeoText('${listImage.length>4?'+${listImage.length-4}':''}', textStyle: TextStyle(color: AppColors.cultured, fontSize: 25))
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
          ,
          Padding(
            padding: EdgeInsets.only(left: 8, top: 4, bottom: 0, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 50,
                  child: TextButton.icon(
                    onPressed: () {
                      isLike
                          ? likes.remove(_username)
                          : likes.add(_username);
                      updateLikePost(likes, data['id']);
                    },
                    icon: Image(
                      image: AssetImage(Images.love),
                      height: 22,
                      width: 22,
                      color: isLike ? AppColors.coralRed : AppColors.grey,
                    ),
                    label: NeoText('$_likeCounter',
                        textStyle: TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal)),

                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextButton.icon(
                    onPressed: () {
                    Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade,
                        widget: CommentPage(data, _userData)))
                          .then((value) {
                        if (value != null && value is bool && value) {}
                      });
                    },
                    icon: Image(
                      image: AssetImage(Images.comments),
                      height: 18,
                      width: 18,
                    ),
                    label: NeoText(
                        'Bình luận ${data['comments'] == 0 ? '' : '${'(${data['comments']})'}'}',
                        textStyle: TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal)),
                  ),
                ),
                Container(
                  width: 100,
                  child: TextButton.icon(
                    onPressed: () {
                    },
                    icon: Image(
                      image: AssetImage(Images.share),
                      height: 18,
                      width: 18,
                    ),
                    label: NeoText('Chia sẻ',
                        textStyle: TextStyle(fontSize: 14, fontFamily: 'LexendThin', color: AppColors.black)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getUserInfo() async{
    _userData = await _presenter!.getUserInfo();
    _username = _userData!['phone'];
    _streamUser = FirebaseFirestore.instance.collection('users').doc(_username).snapshots();
    setState((){});
  }
  void updateLikePost(List<dynamic> userLike, String postId) {
    CollectionReference post = FirebaseFirestore.instance.collection('news');
    post.doc('$postId').update({'user_likes': userLike});
  }
}