import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:intelli_hire/core/helpers/cache_helper.dart'; 

class NotificationHubService {
  HubConnection? _hubConnection;
  final String _hubUrl = "https://intellhire.runasp.net/quizHub";

  bool _isConnecting = false;
  void Function()? onTokenExpiredOrRefreshed;

  Future<void> initHub({
    required Function(dynamic) onNotificationReceived, 
  }) async {
    if (_isConnecting ||
        (_hubConnection != null &&
            _hubConnection!.state == HubConnectionState.Connected)) {
      return;
    }

    _isConnecting = true;

    // 1. هنجيب نوع اليوزر من الكاش أولاً بشكل غير متزامن لتجنب تفريغ الاتصال أثناء الـ await
    String? userType = await CacheHelper.getData(key: 'userType');

    // 2. إنشاء اتصال محلي وتجهيزه بالكامل
    final connection = HubConnectionBuilder()
        .withUrl(
          _hubUrl,
          options: HttpConnectionOptions(
            accessTokenFactory: () async {
              String? freshToken = await CacheHelper.getData(key: 'token');
              print("🔑 SignalR dynamically fetched token: $freshToken");
              return freshToken ?? "";
            },
            requestTimeout: 15000,
          ),
        )
        .withAutomaticReconnect()
        .build();

    // 3. لو اليوزر "شركة"، هنستمع لإشعارات الشركة بس
    if (userType == 'Company') {
      connection.on("ReceiveCompanyNotification", (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          print("🏢 SignalR Message Received (Company): ${arguments[0]}");
          try {
            onNotificationReceived(arguments[0]);
          } catch (e) {
            print("Error parsing company notification data: $e");
          }
        }
      });
    } 
    else {
      connection.on("ReceiveUserNotification", (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          print("👤 SignalR Message Received (User): ${arguments[0]}");
          try {
            onNotificationReceived(arguments[0]);
          } catch (e) {
            print("Error parsing user notification data: $e");
          }
        }
      });
    }
    
    _hubConnection = connection;

    try {
      print("Attempting to connect to SignalR...");
      await connection.start();
      print("✅ SignalR Connected Successfully to /quizHub");
    } catch (e) {
      print("❌ SignalR Connection Error: $e");
    } finally {
      _isConnecting = false;
    }
  }

  void stopConnection() {
    _hubConnection?.stop();
    _hubConnection = null;
    _isConnecting = false;
  }
}