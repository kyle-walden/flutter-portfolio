# Pitboard

**Production iOS & Android** — motorsport performance app for motocross.  
Records high-frequency GPS + telemetry, delivers post-session analysis.

![pitboard](assets/screenshots/pb-ss.png)

---

## Highlight: Offline-First Sync

Riders operate in remote locations with no connectivity.  
Sessions capture locally first; data syncs to Firestore when back online.

```
UI action
    │
    ▼
HistoryViewModel          ← lib/features/history/viewmodel/history_viewmodel.dart
    │
    ▼
HistoryRepository         ← lib/features/history/repo/history_repository.dart
    │
    ├── Hive local cache  (read immediately, always available offline)
    │
    └── Write-behind queue  ──► Firestore  (async flush when authenticated)
```

**Key code:** [history_repository.dart](flutter_app/lib/features/history/repo/history_repository.dart) · [history_viewmodel.dart](flutter_app/lib/features/history/viewmodel/history_viewmodel.dart)

---

## Tech Stack

Flutter · Firebase Auth · Cloud Firestore · Hive · Mapbox · `geolocator`

## Features

- High-frequency GPS + accelerometer/gyroscope capture (1–10 Hz)
- Offline-first session storage with write-behind queue and retry/backoff
- Post-session analysis: lap splits, metrics, heatmap overlays
- Background cloud sync — resilient to connectivity loss mid-session

## Architecture

Feature-first MVVM — each feature has `model/`, `viewmodel/`, `repo/`, `view/`.  
See [`lib/features/`](flutter_app/lib/features/) for all feature folders.

## Status

Production · iOS App Store · Google Play · Solo developer


