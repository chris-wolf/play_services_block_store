import 'dart:typed_data';

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

   Future<bool> saveString(String key, String value) {
    throw UnimplementedError('saveString() has not been implemented.');
  }

  Future<bool> saveBytes(String key, Uint8List bytes) {
    throw UnimplementedError('saveBytes() has not been implemented.');
  }

  Future<String?> retrieveString(String key) {
    throw UnimplementedError('retrieveString() has not been implemented.');
  }

  Future<Uint8List?> retrieveBytes(String key) {
    throw UnimplementedError('retrieveBytes() has not been implemented.');
  }

  Future<void> delete(String key) {
    throw UnimplementedError('delete() has not been implemented.');
  }

  Future<void> deleteAll() {
    throw UnimplementedError('deleteAll() has not been implemented.');
  }
}