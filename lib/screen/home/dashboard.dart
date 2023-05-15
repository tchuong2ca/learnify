import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_learning/common/widgets.dart';
import 'package:online_learning/screen/course/class_list.dart';
import 'package:online_learning/screen/course/course_list.dart';
import 'package:online_learning/screen/course/model/course_model.dart';
import 'package:online_learning/screen/docs/doc_list_page.dart';
import 'package:online_learning/screen/home/dashboard_presenter.dart';
import 'package:online_learning/screen/personal/personal_page.dart';
import 'package:online_learning/screen/schedule/schedule.dart';

import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/keys.dart';
import '../../external/swiper_view/swiper.dart';
import '../../languages/languages.dart';
import '../../res/images.dart';
import '../course/class_detail_admin.dart';
import '../course/model/my_class_model.dart';
import '../social_networking/newsfeed/newsfeed_page.dart';
import '../teacher/teacher_list.dart';

class DashboardPage extends StatefulWidget {
  String? _role;
  String? _username;
DashboardPage(this._role, this._username);

  @override
  State<DashboardPage> createState() => _DashboardPageState(this._role, this._username);
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  String? _role;
  String? _username;
  String _phoneNumber='';
  Map<String, dynamic>? _user;
  Stream<QuerySnapshot>? _courseStream;
  Stream<QuerySnapshot>? _classStream;

  _DashboardPageState(this._role, this._username);
  DashboardPresenter? _presenter;
  int _widgetId = 1;
  late ScrollController _headerBannerController;
  late Timer _headerBannerScrollTimer;
  int _headerScrollIndex = 0;
  AnimationController? _controller;
  Animation<double>? _animation;

  CourseModel? _classModel;
  final List<String> _name = <String>['50000+ thành viên', '100+ lớp học đang diễn ra', '10% lợi nhuận xây trường','hê sờ lô', 'hê sờ li li'];
  final List<String> _photo = <String>[Images.slide2, Images.slide1, Images.day, Images.night, Images.moon];
  bool _toggle=false;
  @override
  void initState(){
    super.initState();
    _presenter=DashboardPresenter();
    _getAccountInfor();
    _courseStream = FirebaseFirestore.instance.collection('course').snapshots();
    _classStream = FirebaseFirestore.instance.collection('class').snapshots();
    Future.delayed(const Duration(seconds: 20), () { //asynchronous delay
      if (this.mounted) { //checks if widget is still active and not disposed
        setState(() { //tells the widget builder to rebuild again because ui has updated
          _widgetId = _widgetId == 1 ? 2 : 1;
          _toggle=true;
          //update the variable declare this under your class so its accessible for both your widget build and initState which is located under widget build{}
          _headerBannerScrollTimer.cancel();
        });
      }
    });
    _headerBannerController = ScrollController();
    _headerBannerScrollTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _headerScrollIndex++;
      if(_headerScrollIndex*30<_headerBannerController.position.maxScrollExtent)
      {
        _headerBannerController.animateTo(_headerBannerController.position.maxScrollExtent,
            duration: Duration(seconds: 5), curve: Curves.linear);
      }
      else{
        _headerBannerController.animateTo(_headerBannerController.position.minScrollExtent,
            duration: Duration(seconds: 1), curve: Curves.linear).whenComplete(() {
          _headerScrollIndex=0;
        });
      }
    });
    //convertBase64ToImage();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.fastLinearToSlowEaseIn,
    );
    getCourse();
  }
  _toggleContainer() {
    print(_animation!.status);
    if (_animation!.status != AnimationStatus.completed) {
      _presenter!.seeMore=false;
      _controller!.forward();
    } else {
      _presenter!.seeMore=true;
      _controller!.animateBack(0, duration: Duration(milliseconds: 500));
    }
  }
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
  Widget _renderWidget1() {
    return Container(
      color: Colors.transparent,
      key: Key('first'),
      height: 130,
    );
  }

  Widget _renderWidget2() {
    return Container(  color: Colors.transparent,);
  }
 
  Widget _renderWidget() {
    return _widgetId == 1 ? _renderWidget1() : _renderWidget2();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   toolbarHeight: 0,
        //   backgroundColor: CommonColor.transparent,
        // ),
        body: WillPopScope(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Expanded(child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              keyboardDismissBehavior : ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                        image: Image.asset(Images.background).image,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(bottomLeft:Radius.circular(25),bottomRight:Radius.circular(25)),
                      boxShadow: [
                        BoxShadow(
                          color: CommonColor.grayLight.withOpacity(1),
                          spreadRadius: 1,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(height: 40,color: CommonColor.transparent,),
                        Container(
                          width: getWidthDevice(context),
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            color: CommonColor.white.withOpacity(0.6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 8,),
                           IconButton(onPressed: (){
                             showDialog(
                               context: context,
                               builder: (context) => AlertDialog(
                                 title: Text('Are you sure?'),
                                 content: Text('Do you want to log out ?'),
                                 actions: <Widget>[
                                   TextButton(
                                     onPressed: () => Navigator.of(context).pop(false),
                                     child: Text('No'),
                                   ),
                                   TextButton(
                                     onPressed: () =>  signOut(context),
                                     child: Text('Yes'),
                                   ),
                                 ],
                               ),
                             );}, icon: Icon(Icons.logout)),
                              SizedBox(width: 8,),
                              Expanded(child: NeoText(Languages.of(context).appName, textStyle: TextStyle(color: CommonColor.blueLight, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                              IconButton(
                                onPressed: (){},
                                icon: Icon(Icons.search_sharp, color: CommonColor.blue,),
                              )
                            ],
                          ),
                        ),
                        Observer(
                         builder: (_)=>Stack(
                           children: [
                             AnimatedSize(
                               duration: const Duration(seconds: 3),
                               curve: Curves.easeInCubic,
                               // other arguments
                               child: _renderWidget(),
                             ),
                             AnimatedOpacity(
                               opacity: _toggle==false ? 1.0 : 0.0,
                               duration: const Duration(milliseconds: 1700),
                               onEnd: (){
                                 _presenter!.setHeight(true);
                               },
                               child: SizedBox(
                                 //key: Key('first'),
                                   height: _presenter!.height==false?130:0,
                                   child: ListView.builder(
                                     controller: _headerBannerController,
                                     scrollDirection: Axis.horizontal,
                                     itemCount: _name.length,
                                     itemBuilder: (context, position) {
                                       return _buildTitleColumn(position);
                                     },
                                   )),
                             ),
                           ],
                         ),
                        ),
                        Observer(builder: (_)=>
                            Container(

                              padding: EdgeInsets.only(top: 4, bottom: 4),
                              margin: EdgeInsets.only(right: 16, left: 16,bottom: 24, top: _widgetId==2?16:0),
                              decoration:
                              BoxDecoration(color: CommonColor.white, borderRadius: BorderRadius.all(Radius.circular(8))),
                              child: (
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GridView.count(
                                        primary: false,
                                        padding: const EdgeInsets.all(8),
                                        childAspectRatio: getWidthDevice(context)/getHeightDevice(context)*1.75,
                                        shrinkWrap: true,
                                        crossAxisCount: 4,
                                        children: <Widget>[
                                          InkWell(
                                            child:    _tabChild(Images.schedule, _role=='ADMIN'||_role=='TEACHER'?'Tạo khóa/lớp học':'Lớp học của tôi'),
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (_)=>_role=='ADMIN'||_role=='TEACHER'?CourseList(_role,'',_username):ClassList(_classModel, _role, "DASHBOARD")));
                                            },
                                          ),

                                          InkWell(
                                            child:  _tabChild(Images.schedule, _role==CommonKey.TEACHER||_role==CommonKey.ADMIN?'Lịch dạy':'Lịch học'),
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (_)=> Schedule(_role)));
                                            },
                                          ),
                                          InkWell(
                                            child: _tabChild(Images.schedule, 'Mạng xã hội'),
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (_)=>NewsPage()));
                                            },
                                          ),
                                          InkWell(
                                            child:   _tabChild(Images.schedule, 'Cá nhân'),
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (_)=>PersonalPage(_role!)));
                                            },
                                          ),
                                        ],
                                      ),
                                      SizeTransition(
                                        sizeFactor: _animation!,
                                        axis: Axis.vertical,
                                        child:Container(
                                          color: CommonColor.white,
                                          child:    GridView.count(
                                            primary: false,
                                            padding: const EdgeInsets.all(8),
                                            childAspectRatio: getWidthDevice(context)/getHeightDevice(context)*1.75,
                                            shrinkWrap: true,
                                            crossAxisCount: 4,
                                            children: <Widget>[

                                              InkWell(
                                                child:    _tabChild(Images.schedule, 'Danh sách giáo viên'),
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (_)=>TeacherPage(_role)));
                                                },
                                              ),

                                              InkWell(
                                                child:  _tabChild(Images.schedule, 'Tài liệu'),
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (_)=>DocListPage(_user)));
                                                },
                                              ),
                                              InkWell(
                                                child: _tabChild(Images.schedule, 'Xếp hạng'),
                                                onTap: (){
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height:10),
                                      InkWell(
                                        //onTap:() => _presenter!.onSeeMoreClick(),
                                        onTap: (){
                                          _toggleContainer();
                                          _presenter!.onSeeMoreClick();
                                        },
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            NeoText(
                                              !_presenter!.seeMore ? "Xem thêm" : "Thu gọn",
                                              textStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: CommonColor.blue),
                                            ),
                                            Icon(!_presenter!.seeMore ? Icons.arrow_drop_down : Icons.arrow_drop_up,size:18,color: CommonColor.blue,)
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                              ),
                            )),

                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  itemSeeMore(context, Languages.of(context).course,(call) {
                    if(_role==null||_role!.isEmpty){
                      CustomDialog(context: context, content: Languages.of(context).requireLogin);
                    }else{
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>CourseList(_role, CommonKey.HOME_PAGE, _phoneNumber)));
                    }
                  }),
                  StreamBuilder<QuerySnapshot>(
                    stream: _courseStream,
                    builder: (context, snapshot){
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return Center(child: Text('Loading'),);
                      }else if(snapshot.hasError){
                        return Center(child: Text('No data'),);
                      }else{
                        return Swiper.children(
                            autoplay: false,
                            layout: SwiperLayout.TINDER,
                            itemWidth: getWidthDevice(context),
                            itemHeight: 340,
                            children: snapshot.data!.docs.map((e) {
                          Map<String, dynamic> data = e.data() as  Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: itemClass(context, data['name'], data['teacherName'], data['imageLink'], (click) => {

                              if(_role==null||_role!.isEmpty){
                                CustomDialog(context: context, content: Languages.of(context).requireLogin)
                              }else{
                                if(CommonKey.ADMIN==_role||(CommonKey.TEACHER==_role&&_phoneNumber==data['idTeacher'])){
                                  Navigator.push(context, MaterialPageRoute(builder: (_)=>ClassList(CourseModel(data['idCourse'], data['idTeacher'], data['teacherName'], data['name']), _role,''))),
                                }else if(CommonKey.MEMBER==_role){
                                  Navigator.push(context, MaterialPageRoute(builder: (_)=>ClassList(CourseModel(data['idCourse'], data['idTeacher'], data['teacherName'], data['name']), _role,CommonKey.MEMBER))),
                                } else{
                                  Fluttertoast.showToast(msg: Languages.of(context).denyAccess)
                                }

                              }

                            }, false),
                          );
                        }).toList());
                      }
                    },
                  ),
                  SizedBox(height: 16,),
                  itemSeeMore(context, Languages.of(context).classStudy, (call) {
                    if(_role==null||_role!.isEmpty){
                      CustomDialog(context: context, content: Languages.of(context).requireLogin);
                    }else{
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>ClassList(null, _role, '')));
                    }
                  }),
                  StreamBuilder<QuerySnapshot>(
                    stream: _classStream,
                    builder: (context, snapshot){
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return Center(child: Text('Loading'),);
                      }else if(snapshot.hasError){
                        return Center(child: Text('No data'),);
                      }else{
                        return Swiper.children(
                            autoplay: false,
                            layout: SwiperLayout.TINDER,
                            itemWidth: getWidthDevice(context),
                            itemHeight: 340,
                            children: snapshot.data!.docs.map((e) {
                              Map<String, dynamic> data = e.data() as  Map<String, dynamic>;
                              List<dynamic> listUser = data['subscribe'];
                              MyClassModel myClass = MyClassModel.fromJson(data);
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: itemClass(context, data['nameClass'], data['teacherName'], data['imageLink'], (click) => {

                                  if(_role==null||_role!.isEmpty){
                                    CustomDialog(context: context, content: Languages.of(context).requireLogin)
                                  }else{
                                    if(CommonKey.INK_WELL!=click&&!listUser.contains(_phoneNumber)){
                                      listUser.add(_phoneNumber!),
                                      _phoneNumber!.isNotEmpty?_presenter!.RegisterClass(data['idClass'], listUser, data['idCourse']):null,
                                    }else if(CommonKey.INK_WELL==click&&listUser.contains(_phoneNumber)){
                                      _navigatorClass(data, myClass),
                                    }else if(CommonKey.INK_WELL==click&&CommonKey.TEACHER==_role&&_phoneNumber==data['idTeacher']){
                                      _navigatorClass(data, myClass),
                                    }else if(CommonKey.INK_WELL==click&&CommonKey.TEACHER==_role&&_phoneNumber!=data['idTeacher']){
                                      Fluttertoast.showToast(msg: Languages.of(context).denyAccess),
                                    } else if(CommonKey.INK_WELL==click&&CommonKey.ADMIN==_role){
                                      _navigatorClass(data, myClass),
                                    } else{
                                      Fluttertoast.showToast(msg: Languages.of(context).requireClass)
                                    }
                                  }

                                },  (listUser.contains(_phoneNumber)&&CommonKey.MEMBER==_role)?false:(CommonKey.TEACHER==_role||CommonKey.ADMIN==_role)?false:true),
                              );
                            }).toList());
                      }
                    },
                  ),
                ],
              ),
            ))
            ],
          ),
          // _getBody(),
            onWillPop: _onWillPop
        ),

      );

  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to exit the App'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Yes'),
        ),
      ],
    ),
    )) ??
    false;
  }
  _buildTitleColumn(int _position) {
    return Container(
      margin: EdgeInsets.only(left: 6, top: 28, right: 6, bottom: 12),
      padding: EdgeInsets.only(left: 4, top: 24, right: 4, bottom: 4),
      width: (getWidthDevice(context) / 3.2 - 12),
      height:(getWidthDevice(context) / 3.2 - 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: CommonColor.white.withOpacity(0.8)),
      child: Container(
        alignment: Alignment.topCenter,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            NeoText(
              _name[_position],
              textAlign: TextAlign.center,
            ),
            Positioned(
              top: -50,
              child: Center(
                child: ClipRRect(
                  child: Image(image: AssetImage(_photo[_position]), width: 48, height: 48),
                  borderRadius: BorderRadius.all(Radius.circular(5000)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _tabChild(String icon,String title){
    return SizedBox(
      child: Column(
        children: [
          SizedBox(height: 8,),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: CommonColor.grayLight,
              borderRadius: BorderRadius.all(Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                  color: CommonColor.white,
                  spreadRadius: 1,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(icon),
            ),
          ),
          SizedBox(height: 4,),
          Expanded(child: NeoText(title,textStyle: TextStyle(fontSize: 14,overflow: TextOverflow.ellipsis, color: CommonColor.black),maxline: 2, textAlign: TextAlign.center)),
        ],
      ),
    );
  }
  Future<void> getCourse() async{
    _classModel = await _presenter!.getClass(_username!);
  }
  Future<void> _getAccountInfor() async{
    _user = await _presenter!.getUserInfo();
    _phoneNumber=_user!['phone'];
    setState(()=>null);
  }
  void _navigatorClass(Map<String, dynamic> data, MyClassModel myClass){
    _presenter!.getCourse(data['idCourse']).then((value) {
      if(value!=null&&value.getIdCourse!.isNotEmpty){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>ClassDetailAdminPage(myClass, value, _role)));
      }
    });
  }
  Widget itemClass(BuildContext context, String title, String gv, String imageLink, Function(String click) onClick, bool visiable){
    return InkWell(
      onTap: () => onClick(CommonKey.INK_WELL),
      child: Container(

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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            loadPhoto.imageNetwork('$imageLink', 196, getWidthDevice(context)),
            SizedBox(height: 16,),
            NeoText('$title', textStyle: TextStyle(color: CommonColor.black, fontWeight: FontWeight.bold, fontSize: 16, overflow: TextOverflow.ellipsis), maxline: 2),
            SizedBox(height: 8,),
            NeoText(
                'GV: $gv',
                textStyle: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: CommonColor.black,
                ),
                maxline: 2
            ),
            Spacer(),
            Visibility(
              visible: visiable,
              child: Container(
                width: getWidthDevice(context),
                margin: EdgeInsets.only(left: 8, right: 8),
                child: ElevatedButton(
                  onPressed: ()=>onClick(''),
                  child: NeoText(Languages.of(context).signUp),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
