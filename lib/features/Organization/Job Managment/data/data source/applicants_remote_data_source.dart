import 'package:intelli_hire/core/service/api_service.dart';

abstract class ApplicantsRemoteDataSource {
  Future<Map<String, dynamic>> getJobApplicants(String jobId);
  Future<Map<String, dynamic>> getApplicantPreview(String sessionId);
}

class ApplicantsRemoteDataSourceImpl implements ApplicantsRemoteDataSource {
  final ApiService apiService;

  ApplicantsRemoteDataSourceImpl(this.apiService);

  @override
  Future<Map<String, dynamic>> getJobApplicants(String jobId) async {
    final response = await apiService.get(endPoint: 'api/Employer/jobs/$jobId/applicants');
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getApplicantPreview(String sessionId) async {
    final response = await apiService.get(endPoint: 'api/Employer/sessions/$sessionId/preview');
    return response.data;
  }
}