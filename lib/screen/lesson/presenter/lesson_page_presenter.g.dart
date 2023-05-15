// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_page_presenter.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expresson_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LessonPagePresenter on _LessonPagePresenter, Store {
  late final _$stateAtom =
      Atom(name: '_LessonPagePresenter.state', context: context);

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

  late final _$getLessonDetailAsyncAction =
      AsyncAction('_LessonPagePresenter.getLessonDetail', context: context);

  @override
  Future<dynamic> getLessonDetail(Lesson lesson) {
    return _$getLessonDetailAsyncAction
        .run(() => super.getLessonDetail(lesson));
  }

  @override
  String toString() {
    return '''
state: ${state}
    ''';
  }
}
