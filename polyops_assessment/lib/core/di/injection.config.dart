// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:polyops_assessment/domain/repositories/i_task_repository.dart'
    as _i361;
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

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
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
    return this;
  }
}
