import 'package:intelli_hire/core/service/api_service.dart';

abstract class HomeRemoteDataSourceOrganization {
  Future<Map<String, dynamic>> getDashboardStats();
  Future<Map<String, dynamic>> getWebDashboardStats(); // 🔴
  Future<void> submitDecision(String sessionId, int status);  
  Future<List<dynamic>> getTopTalent(); 
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSourceOrganization {
  final ApiService apiService;

  HomeRemoteDataSourceImpl(this.apiService);

  @override
  Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await apiService.get(endPoint: 'api/Employer/mobile-dashboard');
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getWebDashboardStats() async {
    final response = await apiService.get(endPoint: 'api/Employer/dashboard');
    return response.data;
  }

  @override
  Future<void> submitDecision(String sessionId, int status) async {
    Map<String, dynamic> requestBody = { "status": status };
    
    await apiService.patch(
      endPoint: 'api/Employer/sessions/$sessionId/status',
      data: requestBody,
    );
  }

  @override
  Future<List<dynamic>> getTopTalent() async {
    final response = await apiService.get(endPoint: 'api/employer/mobile-top-talent');
    return response.data;
  }
}