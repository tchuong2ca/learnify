import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:online_learning/common/widgets.dart';
import 'package:online_learning/screen/course/model/class_detail.dart';
import 'package:online_learning/screen/course/model/course_model.dart';
import 'package:online_learning/screen/course/model/my_class_model.dart';
import 'package:online_learning/screen/lesson/model/lesson.dart';
import 'package:online_learning/screen/lesson/presenter/lesson_page_presenter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/keys.dart';
import '../../common/state.dart';
import '../../languages/languages.dart';
import 'create_new_lesson_page.dart';
import 'discuss/discuss_page.dart';
import 'lesson_pdf_viewer.dart';

class LessonPage extends StatefulWidget {
  Lesson? _lesson;
  String? _type;
  ClassDetail? _myClassDetail;
  CourseModel? _course;
  MyClassModel? _myClass;
  String? _role;
  LessonPage(this._lesson, this._type, this._myClassDetail, this._myClass, this._course, this._role);

  @override
  State<LessonPage> createState() => _LessonPageState(_lesson, _type, _myClassDetail, _myClass, _course, _role);
}


class _LessonPageState extends State<LessonPage> {
  Lesson? _lesson;
  String? _type;
  ClassDetail? _myClassDetail;
  CourseModel? _course;
  MyClassModel? _myClass;
  String? _role;
  _LessonPageState(this._lesson, this._type, this._myClassDetail, this._myClass, this._course, this._role);

  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  bool _isPlayerReady = false;
  LessonPagePresenter? _presenter;
  bool _isLoadFirst = true;

  @override
  void initState() {
    _presenter = LessonPagePresenter();
    _getData();
  }

  void _loadInitYoutube(){
    _controller = YoutubePlayerController(
        initialVideoId: '${getYoutubeId(_presenter!.detail!.videoLink!)}',
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: false,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        )
    )..addListener(() {_listen(); });
  }

  void _listen(){
    if(_isPlayerReady && mounted && !_controller.value.isFullScreen){
      // setState((){
      //   _playerState = _controller.value.playerState;
      // });
    }
  }


  @override
  void deactivate() {
    // if(_controller!=null){
    //   _controller.pause();
    // }
  }


  @override
  void dispose() {
    super.dispose();
    if(_controller!=null){
      _controller.dispose();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CommonColor.white,
      child: Observer(
        builder: (_){
          if(_presenter!.state==SingleState.LOADING){
            return Scaffold(
              appBar: AppBar(toolbarHeight: 0,),
              body: Center(child: Text('Loading...'),),
            );

          }else if(_presenter!.state==SingleState.NO_DATA){
            return Scaffold(
              appBar: AppBar(toolbarHeight: 0,),
              body: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //CustomAppBar(appType: AppType.child, title: _lesson!.lessonName!),
                  Expanded(
                    child: RefreshIndicator(
                        child: CustomScrollView(
                          slivers: [
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: notfound(Languages.of(context).noData),
                            )
                          ],
                        ), onRefresh: (){
                      return Future.delayed(Duration(seconds: 1), () => setState(()=>_getData()),);
                    }),
                  )
                ],
              ),
              floatingActionButton: Visibility(
                visible: CommonKey.ADMIN==_role||CommonKey.TEACHER==_role,
                child: FloatingActionButton(
                  onPressed: ()=> {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => LessonProductPage(_lesson!, '', _course!, _myClass!, _myClassDetail!, null))),
                    _controller.pause(),
                  },
                  child: Icon(
                    Icons.add,
                    color: CommonColor.white,
                  ),
                ),
              ),
            );
          }else{
            if(_isLoadFirst){
              _loadInitYoutube();
              _isLoadFirst=false;
            }
            return YoutubePlayerBuilder(
              onExitFullScreen: (){
              },
              player: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blueAccent,
                onReady: (){
                  _isPlayerReady = true;
                },
                onEnded: (value){

                },
              ),
              builder: (context, player)=>DefaultTabController(
                length: 4,
                child: Scaffold(
                  appBar: AppBar(
                    toolbarHeight: 0,
                    elevation: 0,
                  ),
                  body: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //CustomAppBar(appType: AppType.child, title: _lesson!.nameLesson!),
                      player,
                      Container(
                        width: getWidthDevice(context),
                        child: TabBar(
                          labelColor: CommonColor.blue,
                          tabs: [
                            Tab(
                              text: Languages.of(context).content,
                            ),
                            Tab(
                              text: Languages.of(context).exercise,
                            ),
                            Tab(
                              text: Languages.of(context).answer,
                            ),
                            Tab(
                              text: Languages.of(context).discuss,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            Container(
                                child: _presenter!.detail!=null?PdfViewerPage(_presenter!.detail!.fileContent, null, null)
                                    :notfound(Languages.of(context).noData)
                            ),
                            Container(
                                child: _presenter!.detail!=null?PdfViewerPage(_presenter!.detail!.homework![0].question, _presenter!.detail!.homework![0].listQuestion, _presenter!.detail)
                                    :notfound(Languages.of(context).noData)
                            ),
                            Container(
                                child: _presenter!.detail!=null?PdfViewerPage(_presenter!.detail!.homework![0].answer, null, null)
                                    :notfound(Languages.of(context).noData)
                            ),
                            Container(
                              child: _presenter!.detail!=null?
                                  //SizedBox()
                              DiscussPage(_presenter!.detail)
                                  :notfound(Languages.of(context).noData),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  floatingActionButton: Visibility(
                    visible: CommonKey.ADMIN==_role||CommonKey.TEACHER==_role,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: FloatingActionButton(
                          onPressed: ()=> {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => LessonProductPage(_lesson!, _presenter!.state==SingleState.HAS_DATA?CommonKey.EDIT:'', _course!, _myClass!, _myClassDetail!, _presenter!.state==SingleState.HAS_DATA?_presenter!.detail:null))),
                            _controller.pause(),
                          },
                          child: Observer(
                            builder: (_){
                              if(_presenter!.state==SingleState.HAS_DATA){
                                return Icon(
                                  Icons.edit,
                                  color: CommonColor.white,
                                );
                              }else{
                                return Icon(
                                  Icons.edit,
                                  color: CommonColor.white,
                                );
                              }
                            },
                          )
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _getData(){
    _presenter!.getLessonDetail(_lesson!);
  }
}
