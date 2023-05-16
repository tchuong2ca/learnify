import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_learning/screen/social_networking/chat/presenter/chat_room_presenter.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../common/colors.dart';
import '../../../common/functions.dart';
import '../../../common/themes.dart';
import '../../../common/widgets.dart';
import '../../../res/images.dart';
import 'model/user.dart';
import 'dart:math' as math;
class ChatRoomPage extends StatefulWidget {
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _friendData;

  ChatRoomPage(this._userData, this._friendData);

  @override
  State<ChatRoomPage> createState() => _ChatUserPageState();
}

class _ChatUserPageState extends State<ChatRoomPage> {
  File? _fileImage;
  ChatRoomPresenter? _presenter;
  String _message='';
  TextEditingController _controllerMess = TextEditingController();
  Stream<QuerySnapshot>? _stream;
  bool _createUserChat = false;
  @override
  void initState() {
    _presenter=ChatRoomPresenter();
    _stream = FirebaseFirestore.instance.collection('chats').doc(widget._userData!['phone']).collection(widget._friendData!['username']).snapshots();
    _checkCreateUser();
  }

  void _checkCreateUser(){
    FirebaseFirestore.instance.collection('user_chat').doc(widget._userData!['phone']).collection(widget._userData!['phone']).doc(widget._friendData!['username']).get().then((value) {
      if(!value.exists){
        _createUserChat = true;
        setState(()=>null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>hideKeyboard(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: AppColors.blue,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: getWidthDevice(context),
              height: 52,
              decoration:  BoxDecoration(
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
                  IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back, color: AppColors.blue,)),
                  SizedBox(width: 8,),
                  ClipOval(
                    child: loadPhoto.networkImage(widget._friendData!['userAvatar']!=null?widget._friendData!['userAvatar']:'', 50, 50),
                  ),
                  SizedBox(width: 8.0,),
                  NeoText( widget._friendData!['fullname'], textStyle: TextStyle(color: AppColors.blueLight, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  SizedBox(width: 52,)
                ],
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _stream,
                    builder: (_, snapshot){
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.blueLight, size: 50),
                        );
                      }else if(snapshot.hasError){
                        return  Center(
                          child: Text('Error...'),
                        );
                      }else if(!snapshot.hasData){
                        return SizedBox();
                      }else{
                        return ListView(
                          children: snapshot.data!.docs.map((e) {
                            Map<String, dynamic> data = e.data() as Map<String, dynamic>;
                            return _itemChat(data);
                          }).toList(),
                        );
                      }
                    },
                  )
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8,),
              padding: EdgeInsets.only(top: 8, bottom: 8),
              decoration: BoxDecoration(
                  color: AppColors.grayLight
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _fileImage!=null?Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Image(image: FileImage(_fileImage!), width: getWidthDevice(context)*0.3, height: getWidthDevice(context)*0.3,),
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: AppColors.redAccent,
                        ),
                        onPressed: ()=>setState(()=>_fileImage=null),
                      )
                    ],
                  ):SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(width: 4,),
                      IconButton(
                        onPressed: ()=>cropImage(context, (p0) => setState(()=> _fileImage=p0!), ''),
                        icon: Icon(
                          Icons.image,
                          color: AppColors.blue,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: AppThemes.textFieldInputDecorationChat(),
                          onChanged: (value)=>setState(()=>_message=value),
                          controller: _controllerMess,
                        ),
                      ),
                      Transform.rotate(
                        angle: -35*math.pi /180,
                        child: IconButton(
                          onPressed: ()async{
                            if(_createUserChat){
                              User user = User(username: widget._userData!['phone'], fullname: widget._userData!['fullname'], userAvatar: widget._userData!['avatar'], timestamp: getTimestamp());
                              User userFriend = User(username: widget._friendData!['username'], fullname: widget._friendData!['fullname'], userAvatar: widget._friendData!['userAvatar'], timestamp: getTimestamp());
                              _presenter!.createChatRoom(user, userFriend);
                              _createUserChat=false;
                            }
                            _presenter!.createNewChat(message: _message, user: widget._userData!, userFriend: widget._friendData!, fileImage: _fileImage);
                            _message='';
                            _fileImage=null;
                            _controllerMess = TextEditingController(text: _message);
                            hideKeyboard();
                            setState(()=>null);
                          },
                          icon: Icon(
                            Icons.send,
                            color: AppColors.blue,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _itemChat(Map<String, dynamic> data){
    List<dynamic> listImage = [];
    listImage.add(data['linkImage']);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            widget._userData!['phone']==data['username']?SizedBox():ClipOval(
              child: loadPhoto.networkImage(data['avatar']!=null?data['avatar']:"", getWidthDevice(context)*0.1, getWidthDevice(context)*0.1),
            ),
            SizedBox(width: 8,),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  data['linkImage'].toString().isEmpty?SizedBox():Align(
                    alignment:  widget._userData!['phone']==data['username']?Alignment.bottomRight:Alignment.bottomLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      child: InkWell(
                          onTap: (){
                           // Navigator.push(context, MaterialPageRoute(builder: (_)=>ViewImageList(listImage, 0)));
                          },
                          child: loadPhoto.networkImage(data['linkImage'], getHeightDevice(context)*0.3, getWidthDevice(context)*0.6)),
                    ),
                  ),
                  SizedBox(height: 8,),
                  data['message'].toString().isNotEmpty?Align(
                    alignment:  widget._userData!['phone']==data['username']?Alignment.bottomRight:Alignment.bottomLeft,
                    child: Container(
                      padding: EdgeInsets.only(right: 10, left: 10, top: 8, bottom: 8),
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            )
                          ]
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget._userData!['phone']==data['username']?SizedBox():NeoText(data['fullname'], textStyle: TextStyle(fontSize: 12, color: AppColors.blue)),
                          widget._userData!['phone']==data['username']?SizedBox():SizedBox(height: 10,),
                          NeoText(data['message'], textStyle: TextStyle(fontSize: 14, color: AppColors.black)),
                          SizedBox(height: 8,),
                          NeoText(postedTime(data['timestamp']), textStyle: TextStyle(fontSize: 10, color: AppColors.grey)),
                        ],
                      ),
                    ),
                  ):SizedBox()
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16,)
      ],
    );
  }
}