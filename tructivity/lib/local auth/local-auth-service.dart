import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalAuthService {
  final _storage = FlutterSecureStorage();

  Future<String> read(String key) async {
    final val = await this._storage.read(key: key);
    return val != null ? val : '';
  }

  Future<void> clearStorage() async {
    this._storage.delete(key: 'pin');
  }

  Future<void> write(String key, dynamic value) async {
    this._storage.write(key: key, value: value);
  }
}

final LocalAuthService authService = LocalAuthService();
