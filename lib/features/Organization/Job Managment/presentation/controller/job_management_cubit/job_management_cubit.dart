import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/job_entity.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/usecases/get_jobs_usecase.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/usecases/delete_job_usecase.dart';
import 'job_management_state.dart';

class JobManagementCubit extends Cubit<JobManagementState> {
  final GetJobsUseCase getJobsUseCase; 
  final DeleteJobUseCase deleteJobUseCase;

  JobManagementEntity? originalData;

  JobManagementCubit(
    this.getJobsUseCase,
    this.deleteJobUseCase,
  ) : super(JobManagementInitial());

  Future<void> fetchJobs() async {
    if (isClosed) return;
    emit(JobManagementLoading());
    final result = await getJobsUseCase.execute();
    
    if (isClosed) return;
    result.fold(
      (error) {
        if (!isClosed) emit(JobManagementError(error));
      },
      (data) {
        originalData = data;
        if (!isClosed) emit(JobManagementLoaded(data));
      }
    );
  }

  void searchJobs(String query) {
    if (originalData == null) return;

    if (query.isEmpty) {
      if (!isClosed) emit(JobManagementLoaded(originalData!));
      return;
    }
    
    final filteredJobs = originalData!.jobs.where((job) {
      return job.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (!isClosed) {
      emit(JobManagementLoaded(
        JobManagementEntity(
          activeJobs: filteredJobs.length,
          totalApplicants: originalData!.totalApplicants,
          jobs: filteredJobs,
        ),
      ));
    }
  }

  Future<void> deleteJob(String jobId) async {
    final result = await deleteJobUseCase.execute(jobId);
    
    if (isClosed) return;
    result.fold(
      (error) {
        if (!isClosed) emit(JobManagementError(error));
      }, 
      (_) {
        if (!isClosed) {
          emit(JobDeletedSuccess()); 
          fetchJobs(); 
        }
      }
    );
  }
}