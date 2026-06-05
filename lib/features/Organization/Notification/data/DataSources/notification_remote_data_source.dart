import 'package:intelli_hire/core/service/api_service.dart';
import '../Models/notification_model.dart';

abstract class NotificationRemoteDataSourceOrganization {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAllAsRead(); 
  Future<void> deleteNotification(String notificationId); 
}

class NotificationRemoteDataSourceImplOrganization implements NotificationRemoteDataSourceOrganization {
  final ApiService apiService; 

  NotificationRemoteDataSourceImplOrganization(this.apiService);

  @override
  Future<List<NotificationModel>> getNotifications() async {
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
    
    return data.map((json) => NotificationModel.fromJson(json)).toList();
  }

  @override
  Future<void> markAllAsRead() async {
    print("📡 [API] Sending PUT request to: MarkAllAsRead");
    
    await apiService.put(endPoint: 'MarkAllAsRead');
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    print("📡 [API] Sending PUT request to: MarkAsDeleted/$notificationId");
    
    // 🌟 التعديل الأهم: غيرنا apiService.delete إلى apiService.put
    // 🌟 وغيرنا اسم المسار لـ MarkAsDeleted
    await apiService.put(endPoint: 'MarkAsDeleted/$notificationId');
  }
}