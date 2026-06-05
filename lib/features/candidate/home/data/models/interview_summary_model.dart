import 'package:intelli_hire/features/candidate/home/domain/entities/interview_summary.dart';

class InterviewSummaryModel extends InterviewSummary {
  const InterviewSummaryModel({
    required super.acceptedInterviews,
    required super.pendingInterviews,
    required super.rejectedInterviews,
  });

  factory InterviewSummaryModel.fromJson(Map<String, dynamic> json) {
    return InterviewSummaryModel(
      acceptedInterviews: json['acceptedInterviews'],
      pendingInterviews: json['pendingInterviews'],
      rejectedInterviews: json['rejectedInterviews'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'acceptedInterviews': acceptedInterviews,
      'pendingInterviews': pendingInterviews,
      'rejectedInterviews': rejectedInterviews,
    };
  }
}
