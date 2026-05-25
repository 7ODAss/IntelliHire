import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/job_entity.dart';

abstract class JobManagementState {}

class JobManagementInitial extends JobManagementState {}
class JobManagementLoading extends JobManagementState {}
class JobManagementLoaded extends JobManagementState {
  final JobManagementEntity data;
  JobManagementLoaded(this.data);
}
class JobManagementError extends JobManagementState {
  final String message;
  JobManagementError(this.message);
}
class JobDeletedSuccess extends JobManagementState {} 