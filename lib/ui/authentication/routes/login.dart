
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_learning/common/functions.dart';
import 'package:online_learning/languages/languages.dart';
import 'package:online_learning/ui/home/dashboard.dart';

import '../../../common/keys.dart';
import '../../../common/widgets.dart';
import '../../../restart.dart';
import '../../../storage/storage.dart';
import '../components/day/sun.dart';
import '../components/day/sun_rays.dart';
import '../components/night/moon.dart';
import '../components/night/moon_rays.dart';
import '../components/toggle_button.dart';
import '../enums/mode.dart';
import '../models/login_theme.dart';
import '../utils/cached_images.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
class Login extends StatefulWidget {
  Mode? _mode;
  int? _index;
  Login(this._mode, this._index);
  @override
  _LoginState createState() => _LoginState(this._mode, this._index);
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  Mode? _mode;
  int? _index;
  _LoginState(this._mode, this._index);
  AnimationController? _animationController;
  LoginTheme? _day;
  LoginTheme? _night;
  // Mode _activeMode = Mode.day;
  Mode? _activeMode;

  String _fullname='';
  String _phone='';
  String _email='';
  String _pass1='';
  bool _seePass1 = false;
  final _formFullname = GlobalKey<FormState>();
  final _formPhone = GlobalKey<FormState>();
  final _formPass1 = GlobalKey<FormState>();
  final _formEmail = GlobalKey<FormState>();
  String _loginEmail='';
  String _loginPass='';
  @override
  void initState() {
    _activeMode = _mode;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _animationController!.forward(from: 0.0);
    }); // wait for all the widget to render
    initializeTheme(); //initializing theme for day and night
    super.initState();
  }

  @override
  void didChangeDependencies() {
    cacheImages();
    super.didChangeDependencies();
  }

  cacheImages() {
    CachedImages.imageAssets.forEach((asset) {
      precacheImage(asset, context);
    });
  }

  initializeTheme() {
    _day = LoginTheme(
      title: 'Good Morning,',
      backgroundGradient: [
        const Color(0xFF8C2480),
        const Color(0xFFCE587D),
        const Color(0xFFFF9485),
        const Color(0xFFFF9D80),
        // const Color(0xFFFFBD73),
      ],
      landscape: CachedImages.imageAssets[0],
      circle: Sun(
        controller: _animationController!,
      ),
      rays: SunRays(
        controller: _animationController!,
      ),
    );

    _night = LoginTheme(
      title: 'Good Night',
      backgroundGradient: [
        const Color(0xFF0D1441),
        const Color(0xFF283584),
        const Color(0xFF6384B2),
        const Color(0xFF6486B7),
      ],
      landscape: CachedImages.imageAssets[1],
      circle: Moon(
        controller: _animationController!,
      ),
      rays: MoonRays(
        controller: _animationController!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: GestureDetector(
            onTap: (){hideKeyboard();},
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _activeMode == Mode.day
                      ? _day!.backgroundGradient!
                      : _night!.backgroundGradient!,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    width: height * 0.8,
                    height: height * 0.8,
                    bottom: _activeMode == Mode.day ? -300 : -50,
                    child: _activeMode == Mode.day ? _day!.rays! : _night!.rays!,
                  ),
                  Positioned(
                    bottom: _activeMode == Mode.day ? -160 : -80,
                    child: _activeMode == Mode.day ? _day!.circle! : _night!.circle!,
                  ),
                  Positioned.fill(
                    child: Image(
                      image:
                      _activeMode == Mode.day ? _day!.landscape! : _night!.landscape!,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    top: height * 0.05,

                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ToggleButton(
                            startText: Languages.of(context).login,
                            endText: Languages.of(context).signUp,
                            tapCallback: (index) {
                              setState(() {
                                _index = index;
                                _animationController!.forward(from: 0.0);
                                print(_index);
                              });
                            },
                            index: _index
                        ),
                        isKeyboardVisible==true?SizedBox():_buildText(
                          text: _activeMode == Mode.day ? _day!.title! : _night!.title!,
                          padding: EdgeInsets.only(top: height * 0.02),
                          fontSize: width * 0.09,
                          fontFamily: 'YesevaOne',
                        ),
                        isKeyboardVisible==true?SizedBox():_buildText(
                          fontSize: width * 0.04,
                          padding: EdgeInsets.only(
                            top: height * 0.01,
                          ),
                          text: 'Enter your informations below',
                        ),
                        _index==0?_loginForm(isKeyboardVisible):_signUpForm(isKeyboardVisible),
                        GestureDetector(
                          onTap: (){
                          if(_index==0){
                            if(validateEmail(_loginEmail) && _loginPass.isNotEmpty){
                              showLoaderDialog(context);
                              _doLogin(_loginEmail, _loginPass);
                            }
                          }
                          else{
                            if(_formFullname.currentState!.validate()){
                            }
                            if(_formPhone.currentState!.validate()){
                            }
                            if(_formEmail.currentState!.validate()){
                            }
                            if(_formPass1.currentState!.validate()){
                            }

                            if(_pass1.isNotEmpty && _fullname.isNotEmpty && _email.isNotEmpty && _phone.isNotEmpty
                            ){
                              showLoaderDialog(context);
                              register(_email, _pass1);
                            }

                          }
                          },
                          child: Container(
                            width: getWidthDevice(context) - getWidthDevice(context) * 0.15,
                            margin: EdgeInsets.only(
                              top: getHeightDevice(context) * 0.02,
                            ),
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: getWidthDevice(context) * 0.155,
                              height: getWidthDevice(context) * 0.155,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: const Color(0xFFFFFFFF),
                                shadows: [
                                  BoxShadow(
                                    color: const Color(0x55000000),
                                    blurRadius: getWidthDevice(context) * 0.02,
                                    offset: Offset(3, 3),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.arrow_forward),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Padding _buildText(
      {double? fontSize, EdgeInsets? padding, String? text, String? fontFamily}) {
    return Padding(
      padding: padding!,
      child: Text(
        text!,
        style: TextStyle(
          color: const Color(0xFFFFFFFF),
          fontSize: fontSize,
          fontFamily: fontFamily ?? '',
        ),
      ),
    );
  }
  Widget _loginForm(bool isVisible){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildText(
          text: 'Email Address',
          padding: EdgeInsets.only(
              top: height * 0.04, bottom: height * 0.015),
          fontSize: width * 0.04,
        ),
        Container(
          width: getWidthDevice(context) * 0.85,
          alignment: Alignment.center,
          child: Theme(
            data: ThemeData(
              primaryColor: const Color(0x55000000),
            ),
            child: Form(
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(getWidthDevice(context) * 0.025),
                  ),
                  hintText: 'Enter your email',

                  hintStyle: TextStyle(
                    color: const Color(0xFFFFFFFF),
                  ),
                  fillColor: const Color(0x33000000),
                  filled: true,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (content){
                  _loginEmail=content;
                  setState((){
                  });
                },
              ),
            ),
          ),
        ),
        _buildText(
          text: 'Password',
          padding: EdgeInsets.only(
            top: height * 0.03,
            bottom: height * 0.015,
          ),
          fontSize: width * 0.04,
        ),
        Container(
          width: getWidthDevice(context) * 0.85,
          alignment: Alignment.center,
          child: Theme(
            data: ThemeData(
              primaryColor: const Color(0x55000000),
            ),
            child: Form(
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(getWidthDevice(context) * 0.025),
                  ),
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(
                    color: const Color(0xFFFFFFFF),
                  ),
                  fillColor: const Color(0x33000000),
                  filled: true,
                ),
                keyboardType: TextInputType.text,
                obscureText: !_seePass1,
                onChanged: (value){
                  _loginPass=value;
                  setState((){
                  });
                },
                validator: (value){
                  return value!.isEmpty?'\u26A0 ${Languages.of(context).passError}':null;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _signUpForm(bool isVisible){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildText(
          text: 'Full name',
          padding: EdgeInsets.only(
              top: isVisible?height*0.01:height * 0.02,
              bottom: height * 0.01),
          fontSize: width * 0.04,
        ),
        Container(
          width: getWidthDevice(context) * 0.85,
          alignment: Alignment.center,
          child: Theme(
            data: ThemeData(
              primaryColor: const Color(0x55000000),
            ),
            child: Form(
              key: _formFullname,
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(getWidthDevice(context) * 0.025),
                  ),
                  hintText: 'Enter your full name',

                  hintStyle: TextStyle(
                    color: const Color(0xFFFFFFFF),
                  ),
                  fillColor: const Color(0x33000000),
                  filled: true,
                ),
                onChanged: (fullname){
                  _fullname=fullname;
                  setState((){
                  });
                },
                validator: (value){
                  if(value!.isEmpty){
                    return '\u26A0 ${Languages.of(context).nameEmpty}';
                  }
                },
              ),
            ),
          ),
        ),
        _buildText(
          text: 'Phone',
          padding: EdgeInsets.only(
              top: isVisible?height*0.01:height * 0.02,
              bottom: height * 0.01),
          fontSize: width * 0.04,
        ),
        Container(
          width: getWidthDevice(context) * 0.85,
          alignment: Alignment.center,
          child: Theme(
            data: ThemeData(
              primaryColor: const Color(0x55000000),
            ),
            child: Form(
              key: _formPhone,
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(getWidthDevice(context) * 0.025),
                  ),

                  hintText: 'Enter your phone number',
                  hintStyle: TextStyle(
                    color: const Color(0xFFFFFFFF),
                  ),
                  fillColor: const Color(0x33000000),
                  filled: true,
                ),
                onChanged: (value){
                  _phone=value;
                  setState((){
                  });
                },
                keyboardType: TextInputType.phone,
                validator: (value){
                  if(value!.isEmpty){
                    return '\u26A0 ${Languages.of(context).phoneEmpty}';
                  }else if(value.length != 10){
                    return '\u26A0 ${Languages.of(context).phoneError}';
                  }
                },
              ),
            ),
          ),
        ),
        _buildText(
          text: 'Email Address',
          padding: EdgeInsets.only(
              top: isVisible?height*0.01:height * 0.02,
              bottom: height * 0.01),
          fontSize: width * 0.04,
        ),
        Container(
          width: getWidthDevice(context) * 0.85,
          alignment: Alignment.center,
          child: Theme(
            data: ThemeData(
              primaryColor: const Color(0x55000000),
            ),
            child: Form(
              key: _formEmail,
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(getWidthDevice(context) * 0.025),
                  ),
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(
                    color: const Color(0xFFFFFFFF),
                  ),
                  fillColor: const Color(0x33000000),
                  filled: true,
                ),
                onChanged: (value){
                  _email=value;
                  setState((){
                  });
                },
                keyboardType: TextInputType.emailAddress,
                validator: (value){
                  if(value!.isEmpty){
                    return '\u26A0 ${Languages.of(context).emailEmpty}';
                  }else if(!validateEmail(value)){
                    return '\u26A0 ${Languages.of(context).emailError}';
                  }
                },
              ),
            ),
          ),
        ),
        _buildText(
          text: 'Password',
          padding: EdgeInsets.only(
            top: isVisible?height*0.01:height * 0.02,
            bottom: height * 0.01,
          ),
          fontSize: width * 0.04,
        ),
        Container(
          width: getWidthDevice(context) * 0.85,
          alignment: Alignment.center,
          child: Theme(
            data: ThemeData(
              primaryColor: const Color(0x55000000),
            ),
            child: Form(
              key: _formPass1,
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(getWidthDevice(context) * 0.025),
                  ),
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(
                    color: const Color(0xFFFFFFFF),
                  ),
                  fillColor: const Color(0x33000000),
                  filled: true,
                ),
                onChanged: (value){
                  _pass1=value;
                  setState((){
                  });
                },
                keyboardType: TextInputType.text,
                obscureText: !_seePass1,
                validator: (value){
                  if(value!.isEmpty){
                    return '\u26A0 ${Languages.of(context).passError}';
                  }else if(value.length<6){
                    return '\u26A0 ${Languages.of(context).weakPass}';
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
  Future<void> register(String email, pass) async{
    DateTime _now = DateTime.now();
    bool? exist;
    try {
      await FirebaseFirestore.instance.doc("users/$_phone").get().then((doc) {
        exist = doc.exists;
      });
      // final user = FirebaseAuth.instance.currentUser;
      if(exist==false){
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: pass,
        ).whenComplete(() async{
          final _user = FirebaseAuth.instance.currentUser;
          await _user?.updateDisplayName(_phone);
        });
        // await user!.updateDisplayName(_phone);

        FirebaseFirestore.instance.collection('users').doc(_phone).set({
          "phone": _phone,
          "avatar": "",
          "fullname":_fullname,
          "role":"MEMBER",
          "email":_email,
          'exp': '',
          'specialize': '',
          'intro': '',
          'address':'',
          'dob':''
        }).then((value) {
          Navigator.pop(context);
        Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_)=>Login(_now.hour < 18&&_now.hour>5?Mode.day:Mode.night,0)));
        });
      }
      else{
        Navigator.pop(context);
        CustomDialog(context: context, iconData: Icons.warning_rounded, title: Languages.of(context).alert, content: 'Số điện thoại đã tồn tại');
        //Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (e.code == 'weak-password') {
        print('The password provided is too weak.');

      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        CustomDialog(context: context, iconData: Icons.warning_rounded, title: Languages.of(context).alert, content: Languages.of(context).existEmail);
      }else{

      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _doLogin(String email, String pass) async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "$email",
          password: "$pass"
      );
      final _user =await FirebaseAuth.instance.currentUser;
      if(_user!=null){
        FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get().then((value) {
          value.docs.forEach((element) async{
            Map<String, dynamic> data1 = element.data() as Map<String, dynamic>;
            String phone = data1['phone'];
            if(phone.isNotEmpty){
              await SharedPreferencesData.SaveData(CommonKey.USERNAME, phone);
              FirebaseFirestore.instance.collection('users').doc(phone).get().then((value) {
                if(value.exists){
                  Map<String, dynamic>? data = value.data() ;
                  SharedPreferencesData.SaveData(CommonKey.USER, jsonEncode(data));
                  print(data);
                }
              });
              Navigator.pop(context);
              RestartPage.restartApp(context);
            }else{
              _doLogin(email, pass);
            }
          });
        });
        String phone = _user.displayName!;

      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        CustomDialog(context: context, content: Languages.of(context).accountWrong);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        CustomDialog(context: context, content: Languages.of(context).passWrong);
      }

    }

  }
}
