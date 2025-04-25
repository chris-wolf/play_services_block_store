import 'play_services_block_store_platform_interface.dart';

class PlayServicesBlockStore {
  Future<void> saveString(String key, String value) {
    return PlayServicesBlockStorePlatform.instance.saveString(key, value);
  }

  Future<void> saveBytes(String key, String base64Value) {
    return PlayServicesBlockStorePlatform.instance.saveBytes(key, base64Value);
  }

  Future<String?> retrieveString(String key) {
    return PlayServicesBlockStorePlatform.instance.retrieveString(key);
  }

  Future<String?> retrieveBytes(String key) {
    return PlayServicesBlockStorePlatform.instance.retrieveBytes(key);
  }

  Future<Map<String, String>> retrieveAll() {
    return PlayServicesBlockStorePlatform.instance.retrieveAll();
  }

  Future<void> delete(String key) {
    return PlayServicesBlockStorePlatform.instance.delete(key);
  }

  Future<void> deleteAll() {
    return PlayServicesBlockStorePlatform.instance.deleteAll();
  }
}
