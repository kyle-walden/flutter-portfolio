# Firebase Setup Patterns for Flutter Projects

Complete guide and automation for setting up Firebase in Flutter projects, from CLI installation to service configuration.

## 📋 Table of Contents

- [Quick Start](#quick-start)
- [Prerequisites](#prerequisites)
- [Manual Setup Guide](#manual-setup-guide)
- [Automated Setup Script](#automated-setup-script)
- [Service Configuration](#service-configuration)
- [Testing Firebase Integration](#testing-firebase-integration)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

---

## 🚀 Quick Start

**Automated Setup** (Recommended):
```bash
# From your Flutter project root
/path/to/flutter-portfolio/shared/firebase_setup_patterns/setup-firebase.sh

# If it gets stuck on ℹ️  Running: flutterfire configure --project=mobmeb-kw --platforms=ios,android,web,macos --yes, just run again:
`Running: flutterfire configure --project=mobmeb-kw --platforms=ios,android,web,macos --yes`

# Or if you have shell aliases installed:
firebase-setup
```

This will:
1. ✅ Check/install Firebase CLI
2. ✅ Check/install FlutterFire CLI
3. ✅ Login to Firebase
4. ✅ Create/select Firebase project
5. ✅ Configure Flutter app for all platforms
6. ✅ Add Firebase packages to pubspec.yaml
7. ✅ Generate firebase_options.dart
8. ✅ Update main.dart with Firebase initialization

---

## 📦 Prerequisites

### Required Tools

1. **Flutter SDK** (3.0.0 or higher)
   ```bash
   flutter --version
   ```

2. **Node.js & npm** (for Firebase CLI)
   ```bash
   node --version  # Should be v16 or higher
   npm --version
   ```

3. **Google Account** with Firebase access

### Platform-Specific Requirements

- **iOS**: Xcode, CocoaPods
- **Android**: Android Studio, Java/Kotlin setup
- **Web**: Modern browser for testing

---

## 📖 Manual Setup Guide

### Step 1: Install Firebase CLI

```bash
# Install Firebase CLI globally
npm install -g firebase-tools

# Verify installation
firebase --version

# Login to Firebase
firebase login
```

**Alternative (if npm not available):**
```bash
# macOS
curl -sL https://firebase.tools | bash

# Or use Homebrew
brew install firebase-cli
```

### Step 2: Install FlutterFire CLI

```bash
# Activate FlutterFire CLI
dart pub global activate flutterfire_cli

# Verify installation
flutterfire --version

# Ensure Dart global bin is in PATH
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

Add to `~/.zshrc` or `~/.bashrc`:
```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### Step 3: Create Firebase Project

**⚠️ Important: Project IDs are Globally Unique**

Firebase project IDs must be unique across **ALL Firebase users worldwide**, not just your account. This means:
- ❌ Common names like `my-app`, `test`, `portfolio` are likely taken
- ✅ Use specific names: `yourname-appname`, `company-product-2024`
- ✅ Add unique suffixes: `-prod`, `-2024`, random string


**Recommended naming patterns:**
```
<username>-<appname>           # kyle-portfolio-site
<company>-<product>-<env>      # acme-crm-prod
<appname>-<random>             # myapp-x7k9m3
<domain-reversed>              # com-example-myapp
```

**Option A: Via Firebase Console** (Web UI - Recommended for beginners)
1. Go to https://console.firebase.google.com
2. Click "Add project"
3. Enter project name (e.g., `yourname-flutter-app`)
4. Project ID will auto-generate (you can edit it if available)
5. Enable/disable Google Analytics (recommended: enable)
6. Select Analytics account or create new
7. Click "Create project"

**Option B: Via CLI**
```bash
# List existing projects
firebase projects:list

# Create new project with unique ID
firebase projects:create yourname-myapp-2024

# If ID is taken, try with suffix
firebase projects:create yourname-myapp-$(date +%Y%m%d)

# Set as current project
firebase use yourname-myapp-2024
```

**💡 Pro Tip:** If you get "project with ID already exists" error, the ID is taken globally (not just in your account). Try:
```bash
# Add year suffix
firebase projects:create myapp-2024

# Add your username
firebase projects:create $(whoami)-myapp

# Add random string
firebase projects:create myapp-$(openssl rand -hex 3)
```

# Create new project (if needed)
firebase projects:create my-flutter-app

# Set as current project
firebase use my-flutter-app
```

### Step 4: Configure Flutter App

```bash
# Navigate to your Flutter project root
cd /path/to/your/flutter_project

# Configure Firebase for all platforms
flutterfire configure

# Follow prompts:
# - Select Firebase project
# - Select platforms (iOS, Android, macOS, Web)
# - Enter iOS bundle ID (e.g., com.example.myapp)
# - Enter Android package name (e.g., com.example.myapp)
```

**What this does:**
- Creates `firebase_options.dart` in `lib/`
- Configures iOS: `ios/Runner/GoogleService-Info.plist`
- Configures Android: `android/app/google-services.json`
- Configures Web: Updates `web/index.html`
- Configures macOS: `macos/Runner/GoogleService-Info.plist`

### Step 5: Add Firebase Packages

Edit `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter

  # Firebase Core (required for all Firebase services)
  firebase_core: ^2.24.0
  
  # Firebase services (add as needed)
  firebase_auth: ^4.16.0           # Authentication
  cloud_firestore: ^4.14.0         # Database
  firebase_storage: ^11.6.0        # File storage
  firebase_analytics: ^10.8.0      # Analytics
  firebase_messaging: ^14.7.0      # Push notifications
  firebase_crashlytics: ^3.4.0     # Crash reporting
  firebase_performance: ^0.9.3+0   # Performance monitoring
  firebase_remote_config: ^4.3.0   # Remote config
  firebase_dynamic_links: ^5.4.0   # Deep links
```

Then:
```bash
flutter pub get
```

### Step 6: Initialize Firebase in main.dart

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: const HomeScreen(),
    );
  }
}
```

### Step 7: Platform-Specific Configuration

#### iOS Setup

1. **Minimum iOS Version**: Update `ios/Podfile`:
   ```ruby
   platform :ios, '12.0'  # Firebase requires iOS 12+
   ```

2. **Install Pods**:
   ```bash
   cd ios
   pod install
   cd ..
   ```

3. **Verify GoogleService-Info.plist**:
   - Should be at `ios/Runner/GoogleService-Info.plist`
   - Added to Xcode project automatically by FlutterFire

#### Android Setup

1. **Minimum Android SDK**: Update `android/app/build.gradle`:
   ```gradle
   android {
       defaultConfig {
           minSdkVersion 21  // Firebase requires API 21+
       }
   }
   ```

2. **Add Google Services Plugin**: `android/build.gradle`:
   ```gradle
   buildscript {
       dependencies {
           classpath 'com.google.gms:google-services:4.4.0'
       }
   }
   ```

3. **Apply Plugin**: `android/app/build.gradle`:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

4. **Verify google-services.json**:
   - Should be at `android/app/google-services.json`
   - Added automatically by FlutterFire

#### Web Setup

1. **Update index.html**: `web/index.html`:
   ```html
   <body>
     <!-- Firebase configuration (added by FlutterFire) -->
     <script src="firebase-config.js"></script>
     
     <script src="main.dart.js" type="application/javascript"></script>
   </body>
   ```

2. FlutterFire automatically adds Firebase SDK scripts

#### macOS Setup

1. **Minimum macOS Version**: Update `macos/Runner.xcodeproj/project.pbxproj`:
   ```
   MACOSX_DEPLOYMENT_TARGET = 10.14;
   ```

2. **Install Pods**:
   ```bash
   cd macos
   pod install
   cd ..
   ```

---

## 🤖 Automated Setup Script

Use the provided `setup-firebase.sh` script:

```bash
# Make executable
chmod +x /path/to/flutter-portfolio/shared/firebase_setup_patterns/setup-firebase.sh

# Run from your Flutter project root
/path/to/flutter-portfolio/shared/firebase_setup_patterns/setup-firebase.sh
```

### Script Features

- ✅ Checks for Node.js/npm
- ✅ Installs Firebase CLI if missing
- ✅ Installs FlutterFire CLI if missing
- ✅ Handles Firebase login
- ✅ Interactive project creation/selection
- ✅ Configures all platforms
- ✅ Adds Firebase packages to pubspec.yaml
- ✅ Updates main.dart with initialization code
- ✅ Runs flutter pub get
- ✅ Platform-specific configuration checks

### Script Options

```bash
# Full interactive setup
./setup-firebase.sh

# Specify Firebase project ID
./setup-firebase.sh --project my-flutter-app

# Skip package installation (only configure)
./setup-firebase.sh --skip-packages

# Specify services to add
./setup-firebase.sh --services auth,firestore,storage,analytics

# Help
./setup-firebase.sh --help
```

---

## ⚙️ Service Configuration

### Firebase Authentication

**1. Enable Auth in Firebase Console:**
- Go to Firebase Console > Authentication
- Click "Get Started"
- Enable sign-in methods:
  - Email/Password
  - Google
  - Apple (for iOS)
  - Anonymous (for testing)

**2. Use in Flutter:**
```dart
import 'package:firebase_auth/firebase_auth.dart';

// Sign up
final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: "user@example.com",
  password: "password123",
);

// Sign in
final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: "user@example.com",
  password: "password123",
);

// Listen to auth state
FirebaseAuth.instance.authStateChanges().listen((User? user) {
  if (user == null) {
    print('User is signed out');
  } else {
    print('User is signed in: ${user.email}');
  }
});

// Sign out
await FirebaseAuth.instance.signOut();
```

**3. iOS-Specific (for Apple Sign In):**
- Enable "Sign in with Apple" capability in Xcode
- Add to `ios/Runner/Info.plist`:
  ```xml
  <key>CFBundleURLTypes</key>
  <array>
    <dict>
      <key>CFBundleURLSchemes</key>
      <array>
        <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
      </array>
    </dict>
  </array>
  ```

---

### Cloud Firestore

**1. Enable Firestore in Firebase Console:**
- Go to Firebase Console > Firestore Database
- Click "Create database"
- Select production mode or test mode
- Choose location (e.g., us-central1)

**2. Set Security Rules:**
```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated users to read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Public read, authenticated write
    match /public/{document=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

**3. Use in Flutter:**
```dart
import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;

// Create
await db.collection('users').doc(userId).set({
  'name': 'John Doe',
  'email': 'john@example.com',
  'createdAt': FieldValue.serverTimestamp(),
});

// Read
final snapshot = await db.collection('users').doc(userId).get();
final data = snapshot.data();

// Query
final query = await db.collection('users')
    .where('age', isGreaterThan: 18)
    .orderBy('name')
    .limit(10)
    .get();

// Real-time listener
db.collection('users').doc(userId).snapshots().listen((snapshot) {
  print('User data: ${snapshot.data()}');
});
```

---

### Firebase Storage

**1. Enable Storage in Firebase Console:**
- Go to Firebase Console > Storage
- Click "Get Started"
- Set security rules (start in test mode, then tighten)

**2. Set Security Rules:**
```javascript
// storage.rules
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // User-specific files
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Public files
    match /public/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

**3. Use in Flutter:**
```dart
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

final storage = FirebaseStorage.instance;

// Upload file
final file = File('/path/to/file.jpg');
final ref = storage.ref().child('users/$userId/avatar.jpg');
final uploadTask = ref.putFile(file);

// Monitor progress
uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
  final progress = snapshot.bytesTransferred / snapshot.totalBytes;
  print('Upload progress: ${(progress * 100).toFixed(2)}%');
});

// Get download URL
final downloadUrl = await ref.getDownloadURL();

// Download file
final downloadData = await ref.getData();
```

---

### Firebase Analytics

**1. Enable Analytics:**
- Enabled by default when you create Firebase project with Analytics
- No additional setup needed in console

**2. Use in Flutter:**
```dart
import 'package:firebase_analytics/firebase_analytics.dart';

final analytics = FirebaseAnalytics.instance;

// Log event
await analytics.logEvent(
  name: 'project_viewed',
  parameters: {
    'project_id': '123',
    'project_name': 'My Project',
    'category': 'web_development',
  },
);

// Log screen view
await analytics.logScreenView(
  screenName: 'PortfolioDetailScreen',
  screenClass: 'PortfolioDetailScreen',
);

// Set user properties
await analytics.setUserId(id: userId);
await analytics.setUserProperty(
  name: 'user_type',
  value: 'premium',
);
```

**3. Debug Analytics (Development):**
```bash
# iOS
adb shell setprop debug.firebase.analytics.app <package_name>

# Android
adb shell setprop debug.firebase.analytics.app <package_name>
```

---

## 🧪 Testing Firebase Integration

### Test Authentication
```bash
# Run app
flutter run

# Try sign up/sign in flows
# Check Firebase Console > Authentication > Users
```

### Test Firestore
```bash
# Run app with Firestore operations
flutter run

# Check Firebase Console > Firestore Database > Data
# Monitor real-time updates
```

### Test Storage
```bash
# Upload a file from your app
flutter run

# Check Firebase Console > Storage > Files
# Verify file appears
```

### Test Analytics
```bash
# Enable debug mode
flutter run --dart-define=FIREBASE_ANALYTICS_DEBUG=true

# Check Firebase Console > Analytics > DebugView
# Events should appear within seconds
```

---

## 🐛 Troubleshooting

### Firebase CLI Issues

**Problem**: `firebase: command not found`
```bash
# Reinstall
npm install -g firebase-tools

# Or check PATH
echo $PATH
export PATH="$PATH:/usr/local/bin"
```

**Problem**: Firebase login fails
```bash
# Clear cache and re-login
firebase logout
firebase login --reauth
```

**Problem**: "Project with ID already exists" when creating project
```bash
# Firebase project IDs are globally unique across ALL users (not just your account)
# Solution: Use a more unique project ID

# Try with year suffix
firebase projects:create myapp-2024

# Try with your username
firebase projects:create $(whoami)-myapp

# Try with random suffix
firebase projects:create myapp-$(openssl rand -hex 3)

# Or use reversed domain name (if you own a domain)
firebase projects:create com-yourdomain-myapp
```

**💡 Best Practice:** Always use descriptive, unique project IDs like:
- `yourname-appname-env` (e.g., `kyle-portfolio-prod`)
- `company-product-year` (e.g., `acme-crm-2024`)
- `domain-reversed` (e.g., `com-example-myapp`)

---

### FlutterFire CLI Issues

**Problem**: `flutterfire: command not found`
```bash
# Check Dart global packages
dart pub global list

# Reactivate
dart pub global activate flutterfire_cli

# Add to PATH
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

**Problem**: FlutterFire configuration fails
```bash
# Check Flutter project structure
ls -la  # Should see pubspec.yaml

# Check Firebase project access
firebase projects:list

# Re-run with verbose output
flutterfire configure --verbose
```

---

### iOS Build Issues

**Problem**: `GoogleService-Info.plist not found`
```bash
# Re-run FlutterFire configure
flutterfire configure --platforms=ios

# Verify file exists
ls ios/Runner/GoogleService-Info.plist

# Clean and rebuild
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

**Problem**: Minimum iOS version error
```ruby
# Update ios/Podfile
platform :ios, '12.0'

# Reinstall pods
cd ios
rm Podfile.lock
pod install
cd ..
```

---

### Android Build Issues

**Problem**: `google-services.json not found`
```bash
# Re-run FlutterFire configure
flutterfire configure --platforms=android

# Verify file exists
ls android/app/google-services.json
```

**Problem**: Google Services plugin error
```gradle
// Check android/app/build.gradle has:
apply plugin: 'com.google.gms.google-services'

// Check android/build.gradle has:
classpath 'com.google.gms:google-services:4.4.0'
```

**Problem**: Minimum SDK version error
```gradle
// Update android/app/build.gradle
android {
    defaultConfig {
        minSdkVersion 21  // Firebase requires 21+
    }
}
```

---

### Runtime Issues

**Problem**: `Firebase not initialized`
```dart
// Ensure this is in main() BEFORE runApp()
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

**Problem**: `DefaultFirebaseOptions not found`
```bash
# Regenerate firebase_options.dart
flutterfire configure

# Verify file exists
ls lib/firebase_options.dart
```

**Problem**: Platform-specific config missing
```bash
# Reconfigure for specific platform
flutterfire configure --platforms=ios,android,web,macos

# Check each platform's config file exists
```

---

## ✅ Best Practices

### 1. Security Rules

**Start restrictive, not permissive:**
```javascript
// ❌ Bad (allows anyone to read/write everything)
allow read, write: if true;

// ✅ Good (authenticated users only)
allow read, write: if request.auth != null;

// ✅ Better (user-specific access)
allow read, write: if request.auth.uid == userId;
```

### 2. Environment Management

**Use different Firebase projects for dev/staging/prod:**
```bash
# Development
flutterfire configure --project my-app-dev

# Production
flutterfire configure --project my-app-prod
```

**Use flavors/build variants:**
```yaml
# pubspec.yaml
flutter:
  assets:
    - lib/firebase_options_dev.dart
    - lib/firebase_options_prod.dart
```

### 3. Error Handling

**Always handle Firebase errors:**
```dart
try {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
} on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
    print('No user found for that email.');
  } else if (e.code == 'wrong-password') {
    print('Wrong password provided.');
  }
} catch (e) {
  print('Error: $e');
}
```

### 4. Offline Persistence

**Enable offline caching:**
```dart
// Firestore persistence (enabled by default on mobile)
FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: true,
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
);
```

### 5. Analytics Privacy

**Respect user privacy:**
```dart
// Allow users to opt-out
await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(userConsent);
```

### 6. Cost Management

**Use Firebase Local Emulator Suite for development:**
```bash
# Install emulators
firebase init emulators

# Start emulators
firebase emulators:start

# Connect Flutter app to emulators
FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
```

---

## 📚 Additional Resources

- **Firebase Console**: https://console.firebase.google.com
- **FlutterFire Documentation**: https://firebase.flutter.dev
- **Firebase CLI Reference**: https://firebase.google.com/docs/cli
- **FlutterFire GitHub**: https://github.com/firebase/flutterfire
- **Firebase YouTube Channel**: https://www.youtube.com/firebase

---

## 🔗 Related Files

- `setup-firebase.sh` - Automated setup script
- `../architecture_patterns.md` - Service layer patterns
- `../SCAFFOLD_USAGE.md` - Project scaffolding
- `../shell-aliases.sh` - Convenience commands

---

**Last Updated**: 2026-02-03  
**Maintained by**: Flutter Portfolio Architecture Team
