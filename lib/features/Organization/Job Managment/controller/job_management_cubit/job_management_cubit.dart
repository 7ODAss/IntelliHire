import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/models/job_model.dart';

part 'job_management_state.dart';

class JobManagementCubit extends Cubit<JobManagementState> {
  JobManagementCubit() : super(JobManagementInitial()) {
    _loadInitialJobs();
  }

  final List<JobModel> _jobs = [];

  void _loadInitialJobs() {
    emit(JobManagementLoaded(jobsList: List.from(_jobs)));
  }

  void addJob(JobModel newJob) {
    _jobs.insert(0, newJob);
    emit(JobManagementLoaded(jobsList: List.from(_jobs)));
  }

  void deleteJob(String jobId) {
    _jobs.removeWhere((job) => job.id == jobId);
    emit(JobManagementLoaded(jobsList: List.from(_jobs)));
  }

  void editJob(JobModel updatedJob) {
    final index = _jobs.indexWhere((job) => job.id == updatedJob.id);
    if (index != -1) {
      _jobs[index] = updatedJob;
    }
    emit(JobManagementLoaded(jobsList: List.from(_jobs)));
  }
}
