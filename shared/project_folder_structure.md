# Project Folder Structure

The following is the general folder structure for each project in this portfolio monorepo:

## Notations

- `<project-root>`: Root folder of the specific project (e.g., `projects/pitboard/`)
- `<feature_name>`: Placeholder for specific feature module names (e.g., `home`, `user_profile`, etc.)

## Structure

The typical project folder layout (copyable tree):

```text
.<project-root> — Root folder of the specific project within the monorepo
├── backend — Server-side code and cloud functions
│   ├── flask — Python Flask backend for APIs
│   └── firebase — Firebase functions
├── ci — Continuous integration and delivery configs
│   ├── github-actions — GitHub Actions workflow files
│   └── xcode-cloud — Xcode Cloud workflow and config
├── flutter_app — Flutter application package
│   ├── lib — Application source code
│   │   ├── app — App entry point, routing, and configuration
│   │   ├── core — Core utilities, configs, and shared logic
│   │   │   ├── services — Platform, network, and backend services
│   │   │   └── utils — Utility functions and helpers
│   │   ├── features — Feature modules (UI, state, data)
│   │   │   └── <feature_name> — Individual feature module
│   │   │       ├── data — Repositories and data sources
│   │   │       ├── models — Data models and DTOs
│   │   │       ├── widgets — Feature-specific widgets
│   │   │       ├── repo — Repository interfaces/implementations
│   │   │       ├── state — State management (providers, blocs, etc.)
│   │   │       ├── tests — Unit and widget tests for the feature
│   │   │       └── view — Screens, pages, and UI layouts
│   │   └── shared_widgets — Reusable UI components across features
│   └── test — Project-level test suites (unit/widget/integration)
└── screenshots — Example app screenshots
```

