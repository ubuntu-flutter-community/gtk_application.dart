import 'package:flutter/widgets.dart';

import 'notifier.dart';

class GtkApplication extends StatefulWidget {
  const GtkApplication({
    super.key,
    this.child,
    this.onCommandLine,
    this.onOpen,
    this.notifier,
  });

  final Widget? child;
  final GtkCommandLineListener? onCommandLine;
  final GtkOpenListener? onOpen;
  final GtkApplicationNotifier? notifier;

  @override
  State<GtkApplication> createState() => _GtkApplicationState();
}

class _GtkApplicationState extends State<GtkApplication> {
  late GtkApplicationNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _initNotifier();
  }

  @override
  void didUpdateWidget(covariant GtkApplication oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.notifier != widget.notifier) {
      _cleanupNotifier();
      _initNotifier();
    }
  }

  @override
  void dispose() {
    _cleanupNotifier();
    super.dispose();
  }

  void _initNotifier() {
    _notifier = widget.notifier ?? GtkApplicationNotifier();
    _notifier.addCommandLineListener(_onCommandLine);
    _notifier.addOpenListener(_onOpen);
  }

  void _cleanupNotifier() {
    _notifier.removeCommandLineListener(_onCommandLine);
    _notifier.removeOpenListener(_onOpen);
    if (widget.notifier == null) {
      _notifier.dispose();
    }
  }

  void _onCommandLine(List<String> args) {
    widget.onCommandLine?.call(args);
  }

  void _onOpen(List<String> files, String hint) {
    widget.onOpen?.call(files, hint);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox.shrink();
  }
}
