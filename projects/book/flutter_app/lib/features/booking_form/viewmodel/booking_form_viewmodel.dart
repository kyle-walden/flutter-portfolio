import 'package:flutter/foundation.dart';

import '../repo/booking_form_repo.dart';

class BookingFormViewModel extends ChangeNotifier {
  final BookingFormRepo _repo;

  bool submitting = false;
  String? error;

  BookingFormViewModel(http) : _repo = BookingFormRepo(http);

  Future<bool> submit(Map<String, dynamic> payload) async {
    submitting = true;
    notifyListeners();
    final resp = await _repo.submitPublicBooking(payload);
    submitting = false;
    if (resp['error'] == true) {
      error = resp['body']?.toString() ?? 'submission failed';
      notifyListeners();
      return false;
    }
    error = null;
    notifyListeners();
    return true;
  }
}
