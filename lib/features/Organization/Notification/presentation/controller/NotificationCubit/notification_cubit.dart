import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/service/notification_hub_service.dart';
import 'package:intelli_hire/features/Organization/Notification/domain/Usecases/get_notifications_usecase.dart';
import 'package:intelli_hire/features/Organization/Notification/domain/Usecases/mark_notification_as_read_usecase.dart';
import 'package:intelli_hire/features/Organization/Notification/domain/Entities/notification_entity.dart';
import 'notification_state.dart';

// ... باقي الكود زي ما هو بالظبط من غير تغيير
class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationAsReadUseCase markAsReadUseCase;
  final NotificationHubService hubService;

  NotificationCubit({
    required this.getNotificationsUseCase,
    required this.markAsReadUseCase,
    required this.hubService,
  }) : super(NotificationInitial()) {
    fetchNotifications();
  }

  void initRealTimeNotifications(String userToken) {
    hubService.initHub(
      token: userToken,
      onNotificationReceived: (newNotification) {
        if (state is NotificationLoaded) {
          final currentList = (state as NotificationLoaded).notifications;
          final updatedList = <NotificationEntity>[
            newNotification as NotificationEntity,
            ...currentList,
          ];
          emit(NotificationLoaded(updatedList));
        }
      },
    );
  }

  void fetchNotifications() async {
    emit(NotificationLoading());
    try {
      final notifications = await getNotificationsUseCase.call();
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> markNotificationAsRead(String id) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;

      // 🔴 ضفنا <NotificationEntity> مع الـ map لتأكيد النوع
      final updatedNotifications = currentState.notifications
          .map<NotificationEntity>((n) {
            if (n.id == id) {
              return NotificationEntity(
                id: n.id,
                title: n.title,
                description: n.description,
                time: n.time,
                isUnread: false,
              );
            }
            return n;
          })
          .toList();

      emit(NotificationLoaded(updatedNotifications));

      try {
        await markAsReadUseCase.call(id);
      } catch (e) {
        print("Error marking as read: $e");
      }
    }
  }

  @override
  Future<void> close() {
    hubService.stopConnection();
    return super.close();
  }
}
