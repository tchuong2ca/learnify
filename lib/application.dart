import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:online_learning/res/images.dart';
import 'package:online_learning/storage/storage.dart';
import 'package:online_learning/screen/authentication/enums/mode.dart';
import 'package:online_learning/screen/authentication/routes/login.dart';
import 'package:online_learning/screen/home/dashboard.dart';

import 'common/colors.dart';
import 'common/dimens.dart';
import 'common/functions.dart';
import 'common/keys.dart';
import 'common/widgets.dart';
import 'external/smooth_page_indicator/effects/slide_effect.dart';
import 'external/smooth_page_indicator/smooth_page_indicator.dart';
import 'languages/const_locate.dart';
import 'languages/languages.dart';
import 'languages/localization.dart';

class Application extends StatefulWidget{

  static void setLocale(BuildContext context, Locale newLocale){
    var state = context.findAncestorStateOfType<_Application>();
    state!.setLocale(newLocale);
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Application();
  }

}

class _Application extends State<Application>{

  Locale? _locale;
  void setLocale(Locale locale){
    setState((){
      _locale = locale;
    });
  }


  @override
  void didChangeDependencies() async{
    getLocale().then((value){
      setState((){
        _locale = value;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      builder: (context, child){
        return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: child!);
      },
      home: SplashTutorialPage(),
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [
        Locale('en',''),
        Locale('vn','')
      ],
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }

}
class SplashTutorialPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState()=>SplashTutorialState();

}

class SplashTutorialState extends State<SplashTutorialPage>{
  PageController? _pageControllerComment = PageController(
    initialPage: 0,
  );


  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    Timer(const Duration(seconds: 3), (){
      getData();
    });
    super.initState();
    //_SaveData();
  }

  // _SaveData() async{
  //   await SharedPreferencesData.SaveData(StringsText.TUTORIAL_INTRO, StringsText.TUTORIAL_INTRO);
  // }
  bool? _checkLogin;
  DateTime _now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("${Images.background_tutorial}"),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.only(left:AppDimens.spaceHalf, right: AppDimens.spaceHalf, bottom: AppDimens.spaceMedium, top: AppDimens.spaceLarge),
      child: Column(children: [
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: AppDimens.spaceLarge),
              height: getHeightDevice(context)*0.7,
              child: PageView.builder(
                  itemCount: 3,
                  controller: _pageControllerComment,
                  itemBuilder: (BuildContext context, int index) {
                    return _itemTutorial(index);
                  },
                  onPageChanged: (int index) {
                  }),),
          ],
        ),
        _buildStepIndicatorComment(),
        Spacer(),
        _checkLogin==false?SizedBox(
          width: getWidthDevice(context)*0.7,
          child: MaterialButton(
            onPressed: () =>Navigator.push(context, MaterialPageRoute(builder: (_)=>Login(_now.hour < 18&&_now.hour>5?Mode.day:Mode.night, 0))),
            child: NeoText(
                Languages.of(context).login,
                textStyle: TextStyle(fontSize: 16, color: CommonColor.blue)
            ),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(16.0),
            ),
            color: CommonColor.white,
          ),
        ):SizedBox(),
        SizedBox(height: AppDimens.spaceHalf,),
        _checkLogin==false?SizedBox(
          width: getWidthDevice(context)*0.7,
          child: MaterialButton(
            onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>Login(_now.hour < 18&&_now.hour>5?Mode.day:Mode.night,1))),
            child: NeoText(
                Languages.of(context).signUp,
                textStyle: TextStyle(fontSize: 16, color: CommonColor.white)),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(16.0),
                side: BorderSide(
                    color: CommonColor.white,
                    width: 0.5
                )
            ),
            color: CommonColor.blue,
          ),
        ):SizedBox(),

      ],),);
  }

  // Item comment
  Widget _itemTutorial(int index) {
    return Image(
      image: AssetImage(index==0?Images.tutorial0:(index==1?Images.tutorial1:Images.tutorial2)),
      height: 48,
      width: 48,
      fit: BoxFit.fill,
    );
  }
  _buildStepIndicatorComment() {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: SmoothPageIndicator(
        controller: _pageControllerComment!,
        count: 3,
        axisDirection: Axis.horizontal,
        effect: SlideEffect(
            spacing: 8.0,
            radius: 4.0,
            dotWidth: 8.0,
            dotHeight: 8.0,
            dotColor: CommonColor.blue,
            activeDotColor: CommonColor.white),
      ),
    );
  }
  Future<void> getData() async{
    String role = '';
    String phone = '';
    dynamic username = await SharedPreferencesData.GetData(CommonKey.USERNAME);
    dynamic data = await SharedPreferencesData.GetData(CommonKey.USER);
    if(username.toString().isNotEmpty){
      setState(() {
        _checkLogin=true;
      });
      if(data!=null){
        Map<String, dynamic>json = jsonDecode(data.toString());
        role = json['role']!=null?json['role']:'';
        phone = json['phone']!=null?json['phone']:'';
      }
    }
    else{
      setState(() {
        _checkLogin=false;
      });
    }
    print(_checkLogin);
    if(_checkLogin==true){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage(role, phone)));
    }
  }
}