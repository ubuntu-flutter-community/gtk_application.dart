//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <gtk_application/gtk_application_plugin.h>
#include <yaru/yaru_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) gtk_application_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "GtkApplicationPlugin");
  gtk_application_plugin_register_with_registrar(gtk_application_registrar);
  g_autoptr(FlPluginRegistrar) yaru_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "YaruPlugin");
  yaru_plugin_register_with_registrar(yaru_registrar);
}
