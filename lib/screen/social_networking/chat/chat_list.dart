import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_learning/common/functions.dart';
import 'package:online_learning/common/widgets.dart';
import 'package:online_learning/screen/social_networking/chat/chat_room.dart';

import '../../../common/colors.dart';
import '../../../languages/languages.dart';
import '../../../res/images.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
class ChatListPage extends StatefulWidget {
  Map<String, dynamic>? _userData;

  ChatListPage(this._userData);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {

  Stream<QuerySnapshot>? _streamChat;

  @override
  void initState() {
    _streamChat = FirebaseFirestore.instance.collection('user_chat').doc(widget._userData!['phone']).collection(widget._userData!['phone']).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: AppColors.ultraRed,
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
            child:
                Stack(
                  fit: StackFit.expand,
                  children: [
                    Center(child: NeoText('Tin nhắn', textStyle: TextStyle(color: AppColors.ultraRed, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                    Positioned(child:  IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: AppColors.ultraRed,)),left: 0,)
                  ],
                ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _streamChat,
              builder: (context, snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.ultraRed, size: 50),);
                }else if(snapshot.hasError){
                  return notfound(Languages.of(context).noData);
                }else if(!snapshot.hasData){
                  return notfound(Languages.of(context).noData);
                }else{

                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: snapshot.data!.docs.map((element){
                          Map<String, dynamic> data = element.data() as Map<String, dynamic>;
                          print(data);
                          return _itemChatList(data);
                        }).toList(),
                      )
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _itemChatList(Map<String, dynamic> data){
    return InkWell(
      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatRoomPage(widget._userData!, data))),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: loadPhoto.networkImage(data['userAvatar']!=null?data['userAvatar']:'', getWidthDevice(context)*0.15, getWidthDevice(context)*0.15),
              ),
              SizedBox(width: 8.0,),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NeoText(data['fullname']!=null?data['fullname']:'user', textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.black)),
                    SizedBox(height: 8,),
                    NeoText(postedTime(data['timestamp']), textStyle: TextStyle(fontSize: 12, color: AppColors.pastelBlue))
                  ],
                ),
              )
            ],
          ),
          Divider()
        ],
      ),
    );
  }
}