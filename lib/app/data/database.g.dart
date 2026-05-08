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
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, username, email, version];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
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
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      username:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}username'],
          )!,
      email:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}email'],
          )!,
      version:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}version'],
          )!,
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
  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.version,
  });
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

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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
  }) : username = Value(username),
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

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? username,
    Value<String>? email,
    Value<String>? version,
  }) {
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

class $SupplyLineCodesTable extends SupplyLineCodes
    with TableInfo<$SupplyLineCodesTable, SupplyLineCode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplyLineCodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subidMeta = const VerificationMeta('subid');
  @override
  late final GeneratedColumn<int> subid = GeneratedColumn<int>(
    'subid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _volMeta = const VerificationMeta('vol');
  @override
  late final GeneratedColumn<double> vol = GeneratedColumn<double>(
    'vol',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localTsMeta = const VerificationMeta(
    'localTs',
  );
  @override
  late final GeneratedColumn<DateTime> localTs = GeneratedColumn<DateTime>(
    'local_ts',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, subid, code, vol, localTs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supply_line_codes';
  @override
  VerificationContext validateIntegrity(
    Insertable<SupplyLineCode> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subid')) {
      context.handle(
        _subidMeta,
        subid.isAcceptableOrUnknown(data['subid']!, _subidMeta),
      );
    } else if (isInserting) {
      context.missing(_subidMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('vol')) {
      context.handle(
        _volMeta,
        vol.isAcceptableOrUnknown(data['vol']!, _volMeta),
      );
    } else if (isInserting) {
      context.missing(_volMeta);
    }
    if (data.containsKey('local_ts')) {
      context.handle(
        _localTsMeta,
        localTs.isAcceptableOrUnknown(data['local_ts']!, _localTsMeta),
      );
    } else if (isInserting) {
      context.missing(_localTsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, subid, code};
  @override
  SupplyLineCode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplyLineCode(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      subid:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}subid'],
          )!,
      code:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}code'],
          )!,
      vol:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}vol'],
          )!,
      localTs:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}local_ts'],
          )!,
    );
  }

  @override
  $SupplyLineCodesTable createAlias(String alias) {
    return $SupplyLineCodesTable(attachedDatabase, alias);
  }
}

class SupplyLineCode extends DataClass implements Insertable<SupplyLineCode> {
  final int id;
  final int subid;
  final String code;
  final double vol;
  final DateTime localTs;
  const SupplyLineCode({
    required this.id,
    required this.subid,
    required this.code,
    required this.vol,
    required this.localTs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['subid'] = Variable<int>(subid);
    map['code'] = Variable<String>(code);
    map['vol'] = Variable<double>(vol);
    map['local_ts'] = Variable<DateTime>(localTs);
    return map;
  }

  SupplyLineCodesCompanion toCompanion(bool nullToAbsent) {
    return SupplyLineCodesCompanion(
      id: Value(id),
      subid: Value(subid),
      code: Value(code),
      vol: Value(vol),
      localTs: Value(localTs),
    );
  }

  factory SupplyLineCode.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplyLineCode(
      id: serializer.fromJson<int>(json['id']),
      subid: serializer.fromJson<int>(json['subid']),
      code: serializer.fromJson<String>(json['code']),
      vol: serializer.fromJson<double>(json['vol']),
      localTs: serializer.fromJson<DateTime>(json['localTs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'subid': serializer.toJson<int>(subid),
      'code': serializer.toJson<String>(code),
      'vol': serializer.toJson<double>(vol),
      'localTs': serializer.toJson<DateTime>(localTs),
    };
  }

  SupplyLineCode copyWith({
    int? id,
    int? subid,
    String? code,
    double? vol,
    DateTime? localTs,
  }) => SupplyLineCode(
    id: id ?? this.id,
    subid: subid ?? this.subid,
    code: code ?? this.code,
    vol: vol ?? this.vol,
    localTs: localTs ?? this.localTs,
  );
  SupplyLineCode copyWithCompanion(SupplyLineCodesCompanion data) {
    return SupplyLineCode(
      id: data.id.present ? data.id.value : this.id,
      subid: data.subid.present ? data.subid.value : this.subid,
      code: data.code.present ? data.code.value : this.code,
      vol: data.vol.present ? data.vol.value : this.vol,
      localTs: data.localTs.present ? data.localTs.value : this.localTs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplyLineCode(')
          ..write('id: $id, ')
          ..write('subid: $subid, ')
          ..write('code: $code, ')
          ..write('vol: $vol, ')
          ..write('localTs: $localTs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, subid, code, vol, localTs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplyLineCode &&
          other.id == this.id &&
          other.subid == this.subid &&
          other.code == this.code &&
          other.vol == this.vol &&
          other.localTs == this.localTs);
}

class SupplyLineCodesCompanion extends UpdateCompanion<SupplyLineCode> {
  final Value<int> id;
  final Value<int> subid;
  final Value<String> code;
  final Value<double> vol;
  final Value<DateTime> localTs;
  final Value<int> rowid;
  const SupplyLineCodesCompanion({
    this.id = const Value.absent(),
    this.subid = const Value.absent(),
    this.code = const Value.absent(),
    this.vol = const Value.absent(),
    this.localTs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SupplyLineCodesCompanion.insert({
    required int id,
    required int subid,
    required String code,
    required double vol,
    required DateTime localTs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subid = Value(subid),
       code = Value(code),
       vol = Value(vol),
       localTs = Value(localTs);
  static Insertable<SupplyLineCode> custom({
    Expression<int>? id,
    Expression<int>? subid,
    Expression<String>? code,
    Expression<double>? vol,
    Expression<DateTime>? localTs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subid != null) 'subid': subid,
      if (code != null) 'code': code,
      if (vol != null) 'vol': vol,
      if (localTs != null) 'local_ts': localTs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SupplyLineCodesCompanion copyWith({
    Value<int>? id,
    Value<int>? subid,
    Value<String>? code,
    Value<double>? vol,
    Value<DateTime>? localTs,
    Value<int>? rowid,
  }) {
    return SupplyLineCodesCompanion(
      id: id ?? this.id,
      subid: subid ?? this.subid,
      code: code ?? this.code,
      vol: vol ?? this.vol,
      localTs: localTs ?? this.localTs,
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
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (vol.present) {
      map['vol'] = Variable<double>(vol.value);
    }
    if (localTs.present) {
      map['local_ts'] = Variable<DateTime>(localTs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupplyLineCodesCompanion(')
          ..write('id: $id, ')
          ..write('subid: $subid, ')
          ..write('code: $code, ')
          ..write('vol: $vol, ')
          ..write('localTs: $localTs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SupplyLineCodeDetailsTable extends SupplyLineCodeDetails
    with TableInfo<$SupplyLineCodeDetailsTable, SupplyLineCodeDetail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplyLineCodeDetailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subidMeta = const VerificationMeta('subid');
  @override
  late final GeneratedColumn<int> subid = GeneratedColumn<int>(
    'subid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cisMeta = const VerificationMeta('cis');
  @override
  late final GeneratedColumn<String> cis = GeneratedColumn<String>(
    'cis',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentMeta = const VerificationMeta('parent');
  @override
  late final GeneratedColumn<String> parent = GeneratedColumn<String>(
    'parent',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _initiatorMeta = const VerificationMeta(
    'initiator',
  );
  @override
  late final GeneratedColumn<String> initiator = GeneratedColumn<String>(
    'initiator',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, subid, cis, parent, initiator];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supply_line_code_details';
  @override
  VerificationContext validateIntegrity(
    Insertable<SupplyLineCodeDetail> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subid')) {
      context.handle(
        _subidMeta,
        subid.isAcceptableOrUnknown(data['subid']!, _subidMeta),
      );
    } else if (isInserting) {
      context.missing(_subidMeta);
    }
    if (data.containsKey('cis')) {
      context.handle(
        _cisMeta,
        cis.isAcceptableOrUnknown(data['cis']!, _cisMeta),
      );
    } else if (isInserting) {
      context.missing(_cisMeta);
    }
    if (data.containsKey('parent')) {
      context.handle(
        _parentMeta,
        parent.isAcceptableOrUnknown(data['parent']!, _parentMeta),
      );
    }
    if (data.containsKey('initiator')) {
      context.handle(
        _initiatorMeta,
        initiator.isAcceptableOrUnknown(data['initiator']!, _initiatorMeta),
      );
    } else if (isInserting) {
      context.missing(_initiatorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, subid, cis};
  @override
  SupplyLineCodeDetail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplyLineCodeDetail(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      subid:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}subid'],
          )!,
      cis:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}cis'],
          )!,
      parent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent'],
      ),
      initiator:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}initiator'],
          )!,
    );
  }

  @override
  $SupplyLineCodeDetailsTable createAlias(String alias) {
    return $SupplyLineCodeDetailsTable(attachedDatabase, alias);
  }
}

class SupplyLineCodeDetail extends DataClass
    implements Insertable<SupplyLineCodeDetail> {
  final int id;
  final int subid;
  final String cis;
  final String? parent;
  final String initiator;
  const SupplyLineCodeDetail({
    required this.id,
    required this.subid,
    required this.cis,
    this.parent,
    required this.initiator,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['subid'] = Variable<int>(subid);
    map['cis'] = Variable<String>(cis);
    if (!nullToAbsent || parent != null) {
      map['parent'] = Variable<String>(parent);
    }
    map['initiator'] = Variable<String>(initiator);
    return map;
  }

  SupplyLineCodeDetailsCompanion toCompanion(bool nullToAbsent) {
    return SupplyLineCodeDetailsCompanion(
      id: Value(id),
      subid: Value(subid),
      cis: Value(cis),
      parent:
          parent == null && nullToAbsent ? const Value.absent() : Value(parent),
      initiator: Value(initiator),
    );
  }

  factory SupplyLineCodeDetail.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplyLineCodeDetail(
      id: serializer.fromJson<int>(json['id']),
      subid: serializer.fromJson<int>(json['subid']),
      cis: serializer.fromJson<String>(json['cis']),
      parent: serializer.fromJson<String?>(json['parent']),
      initiator: serializer.fromJson<String>(json['initiator']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'subid': serializer.toJson<int>(subid),
      'cis': serializer.toJson<String>(cis),
      'parent': serializer.toJson<String?>(parent),
      'initiator': serializer.toJson<String>(initiator),
    };
  }

  SupplyLineCodeDetail copyWith({
    int? id,
    int? subid,
    String? cis,
    Value<String?> parent = const Value.absent(),
    String? initiator,
  }) => SupplyLineCodeDetail(
    id: id ?? this.id,
    subid: subid ?? this.subid,
    cis: cis ?? this.cis,
    parent: parent.present ? parent.value : this.parent,
    initiator: initiator ?? this.initiator,
  );
  SupplyLineCodeDetail copyWithCompanion(SupplyLineCodeDetailsCompanion data) {
    return SupplyLineCodeDetail(
      id: data.id.present ? data.id.value : this.id,
      subid: data.subid.present ? data.subid.value : this.subid,
      cis: data.cis.present ? data.cis.value : this.cis,
      parent: data.parent.present ? data.parent.value : this.parent,
      initiator: data.initiator.present ? data.initiator.value : this.initiator,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplyLineCodeDetail(')
          ..write('id: $id, ')
          ..write('subid: $subid, ')
          ..write('cis: $cis, ')
          ..write('parent: $parent, ')
          ..write('initiator: $initiator')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, subid, cis, parent, initiator);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplyLineCodeDetail &&
          other.id == this.id &&
          other.subid == this.subid &&
          other.cis == this.cis &&
          other.parent == this.parent &&
          other.initiator == this.initiator);
}

class SupplyLineCodeDetailsCompanion
    extends UpdateCompanion<SupplyLineCodeDetail> {
  final Value<int> id;
  final Value<int> subid;
  final Value<String> cis;
  final Value<String?> parent;
  final Value<String> initiator;
  final Value<int> rowid;
  const SupplyLineCodeDetailsCompanion({
    this.id = const Value.absent(),
    this.subid = const Value.absent(),
    this.cis = const Value.absent(),
    this.parent = const Value.absent(),
    this.initiator = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SupplyLineCodeDetailsCompanion.insert({
    required int id,
    required int subid,
    required String cis,
    this.parent = const Value.absent(),
    required String initiator,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subid = Value(subid),
       cis = Value(cis),
       initiator = Value(initiator);
  static Insertable<SupplyLineCodeDetail> custom({
    Expression<int>? id,
    Expression<int>? subid,
    Expression<String>? cis,
    Expression<String>? parent,
    Expression<String>? initiator,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subid != null) 'subid': subid,
      if (cis != null) 'cis': cis,
      if (parent != null) 'parent': parent,
      if (initiator != null) 'initiator': initiator,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SupplyLineCodeDetailsCompanion copyWith({
    Value<int>? id,
    Value<int>? subid,
    Value<String>? cis,
    Value<String?>? parent,
    Value<String>? initiator,
    Value<int>? rowid,
  }) {
    return SupplyLineCodeDetailsCompanion(
      id: id ?? this.id,
      subid: subid ?? this.subid,
      cis: cis ?? this.cis,
      parent: parent ?? this.parent,
      initiator: initiator ?? this.initiator,
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
    if (cis.present) {
      map['cis'] = Variable<String>(cis.value);
    }
    if (parent.present) {
      map['parent'] = Variable<String>(parent.value);
    }
    if (initiator.present) {
      map['initiator'] = Variable<String>(initiator.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupplyLineCodeDetailsCompanion(')
          ..write('id: $id, ')
          ..write('subid: $subid, ')
          ..write('cis: $cis, ')
          ..write('parent: $parent, ')
          ..write('initiator: $initiator, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDataStore extends GeneratedDatabase {
  _$AppDataStore(QueryExecutor e) : super(e);
  $AppDataStoreManager get managers => $AppDataStoreManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $SupplyLineCodesTable supplyLineCodes = $SupplyLineCodesTable(
    this,
  );
  late final $SupplyLineCodeDetailsTable supplyLineCodeDetails =
      $SupplyLineCodeDetailsTable(this);
  late final UsersDao usersDao = UsersDao(this as AppDataStore);
  late final SuppliesDao suppliesDao = SuppliesDao(this as AppDataStore);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    supplyLineCodes,
    supplyLineCodeDetails,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      required String username,
      required String email,
      required String version,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
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
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );
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
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );
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

class $$UsersTableTableManager
    extends
        RootTableManager<
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
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDataStore db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> version = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                username: username,
                email: email,
                version: version,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String username,
                required String email,
                required String version,
              }) => UsersCompanion.insert(
                id: id,
                username: username,
                email: email,
                version: version,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
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
      PrefetchHooks Function()
    >;
typedef $$SupplyLineCodesTableCreateCompanionBuilder =
    SupplyLineCodesCompanion Function({
      required int id,
      required int subid,
      required String code,
      required double vol,
      required DateTime localTs,
      Value<int> rowid,
    });
typedef $$SupplyLineCodesTableUpdateCompanionBuilder =
    SupplyLineCodesCompanion Function({
      Value<int> id,
      Value<int> subid,
      Value<String> code,
      Value<double> vol,
      Value<DateTime> localTs,
      Value<int> rowid,
    });

class $$SupplyLineCodesTableFilterComposer
    extends Composer<_$AppDataStore, $SupplyLineCodesTable> {
  $$SupplyLineCodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subid => $composableBuilder(
    column: $table.subid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get vol => $composableBuilder(
    column: $table.vol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get localTs => $composableBuilder(
    column: $table.localTs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SupplyLineCodesTableOrderingComposer
    extends Composer<_$AppDataStore, $SupplyLineCodesTable> {
  $$SupplyLineCodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subid => $composableBuilder(
    column: $table.subid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get vol => $composableBuilder(
    column: $table.vol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get localTs => $composableBuilder(
    column: $table.localTs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SupplyLineCodesTableAnnotationComposer
    extends Composer<_$AppDataStore, $SupplyLineCodesTable> {
  $$SupplyLineCodesTableAnnotationComposer({
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

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<double> get vol =>
      $composableBuilder(column: $table.vol, builder: (column) => column);

  GeneratedColumn<DateTime> get localTs =>
      $composableBuilder(column: $table.localTs, builder: (column) => column);
}

class $$SupplyLineCodesTableTableManager
    extends
        RootTableManager<
          _$AppDataStore,
          $SupplyLineCodesTable,
          SupplyLineCode,
          $$SupplyLineCodesTableFilterComposer,
          $$SupplyLineCodesTableOrderingComposer,
          $$SupplyLineCodesTableAnnotationComposer,
          $$SupplyLineCodesTableCreateCompanionBuilder,
          $$SupplyLineCodesTableUpdateCompanionBuilder,
          (
            SupplyLineCode,
            BaseReferences<
              _$AppDataStore,
              $SupplyLineCodesTable,
              SupplyLineCode
            >,
          ),
          SupplyLineCode,
          PrefetchHooks Function()
        > {
  $$SupplyLineCodesTableTableManager(
    _$AppDataStore db,
    $SupplyLineCodesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$SupplyLineCodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SupplyLineCodesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$SupplyLineCodesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> subid = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<double> vol = const Value.absent(),
                Value<DateTime> localTs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SupplyLineCodesCompanion(
                id: id,
                subid: subid,
                code: code,
                vol: vol,
                localTs: localTs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int id,
                required int subid,
                required String code,
                required double vol,
                required DateTime localTs,
                Value<int> rowid = const Value.absent(),
              }) => SupplyLineCodesCompanion.insert(
                id: id,
                subid: subid,
                code: code,
                vol: vol,
                localTs: localTs,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SupplyLineCodesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDataStore,
      $SupplyLineCodesTable,
      SupplyLineCode,
      $$SupplyLineCodesTableFilterComposer,
      $$SupplyLineCodesTableOrderingComposer,
      $$SupplyLineCodesTableAnnotationComposer,
      $$SupplyLineCodesTableCreateCompanionBuilder,
      $$SupplyLineCodesTableUpdateCompanionBuilder,
      (
        SupplyLineCode,
        BaseReferences<_$AppDataStore, $SupplyLineCodesTable, SupplyLineCode>,
      ),
      SupplyLineCode,
      PrefetchHooks Function()
    >;
typedef $$SupplyLineCodeDetailsTableCreateCompanionBuilder =
    SupplyLineCodeDetailsCompanion Function({
      required int id,
      required int subid,
      required String cis,
      Value<String?> parent,
      required String initiator,
      Value<int> rowid,
    });
typedef $$SupplyLineCodeDetailsTableUpdateCompanionBuilder =
    SupplyLineCodeDetailsCompanion Function({
      Value<int> id,
      Value<int> subid,
      Value<String> cis,
      Value<String?> parent,
      Value<String> initiator,
      Value<int> rowid,
    });

class $$SupplyLineCodeDetailsTableFilterComposer
    extends Composer<_$AppDataStore, $SupplyLineCodeDetailsTable> {
  $$SupplyLineCodeDetailsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subid => $composableBuilder(
    column: $table.subid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cis => $composableBuilder(
    column: $table.cis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parent => $composableBuilder(
    column: $table.parent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get initiator => $composableBuilder(
    column: $table.initiator,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SupplyLineCodeDetailsTableOrderingComposer
    extends Composer<_$AppDataStore, $SupplyLineCodeDetailsTable> {
  $$SupplyLineCodeDetailsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subid => $composableBuilder(
    column: $table.subid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cis => $composableBuilder(
    column: $table.cis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parent => $composableBuilder(
    column: $table.parent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get initiator => $composableBuilder(
    column: $table.initiator,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SupplyLineCodeDetailsTableAnnotationComposer
    extends Composer<_$AppDataStore, $SupplyLineCodeDetailsTable> {
  $$SupplyLineCodeDetailsTableAnnotationComposer({
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

  GeneratedColumn<String> get cis =>
      $composableBuilder(column: $table.cis, builder: (column) => column);

  GeneratedColumn<String> get parent =>
      $composableBuilder(column: $table.parent, builder: (column) => column);

  GeneratedColumn<String> get initiator =>
      $composableBuilder(column: $table.initiator, builder: (column) => column);
}

class $$SupplyLineCodeDetailsTableTableManager
    extends
        RootTableManager<
          _$AppDataStore,
          $SupplyLineCodeDetailsTable,
          SupplyLineCodeDetail,
          $$SupplyLineCodeDetailsTableFilterComposer,
          $$SupplyLineCodeDetailsTableOrderingComposer,
          $$SupplyLineCodeDetailsTableAnnotationComposer,
          $$SupplyLineCodeDetailsTableCreateCompanionBuilder,
          $$SupplyLineCodeDetailsTableUpdateCompanionBuilder,
          (
            SupplyLineCodeDetail,
            BaseReferences<
              _$AppDataStore,
              $SupplyLineCodeDetailsTable,
              SupplyLineCodeDetail
            >,
          ),
          SupplyLineCodeDetail,
          PrefetchHooks Function()
        > {
  $$SupplyLineCodeDetailsTableTableManager(
    _$AppDataStore db,
    $SupplyLineCodeDetailsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SupplyLineCodeDetailsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$SupplyLineCodeDetailsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$SupplyLineCodeDetailsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> subid = const Value.absent(),
                Value<String> cis = const Value.absent(),
                Value<String?> parent = const Value.absent(),
                Value<String> initiator = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SupplyLineCodeDetailsCompanion(
                id: id,
                subid: subid,
                cis: cis,
                parent: parent,
                initiator: initiator,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int id,
                required int subid,
                required String cis,
                Value<String?> parent = const Value.absent(),
                required String initiator,
                Value<int> rowid = const Value.absent(),
              }) => SupplyLineCodeDetailsCompanion.insert(
                id: id,
                subid: subid,
                cis: cis,
                parent: parent,
                initiator: initiator,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SupplyLineCodeDetailsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDataStore,
      $SupplyLineCodeDetailsTable,
      SupplyLineCodeDetail,
      $$SupplyLineCodeDetailsTableFilterComposer,
      $$SupplyLineCodeDetailsTableOrderingComposer,
      $$SupplyLineCodeDetailsTableAnnotationComposer,
      $$SupplyLineCodeDetailsTableCreateCompanionBuilder,
      $$SupplyLineCodeDetailsTableUpdateCompanionBuilder,
      (
        SupplyLineCodeDetail,
        BaseReferences<
          _$AppDataStore,
          $SupplyLineCodeDetailsTable,
          SupplyLineCodeDetail
        >,
      ),
      SupplyLineCodeDetail,
      PrefetchHooks Function()
    >;

class $AppDataStoreManager {
  final _$AppDataStore _db;
  $AppDataStoreManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$SupplyLineCodesTableTableManager get supplyLineCodes =>
      $$SupplyLineCodesTableTableManager(_db, _db.supplyLineCodes);
  $$SupplyLineCodeDetailsTableTableManager get supplyLineCodeDetails =>
      $$SupplyLineCodeDetailsTableTableManager(_db, _db.supplyLineCodeDetails);
}

mixin _$UsersDaoMixin on DatabaseAccessor<AppDataStore> {
  $UsersTable get users => attachedDatabase.users;
}
mixin _$SuppliesDaoMixin on DatabaseAccessor<AppDataStore> {
  $SupplyLineCodesTable get supplyLineCodes => attachedDatabase.supplyLineCodes;
  $SupplyLineCodeDetailsTable get supplyLineCodeDetails =>
      attachedDatabase.supplyLineCodeDetails;
}
