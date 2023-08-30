import 'package:equatable/equatable.dart';

class QuiteTimeData extends Equatable {
  const QuiteTimeData({
    required this.type,
    required this.dateTime,
    required this.bibleName,
    required this.chapter,
    required this.title,
    required this.summary,
  });
  final String type;
  final DateTime dateTime;
  final String bibleName;
  final String chapter;
  final String title;
  final String summary;

  @override
  List<Object?> get props => [
        type,
        dateTime,
        bibleName,
        chapter,
        title,
      ];

  factory QuiteTimeData.fromMap(Map<String, dynamic> map) {
    return QuiteTimeData(
      type: map['Qt_ty'] as String,
      dateTime: DateTime.parse(map['Base_de']),
      bibleName: map['Bible_name'] as String,
      chapter: map['Bible_chapter'] as String,
      title: map['Qt_sj'] as String,
      summary: map['Qt_Brf'] as String,
    );
  }
}
