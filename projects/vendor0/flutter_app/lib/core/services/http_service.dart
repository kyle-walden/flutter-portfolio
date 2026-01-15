// HTTP service implementation demonstrating calls to the Flask backend.
//
// Usage notes (reserve-slug):
// - Call `post('/reserve-slug', {'slug': 'desired-slug', 'owner_id': 'vendor123'})`
//   to request the backend reserve a unique slug. The backend responds with
//   a 201 (reserved) or 409 (taken) status and a JSON body.
// - The `path` parameter may be an absolute URL (starting with http) or a
//   relative path (e.g. '/reserve-slug'). Relative paths will be prefixed with
//   the `baseUrl` supplied to the service.
import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  /// Base URL for the Flask backend, e.g. https://example.run.app or http://localhost:5000
  final String baseUrl;

  HttpService({this.baseUrl = 'http://localhost:5000'});

  Uri _build(String path) => Uri.parse(path.startsWith('http') ? path : '\$baseUrl\$path');

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final uri = _build(path);
    final resp = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
    // Note: we treat 2xx as OK and attempt to decode JSON. Non-2xx results
    // are returned as a structured error map so callers can inspect status
    // and body and handle 409/400/500 appropriately.
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      try {
        return jsonDecode(resp.body) as Map<String, dynamic>;
      } catch (_) {
        return {'ok': true};
      }
    }
    // return structured error
    return {'error': true, 'status': resp.statusCode, 'body': resp.body};
  }

  Future<Map<String, dynamic>> get(String path) async {
    final uri = _build(path);
    final resp = await http.get(uri, headers: {'Accept': 'application/json'});
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      try {
        return jsonDecode(resp.body) as Map<String, dynamic>;
      } catch (_) {
        return {'ok': true};
      }
    }
    return {'error': true, 'status': resp.statusCode, 'body': resp.body};
  }
}
