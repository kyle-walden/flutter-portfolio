# Flutter Architecture Scaffold - Quick Reference

## One-Line Usage for Quick Scaffold Creation

```bash
# flutter quick scaffold
dart pub global activate very_good_cli

very_good create flutter_app --project-name my_app # generates lib with core, features, shared_widget folders
```

## Typical Flutter Folder Structure following MVVM 

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

## Typical Flask API Folder Structure following Services Repository pattern

```my_api/
├── app.py                          # API entry point
├── services/                       # Business logic layer, thin wrappers around data access
│   ├── user_service.py
│   └── booking_service.py
├── repositories/                    # Data access layer, thin wrappers around DB or external APIs
│   ├── user_repository.py
│   └── booking_repository.py
├── models/                          # Data models (e.g. SQLAlchemy)
│   ├── user.py
│   └── booking.py
├── utils/                           # Utility functions, e.g. config, constants
│   └── config.py
├── requirements.txt                 # Python dependencies
└── README.md                       # Guide
```

