import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_learning/screen/course/presenter/create_class_presenter.dart';
import 'package:online_learning/screen/course/status.dart';
import '../../common/colors.dart';
import '../../common/days_dropdown.dart';
import '../../common/functions.dart';
import '../../common/keys.dart';
import '../../common/status_dropdown.dart';
import '../../common/themes.dart';
import '../../common/widgets.dart';
import '../../external/custom_time_picker/custom_picker.dart';
import '../../external/custom_time_picker/flutter_datetime_picker.dart';
import '../../external/custom_time_picker/src/i18n_model.dart';
import '../../languages/languages.dart';
import '../../res/images.dart';
import 'days.dart';
import 'model/course_model.dart';
import 'model/my_class_model.dart';
class CreateClassUI extends StatefulWidget {
  final CourseModel? _course;
  final String? _keyFlow;
  final Map<String, dynamic>? _data;
  CreateClassUI(this._course, this._keyFlow, this._data);

  @override
  State<CreateClassUI> createState() => _CreateClassUIState(_course, _keyFlow, _data);
}

class _CreateClassUIState extends State<CreateClassUI> {
  final CourseModel? _course;
  final String? _keyFlow;
  final Map<String, dynamic>? _data;
  _CreateClassUIState(this._course, this._keyFlow, this._data);
  File? _fileImage;
  String _idClass=''; String _idCourse=''; String _idTeacher='';
  String _teacherName=''; String _status=''; final String _firstDay='';
  final String _price=''; String _nameClass = ''; String _describe = '';
  final List<Status> _statusList = [];
  Status? _selectStatus;
  CreateClassPresenter? _presenter;
  TextEditingController _controllerIdClass = TextEditingController();
  TextEditingController _controllerNameClass = TextEditingController();
  TextEditingController _controllerDescribeClass = TextEditingController();
  String _imageLink = '';
  String _hour = '';
  String _day1 = 'MON';
  String _day2 = 'TUE';
  List<Days> _dayList = [
  ];
  List<Days> _dayList2 = [
  ];
  List<Days> _dayList3 = [
    Days(date: 'Thứ 2', key: CommonKey.MON),
    Days(date: 'Thứ 3', key: CommonKey.TUE),
    Days(date: 'Thứ 4', key: CommonKey.WED),
    Days(date: 'Thứ 5', key: CommonKey.THU),
    Days(date: 'Thứ 6', key: CommonKey.FRI),
    Days(date: 'Thứ 7', key: CommonKey.SAT),
    Days(date: 'Chủ Nhật', key: CommonKey.SUN),
  ];
  Days? _daySelector1;
  Days? _daySelector2;
  TextEditingController _timeController = TextEditingController();
  @override
  void initState() {
    _idClass=CommonKey.CLASS+getCurrentTime();
    _idCourse = _course!.getIdCourse!;
    _idTeacher = _course!.getIdTeacher!;
    _teacherName = _course!.getNameTeacher!;
    _statusList.add(Status('', 'Trạng thái'));
    _statusList.add(Status(CommonKey.PENDING, 'Chưa bắt đầu'));
    _statusList.add(Status(CommonKey.READY, 'Bắt đầu'));
    _selectStatus = _statusList[0];
    _dayList =List.from(_dayList3);

    _dayList2 =List.from(_dayList3);

    // _daySelector1 = _dayList[0];
    // _daySelector2 = _dayList2[1];
    _presenter = CreateClassPresenter();
    if(CommonKey.EDIT==_keyFlow){
      _controllerIdClass = TextEditingController(text: _data!['idClass']);
      _controllerNameClass = TextEditingController(text: _data!['nameClass']);
      _controllerDescribeClass = TextEditingController(text: _data!['describe']);
      _idClass = _data!['idClass'];
      _nameClass = _data!['nameClass'];
      _describe = _data!['describe'];
      _imageLink = _data!['imageLink'];
      for(Status s in _statusList){
        if(s.getKey==_data!['status']){
          _selectStatus = s;
        }
      }
      _status=_selectStatus!.getKey;
      _day1 = _data!['onStageMon']==''?'MON':_data!['onStageMon'];
      _hour = _data!['startHours'];
      _timeController = TextEditingController(text: _hour);
      _daySelector1 = CommonKey.MON==_day1?_dayList[0]
          :CommonKey.TUE==_day1?_dayList[1]
          :CommonKey.WED==_day1?_dayList[2]
          :CommonKey.THU==_day1?_dayList[3]
          :CommonKey.FRI==_day1?_dayList[4]
          :CommonKey.SAT==_day1?_dayList[5]
          :_dayList[6];
      _dayList.removeAt(1);
      _daySelector2 = CommonKey.MON==_day2?_dayList2[0]
          :CommonKey.TUE==_day2?_dayList2[1]
          :CommonKey.WED==_day2?_dayList2[2]
          :CommonKey.THU==_day2?_dayList2[3]
          :CommonKey.FRI==_day2?_dayList2[4]
          :CommonKey.SAT==_day2?_dayList2[5]
          :_dayList2[6];
      _dayList2.removeAt(0);
      print('');
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
                  IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back, color: CommonColor.blue,)),
                  SizedBox(width: 8,),
                  Expanded(child: NeoText('Tạo khóa học', textStyle: TextStyle(color: CommonColor.blueLight, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                  ElevatedButton(
                      onPressed: () {
                        if(_fileImage==null&&CommonKey.EDIT!=_keyFlow
                        ){
                          Fluttertoast.showToast(msg: 'Ảnh đâu');
                        }else if(_nameClass.isEmpty){
                          Fluttertoast.showToast(msg: 'Tên đâu');
                        }else if(_status.isEmpty){
                          Fluttertoast.showToast(msg: 'status đâu');
                        }else if(_hour.isEmpty){
                          Fluttertoast.showToast(msg: 'thời gian đâu');
                        }else{
                          MyClassModel myClass = MyClassModel(idClass: replaceSpace(_idClass), idCourse: _idCourse, idTeacher: _idTeacher,
                              teacherName: _teacherName, status: _status,
                              onStageMon: _day1==CommonKey.MON?_day1:_day2==CommonKey.MON?_day2:'',
                              onStageTue: _day1==CommonKey.TUE?_day1:_day2==CommonKey.TUE?_day2:'',
                              onStageWed: _day1==CommonKey.WED?_day1:_day2==CommonKey.WED?_day2:'',
                              onStageThu: _day1==CommonKey.THU?_day1:_day2==CommonKey.THU?_day2:'',
                              onStageFri: _day1==CommonKey.FRI?_day1:_day2==CommonKey.FRI?_day2:'',
                              onStageSat: _day1==CommonKey.SAT?_day1:_day2==CommonKey.SAT?_day2:'',
                              onStageSun: _day1==CommonKey.SUN?_day1:_day2==CommonKey.SUN?_day2:'',
                              startHours: _hour,
                              price: '', nameClass: _nameClass, describe: _describe);
                          showLoaderDialog(context);
                          CommonKey.EDIT!=_keyFlow?_presenter!.createClass(_fileImage!, _course!, myClass).then((value) {
                            listenStatus(context, value);
                          })
                              :_fileImage!=null?_presenter!.UpdateClass(file: _fileImage, course: _course, myClass: myClass).then((value) {
                            listenStatus(context, value);
                          })
                              :_presenter!.UpdateClass(course: _course, myClass: myClass, url: _imageLink).then((value) {
                            listenStatus(context, value);
                          });
                        }
                      },
                      child: NeoText('Tạo', textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CommonColor.white))),
                  SizedBox(width: 8,)
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
                    InkWell(
                      onTap: () => cropImage(context,(p0) => setState(()=>_fileImage=p0!), ''),
                      child: Center(child: _fileImage!=null?Image(image: FileImage(_fileImage!),width: 150, height: 150,):(_imageLink.isNotEmpty&&CommonKey.EDIT==_keyFlow)?ImageLoad.imageNetwork(_imageLink, 150, 150):Image.asset(Images.tutorial1, width: 150, height: 150,fit: BoxFit.fill,)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).nameClass, hintText: Languages.of(context).nameClass),
                        onChanged: (value)=>setState(()=> _nameClass=value),
                        controller: _controllerNameClass,
                      ),
                    ),

                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: DropDownBoxStatus(
                          value: _selectStatus,
                          itemsList: _statusList,
                          onChanged: (value){
                            setState((){
                              _selectStatus = value;
                              _status = _selectStatus!.getKey;
                            });
                          },
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).describeClass, hintText: Languages.of(context).describeClass),
                        onChanged: (value)=>setState(()=> _describe=value),
                        maxLines: 10,
                        controller: _controllerDescribeClass,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child:InkWell(
                        onTap: (){
                          DatePicker.showPicker(context, showTitleActions: true,
                              onChanged: (date) {
                                print('change $date in time zone ' +
                                    date.timeZoneOffset.inHours.toString());
                              }, onConfirm: (date) {
                                      List list = splitList(splitSpaceEnd(date.toString()));
                                      _hour = '${list[0]}:${list[1]}';
                                      _timeController = TextEditingController(text: _hour);
                                      setState(()=>null);
                              },
                              pickerModel: CustomPicker(currentTime: DateTime.now()),
                              locale: LocaleType.vi);
                        },
                        child: TextFormField(
                          decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).startHours, hintText: Languages.of(context).startHours),
                          enabled: false,
                          controller: _timeController,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(16),
                      child: Text('Chọn ngày học trong tuần (2 buổi)'),),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: DaysDropdown(
                        value: _daySelector1,
                        itemsList:
                        _dayList,
                        onChanged: (value){
                          setState((){

                            _daySelector1=value;
                            _day1=_daySelector1!.key!;
                            _dayList2=List.from(_dayList3);
                            _day1==CommonKey.MON?
                            _dayList2.removeAt(0):
                            _day1==CommonKey.TUE?
                            _dayList2.removeAt(1):
                            _day1==CommonKey.WED?
                            _dayList2.removeAt(2):
                            _day1==CommonKey.THU?
                            _dayList2.removeAt(3):
                            _day1==CommonKey.FRI?
                            _dayList2.removeAt(4):
                            _day1==CommonKey.SAT?
                            _dayList2.removeAt(5):
                            _dayList2.removeAt(6);

                            print(_dayList2);
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0,right: 16, bottom: 48),
                      child: DaysDropdown(
                        value: _daySelector2,
                        itemsList: _dayList2,
                        onChanged: (value){
                          setState((){
                            _daySelector2=value;
                            _day2=_daySelector2!.key!;
                            _dayList=List.from(_dayList3);
                            _day2==CommonKey.MON?
                            _dayList.removeAt(0):
                            _day2==CommonKey.TUE?
                            _dayList.removeAt(1):
                            _day2==CommonKey.WED?
                            _dayList.removeAt(2):
                            _day2==CommonKey.THU?
                            _dayList.removeAt(3):
                            _day2==CommonKey.FRI?
                            _dayList.removeAt(4):
                            _day2==CommonKey.SAT?
                            _dayList.removeAt(5):
                            _dayList.removeAt(6);
                            print(_dayList);
                          });
                        },
                      ),
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
}
