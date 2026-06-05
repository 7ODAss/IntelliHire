import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceHelper {
  
  static Future<String> getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return "${androidInfo.brand} ${androidInfo.model}";
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.name; 
      }
    } catch (e) {
      return "Unknown Device";
    }
    return "Web/Other Device";
  }
  
}