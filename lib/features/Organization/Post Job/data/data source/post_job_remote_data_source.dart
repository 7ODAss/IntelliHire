import 'package:intelli_hire/core/service/api_service.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/data/models/location_model.dart';

abstract class PostJobRemoteDataSource {
  Future<void> postJob(Map<String, dynamic> jobData);
  Future<List<LocationModel>> getCompanyLocations();
}

class PostJobRemoteDataSourceImpl implements PostJobRemoteDataSource {
  final ApiService apiService;

  PostJobRemoteDataSourceImpl(this.apiService);

  @override
  Future<void> postJob(Map<String, dynamic> jobData) async {
    await apiService.post(endPoint: 'api/Employer/post-job', data: jobData);
  }

  Future<List<LocationModel>> getCompanyLocations() async {
    final response = await apiService.get(
      endPoint: 'api/Employer/settings/locations',
    );
    List<LocationModel> locations = [];
    for (var item in response.data) {
      locations.add(LocationModel.fromJson(item));
    }
    return locations;
  }
}
