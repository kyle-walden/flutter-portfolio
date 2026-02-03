import '../../../core/services/firestore_service.dart';
import '../models/availability.dart';

class BookingRepo {
  // final FirestoreService _fs;  // Unused in stubbed implementation

  BookingRepo(FirestoreService fs);  // Accept but don't store for now

  Future<List<AvailabilityRule>> fetchAvailability(String vendorId) async {
    // stubbed: return demo availability rules for portfolio
    await Future.delayed(const Duration(milliseconds: 50));
    return [
      AvailabilityRule(id: 'a1', description: 'Weekdays 9:00 - 17:00'),
      AvailabilityRule(id: 'a2', description: 'Saturdays 10:00 - 14:00'),
    ];
  }

  Future<void> saveAvailability(String vendorId, List<AvailabilityRule> rules) async {
    await Future.delayed(const Duration(milliseconds: 50));
  }
}
