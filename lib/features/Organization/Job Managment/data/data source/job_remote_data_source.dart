import 'package:dio/dio.dart';
import 'package:intelli_hire/core/service/api_service.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/data/models/job_model.dart';

abstract class JobRemoteDataSource {
  Future<Map<String, dynamic>> getJobsDashboard();
  Future<void> deleteJob(String jobId);
  Future<void> updateJob(String jobId, Map<String, dynamic> jobData);
  Future<JobItemModel> getJobDetails(String jobId);
}

class JobRemoteDataSourceImpl implements JobRemoteDataSource {
  final ApiService apiService;

  JobRemoteDataSourceImpl(this.apiService);

  @override
  Future<Map<String, dynamic>> getJobsDashboard() async {
    final response = await apiService.get(endPoint: 'api/Employer/dashboard');
    return response.data;
  }

  @override
  Future<void> deleteJob(String jobId) async {
    try {
      await apiService.delete(endPoint: 'api/Jobs/$jobId');
    } on DioException catch (e) {
      print("Backend Error Data: ${e.response?.data}");
    }
  }
@override
Future<JobItemModel> getJobDetails(String jobId) async {
  final response = await apiService.get(endPoint: 'api/Jobs/Details/$jobId');
  return JobItemModel.fromJson(response.data);
}

@override
Future<void> updateJob(String jobId, Map<String, dynamic> jobData) async {
  await apiService.put(endPoint: 'api/Jobs/$jobId', data: jobData);
}
}
