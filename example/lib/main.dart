import 'package:flutter/material.dart';
import 'package:gtk_application/gtk_application.dart';

void main() => runApp(const MaterialApp(home: MyHomePage()));

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('gtk_application'),
      ),
      body: GtkApplication(
        onCommandLine: (args) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('command-line'),
              content: Text(args.toString()),
              actions: [
                OutlinedButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        },
        onOpen: (files, hint) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('open $hint'),
              content: Column(
                children: files.map((f) => Text(f)).toList(),
              ),
              actions: [
                OutlinedButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
