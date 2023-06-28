// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_presenter.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthenticationPresenter on _AuthenticationPresenter, Store {
  late final _$seePassAtom =
      Atom(name: '_AuthenticationPresenter.seePass', context: context);

  @override
  bool get seePass {
    _$seePassAtom.reportRead();
    return super.seePass;
  }

  @override
  set seePass(bool value) {
    _$seePassAtom.reportWrite(value, super.seePass, () {
      super.seePass = value;
    });
  }

  late final _$loginPassAtom =
      Atom(name: '_AuthenticationPresenter.loginPass', context: context);

  @override
  String get loginPass {
    _$loginPassAtom.reportRead();
    return super.loginPass;
  }

  @override
  set loginPass(String value) {
    _$loginPassAtom.reportWrite(value, super.loginPass, () {
      super.loginPass = value;
    });
  }

  late final _$indexAtom =
      Atom(name: '_AuthenticationPresenter.index', context: context);

  @override
  int get index {
    _$indexAtom.reportRead();
    return super.index;
  }

  @override
  set index(int value) {
    _$indexAtom.reportWrite(value, super.index, () {
      super.index = value;
    });
  }

  late final _$signUpFullNameAtom =
      Atom(name: '_AuthenticationPresenter.signUpFullName', context: context);

  @override
  String get signUpFullName {
    _$signUpFullNameAtom.reportRead();
    return super.signUpFullName;
  }

  @override
  set signUpFullName(String value) {
    _$signUpFullNameAtom.reportWrite(value, super.signUpFullName, () {
      super.signUpFullName = value;
    });
  }

  late final _$signUpPhoneAtom =
      Atom(name: '_AuthenticationPresenter.signUpPhone', context: context);

  @override
  String get signUpPhone {
    _$signUpPhoneAtom.reportRead();
    return super.signUpPhone;
  }

  @override
  set signUpPhone(String value) {
    _$signUpPhoneAtom.reportWrite(value, super.signUpPhone, () {
      super.signUpPhone = value;
    });
  }

  late final _$signUpEmailAtom =
      Atom(name: '_AuthenticationPresenter.signUpEmail', context: context);

  @override
  String get signUpEmail {
    _$signUpEmailAtom.reportRead();
    return super.signUpEmail;
  }

  @override
  set signUpEmail(String value) {
    _$signUpEmailAtom.reportWrite(value, super.signUpEmail, () {
      super.signUpEmail = value;
    });
  }

  late final _$signUpPassAtom =
      Atom(name: '_AuthenticationPresenter.signUpPass', context: context);

  @override
  String get signUpPass {
    _$signUpPassAtom.reportRead();
    return super.signUpPass;
  }

  @override
  set signUpPass(String value) {
    _$signUpPassAtom.reportWrite(value, super.signUpPass, () {
      super.signUpPass = value;
    });
  }

  late final _$loginEmailAtom =
      Atom(name: '_AuthenticationPresenter.loginEmail', context: context);

  @override
  String get loginEmail {
    _$loginEmailAtom.reportRead();
    return super.loginEmail;
  }

  @override
  set loginEmail(String value) {
    _$loginEmailAtom.reportWrite(value, super.loginEmail, () {
      super.loginEmail = value;
    });
  }

  late final _$_AuthenticationPresenterActionController =
      ActionController(name: '_AuthenticationPresenter', context: context);

  @override
  void showPwd() {
    final _$actionInfo = _$_AuthenticationPresenterActionController.startAction(
        name: '_AuthenticationPresenter.showPwd');
    try {
      return super.showPwd();
    } finally {
      _$_AuthenticationPresenterActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onChangeLoginPass(dynamic value) {
    final _$actionInfo = _$_AuthenticationPresenterActionController.startAction(
        name: '_AuthenticationPresenter.onChangeLoginPass');
    try {
      return super.onChangeLoginPass(value);
    } finally {
      _$_AuthenticationPresenterActionController.endAction(_$actionInfo);
    }
  }

  @override
  void forwardController(
      AnimationController animationController, double value) {
    final _$actionInfo = _$_AuthenticationPresenterActionController.startAction(
        name: '_AuthenticationPresenter.forwardController');
    try {
      return super.forwardController(animationController, value);
    } finally {
      _$_AuthenticationPresenterActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onChangeLoginEmail(dynamic value) {
    final _$actionInfo = _$_AuthenticationPresenterActionController.startAction(
        name: '_AuthenticationPresenter.onChangeLoginEmail');
    try {
      return super.onChangeLoginEmail(value);
    } finally {
      _$_AuthenticationPresenterActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onChangeIndex(dynamic value) {
    final _$actionInfo = _$_AuthenticationPresenterActionController.startAction(
        name: '_AuthenticationPresenter.onChangeIndex');
    try {
      return super.onChangeIndex(value);
    } finally {
      _$_AuthenticationPresenterActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onChangeSignUpEmail(dynamic value) {
    final _$actionInfo = _$_AuthenticationPresenterActionController.startAction(
        name: '_AuthenticationPresenter.onChangeSignUpEmail');
    try {
      return super.onChangeSignUpEmail(value);
    } finally {
      _$_AuthenticationPresenterActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onChangeSignUpPhone(dynamic value) {
    final _$actionInfo = _$_AuthenticationPresenterActionController.startAction(
        name: '_AuthenticationPresenter.onChangeSignUpPhone');
    try {
      return super.onChangeSignUpPhone(value);
    } finally {
      _$_AuthenticationPresenterActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onChangeSignUpFullName(dynamic value) {
    final _$actionInfo = _$_AuthenticationPresenterActionController.startAction(
        name: '_AuthenticationPresenter.onChangeSignUpFullName');
    try {
      return super.onChangeSignUpFullName(value);
    } finally {
      _$_AuthenticationPresenterActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onChangeSignUpPass(dynamic value) {
    final _$actionInfo = _$_AuthenticationPresenterActionController.startAction(
        name: '_AuthenticationPresenter.onChangeSignUpPass');
    try {
      return super.onChangeSignUpPass(value);
    } finally {
      _$_AuthenticationPresenterActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
seePass: ${seePass},
loginPass: ${loginPass},
index: ${index},
signUpFullName: ${signUpFullName},
signUpPhone: ${signUpPhone},
signUpEmail: ${signUpEmail},
signUpPass: ${signUpPass},
loginEmail: ${loginEmail}
    ''';
  }
}
