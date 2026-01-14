// Simple Hive wrapper used for caching / local storage

import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    // Register adapters here if using typed boxes
  }

  static Box box(String name) => Hive.box(name);

  /// Open a box if not already open and return it.
  static Future<Box> openBox(String name) async {
    if (!Hive.isBoxOpen(name)) return await Hive.openBox(name);
    return Hive.box(name);
  }
}
