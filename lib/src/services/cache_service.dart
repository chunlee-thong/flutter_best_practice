import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class IHttpCacheService {
  Future<Map<String, dynamic>?> loadCache(String key);
  Future<void> saveCache(String key, Map<String, dynamic>? data);
}

class StorageHttpCacheService extends IHttpCacheService {
  Directory? saveDir;

  Future initDir() async {
    saveDir = await getTemporaryDirectory();
  }

  //
  @override
  Future<Map<String, dynamic>?> loadCache(String key) async {
    if (saveDir == null) await initDir();
    File file = await File("${saveDir!.path}/$key.json"); //.create(recursive: true);
    if (await file.exists()) {
      String data = await file.readAsString();
      return jsonDecode(data);
    }
    return null;
  }

  @override
  Future<void> saveCache(String key, Map<String, dynamic>? data) async {
    if (saveDir == null) await initDir();
    File file = await File("${saveDir!.path}/$key.json").create(recursive: true);
    await file.writeAsString(jsonEncode(data));
  }
}

class MemoryHttpCacheService extends IHttpCacheService {
  Map<String, Map<String, dynamic>?> cache = {};

  @override
  Future<Map<String, dynamic>?> loadCache(String key) async {
    if (cache[key] != null) {
      return cache[key];
    }
    return null;
  }

  @override
  Future<void> saveCache(String key, Map<String, dynamic>? data) async {
    cache[key] = data;
  }
}
