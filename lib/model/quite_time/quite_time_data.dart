import 'package:equatable/equatable.dart';

/// Metadata of a day's Quiet Time (QT), fetched from the QT API.
class QuiteTimeData extends Equatable {
  /// Creates QT metadata.
  const QuiteTimeData({
    required this.type,
    required this.dateTime,
    required this.bibleName,
    required this.chapter,
    required this.title,
    required this.summary,
  });

  /// Builds [QuiteTimeData] from a QT API JSON payload.
  factory QuiteTimeData.fromMap(Map<String, dynamic> map) {
    return QuiteTimeData(
      type: map['Qt_ty'] as String,
      dateTime: DateTime.parse(map['Base_de'] as String),
      bibleName: map['Bible_name'] as String,
      chapter: map['Bible_chapter'] as String,
      title: map['Qt_sj'] as String,
      summary: map['Qt_Brf'] as String,
    );
  }

  /// Type code of the QT content (e.g. `QT1`).
  final String type;

  /// Date the QT content belongs to.
  final DateTime dateTime;

  /// Bible book name of the day's passage.
  final String bibleName;

  /// Chapter reference of the day's passage.
  final String chapter;

  /// Title of the day's QT.
  final String title;

  /// Short summary of the day's QT.
  final String summary;

  @override
  List<Object?> get props => [
        type,
        dateTime,
        bibleName,
        chapter,
        title,
      ];

  /// Whether [other] falls on the same calendar day as this data.
  bool isSameDateTime(DateTime other) {
    return dateTime.year == other.year &&
        dateTime.month == other.month &&
        dateTime.day == other.day;
  }
}
