import 'package:flutter_test/flutter_test.dart';
import 'package:gtk_application/src/widget.dart';

import 'test_utils.dart';

void main() {
  testWidgets('command-line', (tester) async {
    final receivedArgs = <List<String>>[];
    final receivedFiles = <List<String>>[];
    final receivedHints = <String>[];

    void receiveOpen(List<String> files, String hint) {
      receivedFiles.add(files);
      receivedHints.add(hint);
    }

    await tester.pumpWidget(GtkApplication(
      onCommandLine: receivedArgs.add,
      onOpen: receiveOpen,
    ));

    await receiveMethodCall('command-line', ['foo', 'bar']);
    expect(receivedArgs, [
      ['foo', 'bar']
    ]);

    await receiveMethodCall('open', {
      'files': ['foo', 'bar'],
      'hint': 'baz'
    });
    expect(receivedFiles, [
      ['foo', 'bar']
    ]);
    expect(receivedHints, ['baz']);

    await tester.pumpWidget(const GtkApplication());

    receivedArgs.clear();
    receivedFiles.clear();
    receivedHints.clear();

    await receiveMethodCall('command-line', ['none']);
    expect(receivedArgs, isEmpty);
  });

  testWidgets('open', (tester) async {
    final receivedFiles = <List<String>>[];
    final receivedHints = <String>[];

    void receiveOpen(List<String> files, String hint) {
      receivedFiles.add(files);
      receivedHints.add(hint);
    }

    await tester.pumpWidget(GtkApplication(onOpen: receiveOpen));

    await receiveMethodCall('open', {
      'files': ['foo', 'bar'],
      'hint': 'baz'
    });
    expect(receivedFiles, [
      ['foo', 'bar']
    ]);
    expect(receivedHints, ['baz']);

    await tester.pumpWidget(const GtkApplication());

    receivedFiles.clear();
    receivedHints.clear();

    await receiveMethodCall('open', {'files': [], 'hint': ''});
    expect(receivedFiles, isEmpty);
    expect(receivedHints, isEmpty);
  });
}
