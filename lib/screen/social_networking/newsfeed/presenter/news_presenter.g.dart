// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_presenter.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NewsPresenter on _NewsPresenter, Store {
  late final _$stateAtom = Atom(name: '_NewsPresenter.state', context: context);

  @override
  SingleState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(SingleState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$stateSentAtom =
      Atom(name: '_NewsPresenter.stateSent', context: context);

  @override
  SingleState get stateSent {
    _$stateSentAtom.reportRead();
    return super.stateSent;
  }

  @override
  set stateSent(SingleState value) {
    _$stateSentAtom.reportWrite(value, super.stateSent, () {
      super.stateSent = value;
    });
  }

  late final _$stateTopicAtom =
      Atom(name: '_NewsPresenter.stateTopic', context: context);

  @override
  SingleState get stateTopic {
    _$stateTopicAtom.reportRead();
    return super.stateTopic;
  }

  @override
  set stateTopic(SingleState value) {
    _$stateTopicAtom.reportWrite(value, super.stateTopic, () {
      super.stateTopic = value;
    });
  }

  late final _$stateUserAtom =
      Atom(name: '_NewsPresenter.stateUser', context: context);

  @override
  SingleState get stateUser {
    _$stateUserAtom.reportRead();
    return super.stateUser;
  }

  @override
  set stateUser(SingleState value) {
    _$stateUserAtom.reportWrite(value, super.stateUser, () {
      super.stateUser = value;
    });
  }

  late final _$getImageAsyncAction =
      AsyncAction('_NewsPresenter.getImage', context: context);

  @override
  Future<String> getImage(bool camera, BuildContext context) {
    return _$getImageAsyncAction.run(() => super.getImage(camera, context));
  }

  late final _$getImageFromGalleryAsyncAction =
      AsyncAction('_NewsPresenter.getImageFromGallery', context: context);

  @override
  Future<void> getImageFromGallery(BuildContext context) {
    return _$getImageFromGalleryAsyncAction
        .run(() => super.getImageFromGallery(context));
  }

  late final _$getTopicsAsyncAction =
      AsyncAction('_NewsPresenter.getTopics', context: context);

  @override
  Future<void> getTopics() {
    return _$getTopicsAsyncAction.run(() => super.getTopics());
  }

  @override
  String toString() {
    return '''
state: ${state},
stateSent: ${stateSent},
stateTopic: ${stateTopic},
stateUser: ${stateUser}
    ''';
  }
}