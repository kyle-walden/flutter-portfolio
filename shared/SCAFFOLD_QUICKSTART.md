# Flutter Architecture Scaffold - Quick Reference

## One-Line Usage

```bash
bash /path/to/flutter-portfolio/shared/scaffold-flutter-project.sh my_app
```

## What Gets Created

```
my_app/
├── lib/
│   ├── app/providers/              # Global state
│   ├── core/
│   │   ├── services/               # Firebase, HTTP, LocalStorage (3 files)
│   │   ├── utils/                  # AppTheme
│   │   ├── config/                 # Constants
│   │   └── models/                 # Shared models
│   ├── features/home/              # Example feature
│   │   ├── view/                   # home_screen.dart
│   │   ├── state/                  # home_provider.dart
│   │   ├── repo/                   # home_repository.dart
│   │   ├── models/                 # Feature models
│   │   ├── widgets/                # Feature widgets
│   │   └── tests/                  # Tests
│   └── shared_widgets/             # custom_button.dart
├── lib/README.md                   # Architecture guide
├── ARCHITECTURE_CHECKLIST.md       # Compliance checklist
└── pubspec.yaml                    # With provider, http, etc.
```

## Architecture Pattern Enforced

```
View (UI) → Provider (State) → Repository (Data) → Service (I/O)
```

## Key Files Generated

| File | Purpose | Lines |
|------|---------|-------|
| `core/services/firebase_service.dart` | Firebase wrapper | ~25 |
| `core/services/local_storage_service.dart` | SharedPreferences | ~90 |
| `core/services/http_service.dart` | HTTP client | ~110 |
| `core/utils/app_theme.dart` | Material theme | ~30 |
| `features/home/repo/home_repository.dart` | Example repo | ~20 |
| `features/home/state/home_provider.dart` | Example provider | ~25 |
| `features/home/view/home_screen.dart` | Example screen | ~30 |

## Added Dependencies

```yaml
provider: ^6.1.0              # State management
http: ^1.1.0                  # HTTP client  
shared_preferences: ^2.2.0    # Local storage
intl: ^0.18.0                 # Date/number formatting

# Commented out (uncomment as needed):
# firebase_core, firebase_auth, cloud_firestore
```

## Common Commands After Scaffold

```bash
cd my_app

# Run the app
flutter run

# Run tests
flutter test

# Check compliance
grep -r "FirebaseFirestore.instance" lib/features/*/view/  # Should be empty
flutter analyze

# Add a feature
mkdir -p lib/features/booking/{view,state,repo,models,widgets,tests}
```

## Architecture Rules

### ✅ DO
- Views call providers only
- Providers inject repositories
- Repositories inject services  
- Services are thin (<120 lines)
- Use `ConsumerWidget` or `StatefulWidget`

### ❌ DON'T
- No `FirebaseFirestore.instance` in views
- No `http.post()` in views
- No business logic in widgets
- No direct service instantiation
- No god objects (>300 lines)

## Validation Checklist

```bash
# No violations in views
grep -r "FirebaseFirestore" lib/features/*/view/
grep -r "http\." lib/features/*/view/
grep -r "SharedPreferences" lib/features/*/view/

# All tests pass
flutter test

# No lint errors
flutter analyze

# Code formatted
dart format lib/
```

## Example: Add Authentication Feature

```bash
# 1. Create structure
mkdir -p lib/features/auth/{view,state,repo,tests}

# 2. Create repository
cat > lib/features/auth/repo/auth_repository.dart << 'EOF'
import '../../../core/services/firebase_service.dart';

class AuthRepository {
  Future<void> signIn(String email, String password) async {
    await FirebaseService.auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
EOF

# 3. Create provider
cat > lib/features/auth/state/auth_provider.dart << 'EOF'
import 'package:flutter/foundation.dart';
import '../repo/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo;
  bool loading = false;
  
  AuthProvider(this._repo);
  
  Future<void> signIn(String email, String password) async {
    loading = true;
    notifyListeners();
    await _repo.signIn(email, password);
    loading = false;
    notifyListeners();
  }
}
EOF

# 4. Create view
cat > lib/features/auth/view/auth_screen.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/auth_provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: provider.loading
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () => provider.signIn('user@example.com', 'pass'),
              child: const Text('Sign In'),
            ),
    );
  }
}
EOF

# 5. Wire up in main.dart
# Add to MultiProvider:
#   ChangeNotifierProvider(
#     create: (_) => AuthProvider(AuthRepository()),
#   ),
```

## Documentation

- **Full guide**: `shared/SCAFFOLD_USAGE.md`
- **Architecture**: `shared/architecture_patterns.md`
- **Folder structure**: `shared/project_folder_structure.md`

## Support

Issues? Check:
1. Generated `lib/README.md` in your project
2. Generated `ARCHITECTURE_CHECKLIST.md`
3. Portfolio examples: `flutter-portfolio/projects/*/flutter_app/`

---

**Script location**: `flutter-portfolio/shared/scaffold-flutter-project.sh`  
**Requires**: Flutter SDK, Bash  
**Platforms**: macOS, Linux, WSL
