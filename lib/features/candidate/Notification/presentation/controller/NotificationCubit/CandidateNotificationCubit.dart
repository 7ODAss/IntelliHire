import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/service/notification_hub_service.dart';
import 'package:intelli_hire/features/candidate/Notification/data/Models/candidate_notification_model.dart';
import 'package:intelli_hire/features/candidate/Notification/domain/Entities/candidate_notification_entity.dart';
import 'package:intelli_hire/features/candidate/Notification/domain/Usecases/delete_notification_usecase.dart';
import 'package:intelli_hire/features/candidate/Notification/domain/Usecases/get_notifications_usecase.dart';
import 'package:intelli_hire/features/candidate/Notification/domain/Usecases/mark_notification_as_read_usecase.dart';
import 'CandidateNotificationState.dart';

class CandidateNotificationcubit extends Cubit<Candidatenotificationstate> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkAllNotificationsAsReadUseCase markAllAsReadUseCase;
  final DeleteNotificationUseCase deleteNotificationUseCase;
  final NotificationHubService hubService;

  CandidateNotificationcubit({
    required this.getNotificationsUseCase,
    required this.markAllAsReadUseCase,
    required this.deleteNotificationUseCase,
    required this.hubService,
  }) : super(CandidateNotificationInitial()) {
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
          final newEntity = CandidateNotificationModel.fromJson(
            newNotification as Map<String, dynamic>,
          );

          if (state is CandidateNotificationLoaded) {
            final currentList = (state as CandidateNotificationLoaded).notifications;

            final isExists = currentList.any((n) => n.id == newEntity.id);

            if (!isExists) {
              final entity = CandidateNotificationEntity(
                id: newEntity.id,
                title: newEntity.title,
                description: newEntity.description,
                time: newEntity.time,
                isRead: newEntity.isRead,
              );
              final updatedList = <CandidateNotificationEntity>[entity, ...currentList];
              emit(CandidateNotificationLoaded(updatedList));
            }
          } else {
            emit(
              CandidateNotificationLoaded([
                CandidateNotificationEntity(
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
      emit(CandidateNotificationLoading());
    }

    final result = await getNotificationsUseCase.call();

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(CandidateNotificationError(failure.message));
      },
      (notifications) {
        emit(CandidateNotificationLoaded(notifications));
      },
    );
  }

  Future<void> markAllAsRead() async {
    if (state is CandidateNotificationLoaded) {
      final currentState = state as CandidateNotificationLoaded;

      final List<CandidateNotificationEntity> updatedNotifications = currentState
          .notifications
          .map((n) {
            return CandidateNotificationEntity(
              id: n.id,
              title: n.title,
              description: n.description,
              time: n.time,
              isRead: true, // بنبيضهم كلهم
            );
          })
          .toList();

      emit(CandidateNotificationLoaded(updatedNotifications));

      final result = await markAllAsReadUseCase.call();

      result.fold((failure) {
        print("Error marking as read: ${failure.message}");
      }, (_) => print("Marked as read successfully"));
    }
  }

  Future<void> reconnectSignalR() async {
    if (isClosed) return;
    hubService.stopConnection(); 
    initRealTimeNotifications(); 
  }

  void deleteNotificationLocally(String id) async {
    if (state is CandidateNotificationLoaded) {
      final currentState = state as CandidateNotificationLoaded;
      final oldList = currentState.notifications;
      final updatedList = oldList.where((n) => n.id != id).toList();
      emit(CandidateNotificationLoaded(updatedList));

      if (id.startsWith("temp_")) {
        print("⚠️ Notification has a client-generated ID ($id). Skipping backend API deletion call.");
        return;
      }

      final result = await deleteNotificationUseCase.call(id);

      result.fold((failure) {
        emit(CandidateNotificationLoaded(oldList));
        print("Failed to delete: ${failure.message}");
      }, (_) => print("Successfully deleted"));
    }
  }
  void deleteAllNotificationsLocally() async {
    if (state is CandidateNotificationLoaded) {
      final currentState = state as CandidateNotificationLoaded;
      final oldList = currentState.notifications;

      if (oldList.isEmpty) return; // مفيش حاجة تتمسح

      // 1. نفضي الشاشة فوراً قدام اليوزر عشان يحس بالسرعة
      emit(const CandidateNotificationLoaded([]));

      // 2. نمسحهم من الباك إند في الخلفية واحد ورا التاني
      for (var notification in oldList) {
        if (notification.id != null) {
          // بنتجاهل النتيجة هنا عشان الشاشة كدة كدة فضيت
          await deleteNotificationUseCase.call(notification.id!);
        }
      }
      print("Successfully deleted all notifications in the background");
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