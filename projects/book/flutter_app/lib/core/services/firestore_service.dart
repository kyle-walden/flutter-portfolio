// Minimal Firestore service abstraction (stubbed for portfolio)
class FirestoreService {
  FirestoreService();

  // Example: fetch vendor document by id
  Future<Map<String, dynamic>?> getVendor(String vendorId) async {
    // Replace with real Firestore calls in real project
    await Future.delayed(const Duration(milliseconds: 50));
    return null;
  }

  /// Minimal stub to resolve a vendor by its public slug.
  /// In a real project this would query a `slug_reservations` collection or
  /// an index to resolve slug -> vendor id and then fetch the vendor document.
  Future<Map<String, dynamic>?> getVendorBySlug(String slug) async {
    await Future.delayed(const Duration(milliseconds: 75));
    if (slug.isEmpty) return null;
    // Return a demo vendor object so the portfolio form can display data.
    return {
      'id': 'vendor-${slug.replaceAll(RegExp(r"[^a-z0-9]"), '')}',
      'name': 'Demo Vendor ${slug}',
      'slug': slug,
    };
  }

  Future<void> setVendor(String vendorId, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 50));
  }

  Future<List<Map<String, dynamic>>> getBookings(String vendorId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return [];
  }
}
