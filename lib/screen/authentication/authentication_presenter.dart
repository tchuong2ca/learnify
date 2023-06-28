import 'package:flutter/animation.dart';
import 'package:mobx/mobx.dart';
part 'authentication_presenter.g.dart';

class AuthenticationPresenter = _AuthenticationPresenter with _$AuthenticationPresenter;

abstract class _AuthenticationPresenter with Store {
  @observable
  bool seePass = false;
  @observable
  String loginPass = '';
  @observable
  int index=0;
  @observable
  String signUpFullName='';
  @observable
  String signUpPhone='';
  @observable
  String signUpEmail='';
  @observable
  String signUpPass='';
  @observable
  String loginEmail='';
  @action
  void showPwd(){
    seePass = !seePass;
  }
  @action
  void onChangeLoginPass(value){
    loginPass = value;
  }
  @action
  void forwardController(AnimationController animationController, double value){
    animationController.forward(from: value);
  }
  @action
  void onChangeLoginEmail(value){
    loginEmail = value;
  }  @action
  void onChangeIndex(value){
    index = value;
  }  @action
  void onChangeSignUpEmail(value){
    signUpEmail = value;
  }  @action
  void onChangeSignUpPhone(value){
    signUpPhone = value;
  }  @action
  void onChangeSignUpFullName(value){
    signUpFullName = value;
  }  @action
  void onChangeSignUpPass(value){
    signUpPass = value;
  }
}