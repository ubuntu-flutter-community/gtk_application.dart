import 'package:flutter_test/flutter_test.dart';
import 'package:gtk_application/gtk_application.dart';
import 'package:gtk_application/gtk_application_platform_interface.dart';
import 'package:gtk_application/gtk_application_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGtkApplicationPlatform
    with MockPlatformInterfaceMixin
    implements GtkApplicationPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GtkApplicationPlatform initialPlatform = GtkApplicationPlatform.instance;

  test('$MethodChannelGtkApplication is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGtkApplication>());
  });

  test('getPlatformVersion', () async {
    GtkApplication gtkApplicationPlugin = GtkApplication();
    MockGtkApplicationPlatform fakePlatform = MockGtkApplicationPlatform();
    GtkApplicationPlatform.instance = fakePlatform;

    expect(await gtkApplicationPlugin.getPlatformVersion(), '42');
  });
}
