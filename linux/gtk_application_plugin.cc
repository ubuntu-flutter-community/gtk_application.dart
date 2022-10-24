#include "include/gtk_application/gtk_application_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>

#define GTK_APPLICATION_PLUGIN(obj)                                     \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), gtk_application_plugin_get_type(), \
                              GtkApplicationPlugin))

struct _GtkApplicationPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(GtkApplicationPlugin, gtk_application_plugin, g_object_get_type())

static void method_response_cb(GObject* object, GAsyncResult* result,
                               gpointer user_data) {
  FlMethodChannel* method_channel = FL_METHOD_CHANNEL(user_data);
  g_autoptr(GError) error = nullptr;
  g_autoptr(FlMethodResponse) response =
      fl_method_channel_invoke_method_finish(method_channel, result, &error);
  if (response == nullptr) {
    g_warning("Failed to call method: %s", error->message);
  }
}

static gint command_line_cb(GApplication* application,
                            GApplicationCommandLine* command_line,
                            gpointer user_data) {
  FlMethodChannel* method_channel = FL_METHOD_CHANNEL(user_data);
  gchar** arguments =
      g_application_command_line_get_arguments(command_line, nullptr);
  g_autoptr(FlValue) value = fl_value_new_list_from_strv(arguments + 1);
  fl_method_channel_invoke_method(method_channel, "command-line", value,
                                  nullptr, method_response_cb, method_channel);
  return 0;
}

static void open_cb(GApplication* application, GFile** files, gint n_files,
                    gchar* hint, gpointer user_data) {
  FlMethodChannel* method_channel = FL_METHOD_CHANNEL(user_data);
  g_autoptr(FlValue) value = fl_value_new_map();
  FlValue* list = fl_value_new_list();
  for (int i = 0; i < n_files; ++i) {
    fl_value_append_take(list, fl_value_new_string(g_file_get_uri(files[i])));
  }
  fl_value_set_string_take(value, "files", list);
  fl_value_set_string_take(value, "hint", fl_value_new_string(hint));
  fl_method_channel_invoke_method(method_channel, "open", value, nullptr,
                                  method_response_cb, method_channel);
}

static void gtk_application_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(gtk_application_plugin_parent_class)->dispose(object);
}

static void gtk_application_plugin_class_init(
    GtkApplicationPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = gtk_application_plugin_dispose;
}

static void gtk_application_plugin_init(GtkApplicationPlugin* self) {}

void gtk_application_plugin_register_with_registrar(
    FlPluginRegistrar* registrar) {
  GtkApplicationPlugin* plugin = GTK_APPLICATION_PLUGIN(
      g_object_new(gtk_application_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "gtk_application", FL_METHOD_CODEC(codec));

  GApplication* app = g_application_get_default();
  g_signal_connect(app, "command-line", G_CALLBACK(command_line_cb), channel);
  g_signal_connect(app, "open", G_CALLBACK(open_cb), channel);

  g_object_unref(plugin);
}
