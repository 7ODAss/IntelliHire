import 'package:intelli_hire/features/candidate/home/domain/entities/interview_summary.dart';

class InterviewSummaryModel extends InterviewSummary {
  const InterviewSummaryModel({
    required super.accepted,
    required super.inProgress,
    required super.pending,
    required super.rejected,
  });

  factory InterviewSummaryModel.fromJson(Map<String, dynamic> json) {
    return InterviewSummaryModel(
      accepted: json['accepted'],
      inProgress: json['in_progress'],
      pending: json['pending'],
      rejected: json['rejected'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accepted': accepted,
      'in_progress': inProgress,
      'pending': pending,
      'rejected': rejected,
    };
  }
}
