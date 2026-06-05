import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/service/notification_hub_service.dart';
import 'package:intelli_hire/features/Organization/Notification/domain/Usecases/get_notifications_usecase.dart';
import 'package:intelli_hire/features/Organization/Notification/domain/Usecases/delete_notification_usecase.dart';
import 'package:intelli_hire/features/Organization/Notification/domain/Entities/notification_entity.dart';
import 'package:intelli_hire/features/Organization/Notification/data/Models/notification_model.dart';
import 'package:intelli_hire/features/Organization/Notification/domain/Usecases/mark_notification_as_read_usecase.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkAllNotificationsAsReadUseCase markAllAsReadUseCase;
  final DeleteNotificationUseCase deleteNotificationUseCase;
  final NotificationHubService hubService;

  NotificationCubit({
    required this.getNotificationsUseCase,
    required this.markAllAsReadUseCase,
    required this.deleteNotificationUseCase,
    required this.hubService,
  }) : super(NotificationInitial()) {
    fetchNotifications();
    _startSignalR();
    hubService.onTokenExpiredOrRefreshed = reconnectSignalR;
  }

  void _startSignalR() {
    initRealTimeNotifications();
  }

  void initRealTimeNotifications() {
    hubService.initHub(
      onNotificationReceived: (newNotification) {
        if (isClosed) return;

        try {
          final newEntity = NotificationModel.fromJson(
            newNotification as Map<String, dynamic>,
          );

          if (state is NotificationLoaded) {
            final currentList = (state as NotificationLoaded).notifications;

            final isExists = currentList.any((n) => n.id == newEntity.id);

            if (!isExists) {
              final entity = NotificationEntity(
                id: newEntity.id,
                title: newEntity.title,
                description: newEntity.description,
                time: newEntity.time,
                isRead: newEntity.isRead,
              );
              final updatedList = <NotificationEntity>[entity, ...currentList];
              emit(NotificationLoaded(updatedList));
            }
          } else {
            emit(
              NotificationLoaded([
                NotificationEntity(
                  id: newEntity.id,
                  title: newEntity.title,
                  description: newEntity.description,
                  time: newEntity.time,
                  isRead: newEntity.isRead,
                ),
              ]),
            );
          }
        } catch (e) {
          print("Error Parsing SignalR Notification: $e");
        }
      },
    );
  }

  void fetchNotifications({bool isRefresh = false}) async {
    if (isClosed) return;

    if (!isRefresh) {
      emit(NotificationLoading());
    }

    final result = await getNotificationsUseCase.call();

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(NotificationError(failure.message));
      },
      (notifications) {
        emit(NotificationLoaded(notifications));
      },
    );
  }

  Future<void> markAllAsRead() async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;

      final List<NotificationEntity> updatedNotifications = currentState
          .notifications
          .map((n) {
            return NotificationEntity(
              id: n.id,
              title: n.title,
              description: n.description,
              time: n.time,
              isRead: true,
            );
          })
          .toList();

      emit(NotificationLoaded(updatedNotifications));

      final result = await markAllAsReadUseCase.call();

      result.fold((failure) {
        print("Error marking as read: ${failure.message}");
      }, (_) => print("Marked as read successfully"));
    }
  }

  Future<void> reconnectSignalR() async {
    if (isClosed) return;
    print("🔄 Reconnecting SignalR...");
    hubService.stopConnection(); 
    initRealTimeNotifications(); 
  }

  void deleteNotificationLocally(String id) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;

      final oldList = currentState.notifications;

      final updatedList = oldList.where((n) => n.id != id).toList();
      emit(NotificationLoaded(updatedList));

      if (id.startsWith("temp_")) {
        print("⚠️ Notification has a client-generated ID ($id). Skipping backend API deletion call.");
        return;
      }

      final result = await deleteNotificationUseCase.call(id);

      result.fold((failure) {
        emit(NotificationLoaded(oldList));
        print("Failed to delete: ${failure.message}");
      }, (_) => print("Successfully deleted"));
    }
  }
  void deleteAllNotificationsLocally() async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      final oldList = currentState.notifications;

      if (oldList.isEmpty) return; 

      emit(const NotificationLoaded([]));

      for (var notification in oldList) {
        if (notification.id != null) {
          await deleteNotificationUseCase.call(notification.id!);
        }
      }
      print("Successfully deleted all organization notifications in the background");
    }
  }

  @override
  Future<void> close() {
    if (hubService.onTokenExpiredOrRefreshed == reconnectSignalR) {
      hubService.onTokenExpiredOrRefreshed = null;
    }
    hubService.stopConnection();
    return super.close();
  }
}