import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/enums/request.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../../domain/entities/notification_item.dart';
import '../../domain/usecases/fetch_notifications_usecase.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final FetchNotificationsUseCase fetchNotificationsUseCase;

  NotificationsCubit(this.fetchNotificationsUseCase) : super(const NotificationsState());

  Future<void> loadNotifications() async {
    emit(state.copyWith(status: RequestState.loading));
    final result = await fetchNotificationsUseCase(const NoParameters());
    result.fold(
      (failure) => emit(state.copyWith(
        status: RequestState.error,
        errorMessage: failure.message,
      )),
      (notifications) => emit(state.copyWith(
        status: RequestState.success,
        notifications: notifications,
      )),
    );
  }
}
