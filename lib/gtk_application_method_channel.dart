import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'gtk_application_platform_interface.dart';

/// An implementation of [GtkApplicationPlatform] that uses method channels.
class MethodChannelGtkApplication extends GtkApplicationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('gtk_application');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
