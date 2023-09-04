// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Memo extends Equatable {
  Memo({
    this.rawText = "",
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();
  final String rawText;
  final DateTime dateTime;

  String get title {
    return rawText.split("\n").first;
  }

  String get content {
    return rawText.split("\n").sublist(1).join("\n");
  }

  String get index {
    return dateTime.millisecondsSinceEpoch.toString();
  }

  @override
  List<Object?> get props => [
        rawText,
        dateTime,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'index': index,
      'text': rawText,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  factory Memo.fromMap(Map<String, dynamic> map) {
    return Memo(
      rawText: map['text'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
    );
  }

  Memo copyWith({
    String? rawText,
    DateTime? dateTime,
  }) {
    return Memo(
      rawText: rawText ?? this.rawText,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
