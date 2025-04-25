import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'play_services_block_store_platform_interface.dart';

/// An implementation of [PlayServicesBlockStorePlatform] that uses method channels.
class MethodChannelPlayServicesBlockStore extends PlayServicesBlockStorePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('play_services_block_store');

  @override
  Future<void> saveString(String key, String value) async {
    await methodChannel.invokeMethod('saveString', {
      'key': key,
      'value': value,
    });
  }

  @override
  Future<void> saveBytes(String key, Uint8List data) async {
    await methodChannel.invokeMethod('saveBytes', {
      'key': key,
      'value': data,
    });
  }

  @override
  Future<String?> retrieveString(String key) async {
    return await methodChannel.invokeMethod<String>('retrieveString', {
      'key': key,
    });
  }

  @override
  Future<String?> retrieveBytes(String key) async {
    return await methodChannel.invokeMethod<String>('retrieveBytes', {
      'key': key,
    });
  }

  @override
  Future<Map<String, String>> retrieveAll() async {
    final result = await methodChannel.invokeMethod<String>('retrieveAll');
    if (result == null) return {};
    final decoded = Map<String, dynamic>.from(json.decode(result));
    return decoded.map((k, v) => MapEntry(k, v.toString()));
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
