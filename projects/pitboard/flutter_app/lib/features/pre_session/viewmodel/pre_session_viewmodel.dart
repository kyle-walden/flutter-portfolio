import 'package:flutter/foundation.dart';

import '../model/pre_session_config.dart';
import '../repo/pre_session_repo.dart';

class PreSessionViewModel extends ChangeNotifier {
  final PreSessionRepo _repo;
  PreSessionConfig? config;
  bool isLoading = false;

  PreSessionViewModel({PreSessionRepo? repo}) : _repo = repo ?? PreSessionRepo();

  Future<void> loadConfig() async {
    isLoading = true;
    notifyListeners();
    config = await _repo.loadConfig();
    isLoading = false;
    notifyListeners();
  }
}
