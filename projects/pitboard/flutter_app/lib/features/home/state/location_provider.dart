import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/preferences_service.dart';

/// LocationProvider centralizes permission checks, preference persistence,
/// and the live position stream for the Home feature.
class LocationProvider extends ChangeNotifier {
  bool enabled = false;
  Position? currentPosition;
  StreamSubscription<Position>? _sub;

  LocationProvider() {
    // Kick off async initialization without blocking construction.
    Future.microtask(_loadPreferenceAndMaybeStart);
  }

  Future<void> _loadPreferenceAndMaybeStart() async {
    try {
      final pref = await PreferencesService.isLocationEnabled();
      if (pref) await enable();
    } catch (e) {
      debugPrint('Error loading location preference: $e');
    }
  }

  Future<void> enable() async {
    // Request permission first
    final granted = await LocationService.instance.requestPermission();
    if (!granted) {
      await PreferencesService.setLocationEnabled(false);
      enabled = false;
      notifyListeners();
      return;
    }

    enabled = true;
    await PreferencesService.setLocationEnabled(true);

    // start streaming
    _sub?.cancel();
    _sub = LocationService.instance.positionStream().listen((pos) {
      currentPosition = pos;
      notifyListeners();
    }, onError: (err) {
      debugPrint('Location stream error: $err');
    });

    // Also attempt to seed with a current position
    try {
      final p = await LocationService.instance.getCurrentPosition();
      if (p != null) {
        currentPosition = p;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error getting current position: $e');
    }
  }

  Future<void> disable() async {
    await _sub?.cancel();
    _sub = null;
    currentPosition = null;
    enabled = false;
    await PreferencesService.setLocationEnabled(false);
    notifyListeners();
  }

  Future<void> toggle(bool v) => v ? enable() : disable();

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
