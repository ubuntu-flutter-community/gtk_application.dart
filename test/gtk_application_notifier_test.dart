import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gtk_application/src/notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> receiveMethodCall(String method, [dynamic arguments]) async {
    const codec = StandardMethodCodec();
    final messenger =
        TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger;

    await messenger.handlePlatformMessage(
      'gtk_application',
      codec.encodeMethodCall(MethodCall(method, arguments)),
      (_) {},
    );
  }

  test('command-line', () async {
    final notifier = GtkApplicationNotifier();

    final receivedArgs = <List<String>>[];
    notifier.addCommandLineListener(receivedArgs.add);

    await receiveMethodCall('command-line', ['foo', 'bar']);
    expect(receivedArgs, [
      ['foo', 'bar']
    ]);

    await receiveMethodCall('command-line', ['baz qux']);
    expect(receivedArgs, [
      ['foo', 'bar'],
      ['baz qux'],
    ]);

    receivedArgs.clear();
    notifier.removeCommandLineListener(receivedArgs.add);

    await receiveMethodCall('command-line', ['none']);
    expect(receivedArgs, isEmpty);
  });

  test('open', () async {
    final notifier = GtkApplicationNotifier();

    final receivedFiles = <List<String>>[];
    final receivedHints = <String>[];

    void receiver(List<String> files, String hint) {
      receivedFiles.add(files);
      receivedHints.add(hint);
    }

    notifier.addOpenListener(receiver);

    await receiveMethodCall('open', {
      'files': ['foo', 'bar'],
      'hint': 'baz'
    });
    expect(receivedFiles, [
      ['foo', 'bar']
    ]);
    expect(receivedHints, ['baz']);

    await receiveMethodCall('open', {
      'files': ['baz qux'],
      'hint': 'quux'
    });
    expect(receivedFiles, [
      ['foo', 'bar'],
      ['baz qux'],
    ]);
    expect(receivedHints, ['baz', 'quux']);

    receivedFiles.clear();
    receivedHints.clear();
    notifier.removeOpenListener(receiver);

    await receiveMethodCall('open', {'files': [], 'hint': ''});
    expect(receivedFiles, isEmpty);
    expect(receivedHints, isEmpty);
  });
}
