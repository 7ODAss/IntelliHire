import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CacheHelper {
  static late FlutterSecureStorage _secureStorage;

  static void init() {
    _secureStorage = const FlutterSecureStorage();
  }

  static Future<void> saveData({
    required String key,
    required dynamic value,
  }) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  static Future<String?> getData({
    required String key,
  }) async {
    return await _secureStorage.read(key: key);
  }

  static Future<void> removeData({
    required String key,
  }) async {
     await _secureStorage.delete(key: key);
  }

  static Future<void> clearData() async {
    await _secureStorage.deleteAll();
  }
}
