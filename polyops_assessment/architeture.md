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
