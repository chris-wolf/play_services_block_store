import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:play_services_block_store/play_services_block_store.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _status = '';
  String _retrievedString = '';
  Uint8List _retrievedBytes =Uint8List(0);

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveString() async {
    await PlayServicesBlockStore.saveString('exampleKey', 'Hello saved as String');
    setState(() {
      _status = 'String saved';
    });
  }

  Future<void> _retrieveString() async {
    final value = await PlayServicesBlockStore.retrieveString('exampleKey');
    setState(() {
      _retrievedString = value ?? 'No value found';
      _status = 'String retrieved';
    });
  }

  Future<void> _saveBytes() async {
    final bytes = Uint8List.fromList(utf8.encode('Hello saved as bytes'));
    await PlayServicesBlockStore.saveBytes('byteKey', bytes);
    setState(() {
      _status = 'Bytes saved';
    });
  }

  Future<void> _retrieveBytes() async  {
    final byteData = await  PlayServicesBlockStore.retrieveBytes('byteKey');
    setState(() {
      _retrievedBytes = byteData ?? Uint8List(0);
      _status = 'Bytes retrieved';
    });
  }

  Future<void> _deleteAll() async {
    await PlayServicesBlockStore.deleteAll();
    setState(() {
      _retrievedString = '';
      _retrievedBytes = Uint8List(0);
      _status = 'All data deleted';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Block Store Plugin Example'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 64),
              Row(
              crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(onPressed: _saveString, child: const Text('Save String')),
                    const SizedBox(width: 16),
                    ElevatedButton(onPressed: _retrieveString, child: const Text('Retrieve String')),
                  ]
              ),
                  Text('Retrieved String: $_retrievedString'),
                  const SizedBox(height: 32),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
            ElevatedButton(onPressed: _saveBytes, child: const Text('Save Bytes')),
                  const SizedBox(width: 16),
            ElevatedButton(onPressed: _retrieveBytes, child: const Text('Retrieve Bytes')),
                ]
              ),
                  Text('Retrieved Bytes as UTF-8 String: ${utf8.decode(_retrievedBytes)}'),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _deleteAll,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Delete All'),
                  ),
                  const SizedBox(height: 24),
                  Text('Status: $_status'),
                ],
            ),
              ),
        ),
      ),

    );
  }
}