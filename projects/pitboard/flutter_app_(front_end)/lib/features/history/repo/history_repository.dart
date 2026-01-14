import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/services/firebase_service.dart';
import '../../../core/services/hive_service.dart';

/// A small repository demonstrating a cache-first + sync strategy.
///
/// - Uses Hive box `history` for local cache (maps).
/// - Uses Hive box `history_queue` to persist pending remote operations.
/// - On auth, attempts to flush the queue to Firestore under `users/{uid}/history`.
class HistoryRepository {
  Box? _box;
  Box? _queueBox;

  Future<void> init() async {
    _box = await HiveService.openBox('history');
    _queueBox = await HiveService.openBox('history_queue');
  }

  /// Returns the local cached items as a list of maps.
  List<Map> getAllLocal() {
    if (_box == null) return [];
    return _box!.toMap().values.cast<Map>().toList();
  }

  /// If local is empty and user is signed in, fetch remote and cache locally.
  Future<void> fetchRemoteAndCacheIfEmpty() async {
    if (_box == null) return;
    if (_box!.isNotEmpty) return;

    final user = FirebaseService.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseService.db
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .get();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      _box!.put(doc.id, {'id': doc.id, 'title': data['title'] ?? '', 'subtitle': data['subtitle'] ?? ''});
    }
  }

  /// Create locally and enqueue remote create
  Future<void> create(Map item) async {
    // local
    await _box!.put(item['id'].toString(), item);
    // enqueue remote op
    await _enqueueOp({'op': 'create', 'id': item['id'].toString(), 'payload': item, 'retries': 0});
    // try flush immediately if authed
    await flushQueueIfAuthenticated();
  }

  Future<void> update(String id, Map item) async {
    await _box!.put(id, item);
    await _enqueueOp({'op': 'update', 'id': id, 'payload': item, 'retries': 0});
    await flushQueueIfAuthenticated();
  }

  Future<void> delete(String id) async {
    await _box!.delete(id);
    await _enqueueOp({'op': 'delete', 'id': id, 'payload': null, 'retries': 0});
    await flushQueueIfAuthenticated();
  }

  Future<void> _enqueueOp(Map op) async {
    final key = DateTime.now().microsecondsSinceEpoch.toString();
    await _queueBox!.put(key, op);
  }

  /// Attempt to flush queued ops to Firestore if user is signed in.
  /// Implements a simple retry policy (max 3 attempts per op).
  Future<void> flushQueueIfAuthenticated() async {
    final user = FirebaseService.currentUser;
    if (user == null) return;
    if (_queueBox == null) return;

    final keys = _queueBox!.keys.toList();
    for (final key in keys) {
      final op = Map<String, dynamic>.from(_queueBox!.get(key));
      try {
        await _applyOpToRemote(user.uid, op);
        await _queueBox!.delete(key);
      } catch (e) {
        // increment retry count and if exceeded, keep it but don't block others
        op['retries'] = (op['retries'] ?? 0) + 1;
        if (op['retries'] > 3) {
          // give up after 3 retries — in real app you'd surface this
          await _queueBox!.delete(key);
        } else {
          await _queueBox!.put(key, op);
        }
      }
    }
  }

  Future<void> _applyOpToRemote(String uid, Map op) async {
    final col = FirebaseService.db.collection('users').doc(uid).collection('history');
    final String opType = op['op'];
    final String id = op['id'];
    final payload = op['payload'];

    if (opType == 'create' || opType == 'update') {
      await col.doc(id).set({'title': payload['title'], 'subtitle': payload['subtitle']}, SetOptions(merge: true));
    } else if (opType == 'delete') {
      await col.doc(id).delete();
    }
  }

  /// Provide a stream that emits when the local box changes
  Stream<BoxEvent> watchLocal() => _box!.watch();
}
