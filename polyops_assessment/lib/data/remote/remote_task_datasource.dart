import 'package:injectable/injectable.dart';

import '../../core/auth/auth_token_provider.dart';
import '../../domain/entities/outbox_entry.dart';
import '../../domain/entities/sync_result.dart';
import 'i_remote_task_datasource.dart';

@LazySingleton(as: IRemoteTaskDataSource, env: [Environment.prod])
class RemoteTaskDataSource implements IRemoteTaskDataSource {
  final AuthTokenProvider _authTokenProvider;

  RemoteTaskDataSource(this._authTokenProvider);

  Map<String, String> get _headers => {
        'Authorization': _authTokenProvider.bearerHeader,
        'Content-Type': 'application/json',
      };

  // POST /api/v1/tasks/sync
  @override
  Future<SyncResult> applyOperation(OutboxEntry entry) async {
    // TODO: replace with real HTTP call using _headers
    // e.g. await http.post(Uri.parse('$baseUrl/api/v1/tasks/sync'), headers: _headers, body: jsonEncode(entry.toJson()))
    assert(_headers['Authorization'] != null);
    throw UnimplementedError(
      'RemoteTaskDataSource.applyOperation must be wired to the real API endpoint.',
    );
  }
}
