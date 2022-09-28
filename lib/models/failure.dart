import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  const Failure({this.message});
  final String? message;

  @override
  List<Object?> get props => [message];

  factory Failure.fromException(Object e) {
    return Failure(message: e.toString());
  }

  factory Failure.emptyData() {
    return const Failure(message: "EmptyData");
  }
}
