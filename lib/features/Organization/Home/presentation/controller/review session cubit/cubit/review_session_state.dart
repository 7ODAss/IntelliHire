import 'package:intelli_hire/core/models/applicant_model.dart';

abstract class ReviewSessionState {}

class ReviewSessionInitial extends ReviewSessionState {}

class ReviewSessionLoading extends ReviewSessionState {}

class ReviewSessionLoaded extends ReviewSessionState {
  final List<ApplicantModel> applicants;
  ReviewSessionLoaded(this.applicants);
}

class ReviewSessionError extends ReviewSessionState {
  final String message;
  ReviewSessionError(this.message);
}

class ReviewDecisionSubmitting extends ReviewSessionState {}

class ReviewDecisionSuccess extends ReviewSessionState {}

class ReviewDecisionError extends ReviewSessionState {
  final String message;
  ReviewDecisionError(this.message);
}