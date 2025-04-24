import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:play_services_block_store/play_services_block_store_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelPlayServicesBlockStore platform = MethodChannelPlayServicesBlockStore();
  const MethodChannel channel = MethodChannel('play_services_block_store');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
