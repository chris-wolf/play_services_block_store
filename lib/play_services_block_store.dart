import 'play_services_block_store_platform_interface.dart';

class PlayServicesBlockStore {
  static Future<void> saveString(String key, String value) {
    return PlayServicesBlockStorePlatform.instance.saveString(key, value);
  }

  static Future<void> saveBytes(String key, String base64Value) {
    return PlayServicesBlockStorePlatform.instance.saveBytes(key, base64Value);
  }

  static Future<String?> retrieveString(String key) {
    return PlayServicesBlockStorePlatform.instance.retrieveString(key);
  }

  static Future<String?> retrieveBytes(String key) {
    return PlayServicesBlockStorePlatform.instance.retrieveBytes(key);
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
