import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();

  // حفظ التوكن
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'userToken', value: token);
  }

  // قراءة التوكن (هنحتاجها بعدين لما اليوزر يفتح التطبيق وهو عامل لوجن)
  static Future<String?> getToken() async {
    return await _storage.read(key: 'userToken');
  }

  // مسح التوكن (في حالة الـ Logout)
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'userToken');
  }
}