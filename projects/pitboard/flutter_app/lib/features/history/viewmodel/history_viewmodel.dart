import 'dart:async';

import 'package:flutter/foundation.dart';

import '../model/history_item.dart';
import '../repo/history_repository.dart';

class HistoryViewModel extends ChangeNotifier {
  bool isLoading = false;
  List<HistoryItem> items = [];
  StreamSubscription? _boxSub;
  HistoryRepository? _repo;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    _repo = HistoryRepository();
    await _repo!.init();
    await _repo!.fetchRemoteAndCacheIfEmpty();
    _readFromRepo();
    _boxSub = _repo!.watchLocal().listen((_) => _readFromRepo());
    await _repo!.flushQueueIfAuthenticated();
    isLoading = false;
    notifyListeners();
  }

  void _readFromRepo() {
    final values = _repo!.getAllLocal();
    items = values
        .map((m) => HistoryItem(
              id: m['id'].toString(),
              title: m['title'].toString(),
              subtitle: m['subtitle'].toString(),
            ))
        .toList();
    notifyListeners();
  }

  Future<void> createItem(String id, String title, String subtitle) async {
    await _repo!.create({'id': id, 'title': title, 'subtitle': subtitle});
  }

  Future<void> updateItem(String id, String title, String subtitle) async {
    await _repo!.update(id, {'id': id, 'title': title, 'subtitle': subtitle});
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
