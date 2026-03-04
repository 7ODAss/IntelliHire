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
  if (state is JobManagementLoaded) {
    final currentState = state as JobManagementLoaded;
    
    final updatedList = currentState.jobsList.where((job) => job.id != jobId).toList();
    
    emit(JobManagementLoaded(jobsList: updatedList));
  }
}

void editJob(JobModel updatedJob) {
  if (state is JobManagementLoaded) {
    final currentState = state as JobManagementLoaded;
    
    // بندور على الوظيفة القديمة بالـ ID ونبدلها بالجديدة
    final updatedList = currentState.jobsList.map((job) {
      return job.id == updatedJob.id ? updatedJob : job;
    }).toList();
    
    emit(JobManagementLoaded(jobsList: updatedList));
  }
}
}
