import 'package:flutter/material.dart';
import 'package:flutter_flexible_toast/flutter_flexible_toast.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:online_learning/common/widgets.dart';
import 'package:online_learning/external/splitview/splitview.dart';
import 'package:online_learning/screen/course/model/class_detail.dart';
import 'package:online_learning/screen/course/model/course_model.dart';
import 'package:online_learning/screen/course/model/my_class_model.dart';
import 'package:online_learning/screen/lesson/model/lesson.dart';
import 'package:online_learning/screen/lesson/presenter/lesson_page_presenter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/keys.dart';
import '../../common/state.dart';
import '../../languages/languages.dart';
import 'create_lesson_content.dart';
import 'discuss/discuss_page.dart';
import 'exercise/exercise_page.dart';
import 'lesson_pdf_viewer.dart';

class LessonPage extends StatefulWidget {
  Lesson? _lesson;
  String? _type;
  ClassDetail? _myClassDetail;
  CourseModel? _course;
  MyClassModel? _myClass;
  String? _role;
  String? _classDetailId;
  int? _index;
  LessonPage(this._lesson, this._type, this._myClassDetail, this._myClass, this._course, this._role, this._classDetailId, this._index);

  @override
  State<LessonPage> createState() => _LessonPageState(_lesson, _type, _myClassDetail, _myClass, _course, _role, _classDetailId, _index);
}


class _LessonPageState extends State<LessonPage> {
  Lesson? _lesson;
  String? _type;
  ClassDetail? _myClassDetail;
  CourseModel? _course;
  MyClassModel? _myClass;
  String? _role;
  String? _classDetailId;
  int? _index;
  _LessonPageState(this._lesson, this._type, this._myClassDetail, this._myClass, this._course, this._role, this._classDetailId, this._index);

   YoutubePlayerController? _controller;
  late PlayerState _playerState;
  bool _isPlayerReady = false;
  LessonPagePresenter? _presenter;
  bool _isLoadFirst = true;
  int? _tabIndex =0;
  bool _isQuizTab=false;
  @override
  void initState() {
    _presenter = LessonPagePresenter();
    _getData();
  }

  void _loadInitYoutube(){
    _controller = YoutubePlayerController(
        initialVideoId: '${getYoutubeId(_presenter!.detail!.videoLink!)}',
        flags:  YoutubePlayerFlags(
          mute: false,
          autoPlay: false,
          disableDragSeek: _presenter!.detail!.isLive==true?true:false,
          loop: _presenter!.detail!.isLive==false?true:true,
          isLive: _presenter!.detail!.isLive==true?true:false,
          forceHD: true,
          enableCaption: true,
        )
    )..addListener(() {_listen(); });
  }

  void _listen(){
    if(_isPlayerReady && mounted && !_controller!.value.isFullScreen){
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
     _controller!.dispose();
   }

  }

  @override
  Widget build(BuildContext context) {


    return Container(
      color: AppColors.white,
      child: Observer(
        builder: (_){
          if(_presenter!.state==SingleState.LOADING){
            return Scaffold(
              appBar: AppBar(toolbarHeight: 0,),
              body: Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.ultraRed, size: 50),),
            );

          }else if(_presenter!.state==SingleState.NO_DATA){

            return Scaffold(
              appBar: AppBar(toolbarHeight: 0,),
              body: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: RefreshIndicator(
                        child: CustomScrollView(
                          slivers: [
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Stack(
                                children: [
                                  notfound(Languages.of(context).noData),
                                  Positioned(child:  Container(
                                    color: AppColors.transparent,
                                    height: 45,
                                    width: 45,
                                    //margin: EdgeInsets.all(4),
                                    child: Center(
                                      child: Card(
                                        shadowColor: AppColors.ultraRed,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        elevation: 2,
                                        child:  IconButton(
                                          icon: Icon(Icons.close, color: AppColors.ultraRed, size: 22),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                    top: 0, left: 0,),
                                ],
                              ),
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
                            builder: (_) => CreateLessonPage(_lesson!, '', _course!, _myClass!, _myClassDetail!, null, _classDetailId, _index))),
                   _controller!=null? _controller!.pause():null,
                  },
                  child: Icon(
                    Icons.add,
                    color: AppColors.white,
                  ),
                ),
              ),
            );
          }else{
            FlutterFlexibleToast.showToast(
                message:  _presenter!.detail!.isLive==true?"Đây là buổi học trực tuyến":"Đây là buổi học bình thường",
                toastLength: Toast.LENGTH_LONG,
                toastGravity: ToastGravity.TOP,
                icon: ICON.INFO,
                radius: 100,
                elevation: 0,
                imageSize: 25,
                textColor: Colors.white,
                backgroundColor: _presenter!.detail!.isLive==true?AppColors.ultraRed:AppColors.transparent,
                timeInSeconds: _presenter!.detail!.isLive==true?3:0
            );
            if(_isLoadFirst){
              _loadInitYoutube();
              _isLoadFirst=false;
            }
            return YoutubePlayerBuilder(
              onExitFullScreen: (){
              },
              player: YoutubePlayer(
                controller: _controller!,
                onReady: (){
                  _isPlayerReady = true;
                },
                onEnded: (value){

                },
              ),
              builder: (context, player){
                return DefaultTabController(

                  length: 3,
                  child: Scaffold(
                    appBar: AppBar(
                      toolbarHeight: 0,
                      elevation: 0,
                    ),
                    body: Stack(
                      children: [
                        SplitView(children: [
                          player,
                          SizedBox(
                            width: getWidthDevice(context),
                            child: Column(
                              children: [
                                TabBar(
                                  onTap: (int index) {

                                  setState(() {
                                   if(index==1){
                                     _isQuizTab = true;
                                   }
                                   else{
                                     _isQuizTab=false;
                                   }
                                    _tabIndex = index;
                                  });
                                  },
                                  labelColor: AppColors.ultraRed,
                                  tabs: [
                                    Tab(
                                      text: 'Bài giảng',
                                    ),
                                    Tab(
                                      text: Languages.of(context).exercise,),
                                    Tab(
                                      text: Languages.of(context).discuss,
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      Container(
                                          child: _presenter!.detail!=null?PdfViewerPage(_presenter!.detail!.fileContent)
                                              :notfound(Languages.of(context).noData)
                                      ),
                                      ExercisePage(_presenter!.detail!.lessonDetailId!, _role!),
                                      Container(
                                        child: _presenter!.detail!=null?
                                        DiscussPage(_presenter!.detail)
                                            :notfound(Languages.of(context).noData),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],  gripSize: 16,
                          gripColorActive: AppColors.ultraRed,
                          gripColor: AppColors.transparent,
                          viewMode: SplitViewMode.Vertical,
                          indicator: SplitIndicator(viewMode: SplitViewMode.Vertical, color: AppColors.ultraRed,),
                          activeIndicator: SplitIndicator(
                            viewMode: SplitViewMode.Vertical,
                            isActive: true,
                          ),
                          controller: SplitViewController(weights: [_isQuizTab?0:0.28],limits: [null, WeightLimit(min: _isQuizTab?1:0.72)]),),
                        Positioned(child:  Container(
                          color: AppColors.transparent,
                          height: 45,
                          width: 45,
                          //margin: EdgeInsets.all(4),
                          child: Center(
                            child: Card(
                              shadowColor: AppColors.ultraRed,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 2,
                              child:  IconButton(
                                icon: Icon(Icons.close, color: AppColors.ultraRed, size: 22),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        ),
                          top: 0, left: 0,),
                      ],
                    ),
                    floatingActionButton: Visibility(
                      visible: CommonKey.ADMIN==_role&&_tabIndex==0||CommonKey.TEACHER==_role&&_tabIndex==0,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: FloatingActionButton(
                            onPressed: ()=> {

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CreateLessonPage(_lesson!, _presenter!.state==SingleState.HAS_DATA?CommonKey.EDIT:'', _course!=null?_course!:null, _myClass!, _myClassDetail!, _presenter!.state==SingleState.HAS_DATA?_presenter!.detail:null, _classDetailId, _index))),
                              _controller!.pause(),
                            },
                            child: Observer(
                              builder: (_){
                                if(_presenter!.state==SingleState.HAS_DATA){
                                  return Icon(
                                    Icons.edit,
                                    color: AppColors.white,
                                  );
                                }else{
                                  return Icon(
                                    Icons.edit,
                                    color: AppColors.white,
                                  );
                                }
                              },
                            )
                        ),
                      ),
                    ),
                  ),
                );
              },
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
