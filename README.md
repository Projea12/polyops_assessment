# Polyops Assessment

A Flutter application demonstrating clean architecture across two features: a Kanban task board with offline sync, and a KYC document verification pipeline with real-time WebSocket status updates.

---
# App Preview
[Demo](https://drive.google.com/file/d/1UNBZNteKmlTCb2hTIn82poEvCJKkeDV2/view?usp=drive_link)
---

## Features

**Task Board**
- Kanban columns: Todo → In Progress → Done
- Create, edit, delete tasks with rich text descriptions (flutter_quill)
- Drag-and-drop column moves with offline queueing via outbox pattern
- Comments per task with activity feed
- Conflict resolution UI when local and server state diverge

**KYC Document Verification**
- Upload documents (Passport, National ID, Utility Bill)
- Real-time verification status via WebSocket with 100ms batch processing
- Per-document heartbeat fallback with exponential backoff (30s → 60s → 120s → 240s → 300s cap)
- 3-state connectivity banner: live / heartbeat / offline
- Retry rejected documents
- Audit trail per document

---

## Architecture

Clean architecture with strict layer boundaries:

```
lib/
├── core/                         # App-wide infrastructure
│   ├── connectivity/             # ConnectivityService (bool online stream)
│   ├── di/                       # get_it + injectable wiring
│   ├── observer/                 # AppBlocObserver (BLoC logging)
│   └── utils/                    # FileProcessingService, stream extensions
│
├── domain/                       # Pure Dart — no Flutter, no packages
│   ├── entities/                 # BoardTask, Task, VerificationDocument, SyncConflict ...
│   ├── failures/                 # Failure sealed class hierarchy
│   ├── repositories/             # ITaskRepository, IDocumentRepository (contracts only)
│   ├── services/                 # ISyncService (contract only)
│   └── usecases/                 # One class per operation
│       ├── task/
│       └── document/
│
├── data/                         # All I/O: Drift, REST, WebSocket
│   ├── datasources/
│   │   ├── local/                # AppDatabase, TaskDao, DocumentDao, OutboxDao
│   │   └── remote/               # DocumentApiService, DocumentWebSocketService
│   ├── dtos/                     # Network ↔ domain mapping (boundary contained here)
│   ├── remote/                   # IRemoteTaskDataSource + mock/real implementations
│   ├── repositories/             # TaskRepository, DocumentRepository (implements domain interfaces)
│   └── sync/                     # SyncService (implements ISyncService)
│
└── presentation/                 # Flutter widgets + BLoC
    ├── task/                     # BoardScreen, TaskDetailSheet, TaskFormSheet, BoardBloc ...
    ├── documents/                # DocumentDashboardScreen, DocumentDetailSheet, DocumentBloc ...
    └── sync/                     # SyncBloc (conflict stream, manual sync trigger)
```

**Dependency rule:** arrows point inward only. `domain/` imports nothing outside itself. `data/` imports `domain/`. `presentation/` imports `domain/` and uses `data/` only through DI-injected interfaces.

---

## Getting Started

### Prerequisites

- Flutter SDK `^3.11.0` (Dart `^3.11.0`)
- Xcode (iOS) or Android Studio (Android)
- `build_runner` for codegen (already in `dev_dependencies`)

### Setup

```bash
git clone <https://github.com/Projea12/polyops_assessment/tree/main>
cd polyops_assessment
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

The app runs in `dev` environment by default — all remote calls use `MockRemoteTaskDataSource` and a mock document API. No backend required.

### Environment Modes

Controlled via `--dart-define=APP_ENV=<value>` at build time:

| Value | Behaviour |
|-------|-----------|
| `dev` (default) | Mock remote datasource — no network calls |
| `prod` | Real remote datasource — requires backend |

```bash
# Development (default)
flutter run

# Production
flutter run --dart-define=APP_ENV=prod
```

The switch is wired in [lib/core/di/injection.dart](lib/core/di/injection.dart) via `String.fromEnvironment('APP_ENV')` and injectable's `@Environment` annotation on `MockRemoteTaskDataSource` vs `RemoteTaskDataSource`.

---

## Dependency Injection

Uses `get_it` + `injectable`. All registrations are annotation-driven — never touch `injection.config.dart` by hand.

```bash
# Regenerate after adding/changing @injectable, @lazySingleton, or Drift tables
flutter pub run build_runner build --delete-conflicting-outputs
```

**Key registrations:**

| Class | Scope | Registered as |
|-------|-------|---------------|
| `AppDatabase` | `@lazySingleton` | itself |
| `DocumentRepository` | `@LazySingleton(as: IDocumentRepository)` | interface only |
| `TaskRepository` | `@LazySingleton(as: ITaskRepository)` | interface only |
| `SyncService` | `@LazySingleton(as: ISyncService)` | interface only |
| `DocumentBloc` | `@injectable` | factory (new instance per screen) |
| `TaskDetailBloc` | `@injectable` | factory (new instance per bottom sheet) |
| `SyncBloc` | `@injectable` | factory (provided once at app root) |

`@PostConstruct` methods (`DocumentRepository.init()`, `SyncService.init()`) run automatically after construction — do not call them manually.

---

## Database

Drift (SQLite) with a single `AppDatabase` singleton at [lib/data/datasources/local/app_database.dart](lib/data/datasources/local/app_database.dart).

**Schema version:** `6`

**Tables:**

| Table | Purpose |
|-------|---------|
| `TasksTable` | Tasks with status, priority, board position |
| `CommentsTable` | Per-task comments (FK → TasksTable) |
| `ActivityEntriesTable` | Per-task activity log (FK → TasksTable) |
| `OutboxTable` | Pending sync operations (offline queue) |
| `SyncMetaTable` | Sync metadata (last sync timestamp) |
| `DocumentsTable` | KYC documents with verification state |
| `DocumentAuditTable` | Status transition log per document |

**Adding a new table:**
1. Define the table class in `app_database.dart`
2. Add it to the `@DriftDatabase(tables: [...])` list
3. Increment `schemaVersion`
4. Add the migration step in `onUpgrade`
5. Run `build_runner`

**Critical invariant — Drift reactive queries:** `watchTask()` only re-emits when `TasksTable` changes. If you write to `CommentsTable` or `ActivityEntriesTable`, you **must** call `TaskDao.touchTask(taskId)` afterward to bump `updatedAt` — otherwise the detail sheet UI goes stale silently. See [lib/data/datasources/local/task_dao.dart](lib/data/datasources/local/task_dao.dart).

---

## State Management

Flutter BLoC with `bloc_concurrency` transformers.

**BLoCs and their transformers:**

| BLoC | Event transformer | Reason |
|------|------------------|--------|
| `BoardBloc` — subscription | `restartable()` | cancels previous stream on re-subscription |
| `DocumentBloc` — subscription | `restartable()` | same |
| `DocumentBloc` — upload | `sequential()` | no concurrent uploads |
| `SyncBloc` — sync trigger | `droppable()` | ignore new triggers while sync is in flight |
| `SyncBloc` — conflict resolve | `sequential()` | order matters |
| `TaskDetailBloc` — save/delete | `droppable()` | ignore taps while operation is in flight |

**Stream lifetime:** BLoCs use `emit.forEach` to bind stream subscriptions to the event handler lifetime. When the event handler is cancelled (e.g., restartable transformer fires on a second `DocumentSubscriptionRequested`), the subscription is automatically disposed — no manual `StreamSubscription` management needed.

**DocumentBloc merges two streams** — document list and connectivity status — using `StreamGroup.merge` from the `async` package. The connectivity seed value is read synchronously from `IDocumentRepository.connectivityStatus` before the first stream emission arrives.

---

## Offline Sync

**Outbox pattern** in [lib/data/repositories/task_repository.dart](lib/data/repositories/task_repository.dart):

Every mutation (`saveTask`, `moveTask`, `deleteTask`) writes to both `TasksTable` and `OutboxTable` in a single Drift transaction. `SyncService` drains the outbox when connectivity is restored.

**Critical invariant:** always go through `TaskRepository` for task mutations. Direct writes to `TasksTable` that bypass the repository silently skip the outbox — the operation is lost on next sync with no error.

**Conflict resolution:** when `SyncService.applyOperation` returns `SyncConflicted`, the conflict is added to `_conflicts` and emitted on `conflictsStream`. `SyncBloc` surfaces this to `ConflictResolutionSheet`. Resolving keeps local or accepts server value, then marks the outbox entry synced.

---

## Document Verification Pipeline

**Upload flow** ([lib/data/repositories/document_repository.dart](lib/data/repositories/document_repository.dart)):
1. File is processed (compressed, checksummed) by `FileProcessingService`
2. Optimistic row written to `DocumentsTable` immediately (UI shows pending)
3. API upload attempted — on success, temp row replaced with server-confirmed row in one transaction; on failure, temp row deleted (implicit rollback via absence)
4. WebSocket starts tracking the confirmed document ID

**Real-time updates:** WebSocket messages are buffered for 100ms then processed in a single Drift transaction (`_batchTransformer`). This prevents N separate stream emissions for rapid-fire status updates.

**Heartbeat fallback:** if a document hasn't received a WebSocket message in 15 seconds, `DocumentRepository` polls `GET /documents/{id}` directly. Failures back off exponentially: 30s → 60s → 120s → 240s → 300s cap. Each document tracks its own backoff independently.

**ConnectivityStatus (3 states):**

| State | Meaning |
|-------|---------|
| `live` | WebSocket connected |
| `heartbeat` | WebSocket dead, HTTP reachable |
| `offline` | No internet or captive portal |

This 3-state value is owned exclusively by `DocumentRepository` — it is the only component that can produce it from WebSocket state + API reachability probing combined. Do not use `ConnectivityService` (which only emits `bool`) as a substitute.

---

## Critical Invariants for New Developers

These are the non-obvious boundaries that fail silently when violated:

1. **Always write tasks through `TaskRepository`** — direct `TaskDao` writes skip the outbox and lose operations on sync.

2. **Always call `touchTask()` after writing to joined tables** — `CommentsTable` and `ActivityEntriesTable` writes do not trigger Drift's `watchTask()` re-emission without it.

3. **`ConnectivityStatus` comes from `IDocumentRepository`** — not from `ConnectivityService`. Reaching for `ConnectivityService` gives you a degraded `bool` that loses the `heartbeat` state.

4. **`BLoC` events are the only mutation path** — repositories are DI-resolvable anywhere, but calling them from widgets bypasses BLoC state and breaks optimistic UI.

5. **Never edit `injection.config.dart` by hand** — it is fully generated. Run `build_runner` instead.

---

## Running Tests

### Run all tests

```bash
flutter test
```

64 tests, all passing. No backend or platform channels required — tests run entirely on the Dart VM.

### Run a specific suite

```bash
# Domain entity logic
flutter test test/domain/entities/

# Use case validation
flutter test test/domain/usecases/

# BLoC state machines
flutter test test/presentation/task/bloc/
flutter test test/presentation/documents/bloc/
flutter test test/presentation/sync/bloc/
```

### Test structure

```
test/
├── helpers/
│   └── test_helpers.dart        # Shared mocks, factory helpers, Either utilities
├── domain/
│   ├── entities/
│   │   ├── task_test.dart                      # isOverdue, equality, copyWith
│   │   └── verification_document_test.dart     # isTerminal, canRetry, resetForRetry, rollback
│   └── usecases/
│       ├── update_task_usecase_test.dart        # Validation, repository delegation, failure propagation
│       └── add_comment_usecase_test.dart        # Blank/too-long content, whitespace trimming
└── presentation/
    ├── task/bloc/
    │   ├── board_bloc_test.dart         # LoadBoard, MoveTask (optimistic + revert), not-loaded guard
    │   └── task_detail_bloc_test.dart   # Subscription, save, delete, comment — all paths
    ├── documents/bloc/
    │   └── document_bloc_test.dart      # Seeded connectivity, upload success/failure, reset
    └── sync/bloc/
        └── sync_bloc_test.dart          # Conflict stream, SyncTriggered droppable, ConflictResolved
```

### Testing philosophy

Tests are organised by layer, not by file. Each layer has a different goal:

**Domain layer** — pure Dart, no mocks needed for entity logic. Tests exercise computed properties (`isOverdue`, `isTerminal`, `canRetry`) and value object invariants (`rollback`, `resetForRetry`). Use case tests verify that validation fires before the repository is called, and that `Either<Failure, T>` propagates correctly.

**BLoC layer** — each BLoC is tested with `bloc_test` against its full event → state contract. Key scenarios covered:
- `restartable()` stream re-subscription
- `droppable()` event de-duplication (second `SyncTriggered` while first is in flight)
- Optimistic state mutation with revert on failure (`MoveTask`)
- Not-loaded guard (`DocumentUploadRequested` ignored when state is not `DocumentLoaded`)
- Connectivity seeding from repository before first stream emission

**What is not unit-tested and why:** widget tests and integration tests require a fully configured DI graph (`getIt`), platform channels (SQLite via `drift_flutter`, connectivity via `connectivity_plus`), and real file system access. These are covered by running the app directly in the dev environment. Mocking them would add maintenance cost without catching real regressions — the failure mode is always in the platform channel binding, not in widget layout logic.

### Shared test utilities

`test/helpers/test_helpers.dart` provides:

```dart
// Factory helpers with sensible defaults — override only what the test cares about
Task makeTask({String id, String title, TaskStatus status, DateTime? dueDate, ...})
BoardTask makeBoardTask({String id, TaskStatus status, int boardPosition, ...})
VerificationDocument makeDocument({String id, VerificationStatus status, ...})
SyncConflict makeSyncConflict({String taskId, String fieldName, ...})
Comment makeComment({String id, String taskId, String content, ...})

// Either helpers
Either<Failure, T> ok<T>(T value)           // right(value)
Either<Failure, T> failWith<T>(String msg)  // left(NetworkFailure(msg))
```

---


## Tech Stack

| Package | Version | Use |
|---------|---------|-----|
| `flutter_bloc` | ^9.1.1 | State management |
| `bloc_concurrency` | ^0.3.0 | Event transformers |
| `freezed_annotation` | ^3.1.0 | Immutable state/event codegen |
| `injectable` / `get_it` | ^2.5.0 / ^8.0.3 | Dependency injection |
| `drift` | ^2.23.1 | Local SQLite ORM with reactive queries |
| `fpdart` | ^1.1.1 | `Either<Failure, T>` for typed error handling |
| `connectivity_plus` | ^6.1.4 | Network interface state |
| `flutter_quill` | ^11.5.0 | Rich text task descriptions |
| `file_picker` / `image_picker` | ^10 / ^1.1 | Document file selection |
| `flutter_image_compress` | ^2.4.0 | Image compression before upload |
| `uuid` | ^4.5.1 | Client-side ID generation |
