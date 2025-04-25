import 'dart:typed_data';

import 'play_services_block_store_platform_interface.dart';

class PlayServicesBlockStore {
  static Future<void> saveString(String key, String value) {
    return PlayServicesBlockStorePlatform.instance.saveString(key, value);
  }

  static Future<void> saveBytes(String key, Uint8List bytes) {
    return PlayServicesBlockStorePlatform.instance.saveBytes(key, bytes);
  }

  static Future<String?> retrieveString(String key) {
    return PlayServicesBlockStorePlatform.instance.retrieveString(key);
  }

  static Future<Uint8List?> retrieveBytes(String key) {
   return PlayServicesBlockStorePlatform.instance.retrieveBytes(key);
  }

  static Future<void> delete(String key) {
    return PlayServicesBlockStorePlatform.instance.delete(key);
  }

  static Future<void> deleteAll() {
    return PlayServicesBlockStorePlatform.instance.deleteAll();
  }
}
