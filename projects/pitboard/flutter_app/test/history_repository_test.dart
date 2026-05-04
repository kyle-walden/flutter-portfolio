import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:pitboard/features/history/repo/history_repository.dart';

/// Test suite for [HistoryRepository] — covers the local Hive cache layer.
///
/// Firebase-dependent paths (remote fetch, queue flush) are guarded by
/// try-catch in the repository and are no-ops when Firebase is not
/// initialised, making them safe to call here.
///
/// Integration tests against a live Firestore emulator are out of scope
/// for this suite (see shared/TESTING_STRATEGIES.md).
void main() {
  final tempDir = Directory.systemTemp.createTempSync('hive_history_test_');

  setUp(() async {
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await Hive.close();
    for (final entity in tempDir.listSync()) {
      try {
        entity.deleteSync(recursive: true);
      } catch (_) {}
    }
  });

  test('getAllLocal returns empty list before init', () {
    final repo = HistoryRepository();
    expect(repo.getAllLocal(), isEmpty);
  });

  test('getAllLocal returns empty list after init with no data', () async {
    final repo = HistoryRepository();
    await repo.init();
    expect(repo.getAllLocal(), isEmpty);
  });

  test('create() persists item to local cache', () async {
    final repo = HistoryRepository();
    await repo.init();

    final item = {'id': '1', 'title': 'Lap 1', 'subtitle': '01:23.45'};
    await repo.create(item);

    final items = repo.getAllLocal();
    expect(items, hasLength(1));
    expect(items.first['title'], equals('Lap 1'));
  });

  test('create() followed by delete() removes item', () async {
    final repo = HistoryRepository();
    await repo.init();

    final item = {'id': '2', 'title': 'Lap 2', 'subtitle': '01:45.00'};
    await repo.create(item);
    expect(repo.getAllLocal(), hasLength(1));

    await repo.delete('2');
    expect(repo.getAllLocal(), isEmpty);
  });

  test('update() overwrites existing item', () async {
    final repo = HistoryRepository();
    await repo.init();

    await repo.create({'id': '3', 'title': 'Old Title', 'subtitle': 'Old Sub'});
    await repo.update('3', {'id': '3', 'title': 'New Title', 'subtitle': 'New Sub'});

    final items = repo.getAllLocal();
    expect(items.first['title'], equals('New Title'));
  });

  test('flushQueueIfAuthenticated is a no-op when unauthenticated', () async {
    final repo = HistoryRepository();
    await repo.init();
    // Firebase not initialised — guarded try-catch should prevent any error.
    await expectLater(repo.flushQueueIfAuthenticated(), completes);
  });

  test('fetchRemoteAndCacheIfEmpty returns early when unauthenticated', () async {
    final repo = HistoryRepository();
    await repo.init();
    await expectLater(repo.fetchRemoteAndCacheIfEmpty(), completes);
    expect(repo.getAllLocal(), isEmpty);
  });
}
