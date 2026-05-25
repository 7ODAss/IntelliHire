import 'package:equatable/equatable.dart';

class Assessment extends Equatable {
  final String sessionId;
  final String title;
  final String track;
  final double aiScore;
  final String label;
  final String date;

  const Assessment({
    required this.sessionId,
    required this.title,
    required this.track,
    required this.aiScore,
    required this.label,
    required this.date,
  });

  factory Assessment.empty() => const Assessment(
        sessionId: '',
        title: '',
        track: '',
        aiScore: 0,
        label: '',
        date: '',
      );

  @override
  List<Object?> get props => [sessionId, title, track, aiScore, label, date];
}
