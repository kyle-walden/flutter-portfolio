import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../repo/home_repo.dart';
import '../../../core/services/preferences_service.dart';

/// Centralises permission checks, preference persistence, and the live
/// position stream for the Home feature. [HomeRepo] is injected for testability.
class LocationViewModel extends ChangeNotifier {
  final HomeRepo _repo;
  bool enabled = false;
  Position? currentPosition;
  StreamSubscription<Position>? _sub;

  LocationViewModel({HomeRepo? repo}) : _repo = repo ?? HomeRepo() {
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
    final granted = await _repo.requestPermission();
    if (!granted) {
      await PreferencesService.setLocationEnabled(false);
      enabled = false;
      notifyListeners();
      return;
    }
    enabled = true;
    await PreferencesService.setLocationEnabled(true);
    _sub?.cancel();
    _sub = _repo.positionStream().listen((pos) {
      currentPosition = pos;
      notifyListeners();
    }, onError: (err) => debugPrint('Location stream error: $err'));
    try {
      final p = await _repo.getCurrentPosition();
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
