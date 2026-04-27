# Architecture

---

## Phase 3

---

### 1. State Management

**flutter_bloc with bloc_concurrency.**

The two features in this codebase — task management and document verification — share a common problem: multiple concurrent async operations that must not interfere with each other, feeding live streams into UI that can be opened, closed, and reopened mid-flight. That ruled out simple state notifiers and reactive stream wrappers before anything else was evaluated.

#### Why BLoC specifically

Three implementation realities drove the decision.

---

**1. Stream lifetime is tied to event handler lifetime via `emit.forEach`**

In `TaskDetailBloc` (`lib/presentation/task/bloc/task_detail_bloc.dart`), `_onSubscribed` calls:

```dart
await emit.forEach<Task>(
  _watchTask(event.taskId),
  onData: (task) { ... },
  onError: (e, _) => TaskDetailError(e.toString()),
);
```

The Drift-backed `watchTask` stream stays alive only as long as that handler runs. When the detail sheet closes and the BLoC is garbage collected, the subscription is cancelled automatically — no `StreamSubscription` field, no `dispose()` override, no risk of a stale stream delivering events to a closed widget. The same pattern exists in `SyncBloc._onStarted` listening to `ISyncService.conflictsStream`.

---

**2. Per-event concurrency policy declared at registration**

In `TaskDetailBloc`:

```dart
on<TaskDetailSubscribed>(_onSubscribed,       transformer: restartable());
on<TaskDetailSaveRequested>(_onSaveRequested, transformer: droppable());
on<TaskDetailDeleteRequested>(_onDeleteRequested, transformer: droppable());
on<TaskDetailCommentSubmitted>(_onCommentSubmitted, transformer: sequential());
```

- `restartable()` on `TaskDetailSubscribed` means if the sheet is closed and reopened for a different task, the previous `watchTask` stream is cancelled and a new subscription starts — no stale task data bleeds through.
- `droppable()` on save and delete means a double-tap physically cannot submit twice — the second event is silently discarded without any guard variable.
- `sequential()` on comments means rapid comment submissions queue and process in arrival order — no comment is lost, none race.

Implementing these three policies manually with `StreamSubscription`, debounce flags, and queues would add significant stateful complexity to every handler.

In `SyncBloc`:

```dart
on<_SyncStarted>(_onStarted,         transformer: restartable());
on<SyncTriggered>(_onSyncTriggered,  transformer: droppable());
on<ConflictResolved>(_onConflictResolved, transformer: sequential());
```

`SyncTriggered` is `droppable()` because triggering sync twice — from app resume in `BoardScreen.didChangeAppLifecycleState` and from `ConnectivityService.onlineStream` in `SyncService.init()` — must not run two sync cycles concurrently against the outbox.

---

**3. `_SyncStarted` as a private internal bootstrap event**

`SyncBloc` uses a private `final class _SyncStarted extends SyncEvent` defined in `sync_bloc.dart` itself, not exported. This event is fired in the constructor:

```dart
SyncBloc(this._syncService)
    : super(SyncState(conflicts: _syncService.conflicts)) {
  on<_SyncStarted>(_onStarted, transformer: restartable());
  // ...
  add(const _SyncStarted());
}
```

This bootstraps the conflict stream subscription at construction time without any external caller needing to know it exists. Public callers only see `SyncTriggered` and `ConflictResolved`. The internal event pattern keeps the bootstrap concern fully encapsulated inside the BLoC.

---

**4. `DocumentBloc` merges two independent streams into one**

The document dashboard needs documents and connectivity status simultaneously. Rather than nesting `BlocBuilder`s or managing two subscriptions, `DocumentBloc._onSubscriptionRequested` uses `StreamGroup.merge` from the `async` package:

```dart
final merged = StreamGroup.merge([
  _watchDocuments.watchAll().map<_DashboardUpdate>(_DocsUpdate.new),
  _documentRepository.watchConnectivityStatus().map<_DashboardUpdate>(_ConnUpdate.new),
]);

await emit.forEach<_DashboardUpdate>(merged, onData: (update) {
  switch (update) {
    case _DocsUpdate(:final docs): ...
    case _ConnUpdate(:final status): ...
  }
});
```

The sealed `_DashboardUpdate` tagged union (`_DocsUpdate`, `_ConnUpdate`) means a single `emit.forEach` handles both streams exhaustively. Either stream emission produces a new state, and both streams share the same `restartable()` lifecycle — when the subscription restarts, both are cancelled and recreated together. This was preferable to two separate `emit.forEach` calls because the state built from a document update needs the current connectivity status and vice versa — they must read from shared local variables in the same handler scope.

#### Trade-offs considered

**Riverpod** was the primary alternative. Its provider graph and `ref.watch` composition is elegant for derived read-only state. The problem is concurrent async operations — `droppable`, `sequential`, `restartable` are not primitives Riverpod provides. You implement them manually with `CancelToken` patterns or `ref.debounce`, which is exactly the boilerplate BLoC eliminates. For a feature set where save, delete, and comment can fire concurrently on the same entity, that boilerplate is not trivial.

**Provider** has no principled answer for async event sequencing. Ruled out before evaluation.

**GetX** conflates state, logic, and dependency resolution into one object. Incompatible with the separation of concerns this codebase is built around.

The real cost of BLoC is file count. Each screen requires event, state, and bloc files. This assessment has six BLoC sets: `BoardBloc`, `TaskFormBloc`, `TaskDetailBloc`, `SyncBloc`, `DocumentBloc`, `DocumentDetailBloc`. For a solo developer that is friction. For a team it is an asset — every state transition is in one place, every concurrent operation has a declared policy, and `AppBlocObserver` (`lib/core/observer/app_bloc_observer.dart`) captures every event and state change across all six BLoCs for debugging without a single line of instrumentation at the call site.

---

### 2. How the Two Features Share State

The two features are deliberately isolated with one controlled shared boundary.

#### Task management state

`BoardBloc` (`lib/presentation/task/bloc/board_bloc.dart`) owns the kanban board — it watches `ITaskRepository.watchBoardTasksByStatus` across all three columns and rebuilds `_BoardColumns` when tasks change. It is scoped to `BoardScreen` via `BlocProvider` in `board_screen.dart`:

```dart
BlocProvider(
  create: (_) => getIt<BoardBloc>()..add(const LoadBoard()),
  child: const _BoardView(),
)
```

When a card is tapped, `TaskDetailSheet.show()` creates a fresh `TaskDetailBloc` scoped to the sheet:

```dart
BlocProvider(
  create: (_) => getIt<TaskDetailBloc>()..add(TaskDetailSubscribed(taskId)),
  child: _TaskDetailContent(taskId: taskId),
)
```

`TaskFormBloc` follows the same pattern — created when `TaskFormSheet.show()` is called, destroyed when the sheet closes.

These three BLoCs never communicate directly. There is no shared state between board and detail. When `TaskDetailBloc` successfully saves a task, it emits `TaskDetailSaveSuccess` and the sheet pops. The board sees the change because `BoardBloc` is subscribed to the same Drift-backed reactive stream — the database write triggers a new emission on `watchBoardTasksByStatus` automatically. The BLoCs are decoupled through the repository stream, not through shared state.

#### Document verification state

`DocumentBloc` (`lib/presentation/documents/bloc/document_bloc.dart`) owns the dashboard — documents list and connectivity status merged into one stream. `DocumentDetailBloc` is scoped to the detail sheet, created fresh per document. Neither knows the other exists.

#### The one shared boundary — `SyncBloc`

`SyncBloc` is the single point of shared state between the two features. It is registered at app root in `main.dart`:

```dart
BlocProvider<SyncBloc>(
  create: (_) => getIt<SyncBloc>()..add(const SyncTriggered()),
  child: MaterialApp(...),
)
```

It owns conflict state for the lifetime of the app. `BoardScreen` reads it to show `_ConflictBadgeButton`. `ConflictResolutionSheet` reads it to render and resolve conflicts. Both access it via `context.read<SyncBloc>()` — neither owns it, neither creates it.

`SyncBloc` is the only cross-feature state in the system, and it is cross-feature by necessity — sync conflicts arise from task operations but are surfaced in the board UI regardless of which screen the user is on. Scoping it to `BoardScreen` would have silently dropped conflict events whenever the user navigated to the document tab. App-root scope was the only correct answer.

#### What drove the isolation decision

The two features — task management and document verification — have no shared domain entities, no shared repository, and no shared network layer. A task conflict and a document upload are unrelated events. Sharing state between them would mean either feature's state machine can block or corrupt the other's. Isolated BLoCs with isolated lifecycles mean a crash in `DocumentDetailBloc` cannot affect `BoardBloc`, and a long-running save in `TaskDetailBloc` cannot stall document uploads.

The practical enforcement mechanism is DI scope. `TaskFormBloc`, `TaskDetailBloc`, and `DocumentBloc` are all `@injectable` factories in `injection.config.dart` — `getIt` creates a new instance per `BlocProvider.create` call and the instance is garbage collected when the widget tree disposes it. There is no way for two screens to accidentally share an instance. `SyncBloc` is registered as a singleton at app root — there is exactly one instance, accessed by both features through the widget tree, never through `getIt` directly in a widget.

---

### 3. Dependency Injection

**injectable + get_it.** Scope is not a configuration detail — it is an architectural decision about object lifetime and resource ownership.

#### The database is the root of the entire graph

`AppDatabase` is registered in `lib/core/di/register_module.dart` via `@module`:

```dart
@lazySingleton
AppDatabase get database => AppDatabase();
```

Everything else in the graph depends on it directly or indirectly. Two `AppDatabase` instances would mean two competing Drift connections to the same SQLite file — writes from one would not be visible to the watcher queries on the other. The reactive streams that drive the entire UI — `watchBoardTasksByStatus`, `watchAllDocuments`, `watchTask` — would silently diverge. `@lazySingleton` here is not a performance choice, it is a correctness requirement.

`ConnectivityService` from `connectivity_plus` is registered the same way for the same reason — one stream of network events for the entire app. Two instances would mean `SyncService` and `DocumentRepository` receiving independent, potentially out-of-sync connectivity events.

#### Infrastructure singletons — own persistent resources

```dart
@LazySingleton(as: ISyncService)
class SyncService implements ISyncService

@LazySingleton(as: ITaskRepository)
class TaskRepository implements ITaskRepository

@LazySingleton(as: IDocumentRepository)
class DocumentRepository implements IDocumentRepository
```

`@LazySingleton(as: Interface)` does something specific: the concrete class is not entered into `getIt`'s type map at all. `getIt<SyncService>()` throws `Error: Object/factory with type SyncService is not registered` at runtime. The only resolvable type is `ISyncService`. This is not a convention the team agreed to follow — it is enforced by the registration. The presentation layer has zero ability to take a compile-time or runtime dependency on a concrete data class, because the type does not exist in the graph.

`SyncService` holds `_isSyncing`, `_conflicts`, `_connectivitySub`, and `_conflictsController` — mutable state that must be singular. Two instances would run parallel sync cycles against the same outbox table, producing duplicate `SyncConflicted` entries for the same operation. `TaskRepository` and `DocumentRepository` hold Drift DAO references that share the single `AppDatabase` connection — singleton here is again correctness, not optimisation.

`@PostConstruct()` on `SyncService.init()`, `ConnectivityService.init()`, and `DocumentRepository.init()` separates construction from initialisation. Constructors remain pure — no subscriptions, no async work, no side effects. `init()` fires after injectable resolves all constructor dependencies. This matters because `DocumentRepository.init()` subscribes to `_ws.stateStream`, `_ws.messageStream`, and `_connectivity.onlineStream` — these subscriptions must start after the WebSocket service and connectivity service are fully constructed, not during DI graph construction.

#### Use cases — stateless, singleton by consequence

```dart
@lazySingleton
class CreateTaskUseCase

@lazySingleton
class WatchTaskUseCase

@lazySingleton
class AddCommentUseCase
// all use cases follow this pattern
```

Use cases hold only repository references. They carry no mutable state. A fresh instance per call would be behaviourally identical to a shared instance — the only difference is allocation cost. Singleton scope here is a consequence of statelessness, not a deliberate lifetime decision. If a use case ever needed per-call state it would need to become a factory immediately.

#### BLoCs — `@injectable` factory, but lifetime owned by the widget tree

```dart
@injectable
class TaskFormBloc extends Bloc<TaskFormEvent, TaskFormState>

@injectable
class TaskDetailBloc extends Bloc<TaskDetailEvent, TaskDetailState>

@injectable
class DocumentBloc extends Bloc<DocumentEvent, DocumentState>

@injectable
class SyncBloc extends Bloc<SyncEvent, SyncState>
```

`@injectable` without a scope qualifier means factory — `getIt` creates a new instance on every `getIt<T>()` call. But the critical point is where that call happens. Every BLoC is resolved inside `BlocProvider.create`:

```dart
// task_form_sheet.dart
BlocProvider(
  create: (_) => getIt<TaskFormBloc>(),
  child: const TaskFormSheet._(),
)

// task_detail_sheet.dart
BlocProvider(
  create: (_) => getIt<TaskDetailBloc>()..add(TaskDetailSubscribed(taskId)),
  child: _TaskDetailContent(taskId: taskId),
)
```

`BlocProvider` owns the instance. When the sheet closes and the widget is disposed, `flutter_bloc` calls `bloc.close()`, cancelling all active `emit.forEach` subscriptions. `getIt` has no reference to the instance after creation — it cannot keep it alive, cannot return it to another caller, and cannot leak it. This is deliberate: if `TaskDetailBloc` were `@lazySingleton`, `getIt` would hold a reference forever. Reopening the detail sheet would hand the same instance — with its previous stream state, previous error, previous `_initialized` flag — to a fresh widget tree. The `_initialized` guard in `_TaskDetailContentState` would be true from the previous open, and the new task's data would never seed the local edit state.

`SyncBloc` deserves a specific note. It is `@injectable` factory from `getIt`'s perspective, but `main.dart` resolves it exactly once:

```dart
BlocProvider<SyncBloc>(
  create: (_) => getIt<SyncBloc>()..add(const SyncTriggered()),
  child: MaterialApp(...),
)
```

The app-root `BlocProvider` holds it for the application lifetime. `getIt` never creates a second instance because no other `BlocProvider.create` calls `getIt<SyncBloc>()`. If it were registered as `@lazySingleton`, `getIt` would own its lifetime — `flutter_bloc` could not close it on dispose, and the conflict stream subscription would outlive any widget tree reconstruction. App-root `BlocProvider` + factory registration means the widget tree owns the lifetime, which is the correct owner.

#### What is deliberately not in the DI graph

Screens, sheets, and widgets are not registered. `TaskFormSheet`, `TaskDetailSheet`, `BoardScreen`, `ConflictResolutionSheet` — none exist in `injection.config.dart`. The DI graph stops at the BLoC layer. Widgets receive their dependencies through `BlocProvider` and `context.read`, never through `getIt` directly in a widget body.

This boundary is enforced by discipline here, not by the framework. But the reason it matters is concrete: if widget construction went through `getIt`, widget lifetime would be coupled to DI lifetime. That breaks Flutter's widget recycling, breaks hot reload, and makes widget tests require a fully configured `getIt` graph to instantiate a single widget. Keeping widgets out of `getIt` means a `TaskFormSheet` in a test needs only a `MockTaskFormBloc` passed via `BlocProvider.value` — no DI setup required.

#### The safety guarantee of code generation

`injection.config.dart` is generated by `injectable_generator` at build time via `build_runner`. A missing dependency, a wrong scope, or an unresolvable type is a build failure, not a runtime crash. The graph is verified at compile time. This is the concrete advantage over manual `getIt.registerLazySingleton` calls scattered across the codebase — those fail at the first `getIt<T>()` call in production, not during development.

---

### 4. How the Two Features Share Common Services

They share infrastructure through the DI graph, never through direct imports of each other's code.

#### The rule that enforces this

Task management and document verification have zero imports between their respective layers. No file under `lib/presentation/task/` imports anything from `lib/presentation/documents/` and vice versa. No file under `lib/domain/usecases/task/` imports anything from `lib/domain/usecases/document/`. The features are structurally isolated — they share only what lives in `lib/core/`, `lib/data/datasources/local/`, and `lib/domain/`.

This is not enforced by a lint rule in this codebase — it is enforced by the architecture. The shared services sit below both features in the dependency graph. Neither feature can import the other because neither needs to.

#### Local storage — shared `AppDatabase`, isolated DAOs

Both features share one `AppDatabase` instance registered as `@lazySingleton` in `register_module.dart`. But neither feature touches the other's tables.

`TaskDao` (`lib/data/datasources/local/task_dao.dart`) owns `TasksTable`, `CommentsTable`, and `ActivityEntriesTable`. `DocumentDao` (`lib/data/datasources/local/document_dao.dart`) owns `DocumentsTable` and `DocumentAuditTable`. `OutboxDao` (`lib/data/datasources/local/outbox_dao.dart`) owns `OutboxTable` — used exclusively by `SyncService` for task sync.

`TaskRepository` is injected with `TaskDao` and `OutboxDao`. `DocumentRepository` is injected with `DocumentDao`. Neither repository holds a reference to the other's DAO. Neither can query the other's tables. The shared database connection is an implementation detail hidden behind the DAO boundary — from the feature's perspective, it might as well be two separate databases.

#### Connectivity — one source, consumed independently

`ConnectivityService` (`lib/core/connectivity/connectivity_service.dart`) is `@lazySingleton`. It owns one `StreamController<bool>` and one subscription to `connectivity_plus`.

It is consumed by two completely different consumers for completely different purposes:

- `SyncService` (`lib/data/sync/sync_service.dart`) subscribes to `ConnectivityService.onlineStream` in `init()` to trigger task outbox sync when the device comes online
- `DocumentRepository` (`lib/data/repositories/document_repository.dart`) subscribes to `ConnectivityService.onlineStream` in `init()` to trigger WebSocket reconnection and reachability probing

Both receive the same boolean event from the same stream. Neither knows the other is subscribed. `ConnectivityService` broadcasts — `StreamController.broadcast()` — specifically to support multiple independent subscribers without coupling them. If it were a single-subscription stream, the second subscriber would throw at runtime.

#### Auth — shared token provider, consumed at the network boundary

`AuthTokenProvider` (`lib/core/auth/auth_token_provider.dart`) is `@lazySingleton`. It is the single source of bearer tokens for both features.

`DocumentApiService` and `DocumentWebSocketService` consume it for document API calls and WebSocket handshake headers. `MockRemoteTaskDataSource` and `RemoteTaskDataSource` consume it for task sync operations. Neither the task feature nor the document feature holds a token directly — they hold a reference to `AuthTokenProvider` and call it at the network boundary only. This means token refresh logic, expiry handling, or a switch from bearer tokens to a different auth scheme requires changing `AuthTokenProvider` alone. Neither feature's business logic or repository layer touches auth.

#### What is explicitly not shared

`ITaskRepository` and `IDocumentRepository` are completely separate interfaces with no common base. There is no generic `IRepository<T>` abstraction. This was a deliberate decision — a shared repository interface would create a false coupling between two domain areas that have nothing in common. Task sync uses an outbox pattern with conflict resolution. Document verification uses WebSocket with heartbeat fallback. Forcing them into a shared interface would mean either the interface carries methods neither feature fully implements, or the implementation leaks concerns across the boundary.

Similarly, `SyncBloc` is the only app-root shared state, and it is shared only because sync conflicts are a cross-cutting concern that cannot be scoped to either feature alone. It does not expose task internals to the document feature or vice versa — it exposes only `List<SyncConflict>` and two events: `SyncTriggered` and `ConflictResolved`. The document feature never dispatches to `SyncBloc` and never reads from it. The task feature reads it only to display conflict count and resolve conflicts.

---

### 5. Local Database Choice

**Drift (formerly Moor) over SQLite directly.**

#### What forced the decision

The entire UI layer in this codebase is reactive. `BoardBloc` does not fetch tasks — it watches them. `DocumentBloc` does not poll for document changes — it subscribes to a stream. `TaskDetailBloc` does not load a task once — it calls `emit.forEach` on a live stream that re-emits every time the underlying row changes.

This reactive requirement is non-negotiable. When `SyncService` resolves a conflict and calls `_taskDao.updateTaskField`, the board must update automatically. When `DocumentRepository` processes a WebSocket batch and writes updated statuses to `DocumentsTable`, the dashboard card must reflect the change without a manual refresh call. When `TaskRepository.addComment` inserts into `CommentsTable` and touches the task's `updatedAt`, the open detail sheet must see the new comment.

That last case is worth dwelling on. The `watchTask` stream in `TaskDao` watches only `TasksTable`:

```dart
Stream<TasksTableData> watchTask(String id) =>
    (select(tasksTable)..where((t) => t.id.equals(id))).watchSingle();
```

Comments live in `CommentsTable`. Inserting a comment does not trigger `TasksTable` watchers. The fix — `touchTask` in `TaskDao` bumping `updatedAt` after every comment insert — only works because Drift's watcher infrastructure detects the write and re-emits the stream. With raw SQLite this would require manual notification plumbing. With Drift it is one write to the correct table.

This entire reactive chain — from a write in any repository to an emission on any watcher — depends on one invariant: every write and every watcher must share the same SQLite connection. This is why `AppDatabase` is registered as `@lazySingleton` in `lib/core/di/register_module.dart`:

```dart
@lazySingleton
AppDatabase get database => AppDatabase();
```

If this were registered as a factory — or if the annotation were missing and injectable defaulted incorrectly — `getIt` would construct a new `AppDatabase` instance for each dependent. `TaskDao` would hold one connection, `DocumentDao` another, `OutboxDao` a third. A write through `TaskDao` would not be visible to the watcher query running on `DocumentDao`'s connection. The reactive UI would silently stop updating. No exception would be thrown — the streams would simply never re-emit after writes from a different connection. This is the class of bug that only surfaces under integration testing with real database writes, never in unit tests with mocks. The `@lazySingleton` registration is not a performance choice — it is the correctness guarantee that the entire reactive architecture rests on.

No other local database evaluated for Flutter provides this combination of reactive queries and relational expressiveness. Isar provides reactive queries but its query language is object-oriented and loses the relational expressiveness needed for the outbox join queries and the board's `watchBoardTasksByStatus` which uses a `leftOuterJoin` with a `count()` aggregate:

```dart
final count = commentsTable.id.count();
final query = (select(tasksTable)...)
    .join([leftOuterJoin(commentsTable, ...)]);
query.addColumns([count]);
query.groupBy([tasksTable.id]);
return query.watch();
```

This query returns tasks with their comment counts in a single reactive stream with no N+1 problem. Isar cannot express this. You would need two separate queries and manual merging — which reintroduces the race condition between task updates and comment count updates that this join eliminates.

#### Alternatives considered

**Hive / Hive CE** — key-value box storage. Rejected immediately. The task board requires relational queries: tasks filtered by status, ordered by board position, joined with comment counts. Hive has no query language. Every filter and sort would happen in Dart memory after loading entire collections. With 1000+ tasks that is both a memory and a performance problem.

**Isar** — fast, reactive, Flutter-native. Seriously considered. The reactive query support is genuine and the write performance benchmarks are strong. Rejected for two reasons specific to this codebase. First, the outbox pattern requires a reliable transaction guarantee — `TaskRepository.createTask` writes to `TasksTable` and `OutboxTable` in a single Drift transaction. If the app is killed mid-write, the transaction rolls back and the outbox entry does not exist without the task or vice versa. Isar transactions exist but are less battle-tested for this kind of cross-collection atomicity. Second, the `watchBoardTasksByStatus` join query has no equivalent in Isar — it would require two collections, two watchers, and a `StreamGroup.merge` with manual deduplication, which is exactly the complexity Drift's join support eliminates.

**sqflite directly** — the underlying SQLite wrapper. Rejected because it provides no reactive query support at all. Every stream would require manual `StreamController` management, polling, or write notification hooks. The `TaskDao.watchTask`, `watchBoardTasksByStatus`, `watchCommentsForTask`, `watchActivityForTask`, and all document watchers would need to be hand-rolled. That is a significant maintenance surface for behaviour Drift provides as a first-class feature.

**Firebase Firestore** — rejected without serious evaluation. The assessment is explicitly offline-first with a mock REST API and WebSocket. Firestore introduces a mandatory Google dependency, requires network for initial data, and its offline persistence model conflicts with the outbox sync pattern this codebase is built around.

#### The cost of Drift

Code generation. Every schema change requires running `build_runner`. The generated files — `app_database.g.dart`, `task_dao.g.dart`, `document_dao.g.dart` — are not human-readable and must not be hand-edited. Schema migrations require explicit `MigrationStrategy` in `AppDatabase`. For a solo developer this is manageable friction. For a team it requires discipline around not committing schema changes without regenerating and committing the generated files simultaneously.

The second cost is type safety at the schema boundary. Drift's type system maps Dart types to SQLite column types at compile time, which catches type mismatches during build. But it also means adding a nullable column to `TasksTable` requires a migration version bump, a `Migrator.addColumn` call, and a `build_runner` run before any code that uses the column compiles. That friction is the price of the compile-time safety guarantee.

---

### 6. Repository Pattern Implementation

The repository is the only component that knows both where data comes from and where it goes. Everything above it sees only domain entities. Everything below it sees only raw data.

#### The boundary the repository enforces

Nothing in `lib/domain/` or `lib/presentation/` imports from `lib/data/datasources/`. No BLoC, no use case, no entity touches a `TasksTableData`, a `CommentsTableData`, a `DocumentStatusResponseDto`, or a `WebSocketMessageDto` directly. Those types exist only inside the repository implementations. The moment data crosses the repository boundary — in either direction — it is a domain entity or it is nothing.

This boundary is structural, not conventional. `ITaskRepository` and `IDocumentRepository` in `lib/domain/repositories/` declare only domain types in their signatures. `TaskRepository` and `DocumentRepository` in `lib/data/repositories/` implement those interfaces. The presentation layer has compile-time knowledge of only the interface. If the entire data layer were replaced — different database, different API client, different DTO shapes — no file outside `lib/data/` would need to change.

#### Task data flow — from network to UI

The task sync flow starts at `SyncService` (`lib/data/sync/sync_service.dart`). When online, it reads pending entries from `OutboxDao.getPendingEntries()` and calls `IRemoteTaskDataSource.applyOperation()`. The mock implementation in `MockRemoteTaskDataSource` (`lib/data/remote/mock_remote_task_datasource.dart`) returns either `SyncAccepted` or `SyncConflicted`. On `SyncAccepted`, `SyncService` calls `OutboxDao.markSynced()` and `TaskDao.setTaskPending(false)`.

That last write — `setTaskPending` — is what triggers the UI update. `TaskDao.setTaskPending` writes to `TasksTable`. Drift detects the write and re-emits on every active watcher for that table. The chain from that point is:

```
TaskDao.setTaskPending()
  → TasksTable write
    → Drift watcher re-emits
      → TaskRepository.watchBoardTasksByStatus() asyncMap fires
        → BoardBloc._onSubscriptionRequested emit.forEach onData
          → BoardLoaded state emitted
            → _BoardColumns rebuilds
```

No polling. No manual notification. The write propagates to the UI automatically through the reactive chain.

For task creation, `TaskRepository.createTask` wraps two writes in a single Drift transaction:

```dart
await _dao.db.transaction(() async {
  await _dao.insertTask(TasksTableCompanion.insert(...));
  await _dao.insertActivity(ActivityEntriesTableCompanion.insert(...));
  await _outboxDao.insertEntry(_outbox(id, OutboxOperation.taskCreated, {...}));
});
```

The transaction guarantees atomicity — either all three writes succeed or none do. If the app is killed after the task is inserted but before the outbox entry is written, the transaction rolls back. The task does not exist locally without a corresponding outbox entry, which means sync will never attempt to push a task the server does not know about.

#### Document data flow — from WebSocket to UI

The document flow has two paths — WebSocket and heartbeat fallback — both terminating at the same Drift write.

**WebSocket path:**

`DocumentWebSocketService` receives raw JSON frames and emits `WebSocketMessageDto` objects on `messageStream`. `DocumentRepository.init()` subscribes to this stream through a batch transformer:

```dart
_wsMsgSub = _ws.messageStream
    .transform(_batchTransformer(const Duration(milliseconds: 100)))
    .listen(_onWsBatch);
```

The 100ms batch transformer buffers all WebSocket messages within a 100ms window and emits them as a `List<WebSocketMessageDto>`. This prevents N separate Drift transactions for N rapid WebSocket messages — instead `_onWsBatch` processes the entire batch in one transaction:

```dart
await _dao.db.transaction(() async {
  for (final msg in messages) {
    final row = await _dao.getById(msg.documentId);
    final existing = _dao.mapToEntity(row!);
    final updated = msg.toDomain(existing);
    await _persistUpdate(existing, updated);
  }
});
```

`_persistUpdate` writes to `DocumentsTable` and conditionally inserts into `DocumentAuditTable` if the status changed. The single transaction means one Drift watcher emission for the entire batch regardless of how many documents were updated.

**Heartbeat path:**

`DocumentRepository._checkHeartbeats()` fires on a 5-second timer. For documents whose WebSocket last-seen timestamp exceeds 15 seconds, it calls `DocumentApiService.getStatus()` — a `GET /api/v1/documents/{id}/status` call. The response DTO is mapped to a domain entity via `dto.toDomain(existing)` and persisted through the same `_persistUpdate` method. Both paths converge at the same write, producing the same Drift watcher emission.

From that emission, the chain is:

```
_persistUpdate() → DocumentsTable write
  → Drift watcher re-emits
    → DocumentRepository.watchAllDocuments() map fires
      → DocumentBloc._onSubscriptionRequested emit.forEach onData (_DocsUpdate)
        → DocumentLoaded state emitted
          → DocumentCard rebuilds with new status and progress
```

#### DTO mapping — where it happens and why it happens there

DTOs are mapped to domain entities inside the repository, never outside it. `WebSocketMessageDto.toDomain()` and `DocumentStatusResponseDto.toDomain()` are methods on the DTO classes themselves, called only from within `DocumentRepository`. `TasksTableData` is mapped to `Task` via `TaskRepository._mapToTask()` — a private method that never leaks outside the repository file.

The reason this matters: if DTO mapping happened in a use case or a BLoC, a change to the API response shape would require hunting down mapping code across multiple layers. With mapping contained inside the repository, an API contract change touches exactly one file.

#### The upload flow — optimistic UI with rollback

`DocumentRepository.uploadDocument()` demonstrates the full optimistic pattern. It writes an optimistic `VerificationDocument` with `isOptimistic: true` and a temporary UUID to `DocumentsTable` before the API call:

```dart
final tempId = _uuid.v4();
final optimistic = VerificationDocument(
  id: tempId,
  status: VerificationStatus.pending,
  isOptimistic: true,
  ...
);
await _dao.upsert(_toCompanion(optimistic, processed.checksum));
```

This write immediately triggers the Drift watcher, causing the dashboard to show the document with an `_OptimisticChip` spinner before the server responds. When the API call succeeds, the repository replaces the optimistic row with the confirmed server response in a single transaction — delete temp ID, insert confirmed ID, insert audit entry. If the API call fails, the optimistic row is deleted and the dashboard reverts. The UI never calls any rollback method — it simply stops receiving the optimistic document from the stream.

---

### 7. Project Structure for a Team of Four

**Feature-vertical ownership with a shared horizontal foundation.**

#### The four roles

| Role | Ownership |
|------|-----------|
| **Developer A — Task vertical** | `lib/presentation/task/`, `lib/domain/usecases/task/`, `lib/data/repositories/task_repository.dart`, `lib/data/datasources/local/task_dao.dart` — owns everything task end-to-end, never touches document files |
| **Developer B — Document vertical** | `lib/presentation/documents/`, `lib/domain/usecases/document/`, `lib/data/repositories/document_repository.dart`, `lib/data/datasources/remote/` — owns everything document end-to-end, never touches task files |
| **Developer C — Shared infra** | `lib/data/datasources/local/app_database.dart`, `lib/core/`, `lib/data/sync/`, `lib/domain/services/` — the integration point both verticals depend on; changes here require coordination |
| **Developer D — DI + codegen + CI** | `pubspec.yaml`, `injection.config.dart`, `*.g.dart` — owns the connective tissue that serializes everyone else when unowned |

#### What enables true concurrency

- Feature verticals mean Developer A can merge `task_repository.dart` without touching any file Developer B owns — no shared file, no conflict
- `ITaskRepository` and `IDocumentRepository` as interfaces let the BLoC developer code against the contract before the implementation exists — parallel tracks, not sequential
- `@injectable` factory per BLoC means each developer registers their own dependencies without touching a central DI file

#### What still serializes work (honest)

- `AppDatabase` schema changes — two developers cannot add Drift tables in the same sprint without sequencing migrations; one must land first
- `build_runner` codegen — any change to a Drift table or injectable class regenerates shared `*.g.dart` files; uncoordinated runs produce merge conflicts
- Shared domain entities (`VerificationDocument`, `SyncConflict`) — a field rename touches both verticals simultaneously

**The honest ceiling:** this structure supports three true parallel tracks. The 4th developer is most effective owning DI wiring, codegen, and CI — removing the coordination tax from the other three.

**Future evolution:** each vertical becomes a Dart package (`packages/task_feature/`, `packages/document_feature/`, `packages/core/`). The current directory structure already mirrors this boundary — the migration is a mechanical extraction, not an architectural rethink.

---

### 8. Architectural Seams

**The four load-bearing seams — and whether they're enforced or tribal knowledge:**

#### 1. Repository ↔ BLoC boundary

BLoCs receive `Either<Failure, T>` from usecases, never raw exceptions. The seam is **convention only** — nothing in the type system prevents a widget calling `ITaskRepository.saveTask()` directly via `getIt<ITaskRepository>()`, bypassing the BLoC entirely and breaking optimistic state. A new developer discovers this boundary by reading the BLoC layer carefully, not by hitting a compile error. Violation produces widgets that crash on network failure instead of rendering error states — silent until the failure path is exercised.

#### 2. Drift reactive query boundary

`watchTask()` in `TaskRepository` only re-emits when `TasksTable` changes. Writing to `CommentsTable` does not trigger it. The `touchTask()` method in `TaskDao` — which bumps `updatedAt` after every comment insert — is the non-obvious invariant. This seam is **completely silent**: no compile error, no runtime warning, just UI that never updates. A new developer adding a new joined table who misses `touchTask()` ships a bug that only appears under real usage. Highest onboarding risk in the codebase.

#### 3. Outbox ↔ SyncService boundary

`TaskRepository.saveTask()` writes to `TasksTable` and `OutboxDao` in a single Drift transaction. `SyncService` drains `OutboxDao` independently on connectivity events via `@PostConstruct init()`. A developer who writes directly to `TasksTable` without going through `TaskRepository` **silently skips the outbox** — the operation is lost on next sync with no error, no log entry at the call site, no diagnostic signal. This is the highest-risk seam for data loss.

#### 4. ConnectivityStatus ownership boundary

`ConnectivityStatus` (live/heartbeat/offline) is produced exclusively by `DocumentRepository`, combining WebSocket state + reachability probing + raw network. It surfaces through `IDocumentRepository.connectivityStatus` and `watchConnectivityStatus()`. A developer who reaches for `ConnectivityService` directly gets a `bool` — losing the heartbeat state, which is the critical distinction between "WebSocket dead but HTTP alive" and fully offline. This seam is discoverable — `ConnectivityService` exposes `onlineStream` not `ConnectivityStatus` — but the reason why lives only in `DocumentRepository`.

#### The seam that doesn't exist but should

There is no enforcement that BLoC events are the only mutation path into repositories. `injectable` makes `ITaskRepository` resolvable anywhere in the widget tree. A new developer can call `saveTask()` from a widget, bypass the BLoC, and produce inconsistent UI state with no warning. A production codebase would scope repository registration to prevent direct widget access.

**Honest gap across all four:** none of these boundaries are self-documenting at the interface definition. A new developer currently finds them by reading the implementation carefully or hitting the bug in testing.




#### Offline Functionality

#### 1. How would you queue document uploads when offline? Describe your priority model, retry logic, and partial upload recovery.
Tasks and documents handle offline writes differently, and that difference is the problem. An offline task edit is saved locally via TaskRepository → OutboxTable → SyncService drain on connectivity. The user never loses work. An offline document upload in DocumentRepository.uploadDocument() writes an optimistic row, fails the API call, deletes the optimistic row, and returns left(CacheFailure). The user loses the upload silently with no indication it was dropped. The fix is not a new queue system — it is extending the outbox pattern that already works for tasks to cover document uploads.

What the extension looks like:

DocumentUploadQueueTable added to AppDatabase — same singleton connection, same Drift reactive infrastructure. Columns: id, filePath, checksum, documentType, attemptCount, nextRetryAt, createdAt. No priority tiers. Two ordering rules: new uploads before retries, FIFO within each group. The reason priority tiers are unnecessary: document upload has no multi-user race. The only priority question that matters is whether a retrying failed upload should block a fresh one — it should not, so retries sort after new entries by attemptCount DESC, createdAt ASC.

Optimistic row lifecycle change:

Currently the optimistic row is deleted on any API failure. With the queue, the row stays alive with isOptimistic: true displaying a "pending upload" badge. It is not deleted until the entry either confirms from the server or exhausts retries. On server confirmation, the optimistic row is replaced with the confirmed row in a single Drift transaction — same atomic swap already in uploadDocument(). On permanent failure (attempt 4), the row transitions to rejectionReason: 'Upload failed — tap to retry' — the same path _markUploadIncomplete uses today for heartbeat-detected failures. The dashboard never shows a blank — the document is always visible in some state.

Retry logic:

Exponential backoff following the pattern already in DocumentRepository._checkHeartbeats(): 30s → 60s → 120s → 240s → capped at 300s. nextRetryAt persists in the queue row so backoff survives app restarts. At attempt 4 the entry is marked failed and surfaced to the user. The queue processor reads WHERE nextRetryAt <= now() before picking the next entry — no timer drift, no missed retries after restart.

Partial upload recovery — the real risk is idempotency, not file integrity:

FileProcessingService already compresses and checksums the file before the upload attempt. The checksum is already stored in DocumentsTable. The file corruption scenario is not the primary concern.

The real risk: the upload HTTP request completes on the server, the server creates the document record, but the app is killed before the response is processed. On restart the queue still has the entry at attemptCount = 0. The retry sends the same file again. Without an idempotency key the server creates a duplicate document.

The fix: include the checksum as an idempotency key in the upload request header. The server deduplicates on checksum — a second upload of the same file returns the existing document record rather than creating a new one. The client processes it identically either way.

App-kill mid-upload:

On DocumentRepository.init(), scan queue rows with status = uploading. These were in-flight when the app was killed. Reset to status = queued, preserve attemptCount, set nextRetryAt = DateTime.now() for immediate retry on next connectivity event. Without this scan, killed uploads are permanently stuck.

Queue drain trigger:

DocumentRepository.init() already subscribes to ConnectivityService.onlineStream. The queue processor drains on isOnline = true — the same trigger SyncService.init() uses for the task outbox. No new infrastructure needed.

#### 2. How would you handle task sync conflicts — for example, when a user edits a task offline while another user edits the same task online?



What actually causes a conflict — the question the implementation must answer first:

A conflict occurs when two writes target the same field of the same task at overlapping times. Detecting this requires the server to know the task version the client was editing against. Without a version field or vector clock on every task, the server cannot distinguish "first write" (safe) from "conflicting write" (needs resolution). The current mock implementation in MockRemoteTaskDataSource returns SyncConflicted by simulation — in production, every task needs a serverVersion field, every outbox entry carries the baseVersion the client edited against, and the server rejects writes where baseVersion != currentVersion. This is the foundation everything else depends on.

The conflict lifecycle — what is implemented:

When online, SyncService._doSync() reads pending entries from OutboxDao.getPendingEntries() and calls IRemoteTaskDataSource.applyOperation() for each. On SyncConflicted, the conflict is added to _conflicts and emitted on _conflictsController. SyncBloc receives it via emit.forEach on _onStarted, updates SyncState.conflicts, and _ConflictBadgeButton in BoardScreen shows the count. The user opens ConflictResolutionSheet, sees local and server values with actor name and timestamps, and chooses keep-local or accept-server. ConflictResolved dispatches to SyncBloc which calls ISyncService.resolveConflict().

The outbox ordering problem:

If a user edits a task offline three times, the outbox has three entries processed in order. If entry 2 conflicts, _doSync() continues and processes entry 3 — which may apply a local value on top of an unresolved conflict, making the conflict resolution meaningless. The fix: when SyncConflicted is returned for a task, skip all remaining outbox entries for that taskId in the current sync cycle. Only resume them after the conflict is resolved:


final blockedTaskIds = <String>{};
for (final entry in entries) {
  if (blockedTaskIds.contains(entry.taskId)) continue;
  final result = await _remote.applyOperation(entry);
  switch (result) {
    case SyncConflicted(:final conflict):
      blockedTaskIds.add(entry.taskId);
      // add to _conflicts...
  }
}
The known data corruption bug in resolveConflict:


if (!keepLocal) {
  await _taskDao.updateTaskField(conflict.taskId, title: conflict.serverValue);
}
updateTaskField hardcodes title regardless of conflict.fieldName. A conflict on description, priority, or status silently applies serverValue to the title field. The fix dispatches on fieldName:


if (!keepLocal) {
  switch (conflict.fieldName) {
    case 'title':       await _taskDao.updateTaskField(conflict.taskId, title: conflict.serverValue);
    case 'description': await _taskDao.updateTaskField(conflict.taskId, description: conflict.serverValue);
    case 'priority':    await _taskDao.updateTaskField(conflict.taskId, priority: conflict.serverValue);
    case 'status':      await _taskDao.updateTaskField(conflict.taskId, status: conflict.serverValue);
  }
}
The resolution-during-sync race:

_isSyncing in SyncService prevents concurrent sync cycles. But the user can resolve a conflict while a sync cycle is running — markSyncedForTask writes to OutboxTable while _doSync() may be reading the same entries. The fix: resolve conflict only queues the resolution. The actual markSyncedForTask runs at the start of the next sync cycle, after _isSyncing is released. This keeps all outbox mutations inside the sync cycle boundary.

The cross-tab visibility problem:

_ConflictBadgeButton lives in BoardScreen. A user on the document tab never sees it. SyncBloc is app-root scoped — it has the conflict count available everywhere. The fix is a persistent banner driven by SyncBloc in _AppShell, visible across both tabs, that disappears only when conflicts.isEmpty.

Why last-write-wins with user choice is the right model:

Automatic merging of task fields produces nonsensical results — "Buy milkFix bug" merged from two title edits is worse than asking the user. Operational transform is correct for collaborative text editors, not for structured task fields with discrete values. The user-choice model is the right trade-off for this domain. The system surfaces enough context — both values, the server actor name, timestamps — for the user to make an informed decision.


#### 3.

"Offline" is not binary in this codebase — the answer depends on which transition:

ConnectivityStatus has three states produced exclusively by DocumentRepository: live (WebSocket connected), heartbeat (WebSocket dead, HTTP reachable), offline (HTTP unreachable or reachability probe failed). The correct question is not "what works offline" but what degrades at each transition, and what the user experiences at each state.

live → heartbeat: WebSocket dead, HTTP alive

Task feature: No change. The task feature has no WebSocket dependency. SyncService uses HTTP only. All task operations — create, edit, delete, move, comment — continue exactly as in the live state. The user sees no difference.

Document feature: Real-time status updates stop. _onWsStateChange receives WebSocketState.failed and emits ConnectivityStatus.heartbeat. The connectivity banner in DocumentDashboardScreen transitions from live to heartbeat indicator. Critically, _checkHeartbeats() takes over — per-document GET polling fires every 5 seconds for non-terminal documents. From the user's perspective, status updates continue arriving but with higher latency. New uploads still work — uploadDocument() calls _api.uploadDocument() over HTTP which remains reachable. Retry verification works. The document feature is functionally intact at heartbeat — slower, not broken.

heartbeat → offline: HTTP unreachable

Task feature — degrades gracefully:

Every user action still works. Create, edit, delete, move, comment all write to TasksTable and OutboxTable in a single Drift transaction. The board re-renders immediately from the Drift watcher. isPending = true is set on the task, surfaced as a pending indicator on the card.

What the user does not know: The task board has no connectivity banner. A user working on the task tab has no indication their edits are queued. The pending indicator on the card is the only signal — and only for tasks they have edited. This is a degradation failure: the feature works but the user is not informed. The fix is a connectivity indicator in _AppShell driven by SyncBloc, visible across both tabs.

Document feature — degrades partially:

The dashboard reads from DocumentsTable via DocumentDao.watchAll() — a local Drift watcher. Previously uploaded documents are visible with their last-known status. The connectivity banner transitions to offline.

What stops working specifically:

New uploads fail. uploadDocument() writes the optimistic row then calls _api.uploadDocument(). The API call throws, the optimistic row is deleted, the upload is lost — this is the gap Q1 addresses.
Heartbeat polling stops. _checkHeartbeats() checks if (!_connectivity.isOnline) return as its first line. A document mid-verification freezes at its last-known progress value with no indication of when it will resume.
Retry verification fails. Same path as new uploads — HTTP unreachable means the retry call throws immediately.
Audit trail becomes read-only. watchAuditTrail() reads DocumentAuditTable locally — existing entries are visible but no new transitions can be written because server confirmation is required.
Recovery — the transition back matters as much as the degradation:

Task feature: SyncService.init() subscribes to ConnectivityService.onlineStream. When isOnline becomes true, sync() drains the outbox automatically. The board updates reactively as setTaskPending(false) writes trigger Drift watchers. The user sees their queued edits confirm without any manual action. Conflicts surface in SyncState.conflicts and the badge appears. Recovery is automatic and complete.

Document feature: DocumentRepository._onConnectivityChange receives the isOnline event and calls _probeAndConnect() — which probes the API before trusting connectivity, catching captive portals. On confirmed reachability, _ws.connect() is called. _onWsStateChange receives WebSocketState.connected, emits ConnectivityStatus.live, and resets all _lastSeenAt timestamps so the WebSocket gets a fresh 15-second window before heartbeat fires redundant GETs. Documents that were mid-verification when connectivity dropped resume receiving updates immediately — no restart required, no status lost.

The honest asymmetry and why it exists:

The task feature is fully offline-capable because the outbox decouples the write from the sync — local state is the source of truth. The document feature is only partially offline-capable because verification is a server-side process — OCR, identity checks, compliance validation cannot run locally. The upload can be deferred offline (Q1's queue), but verification always requires a live connection. That is not an architectural flaw — it is the correct boundary between what belongs on the client and what belongs on the server.


#### Security

Security Q1: Document encryption at rest and in transit

The pipeline question — encryption must fit the existing data flow without breaking it:

FileProcessingService.process() already does three things in order: compress → checksum → return ProcessedFile. The encryption decision depends on where in this pipeline it lands, and the order is not arbitrary.

Checksum must be computed before encryption. The checksum serves two purposes in this codebase: deduplication in DocumentsTable and idempotency on retry in uploadDocument(). If the checksum is computed after encryption, two uploads of the same file with different IVs produce different checksums — idempotency breaks. If computed before encryption, the checksum is stable across retries regardless of IV. The correct pipeline: compress → checksum → encrypt → store. FileProcessingService stores the pre-encryption checksum. The encrypted file is what lives on disk.

The server receives decrypted bytes — always. The server runs OCR, identity verification, and compliance checks on the document content. Sending encrypted bytes means the server processes noise. The decryption happens immediately before the multipart upload in DocumentApiService.uploadDocument() — decrypt to a memory buffer, stream directly into the HTTP request body, never write the decrypted bytes to disk. The encrypted file on disk is the only persistent form. The memory buffer is garbage collected when the request completes.

retryVerification() re-reads filePath — this path must be transparent. DocumentRepository.retryVerification() calls _api.uploadDocument(filePath: retrying.filePath, ...) which passes the path to DocumentApiService. The decryption must happen inside DocumentApiService at upload time, not at the repository layer. The repository layer never sees raw bytes — it passes paths. This keeps decryption contained to the network boundary, consistent with how DTO mapping is contained inside the repository boundary.

filePath in plaintext is a partial risk. An attacker with filesystem access who sees /data/user/0/com.app/documents/uuid.enc learns that a document exists but cannot read it. The filename itself leaks nothing — UUIDs are opaque. The real risk is DocumentsTable in plaintext: originalName (passport_john.jpg), type (PASSPORT), status, rejectionReason — these fields reveal sensitive information even without the file content. The database needs encryption independently of the files.

At rest — two separate encryption concerns:

Database: Replace NativeDatabase.createInBackground in AppDatabase with SQLCipher via sqlcipher_flutter_libs. The entire swamp.db file is AES-256 encrypted. The key is retrieved from flutter_secure_storage — iOS Keychain with kSecAttrAccessibleWhenUnlockedThisDeviceOnly, Android Keystore with hardware-backed storage. On first launch a random 256-bit key is generated and stored. The key is passed to SQLCipher via PRAGMA key immediately after connection — it never persists in Dart memory beyond that call. This is a contained change to _openConnection() in app_database.dart — nothing above the database layer changes.

Files: AES-256-GCM via the encrypt package. A separate file encryption key is derived from the master key using HKDF — the same master key, different derived keys for database and files, so compromising one does not compromise the other. The IV is randomly generated per file and prepended to the encrypted file on disk. FileProcessingService encrypts as the final step after checksumming. DocumentApiService decrypts to a memory buffer at upload time. retryVerification() works unchanged — it passes paths, decryption is transparent at the API service layer.

In transit — the question the codebase must answer before TLS:

DocumentApiService and DocumentWebSocketService assume HTTPS and WSS but enforce nothing in code. The real question is not whether to use TLS — that is mandatory — but what happens when TLS is present but the certificate is wrong.

A KYC app is a high-value MITM target. An attacker who can install a trusted CA on the device — corporate MDM, malware, user error — can intercept HTTPS silently. Certificate pinning rejects any TLS handshake that does not present the known server public key, regardless of whether the device trusts the signing CA.

What pinning breaks in this codebase: DocumentWebSocketService reconnects automatically with exponential backoff. If the server rotates its certificate during a reconnection cycle, all clients with the old pin stop connecting permanently until the app updates. The mitigation is pinning the CA public key not the leaf certificate, with a backup pin already deployed before rotation begins. The DocumentWebSocketService reconnection logic already handles transient failures — a pin mismatch surfaces as a connection failure and triggers the same backoff path, which is correct behavior during rotation.

The decrypted temp file window: The only moment unencrypted document bytes exist outside secure memory is during the multipart HTTP upload. The request streams bytes from the decryption buffer directly — no temp file written. If the upload is interrupted mid-stream, the buffer is garbage collected. The encrypted file on disk is never touched during the upload. This window is as narrow as the network layer allows.

The key management question is harder than the encryption itself — and that is Q2. The answer here deliberately stops at key retrieval from flutter_secure_storage because how those keys are generated, rotated, and recovered on device migration is a separate system with its own failure modes.

#### Security Q2: Encryption key management on Android and iOS

The question that must be answered before key management:

Who owns the key — the device or the user — and what does the compliance context require?

For a KYC app this is not a technical question first. It is a legal question. GDPR Article 9 classifies biometric data and identity documents as special category data. The applicable regulation determines:

Whether local caching of KYC documents is permitted at all
Who can decrypt and under what circumstances
Whether key escrow is required for legal hold or compliance audit
How long keys must be retained and when they must be destroyed
A device-bound key — Secure Enclave on iOS, StrongBox on Android — means only the device can decrypt. A compliance audit requiring document access cannot be satisfied. A legal hold requiring preservation of a specific user's documents cannot be enforced if the key lives only in hardware on their phone. These are not edge cases — they are foreseeable requirements for any regulated KYC pipeline.

The architecture that follows from the compliance context:

Local files are a cache, not the source of truth. The server holds the documents. Local encryption protects one specific threat: a stolen unlocked device where an attacker reads the filesystem. It does not protect against a compromised server, a malicious insider, or a legal disclosure requirement.

This means the correct key architecture is:

Server-side encryption for the documents themselves — the server encrypts at rest with keys it controls, auditable, rotatable, subject to legal hold
Local encryption is a cache protection layer only — protects the temporary local copy against device theft, not a primary security control
Local keys are ephemeral by design — losing them means re-downloading from the server, not data loss
This changes what local key management needs to solve. It does not need backup, recovery, or escrow — because the server is the recovery path.

Sensitivity classification — not all fields are equal:

DocumentsTable contains fields of different sensitivity. Encrypting everything the same way is not thinking in systems:

Field	Sensitivity	Reason
status, progress, estimatedProcessingTime	Low	Operational, no PII
filePath, checksum	Medium	Reveals document existence
type, originalName, rejectionReason	High	Directly identifies person and KYC outcome
The files themselves	Critical	Biometric data — GDPR Article 9
The database encryption strategy follows this classification:

SQLCipher encrypts the entire swamp.db — all fields encrypted at rest, no field-level decisions needed at the Drift layer
Files encrypted separately with AES-256-GCM — different derived key from the same master, so database compromise does not expose files
Two-layer key architecture — separation of wrapping from encryption:

A single key encrypting all data creates an unrotatable system. The correct structure:

Key Encryption Key (KEK): lives in hardware — iOS Secure Enclave via Keychain, Android StrongBox or TEE via Keystore. Never touches Dart memory. Used only to wrap and unwrap the DEK.
Data Encryption Key (DEK): random 256-bit key generated on first launch. Wrapped by the KEK, stored in flutter_secure_storage. Decrypted at runtime only when needed, held in memory for the duration of the operation, released immediately after.
Key rotation re-wraps the DEK with a new KEK — files and database are untouched. Rotation is fast regardless of how many documents are cached locally.

iOS — Keychain with Secure Enclave:


const storage = FlutterSecureStorage(
  iOptions: IOSOptions(
    accessibility: KeychainAccessibility.unlocked_this_device,
    synchronizable: false,
  ),
);
unlocked_this_device: key is inaccessible when device is locked, does not transfer to a new device, is wiped on device transfer even with encrypted backup. synchronizable: false: prevents iCloud Keychain sync — key is bound to one physical device.

What breaks and how the system recovers: Restoring an encrypted backup to a new device restores encrypted files but not the KEK. On first launch the app detects a missing KEK in DocumentRepository.init() — not at the point of decryption where it would surface as a cryptographic exception to the UI. Detection at init triggers a re-download flag. The user sees "re-syncing your documents" not a crash. The encrypted local files are deleted. Fresh copies are downloaded from the server and re-encrypted with a new KEK and DEK.

Android — Keystore with hardware binding:


const storage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
);
On devices with StrongBox (dedicated security chip), the KEK is hardware-bound and never extractable. On TEE-only devices the KEK is software-emulated within the trusted execution environment — weaker but inaccessible to the normal OS.

The biometric invalidation problem: Android invalidates Keystore keys when new biometrics are enrolled — KeyPermanentlyInvalidatedException at the point of key access. This must be caught in DocumentRepository.init(), not propagated to the UI. On catching it: delete wrapped DEK, generate new KEK and DEK, trigger server re-download. Same recovery path as device migration — the system has one recovery mechanism for all key loss scenarios.

App reinstall: Android Keystore key is deleted on uninstall. Same recovery path on reinstall.

The single recovery path for all key loss scenarios:

Device migration, app reinstall, biometric invalidation, key corruption — all resolve identically:

Detect missing or invalid KEK in DocumentRepository.init()
Delete local encrypted files
Generate new KEK and DEK
Set re-download flag in SyncMetaTable
On next authentication, re-download documents from server
Re-encrypt with new keys
One recovery path, all failure modes. This is the system property that makes the key management tractable — because the server is the source of truth, key loss is cache invalidation, not catastrophe.

What this architecture cannot solve:

If the server is compromised, local encryption provides no protection — the attacker has the plaintext before it reaches the device. Server-side encryption with proper key management, access controls, and audit logging is outside the scope of the mobile client but is the higher-value security control for a KYC pipeline.

#### Security Q3: Audit trail for compliance


A compliance audit trail is not a log. It is a legal record. The difference is tamper-evidence. A log that can be modified after the fact is not admissible as evidence of what happened. For KYC under AML regulations and GDPR Article 30 (records of processing activities), the audit trail must satisfy:

Completeness: every access, every status change, every retry, every rejection — recorded
Tamper-evidence: an entry written cannot be modified or deleted without detection
Attribution: every entry identifies who performed the action — user, system process, or third-party verifier
Retention: minimum 5 years under most AML frameworks — the trail outlives the document itself
Queryability: a compliance officer or regulator can retrieve the full history of a specific document or user without touching production data
Separation: the audit trail is not stored in the same system it audits — a compromised application database must not compromise the audit record simultaneously
What is currently implemented — and where it fails each requirement:

DocumentAuditTable exists in AppDatabase. DocumentRepository._persistUpdate() writes an entry on every status transition:


await _dao.insertAuditEntry(
  DocumentAuditTableCompanion.insert(
    id: _uuid.v4(),
    documentId: updated.id,
    fromStatus: previous.status.apiValue,
    toStatus: updated.status.apiValue,
    note: ...,
    timestamp: DateTime.now(),
  ),
);
watchAuditTrail() surfaces it to DocumentDetailBloc for the UI.

Against compliance requirements:

Requirement	Current state
Status changes	Recorded
Document access (who viewed)	Not recorded
Upload attempts	Partially — audit entry on confirmation, not on attempt
Retry events	Recorded via 'Manual retry' note
App-kill incomplete uploads	Recorded via _markUploadIncomplete
Tamper-evidence	Fails — same database, writable, deletable
Attribution	Fails — no actor recorded, no user identity
Retention	Fails — deleted with app, no retention policy
Queryability by compliance officer	Fails — device-local, no server-side queryability
Separation from audited system	Fails — same swamp.db
The tamper-evidence problem — the hardest requirement:

An audit trail in the same database as the data it audits can be modified by anyone with database write access — which includes the application itself. DocumentDao has unrestricted write access to DocumentAuditTable. A bug, a malicious actor, or a compromised dependency could silently alter entries.

The correct architecture has two components:

Local append-only log: DocumentAuditTable becomes append-only by convention — DocumentDao exposes only insertAuditEntry, never update or delete methods on this table. Drift enforces nothing at the database level, so this is a DAO boundary enforced by code review. For stronger enforcement, a database trigger on DocumentAuditTable that prevents UPDATE and DELETE — implemented as a customStatement in AppDatabase.onCreate:


await customStatement('''
  CREATE TRIGGER prevent_audit_modification
  BEFORE UPDATE ON document_audit
  BEGIN SELECT RAISE(ABORT, 'Audit entries are immutable'); END;
''');
await customStatement('''
  CREATE TRIGGER prevent_audit_deletion
  BEFORE DELETE ON document_audit
  BEGIN SELECT RAISE(ABORT, 'Audit entries cannot be deleted'); END;
''');
This makes the local table append-only at the SQLite level — the application cannot modify entries even if the code tries to.

Server-side audit ledger: Every audit entry written locally is also posted to a server-side audit endpoint — a separate service from the document API, with write-only access from the mobile client. The server stores entries in an append-only ledger — AWS QLDB, Azure Immutable Blob Storage, or a Merkle-chained log. The client cannot read from this endpoint, cannot modify entries, and cannot delete them. The compliance officer queries the server-side ledger, not the device. Device-local entries are for the user's own view of their document history.

Chaining for tamper-detection: Each audit entry includes a hash of the previous entry — previousHash: sha256(previousEntry). A gap or modification in the chain is detectable on verification. This is the same principle as a blockchain without the decentralisation overhead. DocumentRepository._persistUpdate() retrieves the last entry's hash before inserting the new one:


final lastHash = await _dao.getLastAuditHash(documentId);
await _dao.insertAuditEntry(
  DocumentAuditTableCompanion.insert(
    ...
    previousHash: Value(lastHash),
    entryHash: Value(sha256(id + documentId + fromStatus + toStatus + timestamp + lastHash)),
  ),
);
Attribution — who performed the action:

DocumentAuditTable currently records no actor. For compliance, every entry must identify:

For user-initiated actions (upload, retry): the authenticated user ID from AuthTokenProvider
For system actions (heartbeat status update, app-kill recovery): a system actor identifier ('system:heartbeat', 'system:recovery')
For server-initiated changes (WebSocket status push): the server actor, carried in the WebSocketMessageDto and stored in the audit entry
DocumentAuditTable needs an actorId and actorType column. _persistUpdate() receives the actor context from its caller — _onWsBatch passes the server actor, _checkHeartbeats passes system actor, uploadDocument passes the authenticated user.

What gets audited — completeness gap:

Status transitions are audited. These are not:

Document access: when watchDocument() or getDocumentStatus() is called — who viewed the document and when. For GDPR Article 15 (right of access) and compliance audit, access events are as important as modification events.
Upload attempts: the optimistic row is written before the API call but no audit entry is written until server confirmation. A failed upload attempt — including offline failures — leaves no audit record.
Key access events: when the DEK is retrieved to decrypt a document file — this is an access event that should be audited independently of document status changes.
The fix for upload attempts: write an audit entry at the point the optimistic row is created — fromStatus: 'NONE', toStatus: 'PENDING', actorType: 'user' — before the API call. If the upload fails, a second entry records the failure. The audit trail shows the attempt regardless of outcome.

Retention — the policy the app does not implement:

Local DocumentAuditTable has no retention policy. Entries accumulate indefinitely. For compliance, two policies apply:

Minimum retention: 5 years under AML — entries must not be deleted before this period
Maximum retention: GDPR right to erasure — when a user requests deletion, personal data must be removed
These two requirements conflict: AML requires retention, GDPR requires erasure. The resolution: AML obligations override GDPR erasure rights for the retention period in most jurisdictions. After the AML retention period expires, GDPR erasure applies. The app must implement a retention scheduler — a background check in DocumentRepository.init() that marks entries older than the retention period for server-side archival, and purges them from the local database after archival confirmation.

Honest gap: The local append-only enforcement via SQLite triggers, the chained hash entries, the server-side audit ledger, the actor attribution columns, the access event logging, and the retention scheduler are not implemented. DocumentAuditTable records status transitions correctly — that is the foundation. Everything above it is what a production compliance implementation requires.