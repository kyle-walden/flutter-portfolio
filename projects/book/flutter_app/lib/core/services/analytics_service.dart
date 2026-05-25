import 'package:flutter/foundation.dart';
// Add `firebase_analytics` to pubspec.yaml to enable real analytics calls.
// import 'package:firebase_analytics/firebase_analytics.dart';

/// Lightweight analytics service wrapper.
///
/// Intended to be a single injection point for analytics calls. The real
/// `firebase_analytics` dependency can be added to the app and the commented
/// import above enabled. For now this file provides a thin, test-friendly
/// surface that can be wired into providers.
class AnalyticsService {
  // Uncomment when adding dependency:
  // final FirebaseAnalytics _client;

  AnalyticsService();

  Future<void> init() async {
    // Initialize analytics client if present. Keep fast and non-blocking.
    if (kDebugMode) return;
    // _client = FirebaseAnalytics.instance;
  }

  Future<void> logEvent(String name, {Map<String, Object?>? parameters}) async {
    // No-op in this redacted snapshot. Replace with:
    // await _client.logEvent(name: name, parameters: parameters);
    debugPrint('analytics.logEvent: $name params=${parameters ?? {}}');
  }

  Future<void> setUserId(String? id) async {
    // await _client.setUserId(id: id);
    debugPrint('analytics.setUserId: $id');
  }

  Future<void> setUserProperties(Map<String, String> properties) async {
    // properties.forEach((k, v) => _client.setUserProperty(name: k, value: v));
    debugPrint('analytics.setUserProperties: $properties');
  }
}
