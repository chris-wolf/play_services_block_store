import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'play_services_block_store_method_channel.dart';

abstract class PlayServicesBlockStorePlatform extends PlatformInterface {
  /// Constructs a PlayServicesBlockStorePlatform.
  PlayServicesBlockStorePlatform() : super(token: _token);

  static final Object _token = Object();

  static PlayServicesBlockStorePlatform _instance = MethodChannelPlayServicesBlockStore();

  /// The default instance of [PlayServicesBlockStorePlatform] to use.
  ///
  /// Defaults to [MethodChannelPlayServicesBlockStore].
  static PlayServicesBlockStorePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PlayServicesBlockStorePlatform] when
  /// they register themselves.
  static set instance(PlayServicesBlockStorePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
