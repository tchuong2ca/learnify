
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:online_learning/common/functions.dart';
import 'package:online_learning/languages/languages.dart';
import 'package:online_learning/screen/authentication/authentication_presenter.dart';
import 'package:online_learning/screen/home/dashboard.dart';

import '../../../common/colors.dart';
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
import '../../animation_page.dart';
import '../../../external/switch_page_animation/enum.dart';
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
  AuthenticationPresenter? _presenter;
  Mode? _activeMode;


  final _formFullname = GlobalKey<FormState>();
  final _formPhone = GlobalKey<FormState>();
  final _formPass1 = GlobalKey<FormState>();
  final _formEmail = GlobalKey<FormState>();

  @override
  void initState() {
    _activeMode = _mode;
    _presenter = AuthenticationPresenter();
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
  @override
  dispose() {
    _animationController!.dispose(); // you need this
    super.dispose();
  }
  initializeTheme() {
    _day = LoginTheme(
      title: '',
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
      title: '',
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

                    child: Observer(builder: (_){
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ToggleButton(
                              startText: Languages.of(context).login,
                              endText: Languages.of(context).signUp,
                              tapCallback: (index) {
                                _presenter!.onChangeIndex(index);
                                _presenter!.forwardController(_animationController!, 0.0);
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
                            text: 'Vui lòng nhập đầy đủ các trường thông tin',
                          ),
                          _index==0?_loginForm(isKeyboardVisible, _presenter!):_signUpForm(isKeyboardVisible,_presenter!),
                          GestureDetector(
                            onTap: (){
                              if(_index==0){
                                if(validateEmail(_presenter!.loginEmail) && _presenter!.loginPass.isNotEmpty){
                                  showLoaderDialog(context);
                                  _doLogin(_presenter!.loginEmail, _presenter!.loginPass);
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

                                if(_presenter!.signUpPass.isNotEmpty && _presenter!.signUpFullName.isNotEmpty && _presenter!.signUpEmail.isNotEmpty && _presenter!.signUpPhone.isNotEmpty
                                ){
                                  showLoaderDialog(context);
                                  register(_presenter!.signUpEmail, _presenter!.signUpPass);
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
                      );
                    }),
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
  Widget _loginForm(bool isVisible, AuthenticationPresenter presenter){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildText(
          text: 'Email',
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
                  hintText: 'Email',

                  hintStyle: TextStyle(
                    color: const Color(0xFFFFFFFF),
                  ),
                  fillColor: const Color(0x33000000),
                  filled: true,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (content){
                  presenter.onChangeLoginEmail(content);
                },
              ),
            ),
          ),
        ),
        _buildText(
          text: 'Mật khẩu',
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
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      !presenter.seePass
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.white,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                     _presenter!.showPwd();
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(getWidthDevice(context) * 0.025),
                  ),
                  hintText: 'Mật khẩu',
                  hintStyle: TextStyle(
                    color: const Color(0xFFFFFFFF),
                  ),
                  fillColor: const Color(0x33000000),
                  filled: true,
                ),
                keyboardType: TextInputType.text,
                obscureText: !presenter.seePass,
                onChanged: (value){
                 _presenter!.onChangeLoginPass(value);

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
  Widget _signUpForm(bool isVisible, AuthenticationPresenter presenter){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildText(
          text: 'Họ và tên',
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
                  hintText: 'Họ và tên',

                  hintStyle: TextStyle(
                    color: const Color(0xFFFFFFFF),
                  ),
                  fillColor: const Color(0x33000000),
                  filled: true,
                ),
                onChanged: (fullname){
                  presenter.onChangeSignUpFullName(fullname);

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
          text: 'Số điện thoại',
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

                  hintText: 'Số điện thoại',
                  hintStyle: TextStyle(
                    color: const Color(0xFFFFFFFF),
                  ),
                  fillColor: const Color(0x33000000),
                  filled: true,
                ),
                onChanged: (value){
                  _presenter!.onChangeSignUpPhone(value);
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
          text: 'Email',
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
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    color: const Color(0xFFFFFFFF),
                  ),
                  fillColor: const Color(0x33000000),
                  filled: true,
                ),
                onChanged: (value){
                  _presenter!.onChangeSignUpEmail(value);
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
          text: 'Mật khẩu',
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
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      !presenter.seePass
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.white,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      _presenter!.showPwd();
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(getWidthDevice(context) * 0.025),
                  ),
                  hintText: 'Mật khẩu',
                  hintStyle: TextStyle(
                    color: const Color(0xFFFFFFFF),
                  ),
                  fillColor: const Color(0x33000000),
                  filled: true,
                ),
                onChanged: (value){
                  _presenter!.onChangeSignUpPass(value);
                },
                keyboardType: TextInputType.text,
                obscureText: !presenter.seePass,
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
      await FirebaseFirestore.instance.doc("users/${_presenter!.signUpPhone}").get().then((doc) {
        exist = doc.exists;
      });
      // final user = FirebaseAuth.instance.currentUser;
      if(exist==false){
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: pass,
        ).whenComplete(() async{
          final _user = FirebaseAuth.instance.currentUser;
          await _user?.updateDisplayName(_presenter!.signUpPhone);
        });
        // await user!.updateDisplayName(_phone);

        FirebaseFirestore.instance.collection('users').doc(_presenter!.signUpPhone).set({
          "phone": _presenter!.signUpPhone,
          "avatar": "",
          "fullname":_presenter!.signUpFullName,
          "role":"MEMBER",
          "email":_presenter!.signUpEmail,
          'exp': '',
          'specialize': '',
          'intro': '',
          'address':'',
          'dob':''
        }).then((value) {
          Navigator.pop(context);
        Navigator.pop(context);
           Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade, widget: Login(_now.hour < 18&&_now.hour>5?Mode.day:Mode.night,0)));
        });
      }
      else{
        //Navigator.pop(context);

        customDialog(context: context, iconData: Icons.warning_rounded, title: Languages.of(context).alert, content: 'Số điện thoại đã tồn tại');
        //Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {

      if (e.code == 'weak-password') {
        print('The password provided is too weak.');

      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        customDialog(context: context, iconData: Icons.warning_rounded, title: Languages.of(context).alert, content: Languages.of(context).existEmail);
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
              await SharedPreferencesData.saveData(CommonKey.USERNAME, phone);
              FirebaseFirestore.instance.collection('users').doc(phone).get().then((value) {
                if(value.exists){
                  Map<String, dynamic>? data = value.data() ;
                  SharedPreferencesData.saveData(CommonKey.USER, jsonEncode(data));
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
      //Navigator.pop(context);
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        customDialog(context: context, content: Languages.of(context).wrongEmail);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        customDialog(context: context, content: Languages.of(context).wrongPass);
      }

    }

  }
}
