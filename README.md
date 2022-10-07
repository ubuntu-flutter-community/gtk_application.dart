# gtk_application

https://developer.gnome.org/documentation/tutorials/application.html

## Example

### Widget
```dart
import 'package:flutter/material.dart';
import 'package:gtk_application/gtk_application.dart';

void main() {
  runApp(
    MaterialApp(
      home: GtkApplication(
        onCommandLine: (args) => print('command-line: $args'),
        onOpen: (files, hint) => print('open ($hint): $files'),
        child: // ...
      ),
    ),
  );
}
```

### Notifier
```dart
import 'package:flutter/widgets.dart';
import 'package:gtk_application/gtk_application.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final notifier = GtkApplicationNotifier();
  notifier.addCommandLineListener((args) {
    print('command-line: $args');
  });
  notifier.addOpenListener((files, hint) {
    print('open ($hint): $files');
  });

  // ...
  // notifier.dispose();
}
```
