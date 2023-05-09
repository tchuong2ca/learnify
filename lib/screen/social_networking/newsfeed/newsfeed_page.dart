import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_learning/common/widgets.dart';
import 'package:online_learning/screen/social_networking/newsfeed/presenter/news_presenter.dart';
import 'package:online_learning/screen/social_networking/newsfeed/view_photo.dart';

import '../../../common/colors.dart';
import '../../../common/functions.dart';
import '../../../common/keys.dart';
import '../../../common/menu_enum.dart';
import '../../../languages/languages.dart';
import '../../../res/images.dart';
import '../../personal/personal_page.dart';
import '../chat/chat_list.dart';
import '../chat/chat_room.dart';
import '../comment/comment_page.dart';
import '../post/post_page.dart';
import 'news_detail.dart';

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
  Map<String, dynamic>? _dataUser;
  NewsPresenter? _presenter;
  @override
  void initState() {
    _stream = FirebaseFirestore.instance.collection('news').orderBy('timestamp',descending: true).snapshots();
    _presenter = NewsPresenter();
    _getUserInfor();
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
               IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: CommonColor.blue,)),
                SizedBox(width: 8,),
                Expanded(child: NeoText(Languages.of(context).qa, textStyle: TextStyle(color: CommonColor.blueLight, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                IconButton(
                  onPressed:()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatListPage(_dataUser))),
                  icon: Icon(Icons.message, color: CommonColor.blue,),
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
                        return Center(child: Text('Loading...'),);
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
          print(data);
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
                    child: loadPhoto.imageNetwork(data['avatar']!=null?data['avatar']:'', 50, 50),
                  ),onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>PersonalPage(data['role']!)));
                  },),
                  SizedBox(width: 8.0,),
                  Expanded(
                    child: NeoText(Languages.of(context).uNeed, textStyle: TextStyle(fontSize: 14, color: CommonColor.black)),
                  ),
                  IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>PostPage('',null)));
                    },
                    icon: Icon(Icons.image, color: CommonColor.blue,),
                  )
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
    // List<dynamic> topic = data['topic'];
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
                child: loadPhoto.imageNetwork(data['userAvatar']!=null?data['userAvatar']:'', 50, 50),
              ),
              SizedBox(width: 4,),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    NeoText(data['fullname']!=null?data['fullname']:'', textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: CommonColor.black)),
                    NeoText(data['timestamp']!=null?postedTime(data['timestamp']):'', textStyle: TextStyle(fontSize: 12, color: CommonColor.black_light)),
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
                      _presenter!.DeleteNews(data['id']);
                      break;
                  }
                },
                icon: Icon(
                  Icons.more_vert_sharp,
                  color: CommonColor.blue,
                ),
              )
                  :IconButton(
                icon: Icon(
                  Icons.chat_outlined,
                  color: CommonColor.blue,
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatRoomPage(_dataUser, data)));
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: NeoText(data['description']!=null?data['description']:'', textStyle: TextStyle(color: CommonColor.black, fontSize: 14,)),
          ),
          listImage.length==1
              ? InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>PhotosPageView(data['mediaUrl'], 0)));
              },
              child: loadPhoto.imageNetworkWrapContent(
                  listImage[0] != null ? listImage[0] : ''))
              :listImage.length==2?InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>NewsDetailPage(data)));
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                loadPhoto.imageNetwork(listImage[0]!=null?listImage[0]:'', getHeightDevice(context)/4, getWidthDevice(context)/2-16),
                Spacer(),
                loadPhoto.imageNetwork(listImage[1]!=null?listImage[1]:'', getHeightDevice(context)/4, getWidthDevice(context)/2-16),
              ],
            ),
          ): InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>NewsDetailPage(data)));
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                loadPhoto.imageNetwork(listImage[0]!=null?listImage[0]:'', getHeightDevice(context)/2, getWidthDevice(context)/2-16),
                Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    loadPhoto.imageNetwork(listImage[1]!=null?listImage[1]:'', getHeightDevice(context)/4-4, getWidthDevice(context)/2-16),
                    SizedBox(height: 8,),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        loadPhoto.imageNetwork(listImage[2]!=null?listImage[2]:'', getHeightDevice(context)/4-4, getWidthDevice(context)/2-16),
                        NeoText('${listImage.length>3?'+${listImage.length}':''}', textStyle: TextStyle(color: CommonColor.greyLight, fontSize: 25))
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                      color: isLike ? CommonColor.redLight : CommonColor.grey,
                    ),
                    // icon: Image(
                    //   image: AssetImage(Images.love),
                    //   height: 22,
                    //   width: 22,
                    //   color: CommonColor.grey,
                    // ),
                    label: NeoText('$_likeCounter',
                        textStyle: TextStyle(
                            fontSize: 14,
                            color: CommonColor.black,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal)),
                    // label: NeoText('0',
                    //     textStyle: TextStyle(
                    //         fontSize: 14,
                    //         color: CommonColor.black,
                    //         fontStyle: FontStyle.normal,
                    //         fontWeight: FontWeight.normal)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(context,
                         MaterialPageRoute(builder: (_)=>CommentNewsPage(data, _dataUser)))
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
                            color: CommonColor.black,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal)),
                  ),
                ),
                Container(
                  width: 100,
                  child: TextButton.icon(
                    onPressed: () {
                      // onShare(data['id']);
                    },
                    icon: Image(
                      image: AssetImage(Images.share),
                      height: 18,
                      width: 18,
                    ),
                    label: NeoText('Chia sẻ',
                        textStyle: TextStyle(fontSize: 14, fontFamily: 'LexendThin', color: CommonColor.black)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getUserInfor() async{
    _dataUser = await _presenter!.getUserInfor();
    _username = _dataUser!['phone'];
    _streamUser = FirebaseFirestore.instance.collection('users').doc(_username).snapshots();
    setState((){});
  }
  void updateLikePost(List<dynamic> userLike, String postId) {
    CollectionReference post = FirebaseFirestore.instance.collection('news');
    post.doc('$postId').update({'user_likes': userLike});
  }
}