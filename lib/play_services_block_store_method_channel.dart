import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'play_services_block_store_platform_interface.dart';

/// An implementation of [PlayServicesBlockStorePlatform] that uses method channels.
class MethodChannelPlayServicesBlockStore extends PlayServicesBlockStorePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('play_services_block_store');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
