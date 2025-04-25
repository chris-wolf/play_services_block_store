import 'dart:convert';
import 'dart:typed_data';

import 'play_services_block_store_platform_interface.dart';

class PlayServicesBlockStore {
  static Future<void> saveString(String key, String value) {
    return PlayServicesBlockStorePlatform.instance.saveString(key, value);
  }

  static Future<void> saveBytes(String key, Uint8List bytes) {
    return PlayServicesBlockStorePlatform.instance.saveString(key, base64Encode(bytes as List<int>));
  }

  static Future<String?> retrieveString(String key) {
    return PlayServicesBlockStorePlatform.instance.retrieveString(key);
  }

  static Future<Uint8List?> retrieveBytes(String key) async {
   final base64String = await PlayServicesBlockStorePlatform.instance.retrieveBytes(key);
   if (base64String == null) {
     return null;
   }
    return base64Decode(base64String);
  }

  static Future<Map<String, String>> retrieveAll() {
    return PlayServicesBlockStorePlatform.instance.retrieveAll();
  }

  static Future<void> delete(String key) {
    return PlayServicesBlockStorePlatform.instance.delete(key);
  }

  static Future<void> deleteAll() {
    return PlayServicesBlockStorePlatform.instance.deleteAll();
  }
}
