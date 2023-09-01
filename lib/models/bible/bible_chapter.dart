import 'package:equatable/equatable.dart';

class BibleChapter extends Equatable {
  const BibleChapter({
    required this.usfm,
    required this.number,
  });
  final String usfm;
  final String number;

  @override
  List<Object?> get props => [
        usfm,
        number,
      ];

  factory BibleChapter.fromMap(Map<String, dynamic> map) {
    return BibleChapter(
      usfm: map['usfm'] as String,
      number: map['human'] as String,
    );
  }
}
