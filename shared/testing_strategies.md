

# Testing strategies (unit + widget)

This file focuses on unit and widget test patterns used across `projects/` apps. Integration, golden and E2E testing are out of scope here but can be added later (see "Scope to extend" below).

## Quick tools list

- dart/flutter SDK: `flutter test`, `flutter analyze`
- Packages: `flutter_test`, `mocktail` or `mockito`, `fake_async`, `clock` (time control)

## Folder conventions

- Project-level tests: `test/` — unit and small shared tests.
- Feature-scoped tests: `lib/features/<feature>/tests/` or `lib/features/<feature>/tests/widget_test.dart` — colocate feature tests when useful for discoverability.
- Fixtures and mocks: `test/fixtures/` and `test/mocks/` (use generated mocks where useful).

## Test types & strategies

Unit tests
- Target: services, repositories, pure functions and provider controllers (ChangeNotifier logic). Keep these fast and isolated.
- purpose: e.g. validate mapping, caching, offline-queue logic, error handling, and service adapters (fast, deterministic).
- Strategy:
	- Inject dependencies (constructor injection or provider overrides) so tests substitute fakes/mocks.
	- Mock external systems (HTTP, Firestore) using `mocktail` or lightweight fakes.
	- Follow Arrange → Act → Assert; keep tests focused and deterministic.

Widget tests
- Target: single widgets and small screen flows without a real device.
- purpose: e.g. validate UI rendering and interaction without devices.
- Strategy:
	- Wrap widgets with a minimal app shell (MaterialApp, Theme, and provider overrides).
	- Use Keys for important elements to make finders stable.
	- Use `tester.pumpWidget()` and `tester.pumpAndSettle()` to wait for async work.
	- Use `fake_async` or `clock` for deterministic timer behaviour.

Interaction tests
- Target: multi-widget flows and interactions that require more realistic environment (e.g. navigation, state persistence).
- Strategy: validate real SDK behavior, Firestore rules + emulator wiring, platform plugins, CocoaPods/ID signing paths, and full end-to-end flows (auth → repo → backend). They catch issues unit tests miss (rules, emulator host config, serialization edge cases, platform-specific plugin behavior).

## Mocking and fakes

- Prefer `mocktail` for simple mocks; use small explicit fakes when behaviour/state must be preserved across calls.
- Use generated mocks for larger interfaces (repositories, services) to reduce boilerplate.

## Common test patterns

- Provider tests: instantiate provider with fake services and assert state transitions.
- Repository tests: use an in-memory DB or mocked service and validate mapping/projection logic and error paths.
- Async tests: await `tester.pumpAndSettle()` or use explicit `await` for futures; prefer deterministic clocks for scheduled logic.

## CI-friendly commands

Run locally or in CI pipelines:

```bash
# fetch deps
flutter pub get

# static checks
flutter analyze

# run unit + widget tests
flutter test --coverage

```

CI tips
- Cache Pub packages between runs.
- Keep unit/widget tests in a fast pipeline stage; reserve slower integration tests for separate stages when added.

## Best practices

- Keep unit tests fast and deterministic.
- Avoid real network calls in unit/widget tests; use fakes or the emulator in separate integration stages (if added later).
- Name tests clearly: `should_doX_when_conditionY()` or `given_when_then`.
- Use small fixtures and factory helpers to reduce setup duplication.
- Use stable finders (Keys) rather than fragile text matching in widget tests.

## Troubleshooting

- Use `flutter test -r expanded` for improved failure output.
- Run a single test file with `flutter test test/path/to/test.dart` to speed up iteration.

## Scope to extend

- Integration/E2E, golden tests, and emulator-driven scenarios are intentionally out of scope for this document. There's clear scope to introduce them later: add `integration_test/`, `golden/` baselines, and CI steps that provision the Firebase Emulator Suite or device farms.


