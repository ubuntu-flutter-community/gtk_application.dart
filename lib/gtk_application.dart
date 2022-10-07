import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class GtkApplication extends StatefulWidget {
  const GtkApplication({
    super.key,
    this.child,
    this.onCommandLine,
    this.onOpen,
  });

  final Widget? child;
  final void Function(List<String>)? onCommandLine;
  final void Function(List<String>, String)? onOpen;

  @override
  State<GtkApplication> createState() => _GtkApplicationState();
}

class _GtkApplicationState extends State<GtkApplication> {
  final _methodChannel = const MethodChannel('gtk_application');

  @override
  void initState() {
    super.initState();
    _methodChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'command-line':
          final args = call.arguments as List;
          widget.onCommandLine?.call(args.cast<String>());
          break;
        case 'open':
          final args = call.arguments as Map;
          widget.onOpen?.call(
            (args['files'] as List).cast<String>(),
            args['hint'] as String,
          );
          break;
      }
    });
  }

  @override
  void dispose() {
    _methodChannel.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child ?? const SizedBox.shrink();
}
