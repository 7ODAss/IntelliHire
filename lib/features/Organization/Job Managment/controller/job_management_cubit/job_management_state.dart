part of 'job_management_cubit.dart';



sealed class JobManagementState extends Equatable {
  const JobManagementState();

  @override
  List<Object> get props => [];
}

final class JobManagementInitial extends JobManagementState {}

final class JobManagementLoaded extends JobManagementState {
  final List<JobModel> jobsList;

  const JobManagementLoaded({required this.jobsList});

  @override
  List<Object> get props => [jobsList]; 
}