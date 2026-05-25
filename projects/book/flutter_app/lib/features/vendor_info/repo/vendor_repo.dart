import '../model/vendor.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/services/http_service.dart';

class VendorRepo {
  final FirestoreService _fs;
  final HttpService _http;

  VendorRepo(this._fs, this._http);

  Future<Vendor?> fetchVendor(String id) async {
    final data = await _fs.getVendor(id);
    if (data == null) return null;
    return Vendor.fromJson(data);
  }

  Future<Vendor?> fetchVendorBySlug(String slug) async {
    final data = await _fs.getVendorBySlug(slug);
    if (data == null) return null;
    return Vendor.fromJson(data);
  }

  Future<Vendor?> fetchVendorByAuthId(String authId) async {
    // In a real project this would query a mapping from auth user -> vendor doc
    final data = await _fs.getVendor(authId);
    if (data == null) return null;
    return Vendor.fromJson(data);
  }

  Future<bool> reserveSlug(String slug, {String? ownerId}) async {
    // Call Flask endpoint to reserve slug.
    // Recommended payload: { 'slug': '<desired>', 'owner_id': '<vendor id>' }
    // - If owner_id is provided the server should reserve the slug for that
    //   vendor id (idempotent if already owned by same vendor).
    // - Server may return 201 (reserved), 200 (already-owned), or 409 (taken).
    final payload = {'slug': slug};
    if (ownerId != null) payload['owner_id'] = ownerId;
    final resp = await _http.post('/reserve-slug', payload);
    // The HttpService returns either decoded JSON on success or an error map
    // with an `error` key. Here we treat a decoded map as success when it
    // contains a reserved status. Adjust logic if your backend returns a
    // different shape.
    if (resp['status'] == 'reserved' || resp['status'] == 'already_owned' || resp['ok'] == true) {
      return true;
    }
    return false;
  }

  Future<void> saveVendor(Vendor v) async {
    await _fs.setVendor(v.id, v.toJson());
  }
}
