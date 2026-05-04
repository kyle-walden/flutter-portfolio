import 'package:geolocator/geolocator.dart';

import '../../../core/services/location_service.dart';

/// Thin data-access wrapper around [LocationService].
/// Injecting [HomeRepo] into the ViewModel keeps [LocationViewModel] unit-testable.
class HomeRepo {
  final LocationService _locationService;

  HomeRepo({LocationService? locationService})
      : _locationService = locationService ?? LocationService.instance;

  Future<bool> requestPermission() => _locationService.requestPermission();

  Future<Position?> getCurrentPosition() => _locationService.getCurrentPosition();

  Stream<Position> positionStream({LocationSettings? settings}) =>
      _locationService.positionStream(settings: settings);
}
