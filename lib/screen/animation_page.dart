import 'package:flutter/material.dart';

import '../external/switch_page_animation/enum.dart';
import '../external/switch_page_animation/page_transition.dart';

class AnimationPage{
  AnimationPage._privateConstructor();
  static final AnimationPage _animationPage = AnimationPage._privateConstructor();
  factory AnimationPage(){
    return _animationPage;
  }

  PageTransition pageTransition({required PageTransitionType type, required Widget widget}){
    return PageTransition(
      duration : const Duration(milliseconds: 350),
      reverseDuration : const Duration(milliseconds: 300),
      type: type,
      child: widget,
    );
  }
}