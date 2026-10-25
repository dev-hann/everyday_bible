import 'package:equatable/equatable.dart';

/// Application-level error carrying a human-readable message.
class Failure extends Equatable {
  /// Creates a failure with a [message] and optional context [data].
  const Failure(
    this.message, {
    this.data,
  });

  /// Wraps the thrown [e] into a [Failure] using its string form.
  factory Failure.fromException(dynamic e) {
    return Failure(e.toString());
  }

  /// Human-readable description of the failure.
  final String message;

  /// Optional payload giving context about the failure.
  final dynamic data;

  @override
  List<Object?> get props => [
        message,
        data,
      ];
}
