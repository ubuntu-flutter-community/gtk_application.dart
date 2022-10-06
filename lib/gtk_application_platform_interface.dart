import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'gtk_application_method_channel.dart';

abstract class GtkApplicationPlatform extends PlatformInterface {
  /// Constructs a GtkApplicationPlatform.
  GtkApplicationPlatform() : super(token: _token);

  static final Object _token = Object();

  static GtkApplicationPlatform _instance = MethodChannelGtkApplication();

  /// The default instance of [GtkApplicationPlatform] to use.
  ///
  /// Defaults to [MethodChannelGtkApplication].
  static GtkApplicationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GtkApplicationPlatform] when
  /// they register themselves.
  static set instance(GtkApplicationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
