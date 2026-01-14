import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../history/repo/history_repository.dart';


class HistoryItem {
  final String id;
  final String title;
  final String subtitle;

  HistoryItem({required this.id, required this.title, required this.subtitle});
}

class HistoryProvider extends ChangeNotifier {
  bool isLoading = false;
  List<HistoryItem> items = [];
  StreamSubscription? _boxSub;
  HistoryRepository? _repo;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    _repo = HistoryRepository();
    await _repo!.init();
    // If local empty, try remote fetch
    await _repo!.fetchRemoteAndCacheIfEmpty();

    // Read current data from repo
    _readFromRepo();

    // Listen for local changes
    _boxSub = _repo!.watchLocal().listen((event) {
      _readFromRepo();
    });

    // Try flush any queued ops if authed
    await _repo!.flushQueueIfAuthenticated();

    isLoading = false;
    notifyListeners();
  }

  void _readFromRepo() {
    final values = _repo!.getAllLocal();
    items = values
        .map((m) => HistoryItem(id: m['id'].toString(), title: m['title'].toString(), subtitle: m['subtitle'].toString()))
        .toList();
    notifyListeners();
  }

  // CRUD methods exposed to UI
  Future<void> createItem(String id, String title, String subtitle) async {
    final m = {'id': id, 'title': title, 'subtitle': subtitle};
    await _repo!.create(m);
  }

  Future<void> updateItem(String id, String title, String subtitle) async {
    final m = {'id': id, 'title': title, 'subtitle': subtitle};
    await _repo!.update(id, m);
  }

  Future<void> deleteItem(String id) async {
    await _repo!.delete(id);
  }

  @override
  void dispose() {
    _boxSub?.cancel();
    super.dispose();
  }
}
