import 'dart:math' as math;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_learning/common/widgets.dart';
import 'package:online_learning/screen/lesson/discuss/presenter/discuss_presenter.dart';
import 'package:online_learning/screen/social_networking/newsfeed/view_photo.dart';
import 'package:online_learning/screen/animation_page.dart';
import '../../../external/switch_page_animation/enum.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../common/colors.dart';
import '../../../common/functions.dart';
import '../../../common/themes.dart';
import '../../../languages/languages.dart';
import '../model/discuss.dart';
import '../model/lesson_detail.dart';
class DiscussPage extends StatefulWidget {

  LessonContent? _lesson;

  DiscussPage(this._lesson);

  @override
  State<DiscussPage> createState() => _DiscussPageState(_lesson);
}

class _DiscussPageState extends State<DiscussPage> {
  LessonContent? _lesson;

  _DiscussPageState(this._lesson);

  Stream<DocumentSnapshot>? _stream;
  File? _fileImage;
  Map<String, dynamic>? _dataUser;
  DiscussPresenter? _presenter;
  LessonContent? _detail;
  String _message = '';
  TextEditingController _controllerMess = TextEditingController();
  bool _isFeedback = false;
  String _feedbackName = '';
  @override
  void initState() {
    _stream = FirebaseFirestore.instance.collection('lesson_list').doc(_lesson!.lessonDetailId!).snapshots();
    _presenter = DiscussPresenter();
    getAccountInfor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: GestureDetector(
        onTap: () => hideKeyboard(),
        child: StreamBuilder<DocumentSnapshot>(
          stream: _stream!,
          builder: (context, snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.ultraRed, size: 50),);
            }else if(snapshot.hasError){
              return notfound(Languages.of(context).noData);
            }else if(!snapshot.hasData){
              return notfound(Languages.of(context).noData);
            }else{
              dynamic data = snapshot.data!.data();
              _detail = LessonContent.fromJson(data);
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.separated(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.all(8),
                      itemCount: _detail!.discuss!.length,
                      itemBuilder: (context, index)=>_itemChat(_detail!.discuss![index], index),
                      separatorBuilder: (context, index)=>SizedBox(height: 16,),
                    ),
                  ),
                  Container(
                    color: AppColors.white,
                    width: getWidthDevice(context),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _fileImage!=null
                            ?Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Image(image: FileImage(_fileImage!,), width: getWidthDevice(context)*0.2, height: getWidthDevice(context)*0.25,),
                            IconButton(
                              onPressed: ()=>setState(()=>_fileImage=null),
                              icon: Icon(
                                Icons.clear,
                                color: AppColors.brightGray,
                              ),
                            )
                          ],
                        )
                            :SizedBox(),
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
                                color: AppColors.ultraRed,
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
                                onPressed: (){
                                  if(_message.isNotEmpty){
                                    Discuss discuss = Discuss(
                                        avatar: _dataUser!['avatar']!=null?_dataUser!['avatar']:'',
                                        content: replaceKey(_message, _feedbackName),
                                        timeStamp:getTimestamp(),
                                        name: _dataUser!['fullname']!=null?_dataUser!['fullname']:'',
                                        feedbackName: _feedbackName
                                    );
                                    _fileImage!=null
                                        ?_presenter!.sendMessage(lessonDetail: _detail!, discuss: discuss,imageFile: _fileImage)
                                        :_presenter!.sendMessage(lessonDetail: _detail!, discuss: discuss);
                                    _message = '';
                                    _fileImage = null;
                                    _controllerMess = TextEditingController(text: _message);
                                    _isFeedback = false;
                                    _feedbackName = '';
                                    hideKeyboard();
                                    setState(()=>null);
                                  }
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: AppColors.ultraRed,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4,)
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _itemChat(Discuss discuss, int index){
    List<dynamic> image =[discuss.imageLink];
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: index == 0? 0:8,),
            ClipOval(
              child: loadPhoto.networkImage(discuss.avatar, index==0?40:30, index==0?40:30),
            ),
            SizedBox(width: 8,),
            SizedBox(
              width: getWidthDevice(context)/1.5,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (discuss.feedbackName==null||discuss.feedbackName!.isEmpty)?SizedBox():NeoText(discuss.feedbackName!, textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.black)),
                  NeoText(discuss.content!, textStyle: TextStyle(fontSize: index==0?16:14, color: AppColors.black, fontWeight: index==0?FontWeight.bold:FontWeight.normal))
                ],
              ),
            ),
          ],
        ),
        discuss.imageLink!=null
            ?Padding(
          padding: const EdgeInsets.only(left: 50, top: 8),
          child: InkWell(
              onTap: ()=>  Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade, widget: MediaPageView(image, 0))),
              child: loadPhoto.networkImage(discuss.imageLink, getWidthDevice(context)*0.5, getWidthDevice(context)*0.5)),
        )
            :SizedBox(),
        SizedBox(height: 12,),
      ],
    );
  }

  Future<void> getAccountInfor() async{
    _dataUser = await _presenter!.getAccountInfo();
    setState(()=>null);
  }
}