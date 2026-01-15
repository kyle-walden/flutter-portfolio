import 'package:flutter/foundation.dart';
import '../../vendor_info/models/vendor.dart';
import '../../vendor_info/repo/vendor_repo.dart';

class VendorProvider extends ChangeNotifier {
  final VendorRepo _repo;

  Vendor? vendor;
  bool loading = false;
  String? error;

  VendorProvider(firestore, http) : _repo = VendorRepo(firestore, http);

  Future<void> loadVendor(String id) async {
    loading = true;
    notifyListeners();
    try {
      vendor = await _repo.fetchVendor(id);
      error = null;
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  Future<void> loadVendorBySlug(String slug) async {
    loading = true;
    notifyListeners();
    try {
      vendor = await _repo.fetchVendorBySlug(slug);
      error = null;
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  Future<void> loadVendorByAuthId(String authId) async {
    loading = true;
    notifyListeners();
    try {
      vendor = await _repo.fetchVendorByAuthId(authId);
      error = null;
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  Future<bool> reserveSlug(String slug) async {
    // Reserve a slug via the repo. In the real app we would pass the
    // authenticated vendor id so the server can associate the slug with the
    // vendor (idempotent). The repo currently sends only the slug; to include
    // the vendor id change the call to: _repo.reserveSlug(slug, vendorId: vendor.id)
  // Reserve the slug with owner id tied to the current vendor (if loaded).
  final ok = await _repo.reserveSlug(slug, ownerId: vendor?.id);
    if (ok && vendor != null) {
      vendor = Vendor(id: vendor!.id, name: vendor!.name, slug: slug);
      await _repo.saveVendor(vendor!);
      notifyListeners();
    }
    return ok;
  }
}
