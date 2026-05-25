import 'package:intelli_hire/core/service/api_service.dart';
import '../Models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String notificationId); 
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiService apiService; 

  NotificationRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<NotificationModel>> getNotifications() async {
    // 🔴 التعديل هنا: بنكلم الـ API الحقيقي بدل الداتا الوهمية
    final response = await apiService.get(endPoint: 'api/notifications');
    
    // بنحول الداتا اللي راجعة للـ Models
    List<dynamic> data = response.data;
    return data.map((json) => NotificationModel.fromJson(json)).toList();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await apiService.patch(endPoint: 'api/notifications/$notificationId/read');
  }
}