import 'dart:math' as math;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_learning/common/widgets.dart';
import 'package:online_learning/screen/lesson/discuss/presenter/discuss_presenter.dart';
import 'package:online_learning/screen/social_networking/newsfeed/view_photo.dart';

import '../../../common/colors.dart';
import '../../../common/functions.dart';
import '../../../common/themes.dart';
import '../../../languages/languages.dart';
import '../model/discuss.dart';
import '../model/lesson_detail.dart';
class DiscussPage extends StatefulWidget {

  LessonDetail? _lesson;

  DiscussPage(this._lesson);

  @override
  State<DiscussPage> createState() => _DiscussPageState(_lesson);
}

class _DiscussPageState extends State<DiscussPage> {
  LessonDetail? _lesson;

  _DiscussPageState(this._lesson);

  Stream<DocumentSnapshot>? _stream;
  File? _fileImage;
  Map<String, dynamic>? _dataUser;
  DiscussPresenter? _presenter;
  LessonDetail? _detail;
  String _message = '';
  TextEditingController _controllerMess = TextEditingController();
  bool _isFeedback = false;
  String _nameFeedback = '';
  @override
  void initState() {
    _stream = FirebaseFirestore.instance.collection('lesson_detail').doc(_lesson!.idLessonDetail!).snapshots();
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
              return Center(child: Text('Loading...'),);
            }else if(snapshot.hasError){
              return notfound(Languages.of(context).noData);
            }else if(!snapshot.hasData){
              return notfound(Languages.of(context).noData);
            }else{
              dynamic data = snapshot.data!.data();
              _detail = LessonDetail.fromJson(data);
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
                    color: CommonColor.white,
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
                                color: CommonColor.grayLight,
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
                                color: CommonColor.blue,
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: CommonTheme.textFieldInputDecorationChat(),
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
                                        content: replaceKey(_message, _nameFeedback),
                                        timeStamp:getTimestamp(),
                                        name: _dataUser!['fullname']!=null?_dataUser!['fullname']:'',
                                        nameFeedback: _nameFeedback
                                    );
                                    _fileImage!=null
                                        ?_presenter!.SendChat(lessonDetail: _detail!, discuss: discuss,imageFile: _fileImage)
                                        :_presenter!.SendChat(lessonDetail: _detail!, discuss: discuss);
                                    _message = '';
                                    _fileImage = null;
                                    _controllerMess = TextEditingController(text: _message);
                                    _isFeedback = false;
                                    _nameFeedback = '';
                                    hideKeyboard();
                                    setState(()=>null);
                                  }
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: CommonColor.blue,
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
              child: loadPhoto.imageNetwork(discuss.avatar, index==0?40:30, index==0?40:30),
            ),
            SizedBox(width: 8,),
            SizedBox(
              width: getWidthDevice(context)/1.5,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (discuss.nameFeedback==null||discuss.nameFeedback!.isEmpty)?SizedBox():NeoText(discuss.nameFeedback!, textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: CommonColor.black)),
                  NeoText(discuss.content!, textStyle: TextStyle(fontSize: index==0?16:14, color: CommonColor.black, fontWeight: index==0?FontWeight.bold:FontWeight.normal))
                ],
              ),
            ),
          ],
        ),
        discuss.imageLink!=null
            ?Padding(
          padding: const EdgeInsets.only(left: 50, top: 8),
          child: InkWell(
              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>PhotosPageView(image, 0))),
              child: loadPhoto.imageNetwork(discuss.imageLink, getWidthDevice(context)*0.5, getWidthDevice(context)*0.5)),
        )
            :SizedBox(),
        SizedBox(height: 12,),
        // _dataUser['phone']== Row(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     SizedBox(width: index==0?48:46,),
        //     InkWell(
        //       onTap: (){
        //         setState((){
        //           _isFeedback = true;
        //           _nameFeedback = '${discuss.name}';
        //           _controllerMess = TextEditingController(text: _nameFeedback);
        //         });
        //       },
        //       child: CustomText(
        //         Languages.of(context).feedback,
        //         textStyle: TextStyle(color: CommonColor.blue, fontSize: 10)
        //       ),
        //     ),
        //     SizedBox(width: 50,),
        //     InkWell(
        //       onTap: (){
        //         _detail!.discuss!.removeAt(index);
        //         _presenter!.PostData(_detail!);
        //       },
        //       child: CustomText(
        //           Languages.of(context).delete,
        //           textStyle: TextStyle(color: CommonColor.blue, fontSize: 10)
        //       ),
        //     ),
        //   ],
        // )
      ],
    );
  }

  Future<void> getAccountInfor() async{
    _dataUser = await _presenter!.getAccountInfo();
    setState(()=>null);
  }
}