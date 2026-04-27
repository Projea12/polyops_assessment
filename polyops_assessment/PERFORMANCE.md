#### Q1: How would you render 1,000+ tasks smoothly in the task board without UI lag?

Challenge the premise first. 1,000 tasks in a Kanban board is a workflow failure before it is a rendering problem. Kanban is built on WIP limits — columns with hundreds of items are a signal that the product needs filtering, sprint scoping, or archival, not a faster renderer. The system answer is: enforce WIP limits at the domain level so this state cannot be reached in normal use.

Given the premise holds (backlog migration, audit view, admin scenario), the rendering system has four compounding problems — none of them isolated.

Problem 1: All three columns build simultaneously.
_BoardColumns at board_screen.dart:386 renders a SingleChildScrollView → Row → three BoardColumn widgets in one pass. There is no lazy column loading. Even if each column's ListView.builder (at board_column.dart:158) is lazy vertically, all three columns instantiate on the first frame. Fix: replace the Row with a PageView or TabBarView — one column builds at a time.

Problem 2: One drag repaint forces three column rebuilds.
The outer BlocBuilder at board_screen.dart:61 has no buildWhen. Every MoveTask optimistic update — which touches only two columns — rebuilds _BoardColumns, which rebuilds all three BoardColumn instances. Fix: buildWhen: (prev, curr) => prev is! BoardLoaded || (prev as BoardLoaded).columns != (curr as BoardLoaded).columns. Better fix: give each column its own BlocBuilder selecting only its status slice, so a move between todo→inProgress does not repaint done.

Problem 3: _isDragOver setState at board_column.dart:132 repaints the entire column.
When a card is dragged over a column, the whole AnimatedContainer (background, header, list) repaints on every pointer move event. Wrapping the drag-highlight decoration in its own widget with a RepaintBoundary isolates that paint to the overlay layer.

Problem 4: _BoardAppBar's buildWhen at board_screen.dart:156 fires on every BoardLoaded.
The condition curr is BoardLoaded is always true once loaded. Every task move triggers a stats recalculation and progress bar repaint, even if counts did not change. Fix: buildWhen: (prev, curr) => prev is! BoardLoaded || prev.columns != curr.columns.

Problem 5: Drift emits the full list on every mutation.
watchBoardTasksByStatus returns an unbounded reactive query. At 1,000 tasks, a single field update on one task causes Drift to re-emit all 1,000 rows to the stream, which the BLoC passes wholesale to the UI. Fix: cursor-based pagination in the Drift query — WHERE board_position > ? LIMIT 50 — with scroll-triggered page loading in _scrollController's listener.

What the system actually needs:
The real fix is upstream. The domain layer should expose a taskCount(TaskStatus) query so the header stats never touch the full list. The board should display a maximum of 50 tasks per column with a "load more" affordance. A search/filter event on BoardBloc should narrow the Drift query at the SQL level, not filter in-memory after emission. These changes mean the rendering layer never sees 1,000 tasks — the database cursor is the gate.


#### Q2: How would you manage memory efficiently when handling large document files and image previews?
Start with the device floor, not the code. This is a KYC app — the users most likely to need document verification are onboarding users, often on mid-range or budget Android devices with 1–2GB total RAM and 150–250MB available to Flutter. The 10MB file ceiling enforced in FileProcessingService at file_processing_service.dart:79 is the right constraint. The question is: at peak upload, how much of that 150MB does the pipeline consume simultaneously, and does it survive on the floor device?

Trace the peak heap moment. When a user picks a gallery image and submits, the pipeline is:

_pickFromGallery() at document_upload_sheet.dart:54 calls image.readAsBytes() — up to 5MB compressed JPEG in a Uint8List, used only to call .length. This is 5MB held for a setState cycle.
_compressImage() at file_processing_service.dart:114 writes a compressed copy to the temp directory. Disk, not heap — but the temp file is never deleted after upload, accumulating across sessions.
_validateImageQuality() at line 152 calls readAsBytes() again — another 5MB in heap — then decodes to a 200×200 grid via ui.instantiateImageCodec. The ui.Image returned at line 159 holds a GPU texture. It is never disposed. GPU memory is not GC'd when the Dart object is collected; it leaks until the Dart finalizer runs, which is non-deterministic.
Checksum at line 92 calls readAsBytes() a third time — another 5MB. The three calls are sequential, not concurrent, so peak simultaneous heap is one file load (~5MB) plus the 200×200 pixel grid (~160KB as Float64List, or ~80KB if changed to Float32List).
Meanwhile, the dashboard's TweenAnimationBuilder in DocumentCard at document_card.dart:118 is animating progress for every active document. The _heartbeatTimer in DocumentRepository is firing every 5 seconds. The raster thread is compositing all of it.
The failure mode is a frame drop on the upload progress indicator. The user submitted their passport photo and is watching the spinner. That is the moment heap pressure from the readAsBytes() + the GPU texture leak + the animation callbacks collide on the UI thread. On a 150MB budget device, this is where jank appears — not during browsing, precisely during the trust-critical moment.

Fix the pipeline in priority order:

Fix 1 — eliminate the size-only readAsBytes():


_selectedSize = await File(image.path).length(); // stat() syscall, no file read
This removes 5MB from the widget layer entirely.

Fix 2 — dispose ui.Image and ui.Codec explicitly in _validateImageQuality:


final codec = await ui.instantiateImageCodec(...);
try {
  final frame = await codec.getNextFrame();
  final image = frame.image;
  try { /* analysis */ } finally { image.dispose(); }
} finally { codec.dispose(); }
This releases the GPU texture deterministically, not on GC schedule.

Fix 3 — stream the checksum instead of buffering:


final digest = await sha256.bind(File(path).openRead()).first;
openRead() streams in 64KB chunks. The 10MB file never fully materializes in the Dart heap.

Fix 4 — clean up temp files after upload resolves:
The repository knows when upload succeeds or fails. At that point: File(processedFile.path).deleteSync(). Without this, every upload session leaves a compressed copy in the temp directory.

Fix 5 — guard against concurrent picks:
If the user taps Gallery then Camera before the first readAsBytes() resolves, two futures are live simultaneously — 10MB of compressed bytes in heap at once. A _pickInProgress guard or cancellable completer prevents the overlap.

The image preview system that doesn't exist yet — design it now, not later. There are no thumbnails in DocumentCard today — just icons. When thumbnails are added, the naive path is Image.file(document.localPath) which feeds full-resolution files into Flutter's PaintingBinding.instance.imageCache. The default cache is 100MB — on a 150MB budget device, one cache is the entire budget. The correct design: generate server-side thumbnails at upload time (256×256), store the thumbnail path separately in the Drift DocumentsTable, and display the thumbnail in the card. The full-resolution file is only accessed in the detail sheet, loaded once, and evicted on sheet close. imageCache.maximumSizeBytes should be set in main() to a device-tier-appropriate limit (e.g., 40MB on devices with < 3GB RAM), not left at the Flutter default.

The system invariant: at no point in the upload pipeline should the full file bytes exist in the Dart heap simultaneously. The only acceptable exception is the instantiateImageCodec call during quality analysis, which already downsamples to 200×200 pixels. Every other allocation — size check, checksum, HTTP body — should operate from the file path. The GPU texture must be disposed synchronously. Temp files must be deleted on upload completion. These three rules, applied consistently, keep peak heap under 10MB for a 10MB file on the floor device.

#### Q3: What tools and metrics would you use to measure and profile performance? What are your target benchmarks?
Start with what failure costs, not with what tools exist.

This is a KYC app. The user is submitting identity documents — passport, proof of address — to complete onboarding. The performance hierarchy is determined by what each failure costs:

Failure	User consequence	Business cost
Upload pipeline freezes	User abandons mid-submission	Lost user, possibly permanently
Upload latency too high	User doubts submission succeeded, retries or leaves	Duplicate submissions, support load
Document list slow to load	User doesn't trust the app's status display	Churns before verification completes
Board drag jank	Annoying	Nothing — secondary feature
This is the profiling priority order. I instrument the upload pipeline first, not drag, because a frame drop during drag is frustrating; a UI freeze during passport upload is a broken product.

Finding the floor device before setting any benchmark.

Benchmarks set in a vacuum are aspirational. The floor device for this app is determined by who submits KYC documents: first-time financial service users, often in markets where mid-range Android dominates. Check the analytics funnel — device model by submission attempt rate — and profile on the 10th percentile device by RAM. A reasonable starting assumption for this user base is 2GB RAM, ~150MB available to Flutter, with a single-core performance equivalent to a Snapdragon 680. Every benchmark below is set against that device, not a developer MacBook or flagship phone.

Surface 1: Upload pipeline — highest business impact.

The pipeline is: pick → FileProcessingService.process() → BLoC dispatch → HTTP upload. Two things in this chain block the UI thread and are invisible without instrumentation.

First: _validateImageQuality() at file_processing_service.dart:207 runs a 40,000-pixel nested loop on the main isolate. On the floor device, this takes 80–150ms — five to nine dropped frames. The user taps "Upload Document," the spinner appears, then the app freezes visibly before the upload even starts.

Second: readAsBytes() at document_upload_sheet.dart:54 loads the full image into heap just to call .length. On a 10MB file, this is 5MB allocated on the main isolate before process() is even called.

Tool: dart:developer Timeline API with named slices. Wrap each phase of process():


Timeline.startSync('doc_pipeline.compress');
// ...
Timeline.finishSync();
Timeline.startSync('doc_pipeline.quality_analysis');
// ...
Timeline.finishSync();
These appear in DevTools as named blocks on the UI thread flame graph. Without them, you see a spike but can't name it. With them, you see exactly which phase caused the freeze and for how long.

Tool: Firebase Performance Monitoring with custom traces. DevTools runs on developer hardware. Firebase runs on the user's device in the field. Wrap the full pipeline:


final trace = FirebasePerformance.instance.newTrace('document_upload_pipeline');
await trace.start();
// pick → process → dispatch
await trace.stop();
This gives p50/p95/p99 upload pipeline duration broken down by device RAM tier. If p95 on 2GB devices exceeds 5s, that is a production alert, not a retrospective finding.

Benchmark: FileProcessingService.process() must not block the UI thread for > 16ms in total. The quality analysis loop must move into compute(). The entire pick → dispatched pipeline must complete in < 3s on the floor device at p95. Upload success rate (no freeze-induced abandonment) is the business metric this benchmark defends.

Surface 2: Cold start — second highest impact.

main.dart at main.dart:14 runs configureDependencies() synchronously before runApp. DocumentRepository.init() starts WebSocket connections in @PostConstruct. On the floor device, this blocks the first frame by 800ms–1.5s — a blank screen where trust needs to be established immediately.

IndexedStack at main.dart:63 makes it worse: both BoardBloc and DocumentBloc are created on the first build, dispatching LoadBoard and DocumentSubscriptionRequested simultaneously. Four Drift reactive queries open in the first 100ms of startup.

Tool: DevTools Timeline, measuring from runApp call to first meaningful frame. The gap before the first frame event is configureDependencies() duration. Drift query initialization appears as the first cluster of async events after that.

Tool: Firebase Performance — automatic app start trace. Records cold start time by device model in the field. Correlate with retention: if cold start exceeds 3s, what is the 7-day retention rate for those users vs users who started in < 1s?

Benchmark: Cold start → first meaningful frame < 2s on the floor device. If configureDependencies() exceeds 500ms, defer DocumentRepository.init() via Future.microtask so runApp is not blocked. Lazy-load DocumentDashboardScreen instead of building it at startup via IndexedStack.

Surface 3: Rendering — lowest business priority, but visible.

The primary rendering problem is rebuild frequency, not render cost. The BlocBuilder at board_screen.dart:61 has no buildWhen, so every drag pointer event that produces a BoardLoaded rebuilds all three columns. The setState(() => _isDragOver = true) at board_column.dart:132 repaints the full AnimatedContainer on every pointer move.

Tool: DevTools Widget Rebuild Stats. Frame duration alone won't reveal this — a 12ms frame with 3 unnecessary column rebuilds per pointer event looks "acceptable" on the timeline but is wasting budget that a low-end device doesn't have.

Tool: DevTools Frame Timeline (UI + Raster threads separately). The ui.Image that is never disposed at file_processing_service.dart:159 leaks GPU memory, which shows as raster thread pressure — not UI thread pressure. A developer watching only UI thread times would miss the leak entirely.

Benchmark: Drag pointer event → frame complete < 16ms combined UI + raster. Widget rebuilds per pointer event: ≤ 1 column (the drop target only). Native heap growth across 5 consecutive uploads: 0 bytes (after image.dispose()).

The closing system: regression detection, not just measurement.

Benchmarks on a document are aspirational. Benchmarks enforced in CI are operational. The full system is:

In CI: integration_test with WidgetTester frame timing assertions on the drag path and board load time. Any PR that pushes frame duration above 16ms on the CI device fails the build.

In staging: A dedicated performance build on the actual floor device, running the upload pipeline 10 times, recording p50 and p95 via dart:developer Timeline. Results are posted as a PR comment.

In production: Firebase Performance alerts on:

Upload pipeline p95 > 5s on 2GB devices → immediate investigation
Cold start p95 > 3s → next sprint priority
Crash rate spike after any release that touches FileProcessingService → probable OOM on floor device
On memory: A nightly Dart heap snapshot diff — if native heap grows monotonically across upload sessions in staging, the ui.Image dispose fix has regressed.

The tools answer "what is slow." The regression system answers "when did it get slow, and who will know?" Without the second half, the first half produces a report nobody acts on.