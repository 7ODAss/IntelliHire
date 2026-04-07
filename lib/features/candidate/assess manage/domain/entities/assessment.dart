import 'package:equatable/equatable.dart';

class Assessment extends Equatable {
  final String id;
  final String title;
  final String track;
  final double aiScore;
  final String performanceBadge;
  final String date;

  const Assessment({
    required this.id,
    required this.title,
    required this.track,
    required this.aiScore,
    required this.performanceBadge,
    required this.date,
  });

  factory Assessment.empty() => const Assessment(
        id: '',
        title: '',
        track: '',
        aiScore: 0,
        performanceBadge: '',
        date: '',
      );

  @override
  List<Object?> get props => [id, title, track, aiScore, performanceBadge, date];
}
