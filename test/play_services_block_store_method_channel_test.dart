import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:play_services_block_store/play_services_block_store_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('play_services_block_store');


  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

}
