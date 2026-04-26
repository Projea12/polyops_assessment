// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TasksTableTable extends TasksTable
    with TableInfo<$TasksTableTable, TasksTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _richDescriptionMeta = const VerificationMeta(
    'richDescription',
  );
  @override
  late final GeneratedColumn<String> richDescription = GeneratedColumn<String>(
    'rich_description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _boardPositionMeta = const VerificationMeta(
    'boardPosition',
  );
  @override
  late final GeneratedColumn<int> boardPosition = GeneratedColumn<int>(
    'board_position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPendingMeta = const VerificationMeta(
    'isPending',
  );
  @override
  late final GeneratedColumn<bool> isPending = GeneratedColumn<bool>(
    'is_pending',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pending" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    richDescription,
    status,
    priority,
    boardPosition,
    isPending,
    createdAt,
    updatedAt,
    dueDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TasksTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('rich_description')) {
      context.handle(
        _richDescriptionMeta,
        richDescription.isAcceptableOrUnknown(
          data['rich_description']!,
          _richDescriptionMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('board_position')) {
      context.handle(
        _boardPositionMeta,
        boardPosition.isAcceptableOrUnknown(
          data['board_position']!,
          _boardPositionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_boardPositionMeta);
    }
    if (data.containsKey('is_pending')) {
      context.handle(
        _isPendingMeta,
        isPending.isAcceptableOrUnknown(data['is_pending']!, _isPendingMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TasksTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TasksTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      richDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rich_description'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      boardPosition: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}board_position'],
      )!,
      isPending: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pending'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
    );
  }

  @override
  $TasksTableTable createAlias(String alias) {
    return $TasksTableTable(attachedDatabase, alias);
  }
}

class TasksTableData extends DataClass implements Insertable<TasksTableData> {
  final String id;
  final String title;
  final String description;
  final String? richDescription;
  final String status;
  final String priority;
  final int boardPosition;
  final bool isPending;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? dueDate;
  const TasksTableData({
    required this.id,
    required this.title,
    required this.description,
    this.richDescription,
    required this.status,
    required this.priority,
    required this.boardPosition,
    required this.isPending,
    required this.createdAt,
    required this.updatedAt,
    this.dueDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || richDescription != null) {
      map['rich_description'] = Variable<String>(richDescription);
    }
    map['status'] = Variable<String>(status);
    map['priority'] = Variable<String>(priority);
    map['board_position'] = Variable<int>(boardPosition);
    map['is_pending'] = Variable<bool>(isPending);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    return map;
  }

  TasksTableCompanion toCompanion(bool nullToAbsent) {
    return TasksTableCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      richDescription: richDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(richDescription),
      status: Value(status),
      priority: Value(priority),
      boardPosition: Value(boardPosition),
      isPending: Value(isPending),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
    );
  }

  factory TasksTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TasksTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      richDescription: serializer.fromJson<String?>(json['richDescription']),
      status: serializer.fromJson<String>(json['status']),
      priority: serializer.fromJson<String>(json['priority']),
      boardPosition: serializer.fromJson<int>(json['boardPosition']),
      isPending: serializer.fromJson<bool>(json['isPending']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'richDescription': serializer.toJson<String?>(richDescription),
      'status': serializer.toJson<String>(status),
      'priority': serializer.toJson<String>(priority),
      'boardPosition': serializer.toJson<int>(boardPosition),
      'isPending': serializer.toJson<bool>(isPending),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
    };
  }

  TasksTableData copyWith({
    String? id,
    String? title,
    String? description,
    Value<String?> richDescription = const Value.absent(),
    String? status,
    String? priority,
    int? boardPosition,
    bool? isPending,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> dueDate = const Value.absent(),
  }) => TasksTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    richDescription: richDescription.present
        ? richDescription.value
        : this.richDescription,
    status: status ?? this.status,
    priority: priority ?? this.priority,
    boardPosition: boardPosition ?? this.boardPosition,
    isPending: isPending ?? this.isPending,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
  );
  TasksTableData copyWithCompanion(TasksTableCompanion data) {
    return TasksTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      richDescription: data.richDescription.present
          ? data.richDescription.value
          : this.richDescription,
      status: data.status.present ? data.status.value : this.status,
      priority: data.priority.present ? data.priority.value : this.priority,
      boardPosition: data.boardPosition.present
          ? data.boardPosition.value
          : this.boardPosition,
      isPending: data.isPending.present ? data.isPending.value : this.isPending,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('richDescription: $richDescription, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('boardPosition: $boardPosition, ')
          ..write('isPending: $isPending, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dueDate: $dueDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    richDescription,
    status,
    priority,
    boardPosition,
    isPending,
    createdAt,
    updatedAt,
    dueDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TasksTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.richDescription == this.richDescription &&
          other.status == this.status &&
          other.priority == this.priority &&
          other.boardPosition == this.boardPosition &&
          other.isPending == this.isPending &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.dueDate == this.dueDate);
}

class TasksTableCompanion extends UpdateCompanion<TasksTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String?> richDescription;
  final Value<String> status;
  final Value<String> priority;
  final Value<int> boardPosition;
  final Value<bool> isPending;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> dueDate;
  final Value<int> rowid;
  const TasksTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.richDescription = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.boardPosition = const Value.absent(),
    this.isPending = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksTableCompanion.insert({
    required String id,
    required String title,
    required String description,
    this.richDescription = const Value.absent(),
    required String status,
    required String priority,
    required int boardPosition,
    this.isPending = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.dueDate = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       description = Value(description),
       status = Value(status),
       priority = Value(priority),
       boardPosition = Value(boardPosition),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TasksTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? richDescription,
    Expression<String>? status,
    Expression<String>? priority,
    Expression<int>? boardPosition,
    Expression<bool>? isPending,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? dueDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (richDescription != null) 'rich_description': richDescription,
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (boardPosition != null) 'board_position': boardPosition,
      if (isPending != null) 'is_pending': isPending,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (dueDate != null) 'due_date': dueDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? description,
    Value<String?>? richDescription,
    Value<String>? status,
    Value<String>? priority,
    Value<int>? boardPosition,
    Value<bool>? isPending,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? dueDate,
    Value<int>? rowid,
  }) {
    return TasksTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      richDescription: richDescription ?? this.richDescription,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      boardPosition: boardPosition ?? this.boardPosition,
      isPending: isPending ?? this.isPending,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueDate: dueDate ?? this.dueDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (richDescription.present) {
      map['rich_description'] = Variable<String>(richDescription.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (boardPosition.present) {
      map['board_position'] = Variable<int>(boardPosition.value);
    }
    if (isPending.present) {
      map['is_pending'] = Variable<bool>(isPending.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('richDescription: $richDescription, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('boardPosition: $boardPosition, ')
          ..write('isPending: $isPending, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dueDate: $dueDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CommentsTableTable extends CommentsTable
    with TableInfo<$CommentsTableTable, CommentsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks_table (id)',
    ),
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
    'author_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorNameMeta = const VerificationMeta(
    'authorName',
  );
  @override
  late final GeneratedColumn<String> authorName = GeneratedColumn<String>(
    'author_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _editedAtMeta = const VerificationMeta(
    'editedAt',
  );
  @override
  late final GeneratedColumn<DateTime> editedAt = GeneratedColumn<DateTime>(
    'edited_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    authorId,
    authorName,
    content,
    createdAt,
    editedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'comments_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CommentsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('author_name')) {
      context.handle(
        _authorNameMeta,
        authorName.isAcceptableOrUnknown(data['author_name']!, _authorNameMeta),
      );
    } else if (isInserting) {
      context.missing(_authorNameMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('edited_at')) {
      context.handle(
        _editedAtMeta,
        editedAt.isAcceptableOrUnknown(data['edited_at']!, _editedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CommentsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CommentsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id'],
      )!,
      authorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_name'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      editedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}edited_at'],
      ),
    );
  }

  @override
  $CommentsTableTable createAlias(String alias) {
    return $CommentsTableTable(attachedDatabase, alias);
  }
}

class CommentsTableData extends DataClass
    implements Insertable<CommentsTableData> {
  final String id;
  final String taskId;
  final String authorId;
  final String authorName;
  final String content;
  final DateTime createdAt;
  final DateTime? editedAt;
  const CommentsTableData({
    required this.id,
    required this.taskId,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.createdAt,
    this.editedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['author_id'] = Variable<String>(authorId);
    map['author_name'] = Variable<String>(authorName);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || editedAt != null) {
      map['edited_at'] = Variable<DateTime>(editedAt);
    }
    return map;
  }

  CommentsTableCompanion toCompanion(bool nullToAbsent) {
    return CommentsTableCompanion(
      id: Value(id),
      taskId: Value(taskId),
      authorId: Value(authorId),
      authorName: Value(authorName),
      content: Value(content),
      createdAt: Value(createdAt),
      editedAt: editedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(editedAt),
    );
  }

  factory CommentsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CommentsTableData(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      authorId: serializer.fromJson<String>(json['authorId']),
      authorName: serializer.fromJson<String>(json['authorName']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      editedAt: serializer.fromJson<DateTime?>(json['editedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'authorId': serializer.toJson<String>(authorId),
      'authorName': serializer.toJson<String>(authorName),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'editedAt': serializer.toJson<DateTime?>(editedAt),
    };
  }

  CommentsTableData copyWith({
    String? id,
    String? taskId,
    String? authorId,
    String? authorName,
    String? content,
    DateTime? createdAt,
    Value<DateTime?> editedAt = const Value.absent(),
  }) => CommentsTableData(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    authorId: authorId ?? this.authorId,
    authorName: authorName ?? this.authorName,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    editedAt: editedAt.present ? editedAt.value : this.editedAt,
  );
  CommentsTableData copyWithCompanion(CommentsTableCompanion data) {
    return CommentsTableData(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      authorName: data.authorName.present
          ? data.authorName.value
          : this.authorName,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      editedAt: data.editedAt.present ? data.editedAt.value : this.editedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CommentsTableData(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('authorId: $authorId, ')
          ..write('authorName: $authorName, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('editedAt: $editedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskId,
    authorId,
    authorName,
    content,
    createdAt,
    editedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommentsTableData &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.authorId == this.authorId &&
          other.authorName == this.authorName &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.editedAt == this.editedAt);
}

class CommentsTableCompanion extends UpdateCompanion<CommentsTableData> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> authorId;
  final Value<String> authorName;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<DateTime?> editedAt;
  final Value<int> rowid;
  const CommentsTableCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.authorName = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.editedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CommentsTableCompanion.insert({
    required String id,
    required String taskId,
    required String authorId,
    required String authorName,
    required String content,
    required DateTime createdAt,
    this.editedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       authorId = Value(authorId),
       authorName = Value(authorName),
       content = Value(content),
       createdAt = Value(createdAt);
  static Insertable<CommentsTableData> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? authorId,
    Expression<String>? authorName,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? editedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (authorId != null) 'author_id': authorId,
      if (authorName != null) 'author_name': authorName,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (editedAt != null) 'edited_at': editedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CommentsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<String>? authorId,
    Value<String>? authorName,
    Value<String>? content,
    Value<DateTime>? createdAt,
    Value<DateTime?>? editedAt,
    Value<int>? rowid,
  }) {
    return CommentsTableCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      editedAt: editedAt ?? this.editedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (authorName.present) {
      map['author_name'] = Variable<String>(authorName.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (editedAt.present) {
      map['edited_at'] = Variable<DateTime>(editedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommentsTableCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('authorId: $authorId, ')
          ..write('authorName: $authorName, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('editedAt: $editedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityEntriesTableTable extends ActivityEntriesTable
    with TableInfo<$ActivityEntriesTableTable, ActivityEntriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityEntriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks_table (id)',
    ),
  );
  static const VerificationMeta _actorIdMeta = const VerificationMeta(
    'actorId',
  );
  @override
  late final GeneratedColumn<String> actorId = GeneratedColumn<String>(
    'actor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actorNameMeta = const VerificationMeta(
    'actorName',
  );
  @override
  late final GeneratedColumn<String> actorName = GeneratedColumn<String>(
    'actor_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    actorId,
    actorName,
    action,
    metadata,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_entries_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityEntriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('actor_id')) {
      context.handle(
        _actorIdMeta,
        actorId.isAcceptableOrUnknown(data['actor_id']!, _actorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_actorIdMeta);
    }
    if (data.containsKey('actor_name')) {
      context.handle(
        _actorNameMeta,
        actorName.isAcceptableOrUnknown(data['actor_name']!, _actorNameMeta),
      );
    } else if (isInserting) {
      context.missing(_actorNameMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    } else if (isInserting) {
      context.missing(_metadataMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityEntriesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityEntriesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      actorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor_id'],
      )!,
      actorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor_name'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $ActivityEntriesTableTable createAlias(String alias) {
    return $ActivityEntriesTableTable(attachedDatabase, alias);
  }
}

class ActivityEntriesTableData extends DataClass
    implements Insertable<ActivityEntriesTableData> {
  final String id;
  final String taskId;
  final String actorId;
  final String actorName;
  final String action;
  final String metadata;
  final DateTime timestamp;
  const ActivityEntriesTableData({
    required this.id,
    required this.taskId,
    required this.actorId,
    required this.actorName,
    required this.action,
    required this.metadata,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['actor_id'] = Variable<String>(actorId);
    map['actor_name'] = Variable<String>(actorName);
    map['action'] = Variable<String>(action);
    map['metadata'] = Variable<String>(metadata);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  ActivityEntriesTableCompanion toCompanion(bool nullToAbsent) {
    return ActivityEntriesTableCompanion(
      id: Value(id),
      taskId: Value(taskId),
      actorId: Value(actorId),
      actorName: Value(actorName),
      action: Value(action),
      metadata: Value(metadata),
      timestamp: Value(timestamp),
    );
  }

  factory ActivityEntriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityEntriesTableData(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      actorId: serializer.fromJson<String>(json['actorId']),
      actorName: serializer.fromJson<String>(json['actorName']),
      action: serializer.fromJson<String>(json['action']),
      metadata: serializer.fromJson<String>(json['metadata']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'actorId': serializer.toJson<String>(actorId),
      'actorName': serializer.toJson<String>(actorName),
      'action': serializer.toJson<String>(action),
      'metadata': serializer.toJson<String>(metadata),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  ActivityEntriesTableData copyWith({
    String? id,
    String? taskId,
    String? actorId,
    String? actorName,
    String? action,
    String? metadata,
    DateTime? timestamp,
  }) => ActivityEntriesTableData(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    actorId: actorId ?? this.actorId,
    actorName: actorName ?? this.actorName,
    action: action ?? this.action,
    metadata: metadata ?? this.metadata,
    timestamp: timestamp ?? this.timestamp,
  );
  ActivityEntriesTableData copyWithCompanion(
    ActivityEntriesTableCompanion data,
  ) {
    return ActivityEntriesTableData(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      actorId: data.actorId.present ? data.actorId.value : this.actorId,
      actorName: data.actorName.present ? data.actorName.value : this.actorName,
      action: data.action.present ? data.action.value : this.action,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityEntriesTableData(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('actorId: $actorId, ')
          ..write('actorName: $actorName, ')
          ..write('action: $action, ')
          ..write('metadata: $metadata, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, taskId, actorId, actorName, action, metadata, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityEntriesTableData &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.actorId == this.actorId &&
          other.actorName == this.actorName &&
          other.action == this.action &&
          other.metadata == this.metadata &&
          other.timestamp == this.timestamp);
}

class ActivityEntriesTableCompanion
    extends UpdateCompanion<ActivityEntriesTableData> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> actorId;
  final Value<String> actorName;
  final Value<String> action;
  final Value<String> metadata;
  final Value<DateTime> timestamp;
  final Value<int> rowid;
  const ActivityEntriesTableCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.actorId = const Value.absent(),
    this.actorName = const Value.absent(),
    this.action = const Value.absent(),
    this.metadata = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityEntriesTableCompanion.insert({
    required String id,
    required String taskId,
    required String actorId,
    required String actorName,
    required String action,
    required String metadata,
    required DateTime timestamp,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       actorId = Value(actorId),
       actorName = Value(actorName),
       action = Value(action),
       metadata = Value(metadata),
       timestamp = Value(timestamp);
  static Insertable<ActivityEntriesTableData> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? actorId,
    Expression<String>? actorName,
    Expression<String>? action,
    Expression<String>? metadata,
    Expression<DateTime>? timestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (actorId != null) 'actor_id': actorId,
      if (actorName != null) 'actor_name': actorName,
      if (action != null) 'action': action,
      if (metadata != null) 'metadata': metadata,
      if (timestamp != null) 'timestamp': timestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityEntriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<String>? actorId,
    Value<String>? actorName,
    Value<String>? action,
    Value<String>? metadata,
    Value<DateTime>? timestamp,
    Value<int>? rowid,
  }) {
    return ActivityEntriesTableCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      actorId: actorId ?? this.actorId,
      actorName: actorName ?? this.actorName,
      action: action ?? this.action,
      metadata: metadata ?? this.metadata,
      timestamp: timestamp ?? this.timestamp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (actorId.present) {
      map['actor_id'] = Variable<String>(actorId.value);
    }
    if (actorName.present) {
      map['actor_name'] = Variable<String>(actorName.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityEntriesTableCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('actorId: $actorId, ')
          ..write('actorName: $actorName, ')
          ..write('action: $action, ')
          ..write('metadata: $metadata, ')
          ..write('timestamp: $timestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxTableTable extends OutboxTable
    with TableInfo<$OutboxTableTable, OutboxTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    operation,
    payload,
    clientId,
    createdAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $OutboxTableTable createAlias(String alias) {
    return $OutboxTableTable(attachedDatabase, alias);
  }
}

class OutboxTableData extends DataClass implements Insertable<OutboxTableData> {
  final String id;
  final String taskId;
  final String operation;
  final String payload;
  final String clientId;
  final DateTime createdAt;
  final DateTime? syncedAt;
  const OutboxTableData({
    required this.id,
    required this.taskId,
    required this.operation,
    required this.payload,
    required this.clientId,
    required this.createdAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    map['client_id'] = Variable<String>(clientId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  OutboxTableCompanion toCompanion(bool nullToAbsent) {
    return OutboxTableCompanion(
      id: Value(id),
      taskId: Value(taskId),
      operation: Value(operation),
      payload: Value(payload),
      clientId: Value(clientId),
      createdAt: Value(createdAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory OutboxTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxTableData(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      clientId: serializer.fromJson<String>(json['clientId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'clientId': serializer.toJson<String>(clientId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  OutboxTableData copyWith({
    String? id,
    String? taskId,
    String? operation,
    String? payload,
    String? clientId,
    DateTime? createdAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => OutboxTableData(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    operation: operation ?? this.operation,
    payload: payload ?? this.payload,
    clientId: clientId ?? this.clientId,
    createdAt: createdAt ?? this.createdAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  OutboxTableData copyWithCompanion(OutboxTableCompanion data) {
    return OutboxTableData(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxTableData(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('clientId: $clientId, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskId,
    operation,
    payload,
    clientId,
    createdAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxTableData &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.clientId == this.clientId &&
          other.createdAt == this.createdAt &&
          other.syncedAt == this.syncedAt);
}

class OutboxTableCompanion extends UpdateCompanion<OutboxTableData> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<String> clientId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const OutboxTableCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.clientId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutboxTableCompanion.insert({
    required String id,
    required String taskId,
    required String operation,
    required String payload,
    required String clientId,
    required DateTime createdAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       operation = Value(operation),
       payload = Value(payload),
       clientId = Value(clientId),
       createdAt = Value(createdAt);
  static Insertable<OutboxTableData> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<String>? clientId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (clientId != null) 'client_id': clientId,
      if (createdAt != null) 'created_at': createdAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutboxTableCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<String>? operation,
    Value<String>? payload,
    Value<String>? clientId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return OutboxTableCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      clientId: clientId ?? this.clientId,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxTableCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('clientId: $clientId, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetaTableTable extends SyncMetaTable
    with TableInfo<$SyncMetaTableTable, SyncMetaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetaTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_meta_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetaTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncMetaTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetaTableData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SyncMetaTableTable createAlias(String alias) {
    return $SyncMetaTableTable(attachedDatabase, alias);
  }
}

class SyncMetaTableData extends DataClass
    implements Insertable<SyncMetaTableData> {
  final String key;
  final String value;
  const SyncMetaTableData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SyncMetaTableCompanion toCompanion(bool nullToAbsent) {
    return SyncMetaTableCompanion(key: Value(key), value: Value(value));
  }

  factory SyncMetaTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetaTableData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SyncMetaTableData copyWith({String? key, String? value}) =>
      SyncMetaTableData(key: key ?? this.key, value: value ?? this.value);
  SyncMetaTableData copyWithCompanion(SyncMetaTableCompanion data) {
    return SyncMetaTableData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaTableData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetaTableData &&
          other.key == this.key &&
          other.value == this.value);
}

class SyncMetaTableCompanion extends UpdateCompanion<SyncMetaTableData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SyncMetaTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetaTableCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SyncMetaTableData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetaTableCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SyncMetaTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TasksTableTable tasksTable = $TasksTableTable(this);
  late final $CommentsTableTable commentsTable = $CommentsTableTable(this);
  late final $ActivityEntriesTableTable activityEntriesTable =
      $ActivityEntriesTableTable(this);
  late final $OutboxTableTable outboxTable = $OutboxTableTable(this);
  late final $SyncMetaTableTable syncMetaTable = $SyncMetaTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tasksTable,
    commentsTable,
    activityEntriesTable,
    outboxTable,
    syncMetaTable,
  ];
}

typedef $$TasksTableTableCreateCompanionBuilder =
    TasksTableCompanion Function({
      required String id,
      required String title,
      required String description,
      Value<String?> richDescription,
      required String status,
      required String priority,
      required int boardPosition,
      Value<bool> isPending,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> dueDate,
      Value<int> rowid,
    });
typedef $$TasksTableTableUpdateCompanionBuilder =
    TasksTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> description,
      Value<String?> richDescription,
      Value<String> status,
      Value<String> priority,
      Value<int> boardPosition,
      Value<bool> isPending,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> dueDate,
      Value<int> rowid,
    });

final class $$TasksTableTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTableTable, TasksTableData> {
  $$TasksTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CommentsTableTable, List<CommentsTableData>>
  _commentsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.commentsTable,
    aliasName: $_aliasNameGenerator(db.tasksTable.id, db.commentsTable.taskId),
  );

  $$CommentsTableTableProcessedTableManager get commentsTableRefs {
    final manager = $$CommentsTableTableTableManager(
      $_db,
      $_db.commentsTable,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_commentsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ActivityEntriesTableTable,
    List<ActivityEntriesTableData>
  >
  _activityEntriesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.activityEntriesTable,
        aliasName: $_aliasNameGenerator(
          db.tasksTable.id,
          db.activityEntriesTable.taskId,
        ),
      );

  $$ActivityEntriesTableTableProcessedTableManager
  get activityEntriesTableRefs {
    final manager = $$ActivityEntriesTableTableTableManager(
      $_db,
      $_db.activityEntriesTable,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _activityEntriesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TasksTableTableFilterComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get richDescription => $composableBuilder(
    column: $table.richDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get boardPosition => $composableBuilder(
    column: $table.boardPosition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> commentsTableRefs(
    Expression<bool> Function($$CommentsTableTableFilterComposer f) f,
  ) {
    final $$CommentsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.commentsTable,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CommentsTableTableFilterComposer(
            $db: $db,
            $table: $db.commentsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> activityEntriesTableRefs(
    Expression<bool> Function($$ActivityEntriesTableTableFilterComposer f) f,
  ) {
    final $$ActivityEntriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activityEntriesTable,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivityEntriesTableTableFilterComposer(
            $db: $db,
            $table: $db.activityEntriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get richDescription => $composableBuilder(
    column: $table.richDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get boardPosition => $composableBuilder(
    column: $table.boardPosition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPending => $composableBuilder(
    column: $table.isPending,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get richDescription => $composableBuilder(
    column: $table.richDescription,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get boardPosition => $composableBuilder(
    column: $table.boardPosition,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPending =>
      $composableBuilder(column: $table.isPending, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  Expression<T> commentsTableRefs<T extends Object>(
    Expression<T> Function($$CommentsTableTableAnnotationComposer a) f,
  ) {
    final $$CommentsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.commentsTable,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CommentsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.commentsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> activityEntriesTableRefs<T extends Object>(
    Expression<T> Function($$ActivityEntriesTableTableAnnotationComposer a) f,
  ) {
    final $$ActivityEntriesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activityEntriesTable,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActivityEntriesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.activityEntriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TasksTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTableTable,
          TasksTableData,
          $$TasksTableTableFilterComposer,
          $$TasksTableTableOrderingComposer,
          $$TasksTableTableAnnotationComposer,
          $$TasksTableTableCreateCompanionBuilder,
          $$TasksTableTableUpdateCompanionBuilder,
          (TasksTableData, $$TasksTableTableReferences),
          TasksTableData,
          PrefetchHooks Function({
            bool commentsTableRefs,
            bool activityEntriesTableRefs,
          })
        > {
  $$TasksTableTableTableManager(_$AppDatabase db, $TasksTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> richDescription = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<int> boardPosition = const Value.absent(),
                Value<bool> isPending = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksTableCompanion(
                id: id,
                title: title,
                description: description,
                richDescription: richDescription,
                status: status,
                priority: priority,
                boardPosition: boardPosition,
                isPending: isPending,
                createdAt: createdAt,
                updatedAt: updatedAt,
                dueDate: dueDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String description,
                Value<String?> richDescription = const Value.absent(),
                required String status,
                required String priority,
                required int boardPosition,
                Value<bool> isPending = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> dueDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksTableCompanion.insert(
                id: id,
                title: title,
                description: description,
                richDescription: richDescription,
                status: status,
                priority: priority,
                boardPosition: boardPosition,
                isPending: isPending,
                createdAt: createdAt,
                updatedAt: updatedAt,
                dueDate: dueDate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TasksTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({commentsTableRefs = false, activityEntriesTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (commentsTableRefs) db.commentsTable,
                    if (activityEntriesTableRefs) db.activityEntriesTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (commentsTableRefs)
                        await $_getPrefetchedData<
                          TasksTableData,
                          $TasksTableTable,
                          CommentsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableTableReferences
                              ._commentsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableTableReferences(
                                db,
                                table,
                                p0,
                              ).commentsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (activityEntriesTableRefs)
                        await $_getPrefetchedData<
                          TasksTableData,
                          $TasksTableTable,
                          ActivityEntriesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableTableReferences
                              ._activityEntriesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableTableReferences(
                                db,
                                table,
                                p0,
                              ).activityEntriesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TasksTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTableTable,
      TasksTableData,
      $$TasksTableTableFilterComposer,
      $$TasksTableTableOrderingComposer,
      $$TasksTableTableAnnotationComposer,
      $$TasksTableTableCreateCompanionBuilder,
      $$TasksTableTableUpdateCompanionBuilder,
      (TasksTableData, $$TasksTableTableReferences),
      TasksTableData,
      PrefetchHooks Function({
        bool commentsTableRefs,
        bool activityEntriesTableRefs,
      })
    >;
typedef $$CommentsTableTableCreateCompanionBuilder =
    CommentsTableCompanion Function({
      required String id,
      required String taskId,
      required String authorId,
      required String authorName,
      required String content,
      required DateTime createdAt,
      Value<DateTime?> editedAt,
      Value<int> rowid,
    });
typedef $$CommentsTableTableUpdateCompanionBuilder =
    CommentsTableCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<String> authorId,
      Value<String> authorName,
      Value<String> content,
      Value<DateTime> createdAt,
      Value<DateTime?> editedAt,
      Value<int> rowid,
    });

final class $$CommentsTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $CommentsTableTable, CommentsTableData> {
  $$CommentsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TasksTableTable _taskIdTable(_$AppDatabase db) =>
      db.tasksTable.createAlias(
        $_aliasNameGenerator(db.commentsTable.taskId, db.tasksTable.id),
      );

  $$TasksTableTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableTableManager(
      $_db,
      $_db.tasksTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CommentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CommentsTableTable> {
  $$CommentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get editedAt => $composableBuilder(
    column: $table.editedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableTableFilterComposer get taskId {
    final $$TasksTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableFilterComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CommentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CommentsTableTable> {
  $$CommentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get editedAt => $composableBuilder(
    column: $table.editedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableTableOrderingComposer get taskId {
    final $$TasksTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableOrderingComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CommentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CommentsTableTable> {
  $$CommentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get editedAt =>
      $composableBuilder(column: $table.editedAt, builder: (column) => column);

  $$TasksTableTableAnnotationComposer get taskId {
    final $$TasksTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CommentsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CommentsTableTable,
          CommentsTableData,
          $$CommentsTableTableFilterComposer,
          $$CommentsTableTableOrderingComposer,
          $$CommentsTableTableAnnotationComposer,
          $$CommentsTableTableCreateCompanionBuilder,
          $$CommentsTableTableUpdateCompanionBuilder,
          (CommentsTableData, $$CommentsTableTableReferences),
          CommentsTableData,
          PrefetchHooks Function({bool taskId})
        > {
  $$CommentsTableTableTableManager(_$AppDatabase db, $CommentsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CommentsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CommentsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CommentsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String> authorId = const Value.absent(),
                Value<String> authorName = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> editedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CommentsTableCompanion(
                id: id,
                taskId: taskId,
                authorId: authorId,
                authorName: authorName,
                content: content,
                createdAt: createdAt,
                editedAt: editedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required String authorId,
                required String authorName,
                required String content,
                required DateTime createdAt,
                Value<DateTime?> editedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CommentsTableCompanion.insert(
                id: id,
                taskId: taskId,
                authorId: authorId,
                authorName: authorName,
                content: content,
                createdAt: createdAt,
                editedAt: editedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CommentsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable: $$CommentsTableTableReferences
                                    ._taskIdTable(db),
                                referencedColumn: $$CommentsTableTableReferences
                                    ._taskIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CommentsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CommentsTableTable,
      CommentsTableData,
      $$CommentsTableTableFilterComposer,
      $$CommentsTableTableOrderingComposer,
      $$CommentsTableTableAnnotationComposer,
      $$CommentsTableTableCreateCompanionBuilder,
      $$CommentsTableTableUpdateCompanionBuilder,
      (CommentsTableData, $$CommentsTableTableReferences),
      CommentsTableData,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$ActivityEntriesTableTableCreateCompanionBuilder =
    ActivityEntriesTableCompanion Function({
      required String id,
      required String taskId,
      required String actorId,
      required String actorName,
      required String action,
      required String metadata,
      required DateTime timestamp,
      Value<int> rowid,
    });
typedef $$ActivityEntriesTableTableUpdateCompanionBuilder =
    ActivityEntriesTableCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<String> actorId,
      Value<String> actorName,
      Value<String> action,
      Value<String> metadata,
      Value<DateTime> timestamp,
      Value<int> rowid,
    });

final class $$ActivityEntriesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ActivityEntriesTableTable,
          ActivityEntriesTableData
        > {
  $$ActivityEntriesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TasksTableTable _taskIdTable(_$AppDatabase db) =>
      db.tasksTable.createAlias(
        $_aliasNameGenerator(db.activityEntriesTable.taskId, db.tasksTable.id),
      );

  $$TasksTableTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableTableManager(
      $_db,
      $_db.tasksTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ActivityEntriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityEntriesTableTable> {
  $$ActivityEntriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actorId => $composableBuilder(
    column: $table.actorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actorName => $composableBuilder(
    column: $table.actorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableTableFilterComposer get taskId {
    final $$TasksTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableFilterComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityEntriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityEntriesTableTable> {
  $$ActivityEntriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actorId => $composableBuilder(
    column: $table.actorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actorName => $composableBuilder(
    column: $table.actorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableTableOrderingComposer get taskId {
    final $$TasksTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableOrderingComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityEntriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityEntriesTableTable> {
  $$ActivityEntriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get actorId =>
      $composableBuilder(column: $table.actorId, builder: (column) => column);

  GeneratedColumn<String> get actorName =>
      $composableBuilder(column: $table.actorName, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  $$TasksTableTableAnnotationComposer get taskId {
    final $$TasksTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityEntriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityEntriesTableTable,
          ActivityEntriesTableData,
          $$ActivityEntriesTableTableFilterComposer,
          $$ActivityEntriesTableTableOrderingComposer,
          $$ActivityEntriesTableTableAnnotationComposer,
          $$ActivityEntriesTableTableCreateCompanionBuilder,
          $$ActivityEntriesTableTableUpdateCompanionBuilder,
          (ActivityEntriesTableData, $$ActivityEntriesTableTableReferences),
          ActivityEntriesTableData,
          PrefetchHooks Function({bool taskId})
        > {
  $$ActivityEntriesTableTableTableManager(
    _$AppDatabase db,
    $ActivityEntriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityEntriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityEntriesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ActivityEntriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String> actorId = const Value.absent(),
                Value<String> actorName = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> metadata = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityEntriesTableCompanion(
                id: id,
                taskId: taskId,
                actorId: actorId,
                actorName: actorName,
                action: action,
                metadata: metadata,
                timestamp: timestamp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required String actorId,
                required String actorName,
                required String action,
                required String metadata,
                required DateTime timestamp,
                Value<int> rowid = const Value.absent(),
              }) => ActivityEntriesTableCompanion.insert(
                id: id,
                taskId: taskId,
                actorId: actorId,
                actorName: actorName,
                action: action,
                metadata: metadata,
                timestamp: timestamp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActivityEntriesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable:
                                    $$ActivityEntriesTableTableReferences
                                        ._taskIdTable(db),
                                referencedColumn:
                                    $$ActivityEntriesTableTableReferences
                                        ._taskIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ActivityEntriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityEntriesTableTable,
      ActivityEntriesTableData,
      $$ActivityEntriesTableTableFilterComposer,
      $$ActivityEntriesTableTableOrderingComposer,
      $$ActivityEntriesTableTableAnnotationComposer,
      $$ActivityEntriesTableTableCreateCompanionBuilder,
      $$ActivityEntriesTableTableUpdateCompanionBuilder,
      (ActivityEntriesTableData, $$ActivityEntriesTableTableReferences),
      ActivityEntriesTableData,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$OutboxTableTableCreateCompanionBuilder =
    OutboxTableCompanion Function({
      required String id,
      required String taskId,
      required String operation,
      required String payload,
      required String clientId,
      required DateTime createdAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$OutboxTableTableUpdateCompanionBuilder =
    OutboxTableCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<String> operation,
      Value<String> payload,
      Value<String> clientId,
      Value<DateTime> createdAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$OutboxTableTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxTableTable> {
  $$OutboxTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxTableTable> {
  $$OutboxTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxTableTable> {
  $$OutboxTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$OutboxTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxTableTable,
          OutboxTableData,
          $$OutboxTableTableFilterComposer,
          $$OutboxTableTableOrderingComposer,
          $$OutboxTableTableAnnotationComposer,
          $$OutboxTableTableCreateCompanionBuilder,
          $$OutboxTableTableUpdateCompanionBuilder,
          (
            OutboxTableData,
            BaseReferences<_$AppDatabase, $OutboxTableTable, OutboxTableData>,
          ),
          OutboxTableData,
          PrefetchHooks Function()
        > {
  $$OutboxTableTableTableManager(_$AppDatabase db, $OutboxTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxTableCompanion(
                id: id,
                taskId: taskId,
                operation: operation,
                payload: payload,
                clientId: clientId,
                createdAt: createdAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required String operation,
                required String payload,
                required String clientId,
                required DateTime createdAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxTableCompanion.insert(
                id: id,
                taskId: taskId,
                operation: operation,
                payload: payload,
                clientId: clientId,
                createdAt: createdAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxTableTable,
      OutboxTableData,
      $$OutboxTableTableFilterComposer,
      $$OutboxTableTableOrderingComposer,
      $$OutboxTableTableAnnotationComposer,
      $$OutboxTableTableCreateCompanionBuilder,
      $$OutboxTableTableUpdateCompanionBuilder,
      (
        OutboxTableData,
        BaseReferences<_$AppDatabase, $OutboxTableTable, OutboxTableData>,
      ),
      OutboxTableData,
      PrefetchHooks Function()
    >;
typedef $$SyncMetaTableTableCreateCompanionBuilder =
    SyncMetaTableCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SyncMetaTableTableUpdateCompanionBuilder =
    SyncMetaTableCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SyncMetaTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetaTableTable> {
  $$SyncMetaTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetaTableTable> {
  $$SyncMetaTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetaTableTable> {
  $$SyncMetaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SyncMetaTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetaTableTable,
          SyncMetaTableData,
          $$SyncMetaTableTableFilterComposer,
          $$SyncMetaTableTableOrderingComposer,
          $$SyncMetaTableTableAnnotationComposer,
          $$SyncMetaTableTableCreateCompanionBuilder,
          $$SyncMetaTableTableUpdateCompanionBuilder,
          (
            SyncMetaTableData,
            BaseReferences<
              _$AppDatabase,
              $SyncMetaTableTable,
              SyncMetaTableData
            >,
          ),
          SyncMetaTableData,
          PrefetchHooks Function()
        > {
  $$SyncMetaTableTableTableManager(_$AppDatabase db, $SyncMetaTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetaTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetaTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetaTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) =>
                  SyncMetaTableCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SyncMetaTableCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetaTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetaTableTable,
      SyncMetaTableData,
      $$SyncMetaTableTableFilterComposer,
      $$SyncMetaTableTableOrderingComposer,
      $$SyncMetaTableTableAnnotationComposer,
      $$SyncMetaTableTableCreateCompanionBuilder,
      $$SyncMetaTableTableUpdateCompanionBuilder,
      (
        SyncMetaTableData,
        BaseReferences<_$AppDatabase, $SyncMetaTableTable, SyncMetaTableData>,
      ),
      SyncMetaTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TasksTableTableTableManager get tasksTable =>
      $$TasksTableTableTableManager(_db, _db.tasksTable);
  $$CommentsTableTableTableManager get commentsTable =>
      $$CommentsTableTableTableManager(_db, _db.commentsTable);
  $$ActivityEntriesTableTableTableManager get activityEntriesTable =>
      $$ActivityEntriesTableTableTableManager(_db, _db.activityEntriesTable);
  $$OutboxTableTableTableManager get outboxTable =>
      $$OutboxTableTableTableManager(_db, _db.outboxTable);
  $$SyncMetaTableTableTableManager get syncMetaTable =>
      $$SyncMetaTableTableTableManager(_db, _db.syncMetaTable);
}
