import 'package:flutter/foundation.dart';

import '../model/vendor.dart';
import '../repo/vendor_repo.dart';

class VendorViewModel extends ChangeNotifier {
  final VendorRepo _repo;

  Vendor? vendor;
  bool loading = false;
  String? error;

  VendorViewModel(firestore, http) : _repo = VendorRepo(firestore, http);

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
    final ok = await _repo.reserveSlug(slug, ownerId: vendor?.id);
    if (ok && vendor != null) {
      vendor = Vendor(id: vendor!.id, name: vendor!.name, slug: slug);
      await _repo.saveVendor(vendor!);
      notifyListeners();
    }
    return ok;
  }
}
