import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:everydaybible/model/bible/bible_chapter.dart';
import 'package:everydaybible/model/bible/bible_data.dart';
import 'package:flutter/material.dart';

part 'bible_drawer_event.dart';
part 'bible_drawer_state.dart';

class BibleDrawerBloc extends Bloc<BibleDrawerEvent, BibleDrawerState> {
  BibleDrawerBloc() : super(BibleDrawerState()) {
    on<BibleDrawerEventInited>(_onInited);
  }

  FutureOr<void> _onInited(
      BibleDrawerEventInited event, Emitter<BibleDrawerState> emit) {
    final dataList = event.dataList;
    final keyMap = <BibleData, GlobalKey>{};
    for (final data in dataList) {
      keyMap[data] = GlobalKey();
    }
    emit(
      state.copyWith(
        status: BibleDrawerViewStatus.success,
        dataList: event.dataList,
        currentData: event.currentData,
        currentChapter: event.currentChapter,
        scrollKeyMap: keyMap,
      ),
    );
    final context = keyMap[event.currentData]?.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context);
    }
  }
}
