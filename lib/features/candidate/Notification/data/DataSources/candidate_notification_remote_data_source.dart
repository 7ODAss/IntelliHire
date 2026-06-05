import 'package:intelli_hire/core/service/api_service.dart';
import '../Models/candidate_notification_model.dart';

abstract class BaseCandidateNotificationRemoteDataSource {
  Future<List<CandidateNotificationModel>> getNotifications();
  Future<void> markAllAsRead(); 
  Future<void> deleteNotification(String notificationId); 
}

class CandidateNotificationRemoteDataSource implements BaseCandidateNotificationRemoteDataSource {
  final ApiService apiService; 

  CandidateNotificationRemoteDataSource(this.apiService);

  @override
  Future<List<CandidateNotificationModel>> getNotifications() async {
    print("📡 [API] Sending GET request to: GetNotifications");
    
    final response = await apiService.get(endPoint: 'GetNotifications');
    print("📥 [API] Response received successfully!");
    
    List<dynamic> data = [];
    if (response.data is List) {
      data = response.data;
    } else if (response.data is Map && response.data.containsKey('data')) {
      data = response.data['data'];
    } else {
      data = response.data ?? response;
    }
    
    return data.map((json) => CandidateNotificationModel.fromJson(json)).toList();
  }

  @override
  Future<void> markAllAsRead() async {
    print("📡 [API] Sending PUT request to: MarkAllAsRead");
    
    await apiService.put(endPoint: 'MarkAllAsRead');
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    print("📡 [API] Sending PUT request to: MarkAsDeleted/$notificationId");
    await apiService.put(endPoint: 'MarkAsDeleted/$notificationId');
  }
}