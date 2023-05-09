import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_learning/common/themes.dart';
import 'package:online_learning/screen/personal/model/info.dart';
import 'package:online_learning/screen/social_networking/post/model/posts.dart';
import 'package:online_learning/screen/social_networking/post/presenter/post_presenter.dart';

import '../../../common/colors.dart';
import '../../../common/functions.dart';
import '../../../common/keys.dart';
import '../../../common/widgets.dart';
import '../../../languages/languages.dart';
import 'model/image.dart';

class PostPage extends StatefulWidget {
  String? _keyFlow;
  Map<String, dynamic>? _data;
  PostPage(this._keyFlow, this._data);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  PostPresenter? _presenter;
  List<ImageModel> _imageList=[];
  String _content = '';
  Info? _person;
  TextEditingController _textController = TextEditingController();
  List<dynamic> _listLink = [];
  @override
  void initState() {
    _presenter = PostPresenter();
    _getAccountInfor();
    if(CommonKey.EDIT==widget._keyFlow){
      _textController = TextEditingController(text: widget._data!['description']);
      _listLink = widget._data!['mediaUrl'];
      _imageList = _presenter!.getImageUpdate(_listLink);
      _content = widget._data!['description'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            width: double.infinity,
            height: 52,
            color: Colors.lightBlueAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_sharp,
                          color: CommonColor.white, size: 24),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: NeoText('Đăng bài',
                          textStyle: TextStyle(
                              fontSize: 18, color: CommonColor.white)),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(CommonColor.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(color: CommonColor.blue)))),
                    onPressed: () {
                      if(_content.isEmpty){
                        Fluttertoast.showToast(msg: Languages.of(context).emptyContent);

                      }else if(_imageList.length==0){
                        Fluttertoast.showToast(msg: Languages.of(context).imageNull);
                      }else{
                        Posts news = Posts(
                          fullname: _person!.fullname,
                          description: _content,
                          comment: 0,
                          userAvatar: _person!.avatar!=null?_person!.avatar:'',
                          username: _person!.phone,

                        );
                        showLoaderDialog(context);
                        CommonKey.EDIT!=widget._keyFlow
                            ?_presenter!.getLink(_imageList, news).then((value) => _presenter!.createNewPost(value, news).then((value) {
                          listenStatus(context, value);
                        }))
                            :_presenter!.UpdatePost(idNews: widget._data!['id'], listModel: _imageList, listLink: widget._data!['mediaUrl']
                            , description: _content, news: news).then((value) {
                          listenStatus(context, value);
                        });
                      }
                    },
                    child: NeoText('Đăng',
                        textStyle:TextStyle(
                            fontSize: 14, color: Colors.blue)),
                  ),
                )
              ],
            ),
          ),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    autocorrect: true,
                    decoration: InputDecoration.collapsed(
                        hintText: 'Bạn đang nghĩ j',
                        hintStyle: TextStyle(fontSize: 18,fontFamily: 'LexendLight',color: CommonColor.grey)
                    ),
                    maxLines: 10,
                    onChanged: (value)=>setState(()=>_content=value),
                    controller: _textController,
                  ),
                ),
                Container(
                  width: getWidthDevice(context),
                  height: getHeightDevice(context)/13,
                  color: CommonColor.greyLight,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 8,),
                      Expanded(
                        child: NeoText(
                            Languages.of(context).choseImage,
                            textStyle: TextStyle(fontSize: 16, color: CommonColor.blue)
                        ),
                      ),
                      IconButton(
                        onPressed: ()=>selectPhoto((p0){
                          _imageList = _presenter!.getListImage(_imageList, p0!);
                          setState(()=> null);
                        }, CommonKey.CAMERA),
                        icon: Icon(
                          Icons.camera_alt,
                          color: CommonColor.blue,
                        ),
                      ),
                      IconButton(
                        onPressed: ()=>selectPhoto((p0) {
                          _imageList = _presenter!.getListImage(_imageList, p0!);
                          setState(()=> null);
                        }, ''),
                        icon: Icon(
                          Icons.image,
                          color: CommonColor.blue,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    children: List.generate(_imageList.length, (index) =>_itemImage(_imageList[index], index)),
                  ),
                )

              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _itemImage(ImageModel imageModel, int index){
    return Card(
        margin: EdgeInsets.all(8),
        child: Stack(
          children: [
            imageModel.imageLink!=null
                ?loadPhoto.imageNetwork('${imageModel.imageLink}', getWidthDevice(context)/2-16, getWidthDevice(context)/2-16)
                :Image(image: FileImage(imageModel.fileImage!), width: getWidthDevice(context)/2-16, height: getWidthDevice(context)/2-16,),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: CommonColor.greyLight,
                ),
                onPressed: ()=>setState((){
                  _imageList.removeAt(index);
                  if(CommonKey.EDIT==widget._keyFlow){
                    _listLink.removeAt(index);
                  }
                }),
              ),
            )
          ],
        )
    );
  }

  Future<void> _getAccountInfor() async{
    _person = await _presenter!.getAccountInfor();
    setState(()=>null);
  }
}