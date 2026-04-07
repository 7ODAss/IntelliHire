import 'package:equatable/equatable.dart';

class InterviewSummary extends Equatable{
  final int accepted;
  final int inProgress;
  final int pending;
  final int rejected;
  const InterviewSummary({
    required this.accepted,
    required this.inProgress,
    required this.pending,
    required this.rejected,});

  @override
  List<Object?> get props => [accepted, inProgress, pending, rejected];

}