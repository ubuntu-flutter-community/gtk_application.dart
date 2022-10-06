
import 'gtk_application_platform_interface.dart';

class GtkApplication {
  Future<String?> getPlatformVersion() {
    return GtkApplicationPlatform.instance.getPlatformVersion();
  }
}
