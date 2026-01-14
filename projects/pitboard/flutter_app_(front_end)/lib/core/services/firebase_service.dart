// Placeholder Firebase service - abstracted usage

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseService {
  static Future<void> init() async {
    await Firebase.initializeApp();
    // Note: the real project includes platform-specific config files that are not checked-in here.
  }

  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get db => FirebaseFirestore.instance;
  static FirebaseAnalytics get analytics => FirebaseAnalytics.instance;
  /// Convenience: current signed-in user, or null.
  static User? get currentUser => auth.currentUser;

  /// Force a reload of the current user from the backend.
  static Future<void> reloadUser() async {
    final u = auth.currentUser;
    if (u != null) await u.reload();
  }
}
