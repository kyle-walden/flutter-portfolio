# Flutter Architecture Scaffold - Quick Reference

## One-Line Usage

```bash
dart pub global activate very_good_cli

very_good create flutter_app --project-name my_app # generates lib with core, features, shared_widget folders
```

## Typical Folder Structure
Feature-first architecture with clear separation of concerns. Services are shared across features, while each feature has its own view, state management, and repository layers - following MVVM pattern.

```
my_app/
├── lib/
│   ├── app/                        # App bootstrap, routing, global providers
│   ├── core/
│   │   ├── services/               # E.g. Firebase, HTTP, LocalStorage (3 files)
│   │   ├── utils/                  # AppTheme
│   │   ├── config/                 # Constants
│   │   └── models/                 # Shared models
│   ├── features/feature_name/      # Example feature following MVVM pattern
│   │   ├── repo/                   # repositories (data access layer)
│   │   ├── view/                   # feature_screen.dart
│   │   ├── models/                 # Data structure
│   │   └── viewmodel/              # state management 
│   ├── main.dart                   # App entry point
│   └── shared_widgets/             # custom_button.dart
├── test/                           # Unit and widget tests, folder follows lib structure for discoverability
├── README.md                       # Guide
└── pubspec.yaml                    # Dependencies
```

## Architecture Pattern Enforced 

MVVM (Model-View-ViewModel): 
- **Model**: Data structures, no logic
- **View**: Stateless UI, no business logic, only calls ViewModel
- **ViewModel**: State management, calls Repositories, notifies Views
- **Repository**: Data access layer, calls Services, no UI logic
- **Services**: Thin wrappers around Firebase, HTTP, local storage, etc.


