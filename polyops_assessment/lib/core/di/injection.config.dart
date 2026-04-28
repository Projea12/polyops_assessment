// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:polyops_assessment/core/auth/auth_token_provider.dart' as _i361;
import 'package:polyops_assessment/core/connectivity/connectivity_service.dart'
    as _i534;
import 'package:polyops_assessment/core/di/register_module.dart' as _i151;
import 'package:polyops_assessment/core/notifications/notification_service.dart'
    as _i981;
import 'package:polyops_assessment/core/utils/file_processing_service.dart'
    as _i1005;
import 'package:polyops_assessment/data/datasources/local/app_database.dart'
    as _i788;
import 'package:polyops_assessment/data/datasources/local/document_dao.dart'
    as _i146;
import 'package:polyops_assessment/data/datasources/local/outbox_dao.dart'
    as _i690;
import 'package:polyops_assessment/data/datasources/local/task_dao.dart'
    as _i562;
import 'package:polyops_assessment/data/datasources/remote/document_api_service.dart'
    as _i392;
import 'package:polyops_assessment/data/datasources/remote/document_websocket_service.dart'
    as _i749;
import 'package:polyops_assessment/data/remote/i_remote_task_datasource.dart'
    as _i652;
import 'package:polyops_assessment/data/remote/mock_remote_task_datasource.dart'
    as _i969;
import 'package:polyops_assessment/data/remote/remote_task_datasource.dart'
    as _i318;
import 'package:polyops_assessment/data/repositories/document_repository.dart'
    as _i923;
import 'package:polyops_assessment/data/repositories/file_picker_repository.dart'
    as _i228;
import 'package:polyops_assessment/data/repositories/task_repository.dart'
    as _i765;
import 'package:polyops_assessment/data/sync/sync_service.dart' as _i140;
import 'package:polyops_assessment/domain/repositories/i_document_repository.dart'
    as _i147;
import 'package:polyops_assessment/domain/repositories/i_file_picker_repository.dart'
    as _i627;
import 'package:polyops_assessment/domain/repositories/i_task_repository.dart'
    as _i361;
import 'package:polyops_assessment/domain/services/i_notification_service.dart'
    as _i1039;
import 'package:polyops_assessment/domain/services/i_sync_service.dart'
    as _i123;
import 'package:polyops_assessment/domain/usecases/document/get_document_history_usecase.dart'
    as _i303;
import 'package:polyops_assessment/domain/usecases/document/pick_document_file_usecase.dart'
    as _i923;
import 'package:polyops_assessment/domain/usecases/document/retry_verification_usecase.dart'
    as _i180;
import 'package:polyops_assessment/domain/usecases/document/upload_document_usecase.dart'
    as _i881;
import 'package:polyops_assessment/domain/usecases/document/watch_audit_trail_usecase.dart'
    as _i512;
import 'package:polyops_assessment/domain/usecases/document/watch_document_usecase.dart'
    as _i921;
import 'package:polyops_assessment/domain/usecases/task/add_comment_usecase.dart'
    as _i294;
import 'package:polyops_assessment/domain/usecases/task/create_task_usecase.dart'
    as _i1;
import 'package:polyops_assessment/domain/usecases/task/delete_task_usecase.dart'
    as _i621;
import 'package:polyops_assessment/domain/usecases/task/move_task_usecase.dart'
    as _i1065;
import 'package:polyops_assessment/domain/usecases/task/update_task_usecase.dart'
    as _i67;
import 'package:polyops_assessment/domain/usecases/task/watch_board_tasks_usecase.dart'
    as _i84;
import 'package:polyops_assessment/domain/usecases/task/watch_task_usecase.dart'
    as _i506;
import 'package:polyops_assessment/presentation/documents/bloc/document_bloc.dart'
    as _i761;
import 'package:polyops_assessment/presentation/documents/detail/bloc/document_detail_bloc.dart'
    as _i838;
import 'package:polyops_assessment/presentation/sync/bloc/sync_bloc.dart'
    as _i293;
import 'package:polyops_assessment/presentation/task/board/bloc/board_bloc.dart'
    as _i93;
import 'package:polyops_assessment/presentation/task/task_detail/bloc/task_detail_bloc.dart'
    as _i1058;
import 'package:polyops_assessment/presentation/task/task_form/bloc/task_form_bloc.dart'
    as _i563;

const String _dev = 'dev';
const String _test = 'test';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.AuthTokenProvider>(() => _i361.AuthTokenProvider());
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i1005.FileProcessingService>(
      () => _i1005.FileProcessingService(),
    );
    gh.lazySingleton<_i788.AppDatabase>(() => _i788.AppDatabase());
    gh.lazySingleton<_i1039.INotificationService>(
      () => _i981.NotificationService()..init(),
    );
    gh.lazySingleton<_i652.IRemoteTaskDataSource>(
      () => _i969.MockRemoteTaskDataSource(),
      registerFor: {_dev, _test},
    );
    gh.lazySingleton<_i146.DocumentDao>(
      () => _i146.DocumentDao(gh<_i788.AppDatabase>()),
    );
    gh.lazySingleton<_i690.OutboxDao>(
      () => _i690.OutboxDao(gh<_i788.AppDatabase>()),
    );
    gh.lazySingleton<_i562.TaskDao>(
      () => _i562.TaskDao(gh<_i788.AppDatabase>()),
    );
    gh.lazySingleton<_i627.IFilePickerRepository>(
      () => _i228.FilePickerRepository(),
    );
    gh.lazySingleton<_i652.IRemoteTaskDataSource>(
      () => _i318.RemoteTaskDataSource(gh<_i361.AuthTokenProvider>()),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i392.DocumentApiService>(
      () => _i392.DocumentApiService(gh<_i361.AuthTokenProvider>()),
    );
    gh.lazySingleton<_i749.DocumentWebSocketService>(
      () => _i749.DocumentWebSocketService(gh<_i361.AuthTokenProvider>()),
    );
    gh.lazySingleton<_i534.ConnectivityService>(
      () => _i534.ConnectivityService(gh<_i895.Connectivity>())..init(),
    );
    gh.lazySingleton<_i361.ITaskRepository>(
      () => _i765.TaskRepository(
        gh<_i562.TaskDao>(),
        gh<_i690.OutboxDao>(),
        gh<_i1039.INotificationService>(),
      ),
    );
    gh.lazySingleton<_i923.PickDocumentFileUseCase>(
      () => _i923.PickDocumentFileUseCase(gh<_i627.IFilePickerRepository>()),
    );
    gh.lazySingleton<_i294.AddCommentUseCase>(
      () => _i294.AddCommentUseCase(gh<_i361.ITaskRepository>()),
    );
    gh.lazySingleton<_i1.CreateTaskUseCase>(
      () => _i1.CreateTaskUseCase(gh<_i361.ITaskRepository>()),
    );
    gh.lazySingleton<_i621.DeleteTaskUseCase>(
      () => _i621.DeleteTaskUseCase(gh<_i361.ITaskRepository>()),
    );
    gh.lazySingleton<_i1065.MoveTaskUseCase>(
      () => _i1065.MoveTaskUseCase(gh<_i361.ITaskRepository>()),
    );
    gh.lazySingleton<_i67.UpdateTaskUseCase>(
      () => _i67.UpdateTaskUseCase(gh<_i361.ITaskRepository>()),
    );
    gh.lazySingleton<_i84.WatchBoardTasksByStatusUseCase>(
      () => _i84.WatchBoardTasksByStatusUseCase(gh<_i361.ITaskRepository>()),
    );
    gh.lazySingleton<_i506.WatchTaskUseCase>(
      () => _i506.WatchTaskUseCase(gh<_i361.ITaskRepository>()),
    );
    gh.lazySingleton<_i123.ISyncService>(
      () => _i140.SyncService(
        gh<_i690.OutboxDao>(),
        gh<_i562.TaskDao>(),
        gh<_i652.IRemoteTaskDataSource>(),
        gh<_i534.ConnectivityService>(),
      )..init(),
    );
    gh.lazySingleton<_i147.IDocumentRepository>(
      () => _i923.DocumentRepository(
        gh<_i146.DocumentDao>(),
        gh<_i392.DocumentApiService>(),
        gh<_i749.DocumentWebSocketService>(),
        gh<_i534.ConnectivityService>(),
        gh<_i1005.FileProcessingService>(),
      )..init(),
    );
    gh.factory<_i1058.TaskDetailBloc>(
      () => _i1058.TaskDetailBloc(
        gh<_i506.WatchTaskUseCase>(),
        gh<_i67.UpdateTaskUseCase>(),
        gh<_i621.DeleteTaskUseCase>(),
        gh<_i294.AddCommentUseCase>(),
      ),
    );
    gh.lazySingleton<_i303.GetDocumentHistoryUseCase>(
      () => _i303.GetDocumentHistoryUseCase(gh<_i147.IDocumentRepository>()),
    );
    gh.lazySingleton<_i180.RetryVerificationUseCase>(
      () => _i180.RetryVerificationUseCase(gh<_i147.IDocumentRepository>()),
    );
    gh.lazySingleton<_i881.UploadDocumentUseCase>(
      () => _i881.UploadDocumentUseCase(gh<_i147.IDocumentRepository>()),
    );
    gh.lazySingleton<_i512.WatchAuditTrailUseCase>(
      () => _i512.WatchAuditTrailUseCase(gh<_i147.IDocumentRepository>()),
    );
    gh.lazySingleton<_i921.WatchDocumentUseCase>(
      () => _i921.WatchDocumentUseCase(gh<_i147.IDocumentRepository>()),
    );
    gh.factory<_i563.TaskFormBloc>(
      () => _i563.TaskFormBloc(gh<_i1.CreateTaskUseCase>()),
    );
    gh.factory<_i293.SyncBloc>(() => _i293.SyncBloc(gh<_i123.ISyncService>()));
    gh.factory<_i838.DocumentDetailBloc>(
      () => _i838.DocumentDetailBloc(
        gh<_i921.WatchDocumentUseCase>(),
        gh<_i512.WatchAuditTrailUseCase>(),
        gh<_i180.RetryVerificationUseCase>(),
      ),
    );
    gh.factory<_i93.BoardBloc>(
      () => _i93.BoardBloc(
        gh<_i84.WatchBoardTasksByStatusUseCase>(),
        gh<_i1065.MoveTaskUseCase>(),
      ),
    );
    gh.factory<_i761.DocumentBloc>(
      () => _i761.DocumentBloc(
        gh<_i921.WatchDocumentUseCase>(),
        gh<_i881.UploadDocumentUseCase>(),
        gh<_i147.IDocumentRepository>(),
        gh<_i923.PickDocumentFileUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i151.RegisterModule {}
