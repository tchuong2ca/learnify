import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_learning/common/widgets.dart';
import 'package:online_learning/screen/course/presenter/create_course_presenter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/keys.dart';
import '../../common/themes.dart';
import '../../languages/languages.dart';
import '../../res/images.dart';
import '../personal/model/info.dart';

class CreateCourseUI extends StatefulWidget {
  String? _keyFlow;
  Map<String, dynamic>? _data;

  CreateCourseUI(this._keyFlow, this._data);

  @override
  State<CreateCourseUI> createState() => _CreateCourseUIState(_keyFlow, _data);
}

class _CreateCourseUIState extends State<CreateCourseUI> {
  File? _fileImage;
  String _idCourse = '';
  String courseName = '';
  String _idTeacher = '';
  String _teacherName = '';
  List<Info> _teacherNameList = [];
  List<Info> _teacherIdList = [];
  bool _comboBoxStatus = false;
  Info? _selectName;
  Info? _selectId;
  String? _keyFlow;
  String _imageLink = '';
  TextEditingController _idController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  Map<String, dynamic>? _data;
  Info? _person;
  _CreateCourseUIState(this._keyFlow, this._data);

  CreateCoursePresenter? _createCoursePresenter;
  @override
  void initState(){
    _createCoursePresenter = CreateCoursePresenter();
    _idCourse = CommonKey.COURSE+getCurrentTime();
    getData();
    getInfo();
    if(CommonKey.EDIT==_keyFlow){
      _nameController = TextEditingController(text: _data!['name']);
      _idController = TextEditingController(text: _data!['idCourse']);
      courseName = _data!['name'];
      _idCourse = _data!['idCourse'];
      _imageLink = _data!['imageLink'];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(toolbarHeight: 0,),
      body: GestureDetector(
        onTap: ()=>hideKeyboard(),
        child: Column(
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
        child: Stack(
          children: [
            Container(width: getWidthDevice(context),height: 52,alignment: Alignment.center,
            child: NeoText('Tạo khóa học', textStyle: TextStyle(color: AppColors.ultraRed, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
          Positioned(child: IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back, color: AppColors.ultraRed,))
            ,left: 0,)
          ],
        ),
      ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => cropImage(context, (p0) => setState(()=>_fileImage=p0!), ''),
                      child: Center(child: _fileImage!=null?Image(image: FileImage(_fileImage!),width: 150/3*4, height: 150,):_imageLink.isEmpty?Image.asset(Images.pick_photo, width: 150/3*4, height: 150,):loadPhoto.networkImage(_imageLink, 150/3*4, 150)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        decoration: AppThemes.textFieldInputDecoration(labelText: Languages.of(context).courseName, hintText: Languages.of(context).courseName),
                        onChanged: (value)=>setState(()=> courseName=value),
                        controller: _nameController,
                      ),
                    ),
                    _comboBoxStatus?Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomDropDownName(
                        value: _selectName,
                        itemsList: _teacherNameList,
                        onChanged: (value){
                          setState((){
                            _selectName=value;
                            _selectId=value;
                            _teacherName=_selectName!.fullname!;
                            _idTeacher=_selectId!.phone!;
                          });
                        },
                      ),
                    ):SizedBox(),
                    _comboBoxStatus?Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomDropDownId(
                        value: _selectId,
                        itemsList: _teacherIdList,
                        onChanged: (value){
                          setState((){
                            _selectId=value;
                            _selectName=value;
                            _idTeacher=_selectId!.phone!;
                            _teacherName=_selectName!.fullname!;
                          });
                        },
                      ),
                    ):SizedBox(),
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      width: getWidthDevice(context),
                      child:  ElevatedButton(
                        style:  ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith((states) {
                              // If the button is pressed, return green, otherwise blue
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.blue;
                              }
                              return Colors.deepOrange;
                            }),),
                          onPressed: () {
                            if(courseName.isEmpty){
                              Fluttertoast.showToast(msg: Languages.of(context).nameRequired);
                            }else if(_fileImage==null && CommonKey.EDIT!=_keyFlow){
                              Fluttertoast.showToast(msg: Languages.of(context).photoRequired);
                            } else{
                              showLoaderDialog(context);
                              CommonKey.EDIT!=_keyFlow?_createCoursePresenter!.createCourse(_fileImage!, replaceSpace(_idCourse), courseName, _teacherName, _idTeacher).then((value) {
                                _onResult(value);
                              }):_fileImage!=null?_createCoursePresenter!.updateCourse(fileImage: _fileImage, courseId: replaceSpace(_idCourse), teacherId: _idTeacher, courseName: courseName, teacherName: _teacherName).then((value) {
                                _onResult(value);
                              })
                                  :_createCoursePresenter!.updateCourse(courseId: replaceSpace(_idCourse), teacherId: _idTeacher, courseName: courseName, teacherName: _teacherName, imageLink: _imageLink).then((value) {
                                _onResult(value);
                              });
                            }
                          },
                          child: NeoText(Languages.of(context).confirm, textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.white))),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getData() async{
    await FirebaseFirestore.instance.collection('users').where('role', isEqualTo: CommonKey.TEACHER).get().then((value) {
      value.docs.forEach((element) {
        Info person = Info.fromJson(element.data());
        _teacherNameList.add(person);
        _teacherIdList.add(person);
      });
      // _selectName = _teacherNameList[0];
      // _selectId = _teacherIdList[0];
      for(Info p in _teacherNameList){
        if(p.fullname==_person!.fullname){
          _selectName = p;
        }
        else{
          _selectName=_teacherNameList[0];
        }
      }
      for(Info p in _teacherIdList){
        if(p.fullname==_person!.fullname){
          _selectId = p;
        }
        else{
          _selectId = _teacherIdList[0];
        }
      }
      _teacherName = _selectName!.fullname!;
      _idTeacher = _selectId!.phone!;
      if(CommonKey.EDIT==_keyFlow){
        for(Info p in _teacherNameList){
          if(p.fullname==_data!['teacherName']){
            _selectName = p;
          }
        }
        for(Info p in _teacherIdList){
          if(p.fullname==_data!['teacherName']){
            _selectId = p;
          }
        }
      }
      setState((){_comboBoxStatus = true;});
    });
  }
  void _onResult(bool value){
    Navigator.pop(context);
    if(value){
      Navigator.pop(context);
      Fluttertoast.showToast(msg: Languages.of(context).onSuccess);
    }else{
      customDialog(context: context, iconData: Icons.warning_rounded, title: 'Aloo', content: 'Lỗi');
    }
  }
  Future<void> getInfo() async{
    _person = await _createCoursePresenter!.getAccountInfo();
    setState(()=>null);
  }
}

class CustomDropDownName extends StatelessWidget{
  final value;
  final List<Info> itemsList;
  final Function(dynamic value) onChanged;

  const CustomDropDownName({
    required this.value,
    required this.itemsList,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3, bottom: 3),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(
                color: AppColors.ultraRed
            )
        ),
        child: DropdownButtonHideUnderline(
          child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton2(
                  isExpanded: true,
                  value: value,
                  iconEnabledColor: AppColors.cultured,
                  iconDisabledColor: AppColors.cultured,
                  items: itemsList
                      .map((Info item) => DropdownMenuItem<Info>(
                    value: item,
                    child: NeoText(
                      item.fullname!,
                      textStyle: const TextStyle(fontSize: 16, color: AppColors.black),
                    ),
                  ))
                      .toList(),
                  onChanged: (value) => onChanged(value),
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  dropdownMaxHeight: MediaQuery.of(context).size.height/2,
                  dropdownWidth: MediaQuery.of(context).size.width/2+25,
                ),
              )
          ),
        ),
      ),
    );
  }

}

class CustomDropDownId extends StatelessWidget{
  final value;
  final List<Info> itemsList;
  final Function(dynamic value) onChanged;

  const CustomDropDownId({
    required this.value,
    required this.itemsList,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3, bottom: 3),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(
                color: AppColors.ultraRed
            )
        ),
        child: DropdownButtonHideUnderline(
          child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton2(
                  isExpanded: true,
                  value: value,
                  iconEnabledColor: AppColors.cultured,
                  iconDisabledColor: AppColors.cultured,
                  items: itemsList
                      .map((Info item) => DropdownMenuItem<Info>(
                    value: item,
                    child: NeoText(
                      item.phone!,
                      textStyle: TextStyle(fontSize: 16, color: AppColors.black),
                    ),
                  ))
                      .toList(),
                  onChanged: (value) => onChanged(value),
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  dropdownMaxHeight: MediaQuery.of(context).size.height/2,
                  dropdownWidth: MediaQuery.of(context).size.width/2+25,
                ),
              )
          ),
        ),
      ),
    );
  }

}
