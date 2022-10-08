import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// The signature of a callback that receives remote command-line arguments.
///
/// See also:
///  * [GApplication::command-line](https://docs.gtk.org/gio/signal.Application.command-line.html)
typedef GtkCommandLineListener = void Function(List<String> args);

/// The signature of a callback that receives remote file open requests.
///
/// See also:
///  * [GApplication::open](https://docs.gtk.org/gio/signal.Application.open.html)
typedef GtkOpenListener = void Function(List<String> files, String hint);

/// A class that can be used to listen to remote GTK application command-line
/// arguments and file open requests.
///
/// See also:
///  * [GApplication::command-line](https://docs.gtk.org/gio/signal.Application.command-line.html)
///  * [GApplication::open](https://docs.gtk.org/gio/signal.Application.open.html)
class GtkApplicationNotifier {
  /// Creates a new [GtkApplicationNotifier].
  GtkApplicationNotifier() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  final _channel = const MethodChannel('gtk_application');
  final _commandLineListeners = <GtkCommandLineListener>[];
  final _openListeners = <GtkOpenListener>[];

  /// Adds a [listener] that will be notified when the application receives
  /// remote command-line arguments.
  void addCommandLineListener(GtkCommandLineListener listener) {
    _commandLineListeners.add(listener);
  }

  /// Removes a previously registered remote command-line argument [listener].
  void removeCommandLineListener(GtkCommandLineListener listener) {
    _commandLineListeners.remove(listener);
  }

  /// Adds a [listener] that will be called when the application receives remote
  /// file open requests.
  void addOpenListener(GtkOpenListener listener) {
    _openListeners.add(listener);
  }

  /// Removes a previously registered remote file open request [listener].
  void removeOpenListener(GtkOpenListener listener) {
    _openListeners.remove(listener);
  }

  /// Discards any resources used by the object. After this is called, the
  /// listeners will no longer be notified.
  void dispose() {
    _channel.setMethodCallHandler(null);
    _commandLineListeners.clear();
    _openListeners.clear();
  }

  /// Notify all the remote command-line argument listeners.
  @protected
  @visibleForTesting
  void notifyCommandLine(List<String> args) {
    final listeners = List.of(_commandLineListeners);
    for (final listener in listeners) {
      listener(args);
    }
  }

  /// Notify all the remote file open request listeners.
  @protected
  @visibleForTesting
  void notifyOpen({required List<String> files, required String hint}) {
    final listeners = List.of(_openListeners);
    for (final listener in listeners) {
      listener(files, hint);
    }
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'command-line':
        final args = call.arguments as List;
        notifyCommandLine(args.cast<String>());
        break;
      case 'open':
        final args = call.arguments as Map;
        notifyOpen(
          files: (args['files'] as List).cast<String>(),
          hint: args['hint'].toString(),
        );
        break;
      default:
        throw UnsupportedError(call.method);
    }
  }
}
