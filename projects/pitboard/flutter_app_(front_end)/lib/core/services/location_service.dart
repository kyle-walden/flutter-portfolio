import 'dart:async';

import 'package:geolocator/geolocator.dart';

/// A small wrapper around geolocator to centralize permission checks and
/// provide a position stream.
class LocationService {
  LocationService._privateConstructor();
  static final LocationService instance = LocationService._privateConstructor();

  StreamSubscription<Position>? _positionSub;

  /// Request location permission from the user. Returns true if permission
  /// granted (while in use or always).
  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  /// Returns the current position or null if not available / permitted.
  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;
    try {
      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    } catch (_) {
      return null;
    }
  }

  /// Subscribe to a position stream. Returns a Stream<Position> that will
  /// emit location updates. Caller should cancel the subscription when done.
  Stream<Position> positionStream({LocationSettings? settings}) {
    final s = Geolocator.getPositionStream(
      locationSettings: settings ?? const LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 5),
    );
    return s;
  }

  /// Helper to stop an internal subscription if used.
  Future<void> stopInternalSubscription() async {
    await _positionSub?.cancel();
    _positionSub = null;
  }
}
