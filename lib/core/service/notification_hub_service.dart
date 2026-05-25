import 'package:intelli_hire/features/Organization/Notification/data/Models/notification_model.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

class NotificationHubService {
  HubConnection? _hubConnection; // خليناه Nullable عشان نتأكد إنه مش شغال مرتين
  // 🔴 التعديل هنا: المسار بقى quizHub
  final String _hubUrl = "https://intellhire.runasp.net/quizHub";
  Future<void> initHub({
    required String token,
    required Function(NotificationModel) onNotificationReceived,
  }) async {
    if (_hubConnection != null &&
        _hubConnection!.state == HubConnectionState.Connected) {
      return; // لو متصل متعملش حاجة تاني
    }

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          _hubUrl,
          options: HttpConnectionOptions(
            // 🔴 التعديل هنا: بنبعت الـ Token بدون كلمة Bearer (المكتبة بتحطها)
            accessTokenFactory: () async => token,
          ),
        )
        .withAutomaticReconnect()
        .build();

    // 🔴 بنسمع للحدث ReceiveNotification اللي الباك إند بيبعته
    _hubConnection!.on("ReceiveNotification", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        print(
          "🔔 SignalR Message Received: ${arguments[0]}",
        ); // 🔴 اطبع الداتا هنا
        final notificationData = NotificationModel.fromJson(
          arguments[0] as Map<String, dynamic>,
        );
        onNotificationReceived(notificationData);
      }
    });

    try {
      await _hubConnection!.start();
      print("SignalR Connected Successfully to /quizHub");
    } catch (e) {
      print("SignalR Connection Error: $e");
    }
  }

  void stopConnection() {
    _hubConnection?.stop();
    _hubConnection = null;
  }
}
