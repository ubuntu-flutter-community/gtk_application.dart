import 'package:flutter/services.dart';

typedef GtkCommandLineListener = void Function(List<String> args);
typedef GtkOpenListener = void Function(List<String> files, String hint);

class GtkApplicationNotifier {
  GtkApplicationNotifier() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  final _channel = const MethodChannel('gtk_application');
  final _commandLineListeners = <GtkCommandLineListener>[];
  final _openListeners = <GtkOpenListener>[];

  void addCommandLineListener(GtkCommandLineListener listener) {
    _commandLineListeners.add(listener);
  }

  void removeCommandLineListener(GtkCommandLineListener listener) {
    _commandLineListeners.remove(listener);
  }

  void addOpenListener(GtkOpenListener listener) {
    _openListeners.add(listener);
  }

  void removeOpenListener(GtkOpenListener listener) {
    _openListeners.remove(listener);
  }

  void dispose() {
    _channel.setMethodCallHandler(null);
    _commandLineListeners.clear();
    _openListeners.clear();
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'command-line':
        final args = call.arguments as List;
        _notifyCommandLineListeners(args.cast<String>());
        break;
      case 'open':
        final args = call.arguments as Map;
        final files = (args['files'] as List).cast<String>();
        final hint = args['hint'].toString();
        _notifyOpenListeners(files, hint);
        break;
      default:
        throw UnsupportedError(call.method);
    }
  }

  void _notifyCommandLineListeners(List<String> args) {
    final listeners = List.of(_commandLineListeners);
    for (final listener in listeners) {
      listener(args);
    }
  }

  void _notifyOpenListeners(List<String> files, String hint) {
    final listeners = List.of(_openListeners);
    for (final listener in listeners) {
      listener(files, hint);
    }
  }
}
