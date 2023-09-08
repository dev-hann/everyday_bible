part of 'bible_drawer_bloc.dart';

abstract class BibleDrawerEvent extends Equatable {
  const BibleDrawerEvent();

  @override
  List<Object> get props => [];
}

class BibleDrawerEventInited extends BibleDrawerEvent {
  final List<BibleData> dataList;
  final BibleData currentData;
  final BibleChapter currentChapter;

  const BibleDrawerEventInited({
    required this.dataList,
    required this.currentData,
    required this.currentChapter,
  });

  @override
  List<Object> get props => [
        dataList,
        currentData,
        currentChapter,
      ];
}
