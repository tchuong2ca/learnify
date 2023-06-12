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
  static Map<int, Color> color =
  {
    50:Color.fromRGBO(136,14,79, .1),
    100:Color.fromRGBO(136,14,79, .2),
    200:Color.fromRGBO(136,14,79, .3),
    300:Color.fromRGBO(136,14,79, .4),
    400:Color.fromRGBO(136,14,79, .5),
    500:Color.fromRGBO(136,14,79, .6),
    600:Color.fromRGBO(136,14,79, .7),
    700:Color.fromRGBO(136,14,79, .8),
    800:Color.fromRGBO(136,14,79, .9),
    900:Color.fromRGBO(136,14,79, 1),
  };
  MaterialColor primeColor = MaterialColor(0xFFf06a84, color);
  MaterialColor accentColor = MaterialColor(0xFF337C36, color);
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return MaterialApp(

        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          appBarTheme: AppBarTheme(

            iconTheme: IconThemeData(color: Colors.black),
            color: AppColors.vodka,

          ),
        ),
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
  }

  bool? _loginCheck;
  DateTime _now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[AppColors.white, AppColors.vodka]),
      ),

      padding: EdgeInsets.only(left:AppDimens.spaceHalf, right: AppDimens.spaceHalf, bottom: AppDimens.spaceMedium, top: AppDimens.spaceLarge),
      child: Column(children: [
        Image.asset(Images.logo_nobackground),
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: AppDimens.spaceLarge),
              height: getHeightDevice(context)*0.5,
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
        _loginCheck==false?SizedBox(
          width: getWidthDevice(context)*0.7,
          child: MaterialButton(
            onPressed: () =>Navigator.push(context, MaterialPageRoute(builder: (_)=>Login(_now.hour < 18&&_now.hour>5?Mode.day:Mode.night, 0))),
            child: NeoText(
                Languages.of(context).login,
                textStyle: TextStyle(fontSize: 16, color: AppColors.ultraRed)
            ),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(16.0),
            ),
            color: AppColors.white,
          ),
        ):SizedBox(),
        SizedBox(height: AppDimens.spaceHalf,),
        _loginCheck==false?SizedBox(
          width: getWidthDevice(context)*0.7,
          child: MaterialButton(
            onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>Login(_now.hour < 18&&_now.hour>5?Mode.day:Mode.night,1))),
            child: NeoText(
                Languages.of(context).signUp,
                textStyle: TextStyle(fontSize: 16, color: AppColors.white)),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(16.0),
                side: BorderSide(
                    color: AppColors.white,
                    width: 0.5
                )
            ),
            color: AppColors.ultraRed,
          ),
        ):SizedBox(),

      ],),);
  }

  // Item comment
  Widget _itemTutorial(int index) {
    return Image(
      image: AssetImage(index==0?Images.slide1:(index==1?Images.slide2:Images.slide3)),
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
            dotColor: AppColors.ultraRed,
            activeDotColor: AppColors.white),
      ),
    );
  }
  Future<void> getData() async{
    String role = '';
    String phone = '';
    dynamic username = await SharedPreferencesData.getData(CommonKey.USERNAME);
    dynamic data = await SharedPreferencesData.getData(CommonKey.USER);
    if(username.toString().isNotEmpty){
      setState(() {
        _loginCheck=true;
      });
      if(data!=null){
        Map<String, dynamic>json = jsonDecode(data.toString());
        role = json['role']!=null?json['role']:'';
        phone = json['phone']!=null?json['phone']:'';
      }
    }
    else{
      setState(() {
        _loginCheck=false;
      });
    }
    print(_loginCheck);
    if(_loginCheck==true){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage(role, phone)));
    }
  }
}