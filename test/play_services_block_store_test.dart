import 'package:flutter_test/flutter_test.dart';
import 'package:play_services_block_store/play_services_block_store_platform_interface.dart';
import 'package:play_services_block_store/play_services_block_store_method_channel.dart';


void main() {
  final PlayServicesBlockStorePlatform initialPlatform = PlayServicesBlockStorePlatform.instance;

  test('$MethodChannelPlayServicesBlockStore is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPlayServicesBlockStore>());
  });
}
