import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  const Failure(
    this.message, {
    this.data,
  });
  final String message;
  final dynamic data;

  @override
  List<Object?> get props => [
        message,
        data,
      ];

  factory Failure.fromException(dynamic e) {
    return Failure(e.toString());
  }
}
