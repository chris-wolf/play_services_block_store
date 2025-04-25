# play_services_block_store

A Flutter plugin for accessing the [Google Play Services Block Store API](https://developers.google.com/identity/blockstore/overview) on Android. Securely store and retrieve small key-value pairs of data that can survive app uninstall and restore, making it ideal for authentication tokens or device identifiers.

> ⚠️ **Android only.** This plugin uses Google Play Services and is not supported on iOS or web.

---

## Features

- 🔐 Save and retrieve key-value pairs securely.
- 💾 Support for storing both strings and byte arrays.
- 🔍 Retrieve a single item or all stored items.
- 🗑️ Delete individual keys or clear all stored data.
- 🧩 Easy-to-use Flutter API.

---

## Getting Started

### Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  play_services_block_store: ^0.3.0
```

Then run:

```bash
flutter pub get
```

---

## Usage

```dart
import 'package:play_services_block_store/play_services_block_store.dart';

// Save a string
await PlayServicesBlockStore.saveString('username', 'alice');

// Retrieve a string
final username = await PlayServicesBlockStore.retrieveString('username');

// Save bytes
final byteData =  Uint8List.fromList([1, 2, 3, 4]);
await PlayServicesBlockStore.saveBytes('my_bytes', byteData);

// Retrieve bytes
final byteData = await PlayServicesBlockStore.retrieveBytes('my_bytes');

// Delete a single key
await PlayServicesBlockStore.delete('username');

// Delete all stored data
await PlayServicesBlockStore.deleteAll();
```
