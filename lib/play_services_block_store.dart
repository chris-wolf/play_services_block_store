
import 'play_services_block_store_platform_interface.dart';

class PlayServicesBlockStore {
  Future<String?> getPlatformVersion() {
    return PlayServicesBlockStorePlatform.instance.getPlatformVersion();
  }
}
