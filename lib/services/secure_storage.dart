import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static SecureStorageService? _instance;
  late final FlutterSecureStorage _flutterSecureStorage;

  SecureStorageService._internal() {
    _flutterSecureStorage = const FlutterSecureStorage();
  }

  static SecureStorageService getInstance() {
    _instance ??= SecureStorageService._internal();

    return _instance!;
  }

  Future<void> set(String key, String value) async {
    await _flutterSecureStorage.write(key: key, value: value);
  }

  Future<String?> get(String key) async {
    return await _flutterSecureStorage.read(key: key);
  }

  Future<void> clear() async {
    await _flutterSecureStorage.deleteAll();
  }
}
