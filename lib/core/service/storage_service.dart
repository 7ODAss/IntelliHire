import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'userToken', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'userToken');
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'userToken');
  }
}