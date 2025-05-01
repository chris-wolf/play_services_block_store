
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'play_services_block_store_platform_interface.dart';

/// An implementation of [PlayServicesBlockStorePlatform] that uses method channels.
class MethodChannelPlayServicesBlockStore extends PlayServicesBlockStorePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('play_services_block_store');

  @override
  Future<bool> saveString(String key, String value) async {
    return (await methodChannel.invokeMethod('saveString', {
      'key': key,
      'value': value,
    })) as bool? ?? false;
  }

  @override
  Future<bool> saveBytes(String key, Uint8List data) async {
    return (await methodChannel.invokeMethod('saveBytes', {
      'key': key,
      'value': data,
    })) as bool? ?? false;
  }

  @override
  Future<String?> retrieveString(String key) async {
    return await methodChannel.invokeMethod<String>('retrieveString', {
      'key': key,
    });
  }

  @override
  Future<Uint8List?> retrieveBytes(String key) async {
    return await methodChannel.invokeMethod<Uint8List>('retrieveBytes', {
      'key': key,
    });
  }

  @override
  Future<void> delete(String key) async {
    await methodChannel.invokeMethod('delete', {
      'key': key,
    });
  }

  @override
  Future<void> deleteAll() async {
    await methodChannel.invokeMethod('deleteAll');
  }
}
