# Shared Resources & Documentation

This directory contains shared architecture patterns, documentation, and tools used across all projects in the flutter-portfolio repository.

## 📚 Documentation

### Architecture Guides
- **[architecture_patterns.md](architecture_patterns.md)** - Complete architecture reference
  - Core principles (feature-first, explicit layering, single source of truth)
  - Folder mapping and responsibilities
  - State management patterns
  - Data flow diagrams (UI → backend)
  - Offline-first and sync strategies
  - Testing guidance
  
- **[project_folder_structure.md](project_folder_structure.md)** - Standard folder structure
  - Complete directory tree
  - Feature organization patterns
  - Backend and CI structure

- **[testing_strategies.md](testing_strategies.md)** - Testing best practices
  - Unit, widget, and integration tests
  - Mocking strategies
  - Coverage requirements

## 🛠️ Tools & Scripts

### Project Scaffolding
- **[scaffold-flutter-project.sh](scaffold-flutter-project.sh)** - Automated project scaffold
  - Creates complete Flutter project with clean architecture
  - Generates core services, example feature, and documentation
  - Configures dependencies and providers
  - **Usage**: `bash scaffold-flutter-project.sh <project_name>`
  - **Docs**: [SCAFFOLD_USAGE.md](SCAFFOLD_USAGE.md) | [SCAFFOLD_QUICKSTART.md](SCAFFOLD_QUICKSTART.md)

### Development Helpers
- **[shell-aliases.sh](shell-aliases.sh)** - Shell aliases for common tasks
  - `flutter-scaffold` - Quick project creation
  - `firebase-setup` - Automated Firebase configuration
  - `flutter-add-feature` - Generate feature structure
  - `flutter-check-compliance` - Validate architecture
  - `flutter-test-quick` - Run tests and analysis
  - **Usage**: `source shell-aliases.sh`

### Firebase Setup
- **[firebase_setup_patterns/](firebase_setup_patterns/)** - Complete Firebase integration
  - **[README.md](firebase_setup_patterns/README.md)** - Comprehensive setup guide
  - **[setup-firebase.sh](firebase_setup_patterns/setup-firebase.sh)** - Automated setup script
  - **[QUICKSTART.md](firebase_setup_patterns/QUICKSTART.md)** - Quick reference
  - Covers: CLI installation, project configuration, service setup, platform-specific config
  - **Usage**: `bash firebase_setup_patterns/setup-firebase.sh`

## 🚀 Quick Start

### Create a New Project

```bash
# 1. Run the scaffold script
cd ~/projects
bash /path/to/flutter-portfolio/shared/scaffold-flutter-project.sh my_app

# 2. Setup Firebase (optional)
cd my_app
bash /path/to/flutter-portfolio/shared/firebase_setup_patterns/setup-firebase.sh

# 3. Start developing
flutter run
```

### Add to Existing Project

```bash
# Apply architecture patterns to existing project
cd existing_project
bash /path/to/flutter-portfolio/shared/scaffold-flutter-project.sh .
# Answer 'y' to modify existing project
```

### Load Development Aliases

```bash
# Add to ~/.zshrc or ~/.bashrc
source /path/to/flutter-portfolio/shared/shell-aliases.sh

# Then use convenience commands
flutter-scaffold new_app          # Create new project
firebase-setup                    # Setup Firebase in current project
flutter-add-feature auth          # Add new feature
flutter-check-compliance          # Validate architecture
```

## 📋 Architecture Overview

### Layer Structure
```
View (UI) → Provider (State) → Repository (Data) → Service (I/O) → External System
```

### Folder Pattern
```
lib/
├── app/                # Bootstrap, routing, global providers
├── core/
│   ├── services/       # Thin adapters (Firebase Auth/Firestore/Storage/Analytics, HTTP, Hive, Preferences)
│   ├── utils/          # Helpers, theme, formatters
│   └── config/         # Constants, environment
├── features/
│   └── <feature>/
│       ├── view/       # Screens (UI)
│       ├── state/      # Providers (state management)
│       ├── repo/       # Repositories (data orchestration)
│       ├── models/     # Domain models
│       └── widgets/    # Feature-specific widgets
└── shared_widgets/     # Reusable UI components
```

### Key Principles

1. **Feature-First Organization**
   - Keep related code together
   - Small change surfaces
   - Easy to find and modify

2. **Explicit Layering**
   - Clear separation of concerns
   - Dependency injection throughout
   - Testable with mocks

3. **Single Source of Truth**
   - Repositories own data
   - Services are thin adapters
   - No scattered queries

4. **Offline-First**
   - Local cache as primary source
   - Background sync
   - Optimistic updates

## 📖 Documentation Index

| Document | Purpose | Audience |
|----------|---------|----------|
| [architecture_patterns.md](architecture_patterns.md) | Complete architecture guide | Developers, reviewers |
| [project_folder_structure.md](project_folder_structure.md) | Standard folder structure | New contributors |
| [testing_strategies.md](testing_strategies.md) | Testing best practices | QA, developers |
| [SCAFFOLD_USAGE.md](SCAFFOLD_USAGE.md) | Complete scaffold guide | Project setup |
| [SCAFFOLD_QUICKSTART.md](SCAFFOLD_QUICKSTART.md) | Quick reference card | Quick lookup |

## 🎯 Scaffold Features

### What Gets Generated

- ✅ Complete folder structure (app, core, features, shared_widgets)
- ✅ 7 thin service files (Firebase Auth, Firestore, Storage, Analytics, HTTP, Hive, Preferences)
- ✅ Example feature with view/state/repo pattern showing Hive+Firestore sync
- ✅ Provider-based dependency injection
- ✅ Material 3 theme configuration
- ✅ Architecture documentation
- ✅ Compliance checklist

### Dependencies Added

- `provider` - State management
- `http` - HTTP client
- `hive` & `hive_flutter` - Local persistence for complex data
- `shared_preferences` - Simple settings storage
- `intl` - Internationalization
- Optional: Firebase packages (commented out)

## ✅ Architecture Compliance

### Validation Checklist

```bash
# Check for violations
grep -r "FirebaseFirestore.instance" lib/features/*/view/  # Should be empty
grep -r "http\." lib/features/*/view/                      # Should be empty

# Run analysis
flutter analyze

# Run tests
flutter test --coverage
```

### Rules

**DO:**
- ✅ Views call providers only
- ✅ Providers inject repositories
- ✅ Repositories inject services
- ✅ Services <120 lines
- ✅ Use `ConsumerWidget` or `StatefulWidget`

**DON'T:**
- ❌ No direct Firebase/HTTP calls in views
- ❌ No business logic in widgets
- ❌ No god objects (>300 lines)
- ❌ No service instantiation in views

## 📊 Example Projects

See complete implementations:
- [pitboard/flutter_app](../projects/pitboard/flutter_app/)
- [vendor0/flutter_app](../projects/vendor0/flutter_app/)

Each demonstrates:
- Clean layered architecture
- Feature-first organization
- Offline-first patterns
- Repository pattern with caching
- Provider-based state management

## 🤝 Contributing

When adding or modifying shared resources:

1. **Update documentation** - Keep docs in sync with code
2. **Test changes** - Verify scaffold creates working projects
3. **Update examples** - Keep reference projects current
4. **Follow patterns** - Maintain consistency across docs

## 📞 Support

Questions or issues?

1. Check the relevant documentation file
2. Review example projects in `projects/`
3. Run `flutter-check-compliance` to validate your project
4. Refer to generated `lib/README.md` in scaffolded projects

## 🔗 Related Resources

- [Flutter Architecture Guide](https://docs.flutter.dev/app-architecture)
- [Flutter Architecture Concepts](https://docs.flutter.dev/app-architecture/concepts)
- [Flutter Architecture Case Study](https://docs.flutter.dev/app-architecture/case-study)

---

**Last updated**: 2 February 2026  
**Maintained by**: flutter-portfolio team
