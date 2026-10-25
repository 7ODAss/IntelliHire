import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CacheHelper {
  static late FlutterSecureStorage _secureStorage;
  static final Map<String, String> _memoryCache = {};

  static void init() {
    _secureStorage = const FlutterSecureStorage();
  }

  static Future<void> saveData({
    required String key,
    required dynamic value,
  }) async {
    _memoryCache[key] = value.toString();
    await _secureStorage.write(key: key, value: value.toString());
  }

  static Future<String?> getData({required String key}) async {
    if (_memoryCache.containsKey(key)) {
      return _memoryCache[key]; // ⚡ 0ms instantaneous read from RAM!
    }
    final val = await _secureStorage.read(key: key);
    if (val != null) _memoryCache[key] = val;
    return val;
  }

  static Future<void> removeData({required String key}) async {
    _memoryCache.remove(key);
    await _secureStorage.delete(key: key);
  }

  static Future<void> clearData() async {
    _memoryCache.clear();
    await _secureStorage.deleteAll();
  }
}
