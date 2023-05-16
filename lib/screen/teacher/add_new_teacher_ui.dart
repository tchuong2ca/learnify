import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_learning/common/widgets.dart';
import 'package:online_learning/screen/teacher/presenter/add_new_teacher_presenter.dart';

import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/keys.dart';
import '../../common/themes.dart';
import '../../languages/languages.dart';
import '../../res/images.dart';

class AddNewTeacherUI extends StatefulWidget {
  Map<String, dynamic>? _data;
  String? _role;
  AddNewTeacherUI(this._data, this._role);

  @override
  State<AddNewTeacherUI> createState() => _AddNewTeacherUIState(_data, _role);
}

class _AddNewTeacherUIState extends State<AddNewTeacherUI> {
  Map<String, dynamic>? _data;
  String? _role;
  _AddNewTeacherUIState(this._data, this._role);
  String _userName = '';
  TextEditingController? _nameController = TextEditingController();
  TextEditingController? _expController = TextEditingController();
  TextEditingController? _specializeController = TextEditingController();
  TextEditingController? _introController = TextEditingController();
  TextEditingController? _phoneController = TextEditingController();
  TextEditingController? _mailController = TextEditingController();
  String _fullname = '';
  String _keyUser ='';
  String _exp = '';
  String _specialize='';
  String _intro='';
  String _phone ='';
  String _email='';
  bool _loadFirst = true;
  File? _fileImage;
  String _avatar = '';
  AddNewTeacherPresenter? _presenter;



  @override
  void initState() {
    _presenter = AddNewTeacherPresenter();
    if(_data!=null){
      _avatar = _data!['avatar'];
      _userName = _data!['phone'];
      _fullname = _data!['fullname'];
      _phone = _data!['phone'];
      _phoneController = TextEditingController(text:_data!['phone']);
      _nameController = TextEditingController(text: _data!['fullname']);
      _exp = _data!['exp'];
      _expController = TextEditingController(text: _data!['exp']);
      _specialize = _data!['specialize'];
      _specializeController = TextEditingController(text: _data!['specialize']);
      _introController = TextEditingController(text: _data!['intro']);
      _intro = _data!['intro'];
      _email = _data!['email'];
      _mailController = TextEditingController(text: _email);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0,),
      body: GestureDetector(
        onTap: ()=> hideKeyboard(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonKey.ADMIN==widget._role? Container(
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
                  IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back, color: AppColors.blue,)),
                  SizedBox(width: 8,),
                  Expanded(child: NeoText( Languages.of(context).teacherAdd, textStyle: TextStyle(color: AppColors.blueLight, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                  ElevatedButton(
                      onPressed: (){
                        showLoaderDialog(context);
                        if(widget._data==null&&CommonKey.ADMIN==widget._role){
                          _fileImage!=null?_presenter!.createAccount(file: _fileImage!,name: _fullname, phone: _phone, email: _email, exp:  _exp,specialize:  _specialize,intro:  _intro).then((value) {
                            Navigator.pop(context);
                            if(value){
                              Navigator.pop(context);
                            }else{
                              CustomDialog(context: context, iconData: Icons.warning_rounded, title: Languages.of(context).alert, content: Languages.of(context).addFailure);
                            }
                          }):_presenter!.createAccount(name: _fullname,phone:  _phone,email:  _email,exp:  _exp,specialize:  _specialize,intro:  _intro).then((value) {
                            Navigator.pop(context);
                            if(value){
                              Navigator.pop(context);
                              Fluttertoast.showToast(msg: Languages.of(context).onSuccess);
                            }else{
                              CustomDialog(context: context, iconData: Icons.warning_rounded, title: Languages.of(context).alert, content: Languages.of(context).addFailure);
                            }
                          });
                        }else{
                          _presenter!.updateTeacher(_fileImage, _fullname, _phone, _exp, _specialize, _intro, _keyUser, _avatar).then((value) {
                            Navigator.pop(context);
                            if(value){
                              Navigator.pop(context);
                              Fluttertoast.showToast(msg: Languages.of(context).onSuccess);
                            }else{
                              CustomDialog(context: context, iconData: Icons.warning_rounded, title: Languages.of(context).alert, content: Languages.of(context).onFailure);
                            }
                          });
                        }
                      },
                      child: NeoText('Xác nhận', textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.white))),
                  SizedBox(width: 8,)
                ],
              ),
            ):
            Container(
              width: getWidthDevice(context),
              height: 52,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Images.background_tutorial),
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
                  Expanded(child: NeoText(Languages.of(context).teacher, textStyle: TextStyle(color: AppColors.blueLight, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                  SizedBox(width: 52,)
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                          children:[
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(200)),
                                    border: Border.all(
                                        color: AppColors.orangeOriginLight,
                                        width: 1.0
                                    )
                                ),
                                child: InkWell(
                                  onTap: (){
                                    if(CommonKey.ADMIN==widget._role){
                                      cropImage(context, (p0) => setState((){
                                        _fileImage=p0;
                                      }), '');
                                    }

                                  },
                                  child:  ClipOval(
                                      child: _fileImage!=null?Image(image: FileImage(_fileImage!),width: 150, height: 150,):_avatar.isNotEmpty&&widget._data!=null
                                          ?Image.network(_avatar,width: 150, height: 150,fit: BoxFit.cover,)
                                          :Image.asset(Images.background_tutorial, width: 150, height: 150, fit: BoxFit.cover,)
                                  ),
                                )
                            ),
                            CommonKey.ADMIN==widget._role?Positioned(
                                bottom: 5,
                                right: 5,
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(200)),
                                      color: AppColors.white,
                                      border: Border.all(width: 1.0, color: AppColors.orangeOriginLight)
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      icon: const Icon(Icons.camera_alt, size: 12, color: AppColors.grey,),
                                      onPressed: (){
                                        cropImage(context, (p0) => setState(()=>_fileImage=p0), CommonKey.CAMERA);
                                      },
                                    ),
                                  ),
                                )):SizedBox()
                          ]
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 16),
                        child: TextFormField(
                          decoration: AppThemes.textFieldInputDecoration(labelText: Languages.of(context).fullName, hintText: Languages.of(context).fullName),
                          controller: _nameController,
                          maxLines: 1,
                          onChanged: (value)=>setState((){
                            _fullname=value;
                          }),
                          validator: (value){
                            return value!.isEmpty?Languages.of(context).nameEmpty:null;
                          },
                        ),
                      ),
                      SizedBox(height: 8,),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          controller: _phoneController,
                          decoration: AppThemes.textFieldInputDecoration(hintText: Languages.of(context).phone, labelText: Languages.of(context).phone),
                          maxLines: 1,
                          onChanged: (value)=>setState(()=> _phone=value),
                          keyboardType: TextInputType.phone,
                          validator: (value){
                            return value!.isEmpty?Languages.of(context).phoneEmpty:_phone.length!=10?Languages.of(context).phoneError:null;
                          },
                          enabled: widget._data!=null?false:true,
                        ),
                      ),
                      SizedBox(height: 8,),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          controller: _mailController,
                          decoration: AppThemes.textFieldInputDecoration(hintText: Languages.of(context).email, labelText: Languages.of(context).email),
                          maxLines: 1,
                          onChanged: (value)=>setState(()=> _email=value),
                          keyboardType: TextInputType.emailAddress,
                          validator:(value){
                            return value!.isEmpty?Languages.of(context).emailEmpty:!validateEmail(value)?Languages.of(context).emailError:null;
                          },
                          enabled: widget._data!=null? false: true,
                        ),
                      ),
                      SizedBox(height: 8,),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          controller: _expController,
                          decoration: AppThemes.textFieldInputDecoration(hintText: 'Số năm kinh nghiệm', labelText: 'Số năm kinh nghiệm'),
                          maxLines: 1,
                          onChanged: (value)=>setState(()=> _exp=value),
                          enabled: CommonKey.ADMIN==widget._role?true:false,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          controller: _specializeController,
                          decoration: AppThemes.textFieldInputDecoration(hintText: 'Chuyên môn', labelText: 'Chuyên môn'),
                          maxLines: 1,
                          onChanged: (value)=>setState(()=> _specialize=value),
                          enabled: CommonKey.ADMIN==widget._role?true:false,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          controller: _introController,
                          decoration: AppThemes.textFieldInputDecoration(labelText: Languages.of(context).describeInfo, hintText: Languages.of(context).describeInfo),
                          maxLines: 10,
                          onChanged: (value)=>setState(()=> _intro=value,
                          ),
                          enabled: CommonKey.ADMIN==widget._role?true:false,
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
