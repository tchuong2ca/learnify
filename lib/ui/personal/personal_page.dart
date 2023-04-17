import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_learning/common/colors.dart';
import 'package:online_learning/common/widgets.dart';
import 'package:online_learning/ui/personal/presenter/personal_presenter.dart';

import '../../common/functions.dart';
import '../../common/keys.dart';
import '../../common/themes.dart';
import '../../languages/languages.dart';
import '../../res/images.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  Map<String, dynamic>? _user;
  String _userName = '';
  Stream<DocumentSnapshot>? _stream;
  TextEditingController? _controllerName = TextEditingController();
  TextEditingController? _controllerAddress = TextEditingController();
  TextEditingController? _controllerBirthday = TextEditingController();
  TextEditingController? _controllerDescribeInfo = TextEditingController();
  ProfilePresenter? _presenter;
  String _fullname = '';
  String _keyUser ='';
  String _address = '';
  String _birthday='';
  String _describeInfo='';
  String _office='';
  bool _loadFirst = true;
  File? _fileImage;



  @override
  void initState() {
    _presenter = ProfilePresenter();
    initData();
  }
  Future<void> initData() async{
    _user = await _presenter!.getAccountInfor();
    if(_user!=null){
      _stream = FirebaseFirestore.instance.collection('users').doc(_user!['phone']).snapshots();
      setState(()=>null);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => hideKeyboard(),
        child: Column(
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
                  IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back, color: CommonColor.blue,)),
                  SizedBox(width: 8,),
                  Expanded(child: NeoText( Languages.of(context).teacherAdd, textStyle: TextStyle(color: CommonColor.blueLight, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                  ElevatedButton(
                      onPressed: (){
                        showLoaderDialog(context);
                        if(_presenter!.updateProfile(_keyUser, _fullname, _address, _birthday, _describeInfo, _office)){
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }else{
                          Navigator.pop(context);
                        }
                      },
                      child: NeoText('Xác nhận', textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CommonColor.white))),
                  SizedBox(width: 8,)
                ],
              ),
            ),
            Expanded(child: SingleChildScrollView(
              child: StreamBuilder<DocumentSnapshot>(
                stream: _stream,
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return Center(child: Text('Loading...'),);
                  }
                  if(snapshot.hasError){
                    return Center(child: Text('No data...'),);
                  }
                  else{
                    Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                    //print(data);
                    return _itemView(data);
                  }

                },
              ),
            ))
          ],
        ),
      ),
    );
  }
  Widget _itemView(Map<String, dynamic> data) {
    if(_loadFirst){
      _keyUser = data['phone'];
      _fullname = data['fullname'];
      _controllerName = TextEditingController(text: '${data['fullname']}');
      _loadFirst=false;
    }
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: CommonColor.white,
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
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                  children:[
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(200)),
                            border: Border.all(
                                color: CommonColor.orangeOriginLight,
                                width: 1.0
                            )
                        ),
                        child: InkWell(
                          onTap: ()=>cropImage(context,(p0) => setState((){
                            _fileImage=p0;
                            _presenter!.updateAvatar(p0!, _keyUser, CommonKey.AVATAR);
                          }), ''),
                          child:  ClipOval(
                              child: ImageLoad.imageNetwork(data['avatar'], 100, 100)
                          ),
                        )
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(200)),
                              color: CommonColor.white,
                              border: Border.all(width: 1.0, color: CommonColor.orangeOriginLight)
                          ),
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt, size: 12, color: CommonColor.grey,),
                              onPressed: (){
                                cropImage(context,(p0) => setState(()=>_fileImage=p0), CommonKey.CAMERA);
                              },
                            ),
                          ),
                        ))
                  ]
              ),
              SizedBox(width: 8,),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NeoText('${Languages.of(context).hello}, ${data['fullname']}', textStyle: TextStyle(fontSize: 14, color: CommonColor.black)),
                    SizedBox(height: 4,),
                    NeoText('${data['email']}', textStyle: TextStyle(color: CommonColor.black, fontSize: 12))
                  ],
                ),
              ),
              IconButton(
                onPressed: ()=>null,
                icon: Icon(
                  Icons.edit,
                  color: CommonColor.blue,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16,),
        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
          child: TextFormField(
            decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).fullName, hintText: Languages.of(context).fullName),
            controller: _controllerName,
            maxLines: 1,
            onChanged: (value)=>setState((){
              _fullname=value;
            }),
          ),
        ),
        SizedBox(height: 8,),
        Padding(
          padding: EdgeInsets.all(8),
          child: TextFormField(
              decoration: CommonTheme.textFieldInputDecoration(hintText: Languages.of(context).address, labelText: Languages.of(context).address),
              maxLines: 1,
              onChanged: (value)=>setState(()=> _address=value)
          ),
        ),

        Padding(
          padding: EdgeInsets.all(8),
          child: TextFormField(
              decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).describeInfo, hintText: Languages.of(context).describeInfo),
              maxLines: 10,
              onChanged: (value)=>setState(()=> _describeInfo=value)
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: TextFormField(
              decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).office, hintText: Languages.of(context).office),
              maxLines: 2,
              onChanged: (value)=>setState(()=> _office=value)
          ),
        )
      ],
    );
  }
}
