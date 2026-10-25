import 'package:flutter/material.dart';
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
          try {
            onNotificationReceived(arguments[0]);
          } catch (e) {}
        }
      });
    } else {
      connection.on("ReceiveUserNotification", (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          try {
            onNotificationReceived(arguments[0]);
          } catch (e) {}
        }
      });
    }

    _hubConnection = connection;

    try {
      await connection.start();
    } catch (e) {
      debugPrint("❌ SignalR Connection Error: $e");
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
