import 'package:equatable/equatable.dart';

class QTDuration extends Equatable {
  const QTDuration({
    required this.position,
    required this.duration,
  });
  final Duration position;
  final Duration duration;

  @override
  List<Object?> get props => [
        position,
        duration,
      ];
}
