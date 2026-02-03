#!/bin/bash

# scaffold-flutter-project.sh
# Creates a clean Flutter project structure following portfolio architecture patterns.
# Usage: ./scaffold-flutter-project.sh <project_name>
#
# Reference: flutter-portfolio/shared/architecture_patterns.md

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Validate arguments
if [ $# -eq 0 ]; then
    print_error "Project name is required"
    echo "Usage: ./scaffold-flutter-project.sh <project_name>"
    echo "Example: ./scaffold-flutter-project.sh my_awesome_app"
    exit 1
fi

PROJECT_NAME=$1
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$(pwd)"

print_header "Flutter Architecture Scaffold"
print_info "Project name: ${PROJECT_NAME}"
print_info "Target directory: ${TARGET_DIR}"
print_info "Architecture: flutter-portfolio patterns"

# Validate Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

# Check if project already exists
if [ -d "${PROJECT_NAME}" ]; then
    print_warning "Directory '${PROJECT_NAME}' already exists"
    read -p "Continue and modify existing project? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Cancelled"
        exit 0
    fi
    cd "${PROJECT_NAME}"
else
    print_info "Creating Flutter project..."
    flutter create "${PROJECT_NAME}" --org com.example --platforms=ios,android,web
    cd "${PROJECT_NAME}"
    print_success "Flutter project created"
fi

# Create lib folder structure
print_header "Creating Folder Structure"

print_info "Creating lib/app/ structure..."
mkdir -p lib/app/providers
mkdir -p lib/app/routing
print_success "lib/app/ created"

print_info "Creating lib/core/ structure..."
mkdir -p lib/core/services
mkdir -p lib/core/utils
mkdir -p lib/core/config
mkdir -p lib/core/models
print_success "lib/core/ created"

print_info "Creating lib/features/ structure..."
mkdir -p lib/features
print_success "lib/features/ created (features added separately)"

print_info "Creating lib/shared_widgets/ structure..."
mkdir -p lib/shared_widgets
print_success "lib/shared_widgets/ created"

# Create example feature structure
print_info "Creating example 'home' feature structure..."
mkdir -p lib/features/home/view
mkdir -p lib/features/home/state
mkdir -p lib/features/home/repo
mkdir -p lib/features/home/models
mkdir -p lib/features/home/widgets
mkdir -p lib/features/home/tests
print_success "Example feature 'home' created"

# Create core service templates
print_header "Creating Core Service Templates"

# Firebase Auth Service
cat > lib/core/services/firebase_auth_service.dart << 'EOF'
import 'package:firebase_auth/firebase_auth.dart';

/// Thin wrapper around Firebase Authentication.
class FirebaseAuthService {
  FirebaseAuthService._(); // Private constructor

  static FirebaseAuth get auth => FirebaseAuth.instance;
  static User? get currentUser => auth.currentUser;
  static Stream<User?> get authStateChanges => auth.authStateChanges();

  /// Force reload current user from backend
  static Future<void> reloadUser() async {
    final user = currentUser;
    if (user != null) await user.reload();
  }

  /// Sign in with email and password
  static Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Sign up with email and password
  static Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out
  static Future<void> signOut() async {
    await auth.signOut();
  }
}
EOF
print_success "Created firebase_auth_service.dart"

# Firestore Service
cat > lib/core/services/firestore_service.dart << 'EOF'
import 'package:cloud_firestore/cloud_firestore.dart';

/// Thin wrapper around Cloud Firestore.
class FirestoreService {
  FirestoreService._(); // Private constructor

  static FirebaseFirestore get db => FirebaseFirestore.instance;

  /// Get a collection reference
  static CollectionReference<Map<String, dynamic>> collection(String path) {
    return db.collection(path);
  }

  /// Get a document reference
  static DocumentReference<Map<String, dynamic>> doc(String path) {
    return db.doc(path);
  }

  /// Batch write operations
  static WriteBatch batch() {
    return db.batch();
  }

  /// Run a transaction
  static Future<T> runTransaction<T>(
    TransactionHandler<T> transactionHandler, {
    Duration timeout = const Duration(seconds: 30),
  }) {
    return db.runTransaction(transactionHandler, timeout: timeout);
  }
}
EOF
print_success "Created firestore_service.dart"

# Firebase Storage Service
cat > lib/core/services/firebase_storage_service.dart << 'EOF'
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

/// Thin wrapper around Firebase Storage.
class FirebaseStorageService {
  FirebaseStorageService._(); // Private constructor

  static FirebaseStorage get storage => FirebaseStorage.instance;

  /// Get a reference to a storage path
  static Reference ref(String path) {
    return storage.ref(path);
  }

  /// Upload a file
  static Future<String> uploadFile({
    required String path,
    required File file,
    Map<String, String>? metadata,
  }) async {
    final ref = storage.ref(path);
    final uploadTask = await ref.putFile(
      file,
      metadata != null ? SettableMetadata(customMetadata: metadata) : null,
    );
    return await uploadTask.ref.getDownloadURL();
  }

  /// Delete a file
  static Future<void> deleteFile(String path) async {
    await storage.ref(path).delete();
  }

  /// Get download URL
  static Future<String> getDownloadURL(String path) async {
    return await storage.ref(path).getDownloadURL();
  }
}
EOF
print_success "Created firebase_storage_service.dart"

# Firebase Analytics Service
cat > lib/core/services/analytics_service.dart << 'EOF'
import 'package:firebase_analytics/firebase_analytics.dart';

/// Thin wrapper around Firebase Analytics.
class AnalyticsService {
  AnalyticsService._(); // Private constructor

  static FirebaseAnalytics get analytics => FirebaseAnalytics.instance;

  /// Log an event
  static Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  }) async {
    await analytics.logEvent(name: name, parameters: parameters);
  }

  /// Set user property
  static Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await analytics.setUserProperty(name: name, value: value);
  }

  /// Set user ID
  static Future<void> setUserId(String? id) async {
    await analytics.setUserId(id: id);
  }

  /// Log screen view
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }
}
EOF
print_success "Created analytics_service.dart"

# Preferences Service (SharedPreferences for simple app preferences)
cat > lib/core/services/preferences_service.dart << 'EOF'
import 'package:shared_preferences/shared_preferences.dart';

/// Service for simple app preferences using SharedPreferences.
/// Use HiveService for complex data persistence.
class PreferencesService {
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  // String preferences
  Future<String?> getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  Future<void> setString(String key, String value) async {
    final prefs = await _prefs;
    await prefs.setString(key, value);
  }

  // Boolean preferences
  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final prefs = await _prefs;
    return prefs.getBool(key) ?? defaultValue;
  }

  Future<void> setBool(String key, bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(key, value);
  }

  // Integer preferences
  Future<int> getInt(String key, {int defaultValue = 0}) async {
    final prefs = await _prefs;
    return prefs.getInt(key) ?? defaultValue;
  }

  Future<void> setInt(String key, int value) async {
    final prefs = await _prefs;
    await prefs.setInt(key, value);
  }

  // Double preferences
  Future<double> getDouble(String key, {double defaultValue = 0.0}) async {
    final prefs = await _prefs;
    return prefs.getDouble(key) ?? defaultValue;
  }

  Future<void> setDouble(String key, double value) async {
    final prefs = await _prefs;
    await prefs.setDouble(key, value);
  }

  // List of strings
  Future<List<String>> getStringList(String key) async {
    final prefs = await _prefs;
    return prefs.getStringList(key) ?? [];
  }

  Future<void> setStringList(String key, List<String> value) async {
    final prefs = await _prefs;
    await prefs.setStringList(key, value);
  }

  // Remove and clear
  Future<void> remove(String key) async {
    final prefs = await _prefs;
    await prefs.remove(key);
  }

  Future<void> clear() async {
    final prefs = await _prefs;
    await prefs.clear();
  }

  // Check if key exists
  Future<bool> containsKey(String key) async {
    final prefs = await _prefs;
    return prefs.containsKey(key);
  }
}
EOF
print_success "Created preferences_service.dart"

# Hive Service (for local data persistence)
cat > lib/core/services/hive_service.dart << 'EOF'
import 'package:hive_flutter/hive_flutter.dart';

/// Service for local data persistence using Hive.
/// Use PreferencesService for simple app preferences.
class HiveService {
  HiveService._(); // Private constructor

  static bool _initialized = false;

  /// Initialize Hive (call once in main.dart before using)
  static Future<void> initialize() async {
    if (_initialized) return;
    await Hive.initFlutter();
    _initialized = true;
  }

  /// Open a box
  static Future<Box<T>> openBox<T>(String name) async {
    if (!_initialized) {
      throw StateError('HiveService not initialized. Call HiveService.initialize() first.');
    }
    return await Hive.openBox<T>(name);
  }

  /// Get an already opened box
  static Box<T> getBox<T>(String name) {
    return Hive.box<T>(name);
  }

  /// Check if a box is open
  static bool isBoxOpen(String name) {
    return Hive.isBoxOpen(name);
  }

  /// Close a box
  static Future<void> closeBox(String name) async {
    if (isBoxOpen(name)) {
      await Hive.box(name).close();
    }
  }

  /// Delete a box from disk
  static Future<void> deleteBox(String name) async {
    if (isBoxOpen(name)) {
      await Hive.box(name).deleteFromDisk();
    } else {
      await Hive.deleteBoxFromDisk(name);
    }
  }

  /// Close all boxes
  static Future<void> closeAll() async {
    await Hive.close();
  }

  /// Register a type adapter
  static void registerAdapter<T>(TypeAdapter<T> adapter, {int? typeId}) {
    if (!Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter(adapter);
    }
  }
}
EOF
print_success "Created hive_service.dart"

# HTTP Service
cat > lib/core/services/http_service.dart << 'EOF'
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Thin wrapper around HTTP client for backend API calls.
class HttpService {
  final String baseUrl;

  HttpService({this.baseUrl = 'http://localhost:5000'});

  Uri _buildUri(String path) {
    return Uri.parse(path.startsWith('http') ? path : '$baseUrl$path');
  }

  Future<Map<String, dynamic>> post(
      String path, Map<String, dynamic> body) async {
    final uri = _buildUri(path);
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (_) {
          return {'ok': true};
        }
      }

      return {
        'error': true,
        'status': response.statusCode,
        'body': response.body,
      };
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> get(String path) async {
    final uri = _buildUri(path);
    try {
      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (_) {
          return {'ok': true};
        }
      }

      return {
        'error': true,
        'status': response.statusCode,
        'body': response.body,
      };
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }
}
EOF
print_success "Created http_service.dart"

# App Theme
cat > lib/core/utils/app_theme.dart << 'EOF'
import 'package:flutter/material.dart';

/// Application theme configuration.
class AppTheme {
  AppTheme._(); // Private constructor

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
    );
  }
}
EOF
print_success "Created app_theme.dart"

# Create example repository
print_header "Creating Example Repository"

cat > lib/features/home/repo/home_repository.dart << 'EOF'
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/services/hive_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/services/firebase_auth_service.dart';

/// Example repository demonstrating data orchestration.
/// Repositories abstract data sources (local vs remote) and handle caching.
class HomeRepository {
  static const String _boxName = 'home_data';
  Box<Map>? _box;

  /// Initialize the repository (open Hive box)
  Future<void> init() async {
    if (!HiveService.isBoxOpen(_boxName)) {
      _box = await HiveService.openBox<Map>(_boxName);
    } else {
      _box = HiveService.getBox<Map>(_boxName);
    }
  }

  /// Example: Fetch data from local cache (Hive)
  Future<Map<String, dynamic>?> fetchLocalData(String key) async {
    if (_box == null) await init();
    final data = _box!.get(key);
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  /// Example: Save data to local cache (Hive)
  Future<void> saveLocalData(String key, Map<String, dynamic> data) async {
    if (_box == null) await init();
    await _box!.put(key, data);
  }

  /// Example: Fetch data from Firestore (if authenticated)
  Future<Map<String, dynamic>?> fetchRemoteData(String docId) async {
    final user = FirebaseAuthService.currentUser;
    if (user == null) return null;

    final doc = await FirestoreService.collection('home_data')
        .doc(docId)
        .get();

    return doc.exists ? doc.data() : null;
  }

  /// Example: Save data to Firestore (if authenticated)
  Future<void> saveRemoteData(String docId, Map<String, dynamic> data) async {
    final user = FirebaseAuthService.currentUser;
    if (user == null) return;

    await FirestoreService.collection('home_data')
        .doc(docId)
        .set(data);
  }

  /// Example: Sync local and remote data
  Future<Map<String, dynamic>?> fetchData(String key) async {
    // Try local first
    final localData = await fetchLocalData(key);
    if (localData != null) return localData;

    // Fallback to remote if authenticated
    final remoteData = await fetchRemoteData(key);
    if (remoteData != null) {
      // Cache it locally
      await saveLocalData(key, remoteData);
    }

    return remoteData;
  }
}
EOF
print_success "Created home_repository.dart"

# Create example provider
print_header "Creating Example Provider"

cat > lib/features/home/state/home_provider.dart << 'EOF'
import 'package:flutter/foundation.dart';
import '../repo/home_repository.dart';

/// Example provider demonstrating state management with repository injection.
class HomeProvider extends ChangeNotifier {
  final HomeRepository _repo;
  bool isLoading = false;
  Map<String, dynamic>? data;

  HomeProvider(this._repo);

  Future<void> loadData({String key = 'default'}) async {
    isLoading = true;
    notifyListeners();

    data = await _repo.fetchData(key);

    isLoading = false;
    notifyListeners();
  }

  Future<void> saveData(Map<String, dynamic> newData, {String key = 'default'}) async {
    await _repo.saveLocalData(key, newData);
    data = newData;
    notifyListeners();
  }
}
EOF
print_success "Created home_provider.dart"

# Create example view
print_header "Creating Example View"

cat > lib/features/home/view/home_screen.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/home_provider.dart';

/// Example screen demonstrating view layer.
/// Views call providers, never services directly.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Data: ${provider.data?.toString() ?? "No data"}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => provider.loadData(),
                    child: const Text('Load Data'),
                  ),
                ],
              ),
            ),
    );
  }
}
EOF
print_success "Created home_screen.dart"

# Create shared widget example
cat > lib/shared_widgets/custom_button.dart << 'EOF'
import 'package:flutter/material.dart';

/// Example shared widget that can be reused across features.
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
EOF
print_success "Created custom_button.dart"

# Update main.dart
print_header "Updating main.dart"

cat > lib/main.dart << EOF
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/utils/app_theme.dart';
import 'core/services/hive_service.dart';
import 'features/home/repo/home_repository.dart';
import 'features/home/state/home_provider.dart';
import 'features/home/view/home_screen.dart';

// TODO: Uncomment when Firebase is configured
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local data persistence
  await HiveService.initialize();
  
  // TODO: Initialize Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set up dependency injection
    final homeRepo = HomeRepository();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeProvider(homeRepo),
        ),
        // Add more providers here
      ],
      child: MaterialApp(
        title: '${PROJECT_NAME}',
        theme: AppTheme.theme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
EOF
print_success "Updated main.dart with Hive and provider setup"

# Update pubspec.yaml with required dependencies
print_header "Updating pubspec.yaml"

# Backup original pubspec
cp pubspec.yaml pubspec.yaml.backup

# Add dependencies using yq or sed
cat > pubspec_additions.yaml << 'EOF'

  # State management
  provider: ^6.1.0
  
  # Firebase services (uncomment when configured)
  # firebase_core: ^2.24.0
  # firebase_auth: ^4.16.0
  # cloud_firestore: ^4.14.0
  # firebase_storage: ^11.6.0
  # firebase_analytics: ^10.8.0
  
  # HTTP client
  http: ^1.1.0
  
  # Local data persistence (Hive)
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Simple app preferences (SharedPreferences)
  shared_preferences: ^2.2.0
  
  # Utilities
  intl: ^0.18.0
EOF

print_info "Adding dependencies to pubspec.yaml..."
# Use awk to insert dependencies before dev_dependencies
awk '
    /^dev_dependencies:/ {
        # Read and print the additions file
        while ((getline line < "pubspec_additions.yaml") > 0) {
            print line
        }
        close("pubspec_additions.yaml")
    }
    { print }
' pubspec.yaml > pubspec.yaml.tmp
mv pubspec.yaml.tmp pubspec.yaml
rm pubspec_additions.yaml
print_success "Dependencies added"

# Create README for the project
print_header "Creating Project Documentation"

cat > lib/README.md << EOF
# ${PROJECT_NAME} Architecture

This project follows the Flutter portfolio architecture patterns.

## Structure

\`\`\`
lib/
├── app/                    # App bootstrap, routing, global providers
│   ├── providers/          # Global app-level providers
│   └── routing/            # Route configuration
├── core/                   # Shared infrastructure
│   ├── services/           # Thin service adapters (Firebase, HTTP, Storage)
│   ├── utils/              # Helper functions, formatters, theme
│   ├── config/             # App configuration, constants
│   └── models/             # Shared domain models
├── features/               # Feature modules
│   └── <feature_name>/
│       ├── view/           # Screens and pages (UI)
│       ├── state/          # Providers/controllers (state management)
│       ├── repo/           # Repositories (data orchestration)
│       ├── models/         # Feature-specific models
│       ├── widgets/        # Feature-specific widgets
│       └── tests/          # Feature tests
└── shared_widgets/         # Reusable UI components

\`\`\`

## Architecture Layers

### Layer 1: View (\`/view\`)
- **Purpose**: Render UI, capture user events
- **Rules**: 
  - Call providers/controllers only
  - No direct service calls
  - No business logic
- **Example**: \`home_screen.dart\`

### Layer 2: State (\`/state\`)
- **Purpose**: Observable state, coordinate workflows
- **Rules**:
  - Inject repositories (not services)
  - Delegate I/O to repositories
  - Keep thin and testable
- **Example**: \`home_provider.dart\`

### Layer 3: Repository (\`/repo\`)
- **Purpose**: Data orchestration, caching, sync
- **Rules**:
  - Abstract data sources (local vs remote)
  - Inject services
  - Handle offline/online logic
- **Example**: \`home_repository.dart\`

### Layer 4: Services (\`lib/core/services/\`)
- **Purpose**: Thin adapters to external systems
- **Rules**:
  - Single responsibility
  - <120 lines each
  - No business logic
- **Examples**: \`firebase_service.dart\`, \`http_service.dart\`

## Data Flow

\`\`\`
User Interaction
    ↓
View (calls provider)
    ↓
Provider/State (calls repository)
    ↓
Repository (calls services)
    ↓
Services (external systems)
\`\`\`

## Adding a New Feature

\`\`\`bash
# Create feature structure
mkdir -p lib/features/<feature_name>/{view,state,repo,models,widgets,tests}

# Create files
touch lib/features/<feature_name>/repo/<feature>_repository.dart
touch lib/features/<feature_name>/state/<feature>_provider.dart
touch lib/features/<feature_name>/view/<feature>_screen.dart
\`\`\`

## Testing

\`\`\`bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze
\`\`\`

## References

- Architecture patterns: \`flutter-portfolio/shared/architecture_patterns.md\`
- Folder structure: \`flutter-portfolio/shared/project_folder_structure.md\`
- Testing strategies: \`flutter-portfolio/shared/testing_strategies.md\`
EOF
print_success "Created lib/README.md"

# Create architecture compliance checklist
cat > ARCHITECTURE_CHECKLIST.md << 'EOF'
# Architecture Compliance Checklist

Use this checklist to ensure your code follows portfolio architecture patterns.

## ✅ Core Principles

- [ ] Views only call providers (no direct service calls)
- [ ] Providers inject repositories
- [ ] Repositories orchestrate services
- [ ] Services are thin adapters (<120 lines)
- [ ] No god objects (services/repos >300 lines)

## ✅ Dependency Flow

- [ ] View → State (Provider)
- [ ] State → Repository
- [ ] Repository → Service
- [ ] Service → External System

## ✅ File Organization

- [ ] Feature code in `lib/features/<feature>/`
- [ ] Services in `lib/core/services/`
- [ ] Shared widgets in `lib/shared_widgets/`
- [ ] Each feature has `/view`, `/state`, `/repo` as needed

## ✅ Code Quality

- [ ] All views extend `StatelessWidget` or `StatefulWidget`
- [ ] Providers use `ChangeNotifier` or similar
- [ ] Repositories have injected dependencies
- [ ] Services have clear single responsibility

## ✅ Testing

- [ ] Unit tests for repositories (mock services)
- [ ] Unit tests for providers (mock repos)
- [ ] Widget tests for critical screens
- [ ] Tests can use dependency injection/mocks

## ✅ Common Violations to Avoid

- [ ] ❌ No `FirebaseFirestore.instance` in views
- [ ] ❌ No `http.post()` in views
- [ ] ❌ No business logic in widgets
- [ ] ❌ No direct SharedPreferences in views
- [ ] ❌ No instantiating services directly (`new Service()`)

## Search for Violations

```bash
# Find direct Firebase calls in views
grep -r "FirebaseFirestore.instance" lib/features/*/view/

# Find direct HTTP calls in views
grep -r "http\." lib/features/*/view/

# Find large files (potential god objects)
find lib -name "*.dart" -exec wc -l {} + | sort -rn | head -20
```

## Validation Commands

```bash
# Lint
flutter analyze

# Test
flutter test

# Format
dart format lib/

# Check coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```
EOF
print_success "Created ARCHITECTURE_CHECKLIST.md"

# Install dependencies
print_header "Installing Dependencies"
flutter pub get
print_success "Dependencies installed"

# Format code
print_info "Formatting code..."
dart format lib/
print_success "Code formatted"

# Run analysis
print_info "Running static analysis..."
flutter analyze

# Final summary
print_header "✨ Project Scaffold Complete!"

cat << EOF

${GREEN}Project '${PROJECT_NAME}' is ready!${NC}

${BLUE}Structure created:${NC}
  ✓ lib/app/               - App bootstrap
  ✓ lib/core/services/     - Firebase, HTTP, LocalStorage services
  ✓ lib/core/utils/        - App theme
  ✓ lib/features/home/     - Example feature (view/state/repo)
  ✓ lib/shared_widgets/    - Reusable widgets
  ✓ Example provider setup in main.dart

${BLUE}Documentation:${NC}
  ✓ lib/README.md                 - Architecture overview
  ✓ ARCHITECTURE_CHECKLIST.md     - Compliance checklist

${BLUE}Next steps:${NC}
  1. cd ${PROJECT_NAME}
  2. flutter run
  3. Start building features in lib/features/

${BLUE}Add a new feature:${NC}
  mkdir -p lib/features/<name>/{view,state,repo,models,widgets,tests}

${BLUE}Reference:${NC}
  - Architecture: flutter-portfolio/shared/architecture_patterns.md
  - Folder structure: flutter-portfolio/shared/project_folder_structure.md

${GREEN}Happy coding! 🚀${NC}

EOF
