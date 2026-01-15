import 'package:flutter/foundation.dart';
import '../models/availability.dart';
import '../repo/booking_repo.dart';

class BookingProvider extends ChangeNotifier {
  final BookingRepo _repo;
  List<AvailabilityRule> rules = [];
  bool loading = false;

  BookingProvider(firestore) : _repo = BookingRepo(firestore);

  Future<void> loadAvailability(String vendorId) async {
    loading = true;
    notifyListeners();
    rules = await _repo.fetchAvailability(vendorId);
    loading = false;
    notifyListeners();
  }
}
