import '../model/pre_session_config.dart';

class PreSessionRepo {
  Future<PreSessionConfig> loadConfig() async {
    // Stub: production would fetch from Firestore or local preferences.
    return const PreSessionConfig(sessionName: 'New Session', trackId: 'track-01');
  }
}
