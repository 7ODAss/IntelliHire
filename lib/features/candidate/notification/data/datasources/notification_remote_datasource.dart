import '../models/notification_item_model.dart';

abstract class BaseNotificationDataSource {
  Future<List<NotificationItemModel>> fetchNotifications();
}

/// Stub with dummy notifications — swap for real API when backend is ready.
class NotificationRemoteDataSourceCandidate implements BaseNotificationDataSource {
  @override
  Future<List<NotificationItemModel>> fetchNotifications() async {
    await Future.delayed(const Duration(seconds: 1));
    return const [
      NotificationItemModel(
        id: 'n1',
        title: 'New Applicant',
        body: 'Omar Osama applied for Backend Engineer',
        timeAgo: '10m ago',
        isRead: false,
      ),
      NotificationItemModel(
        id: 'n2',
        title: 'New Applicant',
        body: 'Mahmoud Magdy applied for Backend Engineer',
        timeAgo: '10m ago',
        isRead: false,
      ),
      NotificationItemModel(
        id: 'n3',
        title: 'Assessment Complete',
        body: 'Your Frontend assessment results are ready',
        timeAgo: '1h ago',
        isRead: true,
      ),
    ];
  }
}
