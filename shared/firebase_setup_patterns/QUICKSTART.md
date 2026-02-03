# Firebase Setup Quick Reference

## 🚀 One-Command Setup

```bash
# From your Flutter project root
/path/to/flutter-portfolio/shared/firebase_setup_patterns/setup-firebase.sh
```

---

## 📋 Common Commands

### FlutterFire CLI

```bash
# Configure Firebase for Flutter
flutterfire configure

# Configure specific platforms only
flutterfire configure --platforms=ios,android

# Reconfigure existing project
flutterfire configure --project=my-app-id

# Force overwrite existing config
flutterfire configure --yes
```

### Firebase CLI

```bash
# Login to Firebase
firebase login

# List projects
firebase projects:list

# Create new project (IDs must be globally unique!)
firebase projects:create yourname-myapp-2024

# If ID is taken, try with unique suffix
firebase projects:create myapp-$(date +%Y)
firebase projects:create myapp-$(openssl rand -hex 3)

# Use specific project
firebase use my-project-id

# Open project in console
firebase open

# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy Storage rules
firebase deploy --only storage:rules

# Start local emulators
firebase emulators:start
```

### Flutter Commands

```bash
# Get dependencies after adding Firebase packages
flutter pub get

# Clean and rebuild (if issues)
flutter clean
flutter pub get
flutter run

# Run with Firebase debug analytics
flutter run --dart-define=FIREBASE_ANALYTICS_DEBUG=true
```

---

## 🔥 Firebase Package Versions (Latest)

```yaml
dependencies:
  firebase_core: ^2.24.0              # Required for all Firebase
  firebase_auth: ^4.16.0              # Authentication
  cloud_firestore: ^4.14.0            # Database
  firebase_storage: ^11.6.0           # File storage
  firebase_analytics: ^10.8.0         # Analytics
  firebase_messaging: ^14.7.0         # Push notifications
  firebase_crashlytics: ^3.4.0        # Crash reporting
  firebase_performance: ^0.9.3+0      # Performance monitoring
  firebase_remote_config: ^4.3.0      # Remote config
  firebase_dynamic_links: ^5.4.0      # Deep links
```

---

## 🔧 Troubleshooting Quick Fixes

### Firebase CLI not found
```bash
npm install -g firebase-tools
```

### FlutterFire CLI not found
```bash
dart pub global activate flutterfire_cli
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### Project ID already exists
```bash
# Firebase project IDs are globally unique (not just your account)
# Try a more unique ID:
firebase projects:create yourname-myapp-2024
firebase projects:create myapp-$(openssl rand -hex 3)
```

### iOS build fails
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

### Android build fails
```bash
# Check android/app/build.gradle has:
apply plugin: 'com.google.gms.google-services'

# Check android/build.gradle has:
classpath 'com.google.gms:google-services:4.4.0'
```

### Firebase not initialized error
```dart
// Ensure main.dart has:
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

### Regenerate firebase_options.dart
```bash
flutterfire configure --project=my-project
```

---

## 📱 Platform Requirements

### iOS
- Minimum version: iOS 12.0
- Update `ios/Podfile`: `platform :ios, '12.0'`
- Run `cd ios && pod install`

### Android
- Minimum SDK: 21
- Update `android/app/build.gradle`: `minSdkVersion 21`

### macOS
- Minimum version: macOS 10.14
- Run `cd macos && pod install`

### Web
- Modern browsers (Chrome, Firefox, Safari, Edge)
- No additional setup needed

---

## 🔐 Security Rules Templates

### Firestore (Development)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### Firestore (Production)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
  }
}
```

### Storage (Development)
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### Storage (Production)
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth.uid == userId;
    }
  }
}
```

---

## 🧪 Testing Setup

### Check Firebase Connection
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase connected successfully!');
  } catch (e) {
    print('❌ Firebase connection failed: $e');
  }
  
  runApp(const MyApp());
}
```

### Test Authentication
```dart
import 'package:firebase_auth/firebase_auth.dart';

// Anonymous sign-in (easiest test)
try {
  final credential = await FirebaseAuth.instance.signInAnonymously();
  print('✅ Signed in: ${credential.user?.uid}');
} catch (e) {
  print('❌ Auth failed: $e');
}
```

### Test Firestore
```dart
import 'package:cloud_firestore/cloud_firestore.dart';

// Write test
try {
  await FirebaseFirestore.instance.collection('test').add({
    'message': 'Hello Firebase!',
    'timestamp': FieldValue.serverTimestamp(),
  });
  print('✅ Firestore write successful');
} catch (e) {
  print('❌ Firestore failed: $e');
}
```

---

## 🔗 Useful Links

- **Firebase Console**: https://console.firebase.google.com
- **FlutterFire Docs**: https://firebase.flutter.dev
- **Firebase CLI Docs**: https://firebase.google.com/docs/cli
- **FlutterFire GitHub**: https://github.com/firebase/flutterfire
- **Full Setup Guide**: [README.md](./README.md)

---

## 💡 Pro Tips

1. **Use Firebase Local Emulator Suite** for development to avoid costs
2. **Set up separate projects** for dev, staging, and production
3. **Enable Analytics** from the start for better insights
4. **Start with restrictive security rules**, then open up as needed
5. **Use Firebase Extensions** for common functionality (Stripe, Algolia, etc.)
6. **Monitor usage** in Firebase Console to avoid surprise bills
7. **Enable App Check** for production apps to prevent abuse

---

**Last Updated**: 2026-02-03
