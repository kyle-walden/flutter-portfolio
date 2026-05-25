# Fleet — Frontend

Next.js 15 (App Router) + Tailwind CSS + Tremor

## Bootstrap (run this once)

```bash
cd projects/fleet
npx create-next-app@latest frontend \
  --typescript \
  --tailwind \
  --app \
  --src-dir \
  --import-alias "@/*"
```

Then add UI dependencies:

```bash
cd frontend
npm install @tremor/react recharts
npm install zustand swr
npm install react-hook-form zod @hookform/resolvers
npm install react-dropzone
npm install next-auth
```

## Planned Structure

```
frontend/
└── src/
    ├── app/
    │   ├── layout.tsx                  # Root HTML shell  (≈ MaterialApp + ThemeData)
    │   ├── (dashboard)/
    │   │   ├── layout.tsx              # Sidebar + topbar (≈ AppShell.dart + ShellRoute)
    │   │   ├── page.tsx                # Dashboard home
    │   │   ├── vehicles/
    │   │   │   ├── page.tsx            # Vehicle list    (≈ VehiclesScreen)
    │   │   │   └── [id]/page.tsx       # Vehicle detail
    │   │   ├── drivers/
    │   │   │   └── page.tsx
    │   │   ├── fuel/
    │   │   │   └── page.tsx            # Transactions + charts
    │   │   ├── ingest/
    │   │   │   └── page.tsx            # Feature A: upload + review
    │   │   └── analyst/
    │   │       └── page.tsx            # Feature B: NL chat interface
    │   └── api/                        # Next.js Route Handlers (thin proxy to FastAPI)
    ├── components/
    │   ├── layout/                     # Sidebar, TopBar, PageHeader
    │   └── ui/                         # Shared primitives (≈ shared_widgets/)
    ├── features/
    │   ├── vehicles/
    │   │   ├── components/             # VehicleTable, VehicleForm, VehicleCard
    │   │   └── hooks/                  # useVehicles.ts  (≈ VehiclesProvider.dart)
    │   ├── drivers/
    │   ├── fuel/
    │   ├── ingest/
    │   └── analyst/
    ├── lib/
    │   ├── api/                        # Typed fetch wrappers  (≈ Repository classes)
    │   └── utils/
    └── store/                          # Zustand stores  (≈ app/providers/)
```

## Key Mental Model

| Flutter | Next.js / React |
|---|---|
| `AppShell.dart` with `ShellRoute` | `(dashboard)/layout.tsx` |
| `ChangeNotifier` + `Provider` | Zustand `create()` store |
| `Consumer<T>` | `useStore()` hook |
| `features/home/repo/` | `features/vehicles/lib/api/` |
| `features/home/state/` | `features/vehicles/hooks/` |
