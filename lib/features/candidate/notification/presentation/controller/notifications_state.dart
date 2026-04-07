part of 'notifications_cubit.dart';

class NotificationsState extends Equatable {
  final RequestState status;
  final List<NotificationItem> notifications;
  final String errorMessage;

  const NotificationsState({
    this.status = RequestState.initial,
    this.notifications = const [],
    this.errorMessage = '',
  });

  NotificationsState copyWith({
    RequestState? status,
    List<NotificationItem>? notifications,
    String? errorMessage,
  }) =>
      NotificationsState(
        status: status ?? this.status,
        notifications: notifications ?? this.notifications,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [status, notifications, errorMessage];
}
