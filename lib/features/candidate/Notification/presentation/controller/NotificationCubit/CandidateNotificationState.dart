import 'package:equatable/equatable.dart';
import 'package:intelli_hire/features/candidate/Notification/domain/Entities/candidate_notification_entity.dart';

abstract class Candidatenotificationstate extends Equatable {
  const Candidatenotificationstate();

  @override
  List<Object> get props => [];
}

class CandidateNotificationInitial extends Candidatenotificationstate {}

class CandidateNotificationLoading extends Candidatenotificationstate {}

class CandidateNotificationLoaded extends Candidatenotificationstate {
  final List<CandidateNotificationEntity> notifications;

  const CandidateNotificationLoaded(this.notifications);

  @override
  List<Object> get props => [notifications];
}

class CandidateNotificationError extends Candidatenotificationstate {
  final String message;

  const CandidateNotificationError(this.message);

  @override
  List<Object> get props => [message];
}