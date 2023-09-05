part of 'quite_time_content_bloc.dart';

abstract class QuiteTimeContentEvent extends Equatable {
  const QuiteTimeContentEvent();

  @override
  List<Object?> get props => [];
}

class QuiteTimeContentEventInited extends QuiteTimeContentEvent {
  const QuiteTimeContentEventInited(
    this.dateTime,
  );
  final DateTime dateTime;
  @override
  List<Object?> get props => [dateTime];
}

class QuiteTimeContentEventUpdatedDateTime extends QuiteTimeContentEvent {
  const QuiteTimeContentEventUpdatedDateTime(this.dateTime);
  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}
