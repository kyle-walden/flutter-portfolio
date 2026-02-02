# Flutter Project Scaffold

Automated script to create Flutter projects with clean architecture following portfolio patterns.

## Quick Start

```bash
# Navigate to where you want to create the project
cd ~/projects

# Run the scaffold script
/path/to/flutter-portfolio/shared/scaffold-flutter-project.sh my_app_name
```

## What It Creates

### Folder Structure
```
my_app_name/
├── lib/
│   ├── app/
│   │   ├── providers/          # Global providers
│   │   └── routing/            # Route configuration
│   ├── core/
│   │   ├── services/           # FirebaseService, HttpService, LocalStorageService
│   │   ├── utils/              # AppTheme, helpers
│   │   ├── config/             # Constants, environment
│   │   └── models/             # Shared models
│   ├── features/
│   │   └── home/               # Example feature
│   │       ├── view/           # home_screen.dart
│   │       ├── state/          # home_provider.dart
│   │       ├── repo/           # home_repository.dart
│   │       ├── models/         # Feature models
│   │       ├── widgets/        # Feature widgets
│   │       └── tests/          # Feature tests
│   └── shared_widgets/         # custom_button.dart
├── ARCHITECTURE_CHECKLIST.md   # Compliance checklist
└── lib/README.md               # Architecture docs
```

### Generated Files

#### Core Services
- **firebase_service.dart** - Thin Firebase wrapper (~25 lines)
- **local_storage_service.dart** - SharedPreferences abstraction (~90 lines)
- **http_service.dart** - HTTP client wrapper (~110 lines)
- **app_theme.dart** - Material 3 theme configuration

#### Example Feature (home)
- **home_repository.dart** - Data orchestration example
- **home_provider.dart** - State management with ChangeNotifier
- **home_screen.dart** - UI screen calling provider

#### Main App
- **main.dart** - Provider setup with dependency injection
- **custom_button.dart** - Example shared widget

#### Documentation
- **lib/README.md** - Complete architecture guide
- **ARCHITECTURE_CHECKLIST.md** - Compliance validation

### Added Dependencies

```yaml
dependencies:
  provider: ^6.1.0              # State management
  http: ^1.1.0                  # HTTP client
  shared_preferences: ^2.2.0    # Local storage
  intl: ^0.18.0                 # Internationalization

# Commented out (uncomment as needed):
# firebase_core: ^2.24.0
# firebase_auth: ^4.16.0
# cloud_firestore: ^4.14.0
```

## Usage Examples

### Create New Project

```bash
cd ~/projects
/path/to/flutter-portfolio/shared/scaffold-flutter-project.sh awesome_app
cd awesome_app
flutter run
```

### Add to Existing Project

```bash
cd existing_project
/path/to/flutter-portfolio/shared/scaffold-flutter-project.sh .
```

The script will:
- ✅ Create missing folders
- ✅ Add template files
- ✅ Update dependencies
- ✅ Preserve existing code

### Add a New Feature

After scaffolding, create new features:

```bash
cd lib/features
mkdir -p booking/{view,state,repo,models,widgets,tests}

# Create files
cat > booking/repo/booking_repository.dart << 'EOF'
import '../../../core/services/local_storage_service.dart';

class BookingRepository {
  final LocalStorageService _storage;
  BookingRepository(this._storage);
  
  Future<List<Map<String, dynamic>>> fetchBookings() async {
    return await _storage.getList('bookings');
  }
}
EOF

cat > booking/state/booking_provider.dart << 'EOF'
import 'package:flutter/foundation.dart';
import '../repo/booking_repository.dart';

class BookingProvider extends ChangeNotifier {
  final BookingRepository _repo;
  List<Map<String, dynamic>> bookings = [];
  
  BookingProvider(this._repo);
  
  Future<void> load() async {
    bookings = await _repo.fetchBookings();
    notifyListeners();
  }
}
EOF

cat > booking/view/booking_screen.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/booking_provider.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookingProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Bookings')),
      body: ListView.builder(
        itemCount: provider.bookings.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(provider.bookings[i]['title'] ?? ''),
        ),
      ),
    );
  }
}
EOF
```

## Architecture Patterns

The scaffold follows these patterns:

### 1. Layered Architecture
```
View → Provider → Repository → Service → External System
```

### 2. Dependency Injection
- Providers inject repositories
- Repositories inject services
- All dependencies passed via constructors

### 3. Single Responsibility
- Services: <120 lines, one external system
- Repositories: Data orchestration for one feature
- Providers: State for one feature
- Views: UI rendering only

### 4. Testability
```dart
// Repository test (mock services)
test('fetches bookings', () async {
  final mockStorage = MockLocalStorageService();
  when(mockStorage.getList('bookings')).thenReturn([]);
  
  final repo = BookingRepository(mockStorage);
  final result = await repo.fetchBookings();
  
  expect(result, isEmpty);
});

// Provider test (mock repository)
test('loads bookings', () async {
  final mockRepo = MockBookingRepository();
  when(mockRepo.fetchBookings()).thenReturn([{'id': '1'}]);
  
  final provider = BookingProvider(mockRepo);
  await provider.load();
  
  expect(provider.bookings, hasLength(1));
});
```

## Validation

After scaffolding, validate compliance:

```bash
cd my_app_name

# Check for architecture violations
grep -r "FirebaseFirestore.instance" lib/features/*/view/  # Should be empty
grep -r "http\." lib/features/*/view/                      # Should be empty

# Run analysis
flutter analyze

# Run tests
flutter test

# Check coverage
flutter test --coverage
```

## Customization

### Change Theme Colors

Edit `lib/core/utils/app_theme.dart`:

```dart
static ThemeData get theme {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.purple,  // Change this
      brightness: Brightness.light,
    ),
  );
}
```

### Add Firebase

1. Uncomment dependencies in `pubspec.yaml`:
```yaml
firebase_core: ^2.24.0
firebase_auth: ^4.16.0
cloud_firestore: ^4.14.0
```

2. Run Flutter Firebase setup:
```bash
flutterfire configure
```

3. Update `main.dart`:
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

### Add Backend API

Update `lib/core/services/http_service.dart`:

```dart
HttpService({this.baseUrl = 'https://your-api.com'});
```

Use in repository:

```dart
class BookingRepository {
  final HttpService _http;
  
  BookingRepository(this._http);
  
  Future<List<Map<String, dynamic>>> fetchBookings() async {
    final response = await _http.get('/bookings');
    if (response['error'] == true) {
      throw Exception('Failed to fetch bookings');
    }
    return (response['data'] as List).cast<Map<String, dynamic>>();
  }
}
```

## Troubleshooting

### "Command not found: flutter"
Install Flutter: https://docs.flutter.dev/get-started/install

### "Directory already exists"
The script will ask if you want to continue and add files to existing project.

### "Package not found" errors
Run: `flutter pub get`

### Code formatting issues
Run: `dart format lib/`

## Reference Documentation

- **Architecture Patterns**: `flutter-portfolio/shared/architecture_patterns.md`
- **Folder Structure**: `flutter-portfolio/shared/project_folder_structure.md`
- **Testing Strategies**: `flutter-portfolio/shared/testing_strategies.md`

## Examples

See complete examples in:
- `flutter-portfolio/projects/pitboard/flutter_app/`
- `flutter-portfolio/projects/vendor0/flutter_app/`

## Support

For issues or questions:
1. Check `ARCHITECTURE_CHECKLIST.md` in generated project
2. Review `lib/README.md` for architecture details
3. Refer to portfolio reference projects

---

**Created by**: flutter-portfolio scaffold script  
**Version**: 1.0.0  
**Last updated**: 2 February 2026
