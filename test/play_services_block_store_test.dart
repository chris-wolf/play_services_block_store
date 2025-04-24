import 'package:flutter_test/flutter_test.dart';
import 'package:play_services_block_store/play_services_block_store.dart';
import 'package:play_services_block_store/play_services_block_store_platform_interface.dart';
import 'package:play_services_block_store/play_services_block_store_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPlayServicesBlockStorePlatform
    with MockPlatformInterfaceMixin
    implements PlayServicesBlockStorePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PlayServicesBlockStorePlatform initialPlatform = PlayServicesBlockStorePlatform.instance;

  test('$MethodChannelPlayServicesBlockStore is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPlayServicesBlockStore>());
  });

  test('getPlatformVersion', () async {
    PlayServicesBlockStore playServicesBlockStorePlugin = PlayServicesBlockStore();
    MockPlayServicesBlockStorePlatform fakePlatform = MockPlayServicesBlockStorePlatform();
    PlayServicesBlockStorePlatform.instance = fakePlatform;

    expect(await playServicesBlockStorePlugin.getPlatformVersion(), '42');
  });
}
