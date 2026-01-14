import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _keyEnableLocation = 'enable_location';

  /// Initialize preferences if needed. For shared_preferences no explicit init
  /// is necessary beyond calling the APIs, but this keeps parity with other
  /// services.
  static Future<void> init() async {
    // no-op for now
  }

  static Future<bool> isLocationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyEnableLocation) ?? false;
  }

  static Future<void> setLocationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEnableLocation, enabled);
  }
}
