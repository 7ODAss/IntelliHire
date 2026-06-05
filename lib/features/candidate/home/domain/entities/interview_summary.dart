import 'package:equatable/equatable.dart';

class InterviewSummary extends Equatable{
  final int acceptedInterviews;
  final int pendingInterviews;
  final int rejectedInterviews;
  const InterviewSummary({
    required this.acceptedInterviews,
    required this.pendingInterviews,
    required this.rejectedInterviews,});

  @override
  List<Object?> get props => [acceptedInterviews, pendingInterviews, rejectedInterviews];

}