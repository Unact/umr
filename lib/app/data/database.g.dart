// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
      'version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, username, email, version];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String username;
  final String email;
  final String version;
  const User(
      {required this.id,
      required this.username,
      required this.email,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['email'] = Variable<String>(email);
    map['version'] = Variable<String>(version);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      email: Value(email),
      version: Value(version),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      email: serializer.fromJson<String>(json['email']),
      version: serializer.fromJson<String>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'email': serializer.toJson<String>(email),
      'version': serializer.toJson<String>(version),
    };
  }

  User copyWith({int? id, String? username, String? email, String? version}) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        version: version ?? this.version,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      email: data.email.present ? data.email.value : this.email,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, username, email, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.email == this.email &&
          other.version == this.version);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> email;
  final Value<String> version;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.email = const Value.absent(),
    this.version = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String email,
    required String version,
  })  : username = Value(username),
        email = Value(email),
        version = Value(version);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? email,
    Expression<String>? version,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (version != null) 'version': version,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? username,
      Value<String>? email,
      Value<String>? version}) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      version: version ?? this.version,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }
}

class $SaleOrderLineCodesTable extends SaleOrderLineCodes
    with TableInfo<$SaleOrderLineCodesTable, SaleOrderLineCode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleOrderLineCodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _subidMeta = const VerificationMeta('subid');
  @override
  late final GeneratedColumn<int> subid = GeneratedColumn<int>(
      'subid', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
      'type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _volMeta = const VerificationMeta('vol');
  @override
  late final GeneratedColumn<double> vol = GeneratedColumn<double>(
      'vol', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _isTrackingMeta =
      const VerificationMeta('isTracking');
  @override
  late final GeneratedColumn<bool> isTracking = GeneratedColumn<bool>(
      'is_tracking', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_tracking" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, subid, type, code, vol, isTracking];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_order_line_codes';
  @override
  VerificationContext validateIntegrity(Insertable<SaleOrderLineCode> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subid')) {
      context.handle(
          _subidMeta, subid.isAcceptableOrUnknown(data['subid']!, _subidMeta));
    } else if (isInserting) {
      context.missing(_subidMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('vol')) {
      context.handle(
          _volMeta, vol.isAcceptableOrUnknown(data['vol']!, _volMeta));
    } else if (isInserting) {
      context.missing(_volMeta);
    }
    if (data.containsKey('is_tracking')) {
      context.handle(
          _isTrackingMeta,
          isTracking.isAcceptableOrUnknown(
              data['is_tracking']!, _isTrackingMeta));
    } else if (isInserting) {
      context.missing(_isTrackingMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, subid, type, code};
  @override
  SaleOrderLineCode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleOrderLineCode(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      subid: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}subid'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      vol: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vol'])!,
      isTracking: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_tracking'])!,
    );
  }

  @override
  $SaleOrderLineCodesTable createAlias(String alias) {
    return $SaleOrderLineCodesTable(attachedDatabase, alias);
  }
}

class SaleOrderLineCode extends DataClass
    implements Insertable<SaleOrderLineCode> {
  final int id;
  final int subid;
  final int type;
  final String code;
  final double vol;
  final bool isTracking;
  const SaleOrderLineCode(
      {required this.id,
      required this.subid,
      required this.type,
      required this.code,
      required this.vol,
      required this.isTracking});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['subid'] = Variable<int>(subid);
    map['type'] = Variable<int>(type);
    map['code'] = Variable<String>(code);
    map['vol'] = Variable<double>(vol);
    map['is_tracking'] = Variable<bool>(isTracking);
    return map;
  }

  SaleOrderLineCodesCompanion toCompanion(bool nullToAbsent) {
    return SaleOrderLineCodesCompanion(
      id: Value(id),
      subid: Value(subid),
      type: Value(type),
      code: Value(code),
      vol: Value(vol),
      isTracking: Value(isTracking),
    );
  }

  factory SaleOrderLineCode.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleOrderLineCode(
      id: serializer.fromJson<int>(json['id']),
      subid: serializer.fromJson<int>(json['subid']),
      type: serializer.fromJson<int>(json['type']),
      code: serializer.fromJson<String>(json['code']),
      vol: serializer.fromJson<double>(json['vol']),
      isTracking: serializer.fromJson<bool>(json['isTracking']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'subid': serializer.toJson<int>(subid),
      'type': serializer.toJson<int>(type),
      'code': serializer.toJson<String>(code),
      'vol': serializer.toJson<double>(vol),
      'isTracking': serializer.toJson<bool>(isTracking),
    };
  }

  SaleOrderLineCode copyWith(
          {int? id,
          int? subid,
          int? type,
          String? code,
          double? vol,
          bool? isTracking}) =>
      SaleOrderLineCode(
        id: id ?? this.id,
        subid: subid ?? this.subid,
        type: type ?? this.type,
        code: code ?? this.code,
        vol: vol ?? this.vol,
        isTracking: isTracking ?? this.isTracking,
      );
  SaleOrderLineCode copyWithCompanion(SaleOrderLineCodesCompanion data) {
    return SaleOrderLineCode(
      id: data.id.present ? data.id.value : this.id,
      subid: data.subid.present ? data.subid.value : this.subid,
      type: data.type.present ? data.type.value : this.type,
      code: data.code.present ? data.code.value : this.code,
      vol: data.vol.present ? data.vol.value : this.vol,
      isTracking:
          data.isTracking.present ? data.isTracking.value : this.isTracking,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleOrderLineCode(')
          ..write('id: $id, ')
          ..write('subid: $subid, ')
          ..write('type: $type, ')
          ..write('code: $code, ')
          ..write('vol: $vol, ')
          ..write('isTracking: $isTracking')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, subid, type, code, vol, isTracking);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleOrderLineCode &&
          other.id == this.id &&
          other.subid == this.subid &&
          other.type == this.type &&
          other.code == this.code &&
          other.vol == this.vol &&
          other.isTracking == this.isTracking);
}

class SaleOrderLineCodesCompanion extends UpdateCompanion<SaleOrderLineCode> {
  final Value<int> id;
  final Value<int> subid;
  final Value<int> type;
  final Value<String> code;
  final Value<double> vol;
  final Value<bool> isTracking;
  final Value<int> rowid;
  const SaleOrderLineCodesCompanion({
    this.id = const Value.absent(),
    this.subid = const Value.absent(),
    this.type = const Value.absent(),
    this.code = const Value.absent(),
    this.vol = const Value.absent(),
    this.isTracking = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SaleOrderLineCodesCompanion.insert({
    required int id,
    required int subid,
    required int type,
    required String code,
    required double vol,
    required bool isTracking,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        subid = Value(subid),
        type = Value(type),
        code = Value(code),
        vol = Value(vol),
        isTracking = Value(isTracking);
  static Insertable<SaleOrderLineCode> custom({
    Expression<int>? id,
    Expression<int>? subid,
    Expression<int>? type,
    Expression<String>? code,
    Expression<double>? vol,
    Expression<bool>? isTracking,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subid != null) 'subid': subid,
      if (type != null) 'type': type,
      if (code != null) 'code': code,
      if (vol != null) 'vol': vol,
      if (isTracking != null) 'is_tracking': isTracking,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SaleOrderLineCodesCompanion copyWith(
      {Value<int>? id,
      Value<int>? subid,
      Value<int>? type,
      Value<String>? code,
      Value<double>? vol,
      Value<bool>? isTracking,
      Value<int>? rowid}) {
    return SaleOrderLineCodesCompanion(
      id: id ?? this.id,
      subid: subid ?? this.subid,
      type: type ?? this.type,
      code: code ?? this.code,
      vol: vol ?? this.vol,
      isTracking: isTracking ?? this.isTracking,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (subid.present) {
      map['subid'] = Variable<int>(subid.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (vol.present) {
      map['vol'] = Variable<double>(vol.value);
    }
    if (isTracking.present) {
      map['is_tracking'] = Variable<bool>(isTracking.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleOrderLineCodesCompanion(')
          ..write('id: $id, ')
          ..write('subid: $subid, ')
          ..write('type: $type, ')
          ..write('code: $code, ')
          ..write('vol: $vol, ')
          ..write('isTracking: $isTracking, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDataStore extends GeneratedDatabase {
  _$AppDataStore(QueryExecutor e) : super(e);
  $AppDataStoreManager get managers => $AppDataStoreManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $SaleOrderLineCodesTable saleOrderLineCodes =
      $SaleOrderLineCodesTable(this);
  late final UsersDao usersDao = UsersDao(this as AppDataStore);
  late final SaleOrdersDao saleOrdersDao = SaleOrdersDao(this as AppDataStore);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [users, saleOrderLineCodes];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String username,
  required String email,
  required String version,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> username,
  Value<String> email,
  Value<String> version,
});

class $$UsersTableFilterComposer extends Composer<_$AppDataStore, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDataStore, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDataStore, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDataStore,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDataStore, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDataStore db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> version = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            username: username,
            email: email,
            version: version,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String username,
            required String email,
            required String version,
          }) =>
              UsersCompanion.insert(
            id: id,
            username: username,
            email: email,
            version: version,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDataStore,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDataStore, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;
typedef $$SaleOrderLineCodesTableCreateCompanionBuilder
    = SaleOrderLineCodesCompanion Function({
  required int id,
  required int subid,
  required int type,
  required String code,
  required double vol,
  required bool isTracking,
  Value<int> rowid,
});
typedef $$SaleOrderLineCodesTableUpdateCompanionBuilder
    = SaleOrderLineCodesCompanion Function({
  Value<int> id,
  Value<int> subid,
  Value<int> type,
  Value<String> code,
  Value<double> vol,
  Value<bool> isTracking,
  Value<int> rowid,
});

class $$SaleOrderLineCodesTableFilterComposer
    extends Composer<_$AppDataStore, $SaleOrderLineCodesTable> {
  $$SaleOrderLineCodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get subid => $composableBuilder(
      column: $table.subid, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get vol => $composableBuilder(
      column: $table.vol, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isTracking => $composableBuilder(
      column: $table.isTracking, builder: (column) => ColumnFilters(column));
}

class $$SaleOrderLineCodesTableOrderingComposer
    extends Composer<_$AppDataStore, $SaleOrderLineCodesTable> {
  $$SaleOrderLineCodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get subid => $composableBuilder(
      column: $table.subid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get vol => $composableBuilder(
      column: $table.vol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isTracking => $composableBuilder(
      column: $table.isTracking, builder: (column) => ColumnOrderings(column));
}

class $$SaleOrderLineCodesTableAnnotationComposer
    extends Composer<_$AppDataStore, $SaleOrderLineCodesTable> {
  $$SaleOrderLineCodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get subid =>
      $composableBuilder(column: $table.subid, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<double> get vol =>
      $composableBuilder(column: $table.vol, builder: (column) => column);

  GeneratedColumn<bool> get isTracking => $composableBuilder(
      column: $table.isTracking, builder: (column) => column);
}

class $$SaleOrderLineCodesTableTableManager extends RootTableManager<
    _$AppDataStore,
    $SaleOrderLineCodesTable,
    SaleOrderLineCode,
    $$SaleOrderLineCodesTableFilterComposer,
    $$SaleOrderLineCodesTableOrderingComposer,
    $$SaleOrderLineCodesTableAnnotationComposer,
    $$SaleOrderLineCodesTableCreateCompanionBuilder,
    $$SaleOrderLineCodesTableUpdateCompanionBuilder,
    (
      SaleOrderLineCode,
      BaseReferences<_$AppDataStore, $SaleOrderLineCodesTable,
          SaleOrderLineCode>
    ),
    SaleOrderLineCode,
    PrefetchHooks Function()> {
  $$SaleOrderLineCodesTableTableManager(
      _$AppDataStore db, $SaleOrderLineCodesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleOrderLineCodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleOrderLineCodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleOrderLineCodesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> subid = const Value.absent(),
            Value<int> type = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<double> vol = const Value.absent(),
            Value<bool> isTracking = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SaleOrderLineCodesCompanion(
            id: id,
            subid: subid,
            type: type,
            code: code,
            vol: vol,
            isTracking: isTracking,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int id,
            required int subid,
            required int type,
            required String code,
            required double vol,
            required bool isTracking,
            Value<int> rowid = const Value.absent(),
          }) =>
              SaleOrderLineCodesCompanion.insert(
            id: id,
            subid: subid,
            type: type,
            code: code,
            vol: vol,
            isTracking: isTracking,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SaleOrderLineCodesTableProcessedTableManager = ProcessedTableManager<
    _$AppDataStore,
    $SaleOrderLineCodesTable,
    SaleOrderLineCode,
    $$SaleOrderLineCodesTableFilterComposer,
    $$SaleOrderLineCodesTableOrderingComposer,
    $$SaleOrderLineCodesTableAnnotationComposer,
    $$SaleOrderLineCodesTableCreateCompanionBuilder,
    $$SaleOrderLineCodesTableUpdateCompanionBuilder,
    (
      SaleOrderLineCode,
      BaseReferences<_$AppDataStore, $SaleOrderLineCodesTable,
          SaleOrderLineCode>
    ),
    SaleOrderLineCode,
    PrefetchHooks Function()>;

class $AppDataStoreManager {
  final _$AppDataStore _db;
  $AppDataStoreManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$SaleOrderLineCodesTableTableManager get saleOrderLineCodes =>
      $$SaleOrderLineCodesTableTableManager(_db, _db.saleOrderLineCodes);
}

mixin _$UsersDaoMixin on DatabaseAccessor<AppDataStore> {
  $UsersTable get users => attachedDatabase.users;
}
mixin _$SaleOrdersDaoMixin on DatabaseAccessor<AppDataStore> {
  $SaleOrderLineCodesTable get saleOrderLineCodes =>
      attachedDatabase.saleOrderLineCodes;
}
