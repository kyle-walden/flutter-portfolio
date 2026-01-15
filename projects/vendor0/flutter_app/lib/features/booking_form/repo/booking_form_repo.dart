import '../../../core/services/http_service.dart';

class BookingFormRepo {
  final HttpService _http;

  BookingFormRepo(this._http);

  Future<Map<String, dynamic>> submitPublicBooking(Map<String, dynamic> payload) async {
    // Submit to Flask public bookings endpoint
    return await _http.post('/public/bookings', payload);
  }
}
