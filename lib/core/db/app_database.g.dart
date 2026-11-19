// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $StoresTable extends Stores with TableInfo<$StoresTable, Store> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _code2Meta = const VerificationMeta('code2');
  @override
  late final GeneratedColumn<String> code2 = GeneratedColumn<String>(
    'code2',
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    code2,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stores';
  @override
  VerificationContext validateIntegrity(
    Insertable<Store> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code2')) {
      context.handle(
        _code2Meta,
        code2.isAcceptableOrUnknown(data['code2']!, _code2Meta),
      );
    } else if (isInserting) {
      context.missing(_code2Meta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Store map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Store(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      code2: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code2'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
    );
  }

  @override
  $StoresTable createAlias(String alias) {
    return $StoresTable(attachedDatabase, alias);
  }
}

class Store extends DataClass implements Insertable<Store> {
  final String id;
  final String name;
  final String code2;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? deviceId;
  const Store({
    required this.id,
    required this.name,
    required this.code2,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['code2'] = Variable<String>(code2);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    return map;
  }

  StoresCompanion toCompanion(bool nullToAbsent) {
    return StoresCompanion(
      id: Value(id),
      name: Value(name),
      code2: Value(code2),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
    );
  }

  factory Store.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Store(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      code2: serializer.fromJson<String>(json['code2']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'code2': serializer.toJson<String>(code2),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
    };
  }

  Store copyWith({
    String? id,
    String? name,
    String? code2,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
  }) => Store(
    id: id ?? this.id,
    name: name ?? this.name,
    code2: code2 ?? this.code2,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
  );
  Store copyWithCompanion(StoresCompanion data) {
    return Store(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      code2: data.code2.present ? data.code2.value : this.code2,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Store(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code2: $code2, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, code2, createdAt, updatedAt, deletedAt, deviceId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Store &&
          other.id == this.id &&
          other.name == this.name &&
          other.code2 == this.code2 &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId);
}

class StoresCompanion extends UpdateCompanion<Store> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> code2;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> deviceId;
  final Value<int> rowid;
  const StoresCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.code2 = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoresCompanion.insert({
    required String id,
    required String name,
    required String code2,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       code2 = Value(code2),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Store> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? code2,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (code2 != null) 'code2': code2,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoresCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? code2,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? deviceId,
    Value<int>? rowid,
  }) {
    return StoresCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      code2: code2 ?? this.code2,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code2.present) {
      map['code2'] = Variable<String>(code2.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoresCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code2: $code2, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<UserRole, String> role =
      GeneratedColumn<String>(
        'role',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<UserRole>($ProfilesTable.$converterrole);
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    storeId,
    role,
    displayName,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      role: $ProfilesTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}role'],
        )!,
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }

  static TypeConverter<UserRole, String> $converterrole =
      const UserRoleConverter();
}

class Profile extends DataClass implements Insertable<Profile> {
  final String userId;
  final String storeId;
  final UserRole role;
  final String? displayName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? deviceId;
  const Profile({
    required this.userId,
    required this.storeId,
    required this.role,
    this.displayName,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['store_id'] = Variable<String>(storeId);
    {
      map['role'] = Variable<String>($ProfilesTable.$converterrole.toSql(role));
    }
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      userId: Value(userId),
      storeId: Value(storeId),
      role: Value(role),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      userId: serializer.fromJson<String>(json['userId']),
      storeId: serializer.fromJson<String>(json['storeId']),
      role: serializer.fromJson<UserRole>(json['role']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'storeId': serializer.toJson<String>(storeId),
      'role': serializer.toJson<UserRole>(role),
      'displayName': serializer.toJson<String?>(displayName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
    };
  }

  Profile copyWith({
    String? userId,
    String? storeId,
    UserRole? role,
    Value<String?> displayName = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
  }) => Profile(
    userId: userId ?? this.userId,
    storeId: storeId ?? this.storeId,
    role: role ?? this.role,
    displayName: displayName.present ? displayName.value : this.displayName,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      userId: data.userId.present ? data.userId.value : this.userId,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      role: data.role.present ? data.role.value : this.role,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('userId: $userId, ')
          ..write('storeId: $storeId, ')
          ..write('role: $role, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    storeId,
    role,
    displayName,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.userId == this.userId &&
          other.storeId == this.storeId &&
          other.role == this.role &&
          other.displayName == this.displayName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<String> userId;
  final Value<String> storeId;
  final Value<UserRole> role;
  final Value<String?> displayName;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> deviceId;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.userId = const Value.absent(),
    this.storeId = const Value.absent(),
    this.role = const Value.absent(),
    this.displayName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String userId,
    required String storeId,
    required UserRole role,
    this.displayName = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       storeId = Value(storeId),
       role = Value(role),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Profile> custom({
    Expression<String>? userId,
    Expression<String>? storeId,
    Expression<String>? role,
    Expression<String>? displayName,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (storeId != null) 'store_id': storeId,
      if (role != null) 'role': role,
      if (displayName != null) 'display_name': displayName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? userId,
    Value<String>? storeId,
    Value<UserRole>? role,
    Value<String?>? displayName,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? deviceId,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      userId: userId ?? this.userId,
      storeId: storeId ?? this.storeId,
      role: role ?? this.role,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(
        $ProfilesTable.$converterrole.toSql(role.value),
      );
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('userId: $userId, ')
          ..write('storeId: $storeId, ')
          ..write('role: $role, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DevicesTable extends Devices with TableInfo<$DevicesTable, Device> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DevicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    code,
    name,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'devices';
  @override
  VerificationContext validateIntegrity(
    Insertable<Device> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Device map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Device(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
    );
  }

  @override
  $DevicesTable createAlias(String alias) {
    return $DevicesTable(attachedDatabase, alias);
  }
}

class Device extends DataClass implements Insertable<Device> {
  final String id;
  final String storeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? deviceId;
  final String code;
  final String? name;
  const Device({
    required this.id,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.deviceId,
    required this.code,
    this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['code'] = Variable<String>(code);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    return map;
  }

  DevicesCompanion toCompanion(bool nullToAbsent) {
    return DevicesCompanion(
      id: Value(id),
      storeId: Value(storeId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      code: Value(code),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  factory Device.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Device(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String?>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String?>(name),
    };
  }

  Device copyWith({
    String? id,
    String? storeId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    String? code,
    Value<String?> name = const Value.absent(),
  }) => Device(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    code: code ?? this.code,
    name: name.present ? name.value : this.name,
  );
  Device copyWithCompanion(DevicesCompanion data) {
    return Device(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Device(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('code: $code, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    code,
    name,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Device &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.code == this.code &&
          other.name == this.name);
}

class DevicesCompanion extends UpdateCompanion<Device> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> deviceId;
  final Value<String> code;
  final Value<String?> name;
  final Value<int> rowid;
  const DevicesCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DevicesCompanion.insert({
    required String id,
    required String storeId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String code,
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       code = Value(code);
  static Insertable<Device> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? code,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DevicesCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? deviceId,
    Value<String>? code,
    Value<String?>? name,
    Value<int>? rowid,
  }) {
    return DevicesCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      code: code ?? this.code,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DevicesCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, Supplier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    name,
    phone,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Supplier> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplier(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }
}

class Supplier extends DataClass implements Insertable<Supplier> {
  final String id;
  final String storeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? deviceId;
  final String name;
  final String? phone;
  final String? note;
  const Supplier({
    required this.id,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.deviceId,
    required this.name,
    this.phone,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      storeId: Value(storeId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Supplier.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplier(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'note': serializer.toJson<String?>(note),
    };
  }

  Supplier copyWith({
    String? id,
    String? storeId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    String? name,
    Value<String?> phone = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => Supplier(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    note: note.present ? note.value : this.note,
  );
  Supplier copyWithCompanion(SuppliersCompanion data) {
    return Supplier(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplier(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    name,
    phone,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplier &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.note == this.note);
}

class SuppliersCompanion extends UpdateCompanion<Supplier> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> deviceId;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> note;
  final Value<int> rowid;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SuppliersCompanion.insert({
    required String id,
    required String storeId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       name = Value(name);
  static Insertable<Supplier> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SuppliersCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? deviceId,
    Value<String>? name,
    Value<String?>? phone,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return SuppliersCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultMarginPctMeta = const VerificationMeta(
    'defaultMarginPct',
  );
  @override
  late final GeneratedColumn<double> defaultMarginPct = GeneratedColumn<double>(
    'default_margin_pct',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    name,
    defaultMarginPct,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('default_margin_pct')) {
      context.handle(
        _defaultMarginPctMeta,
        defaultMarginPct.isAcceptableOrUnknown(
          data['default_margin_pct']!,
          _defaultMarginPctMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      defaultMarginPct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}default_margin_pct'],
      ),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String storeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? deviceId;
  final String name;
  final double? defaultMarginPct;
  const Category({
    required this.id,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.deviceId,
    required this.name,
    this.defaultMarginPct,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || defaultMarginPct != null) {
      map['default_margin_pct'] = Variable<double>(defaultMarginPct);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      storeId: Value(storeId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      name: Value(name),
      defaultMarginPct: defaultMarginPct == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultMarginPct),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      name: serializer.fromJson<String>(json['name']),
      defaultMarginPct: serializer.fromJson<double?>(json['defaultMarginPct']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'name': serializer.toJson<String>(name),
      'defaultMarginPct': serializer.toJson<double?>(defaultMarginPct),
    };
  }

  Category copyWith({
    String? id,
    String? storeId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    String? name,
    Value<double?> defaultMarginPct = const Value.absent(),
  }) => Category(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    name: name ?? this.name,
    defaultMarginPct: defaultMarginPct.present
        ? defaultMarginPct.value
        : this.defaultMarginPct,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      name: data.name.present ? data.name.value : this.name,
      defaultMarginPct: data.defaultMarginPct.present
          ? data.defaultMarginPct.value
          : this.defaultMarginPct,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('defaultMarginPct: $defaultMarginPct')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    name,
    defaultMarginPct,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.name == this.name &&
          other.defaultMarginPct == this.defaultMarginPct);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> deviceId;
  final Value<String> name;
  final Value<double?> defaultMarginPct;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.name = const Value.absent(),
    this.defaultMarginPct = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String storeId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String name,
    this.defaultMarginPct = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       name = Value(name);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? name,
    Expression<double>? defaultMarginPct,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (name != null) 'name': name,
      if (defaultMarginPct != null) 'default_margin_pct': defaultMarginPct,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? deviceId,
    Value<String>? name,
    Value<double?>? defaultMarginPct,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      defaultMarginPct: defaultMarginPct ?? this.defaultMarginPct,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (defaultMarginPct.present) {
      map['default_margin_pct'] = Variable<double>(defaultMarginPct.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('defaultMarginPct: $defaultMarginPct, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _variantMeta = const VerificationMeta(
    'variant',
  );
  @override
  late final GeneratedColumn<String> variant = GeneratedColumn<String>(
    'variant',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _baseUnitMeta = const VerificationMeta(
    'baseUnit',
  );
  @override
  late final GeneratedColumn<String> baseUnit = GeneratedColumn<String>(
    'base_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minStockBaseMeta = const VerificationMeta(
    'minStockBase',
  );
  @override
  late final GeneratedColumn<int> minStockBase = GeneratedColumn<int>(
    'min_stock_base',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _shelfLocationMeta = const VerificationMeta(
    'shelfLocation',
  );
  @override
  late final GeneratedColumn<String> shelfLocation = GeneratedColumn<String>(
    'shelf_location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mainSupplierIdMeta = const VerificationMeta(
    'mainSupplierId',
  );
  @override
  late final GeneratedColumn<String> mainSupplierId = GeneratedColumn<String>(
    'main_supplier_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _needsPriceReviewMeta = const VerificationMeta(
    'needsPriceReview',
  );
  @override
  late final GeneratedColumn<bool> needsPriceReview = GeneratedColumn<bool>(
    'needs_price_review',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_price_review" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    name,
    brand,
    variant,
    categoryId,
    baseUnit,
    minStockBase,
    shelfLocation,
    mainSupplierId,
    needsPriceReview,
    isActive,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('variant')) {
      context.handle(
        _variantMeta,
        variant.isAcceptableOrUnknown(data['variant']!, _variantMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('base_unit')) {
      context.handle(
        _baseUnitMeta,
        baseUnit.isAcceptableOrUnknown(data['base_unit']!, _baseUnitMeta),
      );
    } else if (isInserting) {
      context.missing(_baseUnitMeta);
    }
    if (data.containsKey('min_stock_base')) {
      context.handle(
        _minStockBaseMeta,
        minStockBase.isAcceptableOrUnknown(
          data['min_stock_base']!,
          _minStockBaseMeta,
        ),
      );
    }
    if (data.containsKey('shelf_location')) {
      context.handle(
        _shelfLocationMeta,
        shelfLocation.isAcceptableOrUnknown(
          data['shelf_location']!,
          _shelfLocationMeta,
        ),
      );
    }
    if (data.containsKey('main_supplier_id')) {
      context.handle(
        _mainSupplierIdMeta,
        mainSupplierId.isAcceptableOrUnknown(
          data['main_supplier_id']!,
          _mainSupplierIdMeta,
        ),
      );
    }
    if (data.containsKey('needs_price_review')) {
      context.handle(
        _needsPriceReviewMeta,
        needsPriceReview.isAcceptableOrUnknown(
          data['needs_price_review']!,
          _needsPriceReviewMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      variant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variant'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      baseUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_unit'],
      )!,
      minStockBase: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_stock_base'],
      )!,
      shelfLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shelf_location'],
      ),
      mainSupplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}main_supplier_id'],
      ),
      needsPriceReview: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_price_review'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String storeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? deviceId;
  final String name;
  final String? brand;
  final String? variant;
  final String? categoryId;
  final String baseUnit;
  final int minStockBase;
  final String? shelfLocation;
  final String? mainSupplierId;
  final bool needsPriceReview;
  final bool isActive;
  final String? note;
  const Product({
    required this.id,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.deviceId,
    required this.name,
    this.brand,
    this.variant,
    this.categoryId,
    required this.baseUnit,
    required this.minStockBase,
    this.shelfLocation,
    this.mainSupplierId,
    required this.needsPriceReview,
    required this.isActive,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || variant != null) {
      map['variant'] = Variable<String>(variant);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['base_unit'] = Variable<String>(baseUnit);
    map['min_stock_base'] = Variable<int>(minStockBase);
    if (!nullToAbsent || shelfLocation != null) {
      map['shelf_location'] = Variable<String>(shelfLocation);
    }
    if (!nullToAbsent || mainSupplierId != null) {
      map['main_supplier_id'] = Variable<String>(mainSupplierId);
    }
    map['needs_price_review'] = Variable<bool>(needsPriceReview);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      storeId: Value(storeId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      name: Value(name),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      variant: variant == null && nullToAbsent
          ? const Value.absent()
          : Value(variant),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      baseUnit: Value(baseUnit),
      minStockBase: Value(minStockBase),
      shelfLocation: shelfLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(shelfLocation),
      mainSupplierId: mainSupplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(mainSupplierId),
      needsPriceReview: Value(needsPriceReview),
      isActive: Value(isActive),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String?>(json['brand']),
      variant: serializer.fromJson<String?>(json['variant']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      baseUnit: serializer.fromJson<String>(json['baseUnit']),
      minStockBase: serializer.fromJson<int>(json['minStockBase']),
      shelfLocation: serializer.fromJson<String?>(json['shelfLocation']),
      mainSupplierId: serializer.fromJson<String?>(json['mainSupplierId']),
      needsPriceReview: serializer.fromJson<bool>(json['needsPriceReview']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String?>(brand),
      'variant': serializer.toJson<String?>(variant),
      'categoryId': serializer.toJson<String?>(categoryId),
      'baseUnit': serializer.toJson<String>(baseUnit),
      'minStockBase': serializer.toJson<int>(minStockBase),
      'shelfLocation': serializer.toJson<String?>(shelfLocation),
      'mainSupplierId': serializer.toJson<String?>(mainSupplierId),
      'needsPriceReview': serializer.toJson<bool>(needsPriceReview),
      'isActive': serializer.toJson<bool>(isActive),
      'note': serializer.toJson<String?>(note),
    };
  }

  Product copyWith({
    String? id,
    String? storeId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    String? name,
    Value<String?> brand = const Value.absent(),
    Value<String?> variant = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    String? baseUnit,
    int? minStockBase,
    Value<String?> shelfLocation = const Value.absent(),
    Value<String?> mainSupplierId = const Value.absent(),
    bool? needsPriceReview,
    bool? isActive,
    Value<String?> note = const Value.absent(),
  }) => Product(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    name: name ?? this.name,
    brand: brand.present ? brand.value : this.brand,
    variant: variant.present ? variant.value : this.variant,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    baseUnit: baseUnit ?? this.baseUnit,
    minStockBase: minStockBase ?? this.minStockBase,
    shelfLocation: shelfLocation.present
        ? shelfLocation.value
        : this.shelfLocation,
    mainSupplierId: mainSupplierId.present
        ? mainSupplierId.value
        : this.mainSupplierId,
    needsPriceReview: needsPriceReview ?? this.needsPriceReview,
    isActive: isActive ?? this.isActive,
    note: note.present ? note.value : this.note,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      variant: data.variant.present ? data.variant.value : this.variant,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      baseUnit: data.baseUnit.present ? data.baseUnit.value : this.baseUnit,
      minStockBase: data.minStockBase.present
          ? data.minStockBase.value
          : this.minStockBase,
      shelfLocation: data.shelfLocation.present
          ? data.shelfLocation.value
          : this.shelfLocation,
      mainSupplierId: data.mainSupplierId.present
          ? data.mainSupplierId.value
          : this.mainSupplierId,
      needsPriceReview: data.needsPriceReview.present
          ? data.needsPriceReview.value
          : this.needsPriceReview,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('variant: $variant, ')
          ..write('categoryId: $categoryId, ')
          ..write('baseUnit: $baseUnit, ')
          ..write('minStockBase: $minStockBase, ')
          ..write('shelfLocation: $shelfLocation, ')
          ..write('mainSupplierId: $mainSupplierId, ')
          ..write('needsPriceReview: $needsPriceReview, ')
          ..write('isActive: $isActive, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    name,
    brand,
    variant,
    categoryId,
    baseUnit,
    minStockBase,
    shelfLocation,
    mainSupplierId,
    needsPriceReview,
    isActive,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.variant == this.variant &&
          other.categoryId == this.categoryId &&
          other.baseUnit == this.baseUnit &&
          other.minStockBase == this.minStockBase &&
          other.shelfLocation == this.shelfLocation &&
          other.mainSupplierId == this.mainSupplierId &&
          other.needsPriceReview == this.needsPriceReview &&
          other.isActive == this.isActive &&
          other.note == this.note);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> deviceId;
  final Value<String> name;
  final Value<String?> brand;
  final Value<String?> variant;
  final Value<String?> categoryId;
  final Value<String> baseUnit;
  final Value<int> minStockBase;
  final Value<String?> shelfLocation;
  final Value<String?> mainSupplierId;
  final Value<bool> needsPriceReview;
  final Value<bool> isActive;
  final Value<String?> note;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.variant = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.baseUnit = const Value.absent(),
    this.minStockBase = const Value.absent(),
    this.shelfLocation = const Value.absent(),
    this.mainSupplierId = const Value.absent(),
    this.needsPriceReview = const Value.absent(),
    this.isActive = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String storeId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String name,
    this.brand = const Value.absent(),
    this.variant = const Value.absent(),
    this.categoryId = const Value.absent(),
    required String baseUnit,
    this.minStockBase = const Value.absent(),
    this.shelfLocation = const Value.absent(),
    this.mainSupplierId = const Value.absent(),
    this.needsPriceReview = const Value.absent(),
    this.isActive = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       name = Value(name),
       baseUnit = Value(baseUnit);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? variant,
    Expression<String>? categoryId,
    Expression<String>? baseUnit,
    Expression<int>? minStockBase,
    Expression<String>? shelfLocation,
    Expression<String>? mainSupplierId,
    Expression<bool>? needsPriceReview,
    Expression<bool>? isActive,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (variant != null) 'variant': variant,
      if (categoryId != null) 'category_id': categoryId,
      if (baseUnit != null) 'base_unit': baseUnit,
      if (minStockBase != null) 'min_stock_base': minStockBase,
      if (shelfLocation != null) 'shelf_location': shelfLocation,
      if (mainSupplierId != null) 'main_supplier_id': mainSupplierId,
      if (needsPriceReview != null) 'needs_price_review': needsPriceReview,
      if (isActive != null) 'is_active': isActive,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? deviceId,
    Value<String>? name,
    Value<String?>? brand,
    Value<String?>? variant,
    Value<String?>? categoryId,
    Value<String>? baseUnit,
    Value<int>? minStockBase,
    Value<String?>? shelfLocation,
    Value<String?>? mainSupplierId,
    Value<bool>? needsPriceReview,
    Value<bool>? isActive,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      variant: variant ?? this.variant,
      categoryId: categoryId ?? this.categoryId,
      baseUnit: baseUnit ?? this.baseUnit,
      minStockBase: minStockBase ?? this.minStockBase,
      shelfLocation: shelfLocation ?? this.shelfLocation,
      mainSupplierId: mainSupplierId ?? this.mainSupplierId,
      needsPriceReview: needsPriceReview ?? this.needsPriceReview,
      isActive: isActive ?? this.isActive,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (variant.present) {
      map['variant'] = Variable<String>(variant.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (baseUnit.present) {
      map['base_unit'] = Variable<String>(baseUnit.value);
    }
    if (minStockBase.present) {
      map['min_stock_base'] = Variable<int>(minStockBase.value);
    }
    if (shelfLocation.present) {
      map['shelf_location'] = Variable<String>(shelfLocation.value);
    }
    if (mainSupplierId.present) {
      map['main_supplier_id'] = Variable<String>(mainSupplierId.value);
    }
    if (needsPriceReview.present) {
      map['needs_price_review'] = Variable<bool>(needsPriceReview.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('variant: $variant, ')
          ..write('categoryId: $categoryId, ')
          ..write('baseUnit: $baseUnit, ')
          ..write('minStockBase: $minStockBase, ')
          ..write('shelfLocation: $shelfLocation, ')
          ..write('mainSupplierId: $mainSupplierId, ')
          ..write('needsPriceReview: $needsPriceReview, ')
          ..write('isActive: $isActive, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductUnitsTable extends ProductUnits
    with TableInfo<$ProductUnitsTable, ProductUnit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductUnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitNameMeta = const VerificationMeta(
    'unitName',
  );
  @override
  late final GeneratedColumn<String> unitName = GeneratedColumn<String>(
    'unit_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _factorToBaseMeta = const VerificationMeta(
    'factorToBase',
  );
  @override
  late final GeneratedColumn<int> factorToBase = GeneratedColumn<int>(
    'factor_to_base',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<BarcodeSource?, String>
  barcodeSource = GeneratedColumn<String>(
    'barcode_source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<BarcodeSource?>($ProductUnitsTable.$converterbarcodeSourcen);
  static const VerificationMeta _sellPriceMeta = const VerificationMeta(
    'sellPrice',
  );
  @override
  late final GeneratedColumn<int> sellPrice = GeneratedColumn<int>(
    'sell_price',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDefaultSaleMeta = const VerificationMeta(
    'isDefaultSale',
  );
  @override
  late final GeneratedColumn<bool> isDefaultSale = GeneratedColumn<bool>(
    'is_default_sale',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default_sale" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDefaultPurchaseMeta = const VerificationMeta(
    'isDefaultPurchase',
  );
  @override
  late final GeneratedColumn<bool> isDefaultPurchase = GeneratedColumn<bool>(
    'is_default_purchase',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default_purchase" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    productId,
    unitName,
    factorToBase,
    barcode,
    barcodeSource,
    sellPrice,
    isDefaultSale,
    isDefaultPurchase,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_units';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductUnit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('unit_name')) {
      context.handle(
        _unitNameMeta,
        unitName.isAcceptableOrUnknown(data['unit_name']!, _unitNameMeta),
      );
    } else if (isInserting) {
      context.missing(_unitNameMeta);
    }
    if (data.containsKey('factor_to_base')) {
      context.handle(
        _factorToBaseMeta,
        factorToBase.isAcceptableOrUnknown(
          data['factor_to_base']!,
          _factorToBaseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_factorToBaseMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('sell_price')) {
      context.handle(
        _sellPriceMeta,
        sellPrice.isAcceptableOrUnknown(data['sell_price']!, _sellPriceMeta),
      );
    }
    if (data.containsKey('is_default_sale')) {
      context.handle(
        _isDefaultSaleMeta,
        isDefaultSale.isAcceptableOrUnknown(
          data['is_default_sale']!,
          _isDefaultSaleMeta,
        ),
      );
    }
    if (data.containsKey('is_default_purchase')) {
      context.handle(
        _isDefaultPurchaseMeta,
        isDefaultPurchase.isAcceptableOrUnknown(
          data['is_default_purchase']!,
          _isDefaultPurchaseMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {storeId, barcode},
  ];
  @override
  ProductUnit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductUnit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      unitName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_name'],
      )!,
      factorToBase: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}factor_to_base'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      barcodeSource: $ProductUnitsTable.$converterbarcodeSourcen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}barcode_source'],
        ),
      ),
      sellPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sell_price'],
      ),
      isDefaultSale: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default_sale'],
      )!,
      isDefaultPurchase: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default_purchase'],
      )!,
    );
  }

  @override
  $ProductUnitsTable createAlias(String alias) {
    return $ProductUnitsTable(attachedDatabase, alias);
  }

  static TypeConverter<BarcodeSource, String> $converterbarcodeSource =
      const BarcodeSourceConverter();
  static TypeConverter<BarcodeSource?, String?> $converterbarcodeSourcen =
      NullAwareTypeConverter.wrap($converterbarcodeSource);
}

class ProductUnit extends DataClass implements Insertable<ProductUnit> {
  final String id;
  final String storeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? deviceId;
  final String productId;
  final String unitName;
  final int factorToBase;
  final String? barcode;
  final BarcodeSource? barcodeSource;
  final int? sellPrice;
  final bool isDefaultSale;
  final bool isDefaultPurchase;
  const ProductUnit({
    required this.id,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.deviceId,
    required this.productId,
    required this.unitName,
    required this.factorToBase,
    this.barcode,
    this.barcodeSource,
    this.sellPrice,
    required this.isDefaultSale,
    required this.isDefaultPurchase,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['product_id'] = Variable<String>(productId);
    map['unit_name'] = Variable<String>(unitName);
    map['factor_to_base'] = Variable<int>(factorToBase);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || barcodeSource != null) {
      map['barcode_source'] = Variable<String>(
        $ProductUnitsTable.$converterbarcodeSourcen.toSql(barcodeSource),
      );
    }
    if (!nullToAbsent || sellPrice != null) {
      map['sell_price'] = Variable<int>(sellPrice);
    }
    map['is_default_sale'] = Variable<bool>(isDefaultSale);
    map['is_default_purchase'] = Variable<bool>(isDefaultPurchase);
    return map;
  }

  ProductUnitsCompanion toCompanion(bool nullToAbsent) {
    return ProductUnitsCompanion(
      id: Value(id),
      storeId: Value(storeId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      productId: Value(productId),
      unitName: Value(unitName),
      factorToBase: Value(factorToBase),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      barcodeSource: barcodeSource == null && nullToAbsent
          ? const Value.absent()
          : Value(barcodeSource),
      sellPrice: sellPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(sellPrice),
      isDefaultSale: Value(isDefaultSale),
      isDefaultPurchase: Value(isDefaultPurchase),
    );
  }

  factory ProductUnit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductUnit(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      productId: serializer.fromJson<String>(json['productId']),
      unitName: serializer.fromJson<String>(json['unitName']),
      factorToBase: serializer.fromJson<int>(json['factorToBase']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      barcodeSource: serializer.fromJson<BarcodeSource?>(json['barcodeSource']),
      sellPrice: serializer.fromJson<int?>(json['sellPrice']),
      isDefaultSale: serializer.fromJson<bool>(json['isDefaultSale']),
      isDefaultPurchase: serializer.fromJson<bool>(json['isDefaultPurchase']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'productId': serializer.toJson<String>(productId),
      'unitName': serializer.toJson<String>(unitName),
      'factorToBase': serializer.toJson<int>(factorToBase),
      'barcode': serializer.toJson<String?>(barcode),
      'barcodeSource': serializer.toJson<BarcodeSource?>(barcodeSource),
      'sellPrice': serializer.toJson<int?>(sellPrice),
      'isDefaultSale': serializer.toJson<bool>(isDefaultSale),
      'isDefaultPurchase': serializer.toJson<bool>(isDefaultPurchase),
    };
  }

  ProductUnit copyWith({
    String? id,
    String? storeId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    String? productId,
    String? unitName,
    int? factorToBase,
    Value<String?> barcode = const Value.absent(),
    Value<BarcodeSource?> barcodeSource = const Value.absent(),
    Value<int?> sellPrice = const Value.absent(),
    bool? isDefaultSale,
    bool? isDefaultPurchase,
  }) => ProductUnit(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    productId: productId ?? this.productId,
    unitName: unitName ?? this.unitName,
    factorToBase: factorToBase ?? this.factorToBase,
    barcode: barcode.present ? barcode.value : this.barcode,
    barcodeSource: barcodeSource.present
        ? barcodeSource.value
        : this.barcodeSource,
    sellPrice: sellPrice.present ? sellPrice.value : this.sellPrice,
    isDefaultSale: isDefaultSale ?? this.isDefaultSale,
    isDefaultPurchase: isDefaultPurchase ?? this.isDefaultPurchase,
  );
  ProductUnit copyWithCompanion(ProductUnitsCompanion data) {
    return ProductUnit(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      productId: data.productId.present ? data.productId.value : this.productId,
      unitName: data.unitName.present ? data.unitName.value : this.unitName,
      factorToBase: data.factorToBase.present
          ? data.factorToBase.value
          : this.factorToBase,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      barcodeSource: data.barcodeSource.present
          ? data.barcodeSource.value
          : this.barcodeSource,
      sellPrice: data.sellPrice.present ? data.sellPrice.value : this.sellPrice,
      isDefaultSale: data.isDefaultSale.present
          ? data.isDefaultSale.value
          : this.isDefaultSale,
      isDefaultPurchase: data.isDefaultPurchase.present
          ? data.isDefaultPurchase.value
          : this.isDefaultPurchase,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductUnit(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('productId: $productId, ')
          ..write('unitName: $unitName, ')
          ..write('factorToBase: $factorToBase, ')
          ..write('barcode: $barcode, ')
          ..write('barcodeSource: $barcodeSource, ')
          ..write('sellPrice: $sellPrice, ')
          ..write('isDefaultSale: $isDefaultSale, ')
          ..write('isDefaultPurchase: $isDefaultPurchase')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    productId,
    unitName,
    factorToBase,
    barcode,
    barcodeSource,
    sellPrice,
    isDefaultSale,
    isDefaultPurchase,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductUnit &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.productId == this.productId &&
          other.unitName == this.unitName &&
          other.factorToBase == this.factorToBase &&
          other.barcode == this.barcode &&
          other.barcodeSource == this.barcodeSource &&
          other.sellPrice == this.sellPrice &&
          other.isDefaultSale == this.isDefaultSale &&
          other.isDefaultPurchase == this.isDefaultPurchase);
}

class ProductUnitsCompanion extends UpdateCompanion<ProductUnit> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> deviceId;
  final Value<String> productId;
  final Value<String> unitName;
  final Value<int> factorToBase;
  final Value<String?> barcode;
  final Value<BarcodeSource?> barcodeSource;
  final Value<int?> sellPrice;
  final Value<bool> isDefaultSale;
  final Value<bool> isDefaultPurchase;
  final Value<int> rowid;
  const ProductUnitsCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.productId = const Value.absent(),
    this.unitName = const Value.absent(),
    this.factorToBase = const Value.absent(),
    this.barcode = const Value.absent(),
    this.barcodeSource = const Value.absent(),
    this.sellPrice = const Value.absent(),
    this.isDefaultSale = const Value.absent(),
    this.isDefaultPurchase = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductUnitsCompanion.insert({
    required String id,
    required String storeId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String productId,
    required String unitName,
    required int factorToBase,
    this.barcode = const Value.absent(),
    this.barcodeSource = const Value.absent(),
    this.sellPrice = const Value.absent(),
    this.isDefaultSale = const Value.absent(),
    this.isDefaultPurchase = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       productId = Value(productId),
       unitName = Value(unitName),
       factorToBase = Value(factorToBase);
  static Insertable<ProductUnit> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? productId,
    Expression<String>? unitName,
    Expression<int>? factorToBase,
    Expression<String>? barcode,
    Expression<String>? barcodeSource,
    Expression<int>? sellPrice,
    Expression<bool>? isDefaultSale,
    Expression<bool>? isDefaultPurchase,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (productId != null) 'product_id': productId,
      if (unitName != null) 'unit_name': unitName,
      if (factorToBase != null) 'factor_to_base': factorToBase,
      if (barcode != null) 'barcode': barcode,
      if (barcodeSource != null) 'barcode_source': barcodeSource,
      if (sellPrice != null) 'sell_price': sellPrice,
      if (isDefaultSale != null) 'is_default_sale': isDefaultSale,
      if (isDefaultPurchase != null) 'is_default_purchase': isDefaultPurchase,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductUnitsCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? deviceId,
    Value<String>? productId,
    Value<String>? unitName,
    Value<int>? factorToBase,
    Value<String?>? barcode,
    Value<BarcodeSource?>? barcodeSource,
    Value<int?>? sellPrice,
    Value<bool>? isDefaultSale,
    Value<bool>? isDefaultPurchase,
    Value<int>? rowid,
  }) {
    return ProductUnitsCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      productId: productId ?? this.productId,
      unitName: unitName ?? this.unitName,
      factorToBase: factorToBase ?? this.factorToBase,
      barcode: barcode ?? this.barcode,
      barcodeSource: barcodeSource ?? this.barcodeSource,
      sellPrice: sellPrice ?? this.sellPrice,
      isDefaultSale: isDefaultSale ?? this.isDefaultSale,
      isDefaultPurchase: isDefaultPurchase ?? this.isDefaultPurchase,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (unitName.present) {
      map['unit_name'] = Variable<String>(unitName.value);
    }
    if (factorToBase.present) {
      map['factor_to_base'] = Variable<int>(factorToBase.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (barcodeSource.present) {
      map['barcode_source'] = Variable<String>(
        $ProductUnitsTable.$converterbarcodeSourcen.toSql(barcodeSource.value),
      );
    }
    if (sellPrice.present) {
      map['sell_price'] = Variable<int>(sellPrice.value);
    }
    if (isDefaultSale.present) {
      map['is_default_sale'] = Variable<bool>(isDefaultSale.value);
    }
    if (isDefaultPurchase.present) {
      map['is_default_purchase'] = Variable<bool>(isDefaultPurchase.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductUnitsCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('productId: $productId, ')
          ..write('unitName: $unitName, ')
          ..write('factorToBase: $factorToBase, ')
          ..write('barcode: $barcode, ')
          ..write('barcodeSource: $barcodeSource, ')
          ..write('sellPrice: $sellPrice, ')
          ..write('isDefaultSale: $isDefaultSale, ')
          ..write('isDefaultPurchase: $isDefaultPurchase, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PriceHistoryTable extends PriceHistory
    with TableInfo<$PriceHistoryTable, PriceHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PriceHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productUnitIdMeta = const VerificationMeta(
    'productUnitId',
  );
  @override
  late final GeneratedColumn<String> productUnitId = GeneratedColumn<String>(
    'product_unit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PriceKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PriceKind>($PriceHistoryTable.$converterkind);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _effectiveAtMeta = const VerificationMeta(
    'effectiveAt',
  );
  @override
  late final GeneratedColumn<DateTime> effectiveAt = GeneratedColumn<DateTime>(
    'effective_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceRefMeta = const VerificationMeta(
    'sourceRef',
  );
  @override
  late final GeneratedColumn<String> sourceRef = GeneratedColumn<String>(
    'source_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    productUnitId,
    kind,
    price,
    effectiveAt,
    sourceRef,
    createdAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'price_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<PriceHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('product_unit_id')) {
      context.handle(
        _productUnitIdMeta,
        productUnitId.isAcceptableOrUnknown(
          data['product_unit_id']!,
          _productUnitIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productUnitIdMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('effective_at')) {
      context.handle(
        _effectiveAtMeta,
        effectiveAt.isAcceptableOrUnknown(
          data['effective_at']!,
          _effectiveAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_effectiveAtMeta);
    }
    if (data.containsKey('source_ref')) {
      context.handle(
        _sourceRefMeta,
        sourceRef.isAcceptableOrUnknown(data['source_ref']!, _sourceRefMeta),
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
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PriceHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PriceHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      productUnitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_unit_id'],
      )!,
      kind: $PriceHistoryTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price'],
      )!,
      effectiveAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}effective_at'],
      )!,
      sourceRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_ref'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
    );
  }

  @override
  $PriceHistoryTable createAlias(String alias) {
    return $PriceHistoryTable(attachedDatabase, alias);
  }

  static TypeConverter<PriceKind, String> $converterkind =
      const PriceKindConverter();
}

class PriceHistoryData extends DataClass
    implements Insertable<PriceHistoryData> {
  final String id;
  final String storeId;
  final String productUnitId;
  final PriceKind kind;
  final int price;
  final DateTime effectiveAt;
  final String? sourceRef;
  final DateTime createdAt;
  final String? deviceId;
  const PriceHistoryData({
    required this.id,
    required this.storeId,
    required this.productUnitId,
    required this.kind,
    required this.price,
    required this.effectiveAt,
    this.sourceRef,
    required this.createdAt,
    this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['product_unit_id'] = Variable<String>(productUnitId);
    {
      map['kind'] = Variable<String>(
        $PriceHistoryTable.$converterkind.toSql(kind),
      );
    }
    map['price'] = Variable<int>(price);
    map['effective_at'] = Variable<DateTime>(effectiveAt);
    if (!nullToAbsent || sourceRef != null) {
      map['source_ref'] = Variable<String>(sourceRef);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    return map;
  }

  PriceHistoryCompanion toCompanion(bool nullToAbsent) {
    return PriceHistoryCompanion(
      id: Value(id),
      storeId: Value(storeId),
      productUnitId: Value(productUnitId),
      kind: Value(kind),
      price: Value(price),
      effectiveAt: Value(effectiveAt),
      sourceRef: sourceRef == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceRef),
      createdAt: Value(createdAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
    );
  }

  factory PriceHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PriceHistoryData(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      productUnitId: serializer.fromJson<String>(json['productUnitId']),
      kind: serializer.fromJson<PriceKind>(json['kind']),
      price: serializer.fromJson<int>(json['price']),
      effectiveAt: serializer.fromJson<DateTime>(json['effectiveAt']),
      sourceRef: serializer.fromJson<String?>(json['sourceRef']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'productUnitId': serializer.toJson<String>(productUnitId),
      'kind': serializer.toJson<PriceKind>(kind),
      'price': serializer.toJson<int>(price),
      'effectiveAt': serializer.toJson<DateTime>(effectiveAt),
      'sourceRef': serializer.toJson<String?>(sourceRef),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deviceId': serializer.toJson<String?>(deviceId),
    };
  }

  PriceHistoryData copyWith({
    String? id,
    String? storeId,
    String? productUnitId,
    PriceKind? kind,
    int? price,
    DateTime? effectiveAt,
    Value<String?> sourceRef = const Value.absent(),
    DateTime? createdAt,
    Value<String?> deviceId = const Value.absent(),
  }) => PriceHistoryData(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    productUnitId: productUnitId ?? this.productUnitId,
    kind: kind ?? this.kind,
    price: price ?? this.price,
    effectiveAt: effectiveAt ?? this.effectiveAt,
    sourceRef: sourceRef.present ? sourceRef.value : this.sourceRef,
    createdAt: createdAt ?? this.createdAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
  );
  PriceHistoryData copyWithCompanion(PriceHistoryCompanion data) {
    return PriceHistoryData(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      productUnitId: data.productUnitId.present
          ? data.productUnitId.value
          : this.productUnitId,
      kind: data.kind.present ? data.kind.value : this.kind,
      price: data.price.present ? data.price.value : this.price,
      effectiveAt: data.effectiveAt.present
          ? data.effectiveAt.value
          : this.effectiveAt,
      sourceRef: data.sourceRef.present ? data.sourceRef.value : this.sourceRef,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PriceHistoryData(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('productUnitId: $productUnitId, ')
          ..write('kind: $kind, ')
          ..write('price: $price, ')
          ..write('effectiveAt: $effectiveAt, ')
          ..write('sourceRef: $sourceRef, ')
          ..write('createdAt: $createdAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    productUnitId,
    kind,
    price,
    effectiveAt,
    sourceRef,
    createdAt,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PriceHistoryData &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.productUnitId == this.productUnitId &&
          other.kind == this.kind &&
          other.price == this.price &&
          other.effectiveAt == this.effectiveAt &&
          other.sourceRef == this.sourceRef &&
          other.createdAt == this.createdAt &&
          other.deviceId == this.deviceId);
}

class PriceHistoryCompanion extends UpdateCompanion<PriceHistoryData> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<String> productUnitId;
  final Value<PriceKind> kind;
  final Value<int> price;
  final Value<DateTime> effectiveAt;
  final Value<String?> sourceRef;
  final Value<DateTime> createdAt;
  final Value<String?> deviceId;
  final Value<int> rowid;
  const PriceHistoryCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.productUnitId = const Value.absent(),
    this.kind = const Value.absent(),
    this.price = const Value.absent(),
    this.effectiveAt = const Value.absent(),
    this.sourceRef = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PriceHistoryCompanion.insert({
    required String id,
    required String storeId,
    required String productUnitId,
    required PriceKind kind,
    required int price,
    required DateTime effectiveAt,
    this.sourceRef = const Value.absent(),
    required DateTime createdAt,
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       productUnitId = Value(productUnitId),
       kind = Value(kind),
       price = Value(price),
       effectiveAt = Value(effectiveAt),
       createdAt = Value(createdAt);
  static Insertable<PriceHistoryData> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<String>? productUnitId,
    Expression<String>? kind,
    Expression<int>? price,
    Expression<DateTime>? effectiveAt,
    Expression<String>? sourceRef,
    Expression<DateTime>? createdAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (productUnitId != null) 'product_unit_id': productUnitId,
      if (kind != null) 'kind': kind,
      if (price != null) 'price': price,
      if (effectiveAt != null) 'effective_at': effectiveAt,
      if (sourceRef != null) 'source_ref': sourceRef,
      if (createdAt != null) 'created_at': createdAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PriceHistoryCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<String>? productUnitId,
    Value<PriceKind>? kind,
    Value<int>? price,
    Value<DateTime>? effectiveAt,
    Value<String?>? sourceRef,
    Value<DateTime>? createdAt,
    Value<String?>? deviceId,
    Value<int>? rowid,
  }) {
    return PriceHistoryCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      productUnitId: productUnitId ?? this.productUnitId,
      kind: kind ?? this.kind,
      price: price ?? this.price,
      effectiveAt: effectiveAt ?? this.effectiveAt,
      sourceRef: sourceRef ?? this.sourceRef,
      createdAt: createdAt ?? this.createdAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (productUnitId.present) {
      map['product_unit_id'] = Variable<String>(productUnitId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $PriceHistoryTable.$converterkind.toSql(kind.value),
      );
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (effectiveAt.present) {
      map['effective_at'] = Variable<DateTime>(effectiveAt.value);
    }
    if (sourceRef.present) {
      map['source_ref'] = Variable<String>(sourceRef.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PriceHistoryCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('productUnitId: $productUnitId, ')
          ..write('kind: $kind, ')
          ..write('price: $price, ')
          ..write('effectiveAt: $effectiveAt, ')
          ..write('sourceRef: $sourceRef, ')
          ..write('createdAt: $createdAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchasesTable extends Purchases
    with TableInfo<$PurchasesTable, Purchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
    'supplier_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _docNoMeta = const VerificationMeta('docNo');
  @override
  late final GeneratedColumn<String> docNo = GeneratedColumn<String>(
    'doc_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchasedAtMeta = const VerificationMeta(
    'purchasedAt',
  );
  @override
  late final GeneratedColumn<DateTime> purchasedAt = GeneratedColumn<DateTime>(
    'purchased_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
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
    requiredDuringInsert: false,
    defaultValue: const Constant('completed'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    supplierId,
    docNo,
    purchasedAt,
    total,
    note,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchases';
  @override
  VerificationContext validateIntegrity(
    Insertable<Purchase> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    }
    if (data.containsKey('doc_no')) {
      context.handle(
        _docNoMeta,
        docNo.isAcceptableOrUnknown(data['doc_no']!, _docNoMeta),
      );
    }
    if (data.containsKey('purchased_at')) {
      context.handle(
        _purchasedAtMeta,
        purchasedAt.isAcceptableOrUnknown(
          data['purchased_at']!,
          _purchasedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchasedAtMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Purchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Purchase(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_id'],
      ),
      docNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doc_no'],
      ),
      purchasedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchased_at'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $PurchasesTable createAlias(String alias) {
    return $PurchasesTable(attachedDatabase, alias);
  }
}

class Purchase extends DataClass implements Insertable<Purchase> {
  final String id;
  final String storeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? deviceId;
  final String? supplierId;
  final String? docNo;
  final DateTime purchasedAt;
  final int total;
  final String? note;
  final String status;
  const Purchase({
    required this.id,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.deviceId,
    this.supplierId,
    this.docNo,
    required this.purchasedAt,
    required this.total,
    this.note,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    if (!nullToAbsent || docNo != null) {
      map['doc_no'] = Variable<String>(docNo);
    }
    map['purchased_at'] = Variable<DateTime>(purchasedAt);
    map['total'] = Variable<int>(total);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  PurchasesCompanion toCompanion(bool nullToAbsent) {
    return PurchasesCompanion(
      id: Value(id),
      storeId: Value(storeId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      docNo: docNo == null && nullToAbsent
          ? const Value.absent()
          : Value(docNo),
      purchasedAt: Value(purchasedAt),
      total: Value(total),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      status: Value(status),
    );
  }

  factory Purchase.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Purchase(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      supplierId: serializer.fromJson<String?>(json['supplierId']),
      docNo: serializer.fromJson<String?>(json['docNo']),
      purchasedAt: serializer.fromJson<DateTime>(json['purchasedAt']),
      total: serializer.fromJson<int>(json['total']),
      note: serializer.fromJson<String?>(json['note']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'supplierId': serializer.toJson<String?>(supplierId),
      'docNo': serializer.toJson<String?>(docNo),
      'purchasedAt': serializer.toJson<DateTime>(purchasedAt),
      'total': serializer.toJson<int>(total),
      'note': serializer.toJson<String?>(note),
      'status': serializer.toJson<String>(status),
    };
  }

  Purchase copyWith({
    String? id,
    String? storeId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    Value<String?> supplierId = const Value.absent(),
    Value<String?> docNo = const Value.absent(),
    DateTime? purchasedAt,
    int? total,
    Value<String?> note = const Value.absent(),
    String? status,
  }) => Purchase(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    supplierId: supplierId.present ? supplierId.value : this.supplierId,
    docNo: docNo.present ? docNo.value : this.docNo,
    purchasedAt: purchasedAt ?? this.purchasedAt,
    total: total ?? this.total,
    note: note.present ? note.value : this.note,
    status: status ?? this.status,
  );
  Purchase copyWithCompanion(PurchasesCompanion data) {
    return Purchase(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      docNo: data.docNo.present ? data.docNo.value : this.docNo,
      purchasedAt: data.purchasedAt.present
          ? data.purchasedAt.value
          : this.purchasedAt,
      total: data.total.present ? data.total.value : this.total,
      note: data.note.present ? data.note.value : this.note,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Purchase(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('supplierId: $supplierId, ')
          ..write('docNo: $docNo, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('total: $total, ')
          ..write('note: $note, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    supplierId,
    docNo,
    purchasedAt,
    total,
    note,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Purchase &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.supplierId == this.supplierId &&
          other.docNo == this.docNo &&
          other.purchasedAt == this.purchasedAt &&
          other.total == this.total &&
          other.note == this.note &&
          other.status == this.status);
}

class PurchasesCompanion extends UpdateCompanion<Purchase> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> deviceId;
  final Value<String?> supplierId;
  final Value<String?> docNo;
  final Value<DateTime> purchasedAt;
  final Value<int> total;
  final Value<String?> note;
  final Value<String> status;
  final Value<int> rowid;
  const PurchasesCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.docNo = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.total = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchasesCompanion.insert({
    required String id,
    required String storeId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.docNo = const Value.absent(),
    required DateTime purchasedAt,
    required int total,
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       purchasedAt = Value(purchasedAt),
       total = Value(total);
  static Insertable<Purchase> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? supplierId,
    Expression<String>? docNo,
    Expression<DateTime>? purchasedAt,
    Expression<int>? total,
    Expression<String>? note,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (supplierId != null) 'supplier_id': supplierId,
      if (docNo != null) 'doc_no': docNo,
      if (purchasedAt != null) 'purchased_at': purchasedAt,
      if (total != null) 'total': total,
      if (note != null) 'note': note,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchasesCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? deviceId,
    Value<String?>? supplierId,
    Value<String?>? docNo,
    Value<DateTime>? purchasedAt,
    Value<int>? total,
    Value<String?>? note,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return PurchasesCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      supplierId: supplierId ?? this.supplierId,
      docNo: docNo ?? this.docNo,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      total: total ?? this.total,
      note: note ?? this.note,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (docNo.present) {
      map['doc_no'] = Variable<String>(docNo.value);
    }
    if (purchasedAt.present) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchasesCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('supplierId: $supplierId, ')
          ..write('docNo: $docNo, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('total: $total, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchaseItemsTable extends PurchaseItems
    with TableInfo<$PurchaseItemsTable, PurchaseItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchaseIdMeta = const VerificationMeta(
    'purchaseId',
  );
  @override
  late final GeneratedColumn<String> purchaseId = GeneratedColumn<String>(
    'purchase_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<String> unitId = GeneratedColumn<String>(
    'unit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitCostMeta = const VerificationMeta(
    'unitCost',
  );
  @override
  late final GeneratedColumn<int> unitCost = GeneratedColumn<int>(
    'unit_cost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyBaseMeta = const VerificationMeta(
    'qtyBase',
  );
  @override
  late final GeneratedColumn<int> qtyBase = GeneratedColumn<int>(
    'qty_base',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costPerBaseMeta = const VerificationMeta(
    'costPerBase',
  );
  @override
  late final GeneratedColumn<double> costPerBase = GeneratedColumn<double>(
    'cost_per_base',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    purchaseId,
    productId,
    unitId,
    qty,
    unitCost,
    qtyBase,
    costPerBase,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
        _purchaseIdMeta,
        purchaseId.isAcceptableOrUnknown(data['purchase_id']!, _purchaseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_purchaseIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('unit_cost')) {
      context.handle(
        _unitCostMeta,
        unitCost.isAcceptableOrUnknown(data['unit_cost']!, _unitCostMeta),
      );
    } else if (isInserting) {
      context.missing(_unitCostMeta);
    }
    if (data.containsKey('qty_base')) {
      context.handle(
        _qtyBaseMeta,
        qtyBase.isAcceptableOrUnknown(data['qty_base']!, _qtyBaseMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyBaseMeta);
    }
    if (data.containsKey('cost_per_base')) {
      context.handle(
        _costPerBaseMeta,
        costPerBase.isAcceptableOrUnknown(
          data['cost_per_base']!,
          _costPerBaseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_costPerBaseMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      purchaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_id'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty'],
      )!,
      unitCost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_cost'],
      )!,
      qtyBase: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty_base'],
      )!,
      costPerBase: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost_per_base'],
      )!,
    );
  }

  @override
  $PurchaseItemsTable createAlias(String alias) {
    return $PurchaseItemsTable(attachedDatabase, alias);
  }
}

class PurchaseItem extends DataClass implements Insertable<PurchaseItem> {
  final String id;
  final String storeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? deviceId;
  final String purchaseId;
  final String productId;
  final String unitId;
  final int qty;
  final int unitCost;
  final int qtyBase;
  final double costPerBase;
  const PurchaseItem({
    required this.id,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.deviceId,
    required this.purchaseId,
    required this.productId,
    required this.unitId,
    required this.qty,
    required this.unitCost,
    required this.qtyBase,
    required this.costPerBase,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['purchase_id'] = Variable<String>(purchaseId);
    map['product_id'] = Variable<String>(productId);
    map['unit_id'] = Variable<String>(unitId);
    map['qty'] = Variable<int>(qty);
    map['unit_cost'] = Variable<int>(unitCost);
    map['qty_base'] = Variable<int>(qtyBase);
    map['cost_per_base'] = Variable<double>(costPerBase);
    return map;
  }

  PurchaseItemsCompanion toCompanion(bool nullToAbsent) {
    return PurchaseItemsCompanion(
      id: Value(id),
      storeId: Value(storeId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      purchaseId: Value(purchaseId),
      productId: Value(productId),
      unitId: Value(unitId),
      qty: Value(qty),
      unitCost: Value(unitCost),
      qtyBase: Value(qtyBase),
      costPerBase: Value(costPerBase),
    );
  }

  factory PurchaseItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseItem(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      purchaseId: serializer.fromJson<String>(json['purchaseId']),
      productId: serializer.fromJson<String>(json['productId']),
      unitId: serializer.fromJson<String>(json['unitId']),
      qty: serializer.fromJson<int>(json['qty']),
      unitCost: serializer.fromJson<int>(json['unitCost']),
      qtyBase: serializer.fromJson<int>(json['qtyBase']),
      costPerBase: serializer.fromJson<double>(json['costPerBase']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'purchaseId': serializer.toJson<String>(purchaseId),
      'productId': serializer.toJson<String>(productId),
      'unitId': serializer.toJson<String>(unitId),
      'qty': serializer.toJson<int>(qty),
      'unitCost': serializer.toJson<int>(unitCost),
      'qtyBase': serializer.toJson<int>(qtyBase),
      'costPerBase': serializer.toJson<double>(costPerBase),
    };
  }

  PurchaseItem copyWith({
    String? id,
    String? storeId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    String? purchaseId,
    String? productId,
    String? unitId,
    int? qty,
    int? unitCost,
    int? qtyBase,
    double? costPerBase,
  }) => PurchaseItem(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    purchaseId: purchaseId ?? this.purchaseId,
    productId: productId ?? this.productId,
    unitId: unitId ?? this.unitId,
    qty: qty ?? this.qty,
    unitCost: unitCost ?? this.unitCost,
    qtyBase: qtyBase ?? this.qtyBase,
    costPerBase: costPerBase ?? this.costPerBase,
  );
  PurchaseItem copyWithCompanion(PurchaseItemsCompanion data) {
    return PurchaseItem(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      purchaseId: data.purchaseId.present
          ? data.purchaseId.value
          : this.purchaseId,
      productId: data.productId.present ? data.productId.value : this.productId,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      qty: data.qty.present ? data.qty.value : this.qty,
      unitCost: data.unitCost.present ? data.unitCost.value : this.unitCost,
      qtyBase: data.qtyBase.present ? data.qtyBase.value : this.qtyBase,
      costPerBase: data.costPerBase.present
          ? data.costPerBase.value
          : this.costPerBase,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItem(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('productId: $productId, ')
          ..write('unitId: $unitId, ')
          ..write('qty: $qty, ')
          ..write('unitCost: $unitCost, ')
          ..write('qtyBase: $qtyBase, ')
          ..write('costPerBase: $costPerBase')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    purchaseId,
    productId,
    unitId,
    qty,
    unitCost,
    qtyBase,
    costPerBase,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseItem &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.purchaseId == this.purchaseId &&
          other.productId == this.productId &&
          other.unitId == this.unitId &&
          other.qty == this.qty &&
          other.unitCost == this.unitCost &&
          other.qtyBase == this.qtyBase &&
          other.costPerBase == this.costPerBase);
}

class PurchaseItemsCompanion extends UpdateCompanion<PurchaseItem> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> deviceId;
  final Value<String> purchaseId;
  final Value<String> productId;
  final Value<String> unitId;
  final Value<int> qty;
  final Value<int> unitCost;
  final Value<int> qtyBase;
  final Value<double> costPerBase;
  final Value<int> rowid;
  const PurchaseItemsCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.productId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.qty = const Value.absent(),
    this.unitCost = const Value.absent(),
    this.qtyBase = const Value.absent(),
    this.costPerBase = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchaseItemsCompanion.insert({
    required String id,
    required String storeId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String purchaseId,
    required String productId,
    required String unitId,
    required int qty,
    required int unitCost,
    required int qtyBase,
    required double costPerBase,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       purchaseId = Value(purchaseId),
       productId = Value(productId),
       unitId = Value(unitId),
       qty = Value(qty),
       unitCost = Value(unitCost),
       qtyBase = Value(qtyBase),
       costPerBase = Value(costPerBase);
  static Insertable<PurchaseItem> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? purchaseId,
    Expression<String>? productId,
    Expression<String>? unitId,
    Expression<int>? qty,
    Expression<int>? unitCost,
    Expression<int>? qtyBase,
    Expression<double>? costPerBase,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (productId != null) 'product_id': productId,
      if (unitId != null) 'unit_id': unitId,
      if (qty != null) 'qty': qty,
      if (unitCost != null) 'unit_cost': unitCost,
      if (qtyBase != null) 'qty_base': qtyBase,
      if (costPerBase != null) 'cost_per_base': costPerBase,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchaseItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? deviceId,
    Value<String>? purchaseId,
    Value<String>? productId,
    Value<String>? unitId,
    Value<int>? qty,
    Value<int>? unitCost,
    Value<int>? qtyBase,
    Value<double>? costPerBase,
    Value<int>? rowid,
  }) {
    return PurchaseItemsCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      purchaseId: purchaseId ?? this.purchaseId,
      productId: productId ?? this.productId,
      unitId: unitId ?? this.unitId,
      qty: qty ?? this.qty,
      unitCost: unitCost ?? this.unitCost,
      qtyBase: qtyBase ?? this.qtyBase,
      costPerBase: costPerBase ?? this.costPerBase,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<String>(purchaseId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<String>(unitId.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (unitCost.present) {
      map['unit_cost'] = Variable<int>(unitCost.value);
    }
    if (qtyBase.present) {
      map['qty_base'] = Variable<int>(qtyBase.value);
    }
    if (costPerBase.present) {
      map['cost_per_base'] = Variable<double>(costPerBase.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItemsCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('productId: $productId, ')
          ..write('unitId: $unitId, ')
          ..write('qty: $qty, ')
          ..write('unitCost: $unitCost, ')
          ..write('qtyBase: $qtyBase, ')
          ..write('costPerBase: $costPerBase, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockMovementsTable extends StockMovements
    with TableInfo<$StockMovementsTable, StockMovement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyBaseDeltaMeta = const VerificationMeta(
    'qtyBaseDelta',
  );
  @override
  late final GeneratedColumn<int> qtyBaseDelta = GeneratedColumn<int>(
    'qty_base_delta',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MovementType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MovementType>($StockMovementsTable.$convertertype);
  static const VerificationMeta _refTypeMeta = const VerificationMeta(
    'refType',
  );
  @override
  late final GeneratedColumn<String> refType = GeneratedColumn<String>(
    'ref_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _refIdMeta = const VerificationMeta('refId');
  @override
  late final GeneratedColumn<String> refId = GeneratedColumn<String>(
    'ref_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costPerBaseMeta = const VerificationMeta(
    'costPerBase',
  );
  @override
  late final GeneratedColumn<double> costPerBase = GeneratedColumn<double>(
    'cost_per_base',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverSeqMeta = const VerificationMeta(
    'serverSeq',
  );
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
    'server_seq',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    productId,
    qtyBaseDelta,
    type,
    refType,
    refId,
    costPerBase,
    occurredAt,
    note,
    deviceId,
    serverSeq,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_movements';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockMovement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('qty_base_delta')) {
      context.handle(
        _qtyBaseDeltaMeta,
        qtyBaseDelta.isAcceptableOrUnknown(
          data['qty_base_delta']!,
          _qtyBaseDeltaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_qtyBaseDeltaMeta);
    }
    if (data.containsKey('ref_type')) {
      context.handle(
        _refTypeMeta,
        refType.isAcceptableOrUnknown(data['ref_type']!, _refTypeMeta),
      );
    }
    if (data.containsKey('ref_id')) {
      context.handle(
        _refIdMeta,
        refId.isAcceptableOrUnknown(data['ref_id']!, _refIdMeta),
      );
    }
    if (data.containsKey('cost_per_base')) {
      context.handle(
        _costPerBaseMeta,
        costPerBase.isAcceptableOrUnknown(
          data['cost_per_base']!,
          _costPerBaseMeta,
        ),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('server_seq')) {
      context.handle(
        _serverSeqMeta,
        serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockMovement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockMovement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      qtyBaseDelta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty_base_delta'],
      )!,
      type: $StockMovementsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      refType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref_type'],
      ),
      refId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref_id'],
      ),
      costPerBase: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost_per_base'],
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      serverSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_seq'],
      ),
    );
  }

  @override
  $StockMovementsTable createAlias(String alias) {
    return $StockMovementsTable(attachedDatabase, alias);
  }

  static TypeConverter<MovementType, String> $convertertype =
      const MovementTypeConverter();
}

class StockMovement extends DataClass implements Insertable<StockMovement> {
  final String id;
  final String storeId;
  final String productId;
  final int qtyBaseDelta;
  final MovementType type;
  final String? refType;
  final String? refId;
  final double? costPerBase;
  final DateTime occurredAt;
  final String? note;
  final String? deviceId;
  final int? serverSeq;
  const StockMovement({
    required this.id,
    required this.storeId,
    required this.productId,
    required this.qtyBaseDelta,
    required this.type,
    this.refType,
    this.refId,
    this.costPerBase,
    required this.occurredAt,
    this.note,
    this.deviceId,
    this.serverSeq,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['product_id'] = Variable<String>(productId);
    map['qty_base_delta'] = Variable<int>(qtyBaseDelta);
    {
      map['type'] = Variable<String>(
        $StockMovementsTable.$convertertype.toSql(type),
      );
    }
    if (!nullToAbsent || refType != null) {
      map['ref_type'] = Variable<String>(refType);
    }
    if (!nullToAbsent || refId != null) {
      map['ref_id'] = Variable<String>(refId);
    }
    if (!nullToAbsent || costPerBase != null) {
      map['cost_per_base'] = Variable<double>(costPerBase);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    if (!nullToAbsent || serverSeq != null) {
      map['server_seq'] = Variable<int>(serverSeq);
    }
    return map;
  }

  StockMovementsCompanion toCompanion(bool nullToAbsent) {
    return StockMovementsCompanion(
      id: Value(id),
      storeId: Value(storeId),
      productId: Value(productId),
      qtyBaseDelta: Value(qtyBaseDelta),
      type: Value(type),
      refType: refType == null && nullToAbsent
          ? const Value.absent()
          : Value(refType),
      refId: refId == null && nullToAbsent
          ? const Value.absent()
          : Value(refId),
      costPerBase: costPerBase == null && nullToAbsent
          ? const Value.absent()
          : Value(costPerBase),
      occurredAt: Value(occurredAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      serverSeq: serverSeq == null && nullToAbsent
          ? const Value.absent()
          : Value(serverSeq),
    );
  }

  factory StockMovement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockMovement(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      productId: serializer.fromJson<String>(json['productId']),
      qtyBaseDelta: serializer.fromJson<int>(json['qtyBaseDelta']),
      type: serializer.fromJson<MovementType>(json['type']),
      refType: serializer.fromJson<String?>(json['refType']),
      refId: serializer.fromJson<String?>(json['refId']),
      costPerBase: serializer.fromJson<double?>(json['costPerBase']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      note: serializer.fromJson<String?>(json['note']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      serverSeq: serializer.fromJson<int?>(json['serverSeq']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'productId': serializer.toJson<String>(productId),
      'qtyBaseDelta': serializer.toJson<int>(qtyBaseDelta),
      'type': serializer.toJson<MovementType>(type),
      'refType': serializer.toJson<String?>(refType),
      'refId': serializer.toJson<String?>(refId),
      'costPerBase': serializer.toJson<double?>(costPerBase),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'note': serializer.toJson<String?>(note),
      'deviceId': serializer.toJson<String?>(deviceId),
      'serverSeq': serializer.toJson<int?>(serverSeq),
    };
  }

  StockMovement copyWith({
    String? id,
    String? storeId,
    String? productId,
    int? qtyBaseDelta,
    MovementType? type,
    Value<String?> refType = const Value.absent(),
    Value<String?> refId = const Value.absent(),
    Value<double?> costPerBase = const Value.absent(),
    DateTime? occurredAt,
    Value<String?> note = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    Value<int?> serverSeq = const Value.absent(),
  }) => StockMovement(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    productId: productId ?? this.productId,
    qtyBaseDelta: qtyBaseDelta ?? this.qtyBaseDelta,
    type: type ?? this.type,
    refType: refType.present ? refType.value : this.refType,
    refId: refId.present ? refId.value : this.refId,
    costPerBase: costPerBase.present ? costPerBase.value : this.costPerBase,
    occurredAt: occurredAt ?? this.occurredAt,
    note: note.present ? note.value : this.note,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    serverSeq: serverSeq.present ? serverSeq.value : this.serverSeq,
  );
  StockMovement copyWithCompanion(StockMovementsCompanion data) {
    return StockMovement(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      productId: data.productId.present ? data.productId.value : this.productId,
      qtyBaseDelta: data.qtyBaseDelta.present
          ? data.qtyBaseDelta.value
          : this.qtyBaseDelta,
      type: data.type.present ? data.type.value : this.type,
      refType: data.refType.present ? data.refType.value : this.refType,
      refId: data.refId.present ? data.refId.value : this.refId,
      costPerBase: data.costPerBase.present
          ? data.costPerBase.value
          : this.costPerBase,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      note: data.note.present ? data.note.value : this.note,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      serverSeq: data.serverSeq.present ? data.serverSeq.value : this.serverSeq,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockMovement(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('productId: $productId, ')
          ..write('qtyBaseDelta: $qtyBaseDelta, ')
          ..write('type: $type, ')
          ..write('refType: $refType, ')
          ..write('refId: $refId, ')
          ..write('costPerBase: $costPerBase, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('note: $note, ')
          ..write('deviceId: $deviceId, ')
          ..write('serverSeq: $serverSeq')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    productId,
    qtyBaseDelta,
    type,
    refType,
    refId,
    costPerBase,
    occurredAt,
    note,
    deviceId,
    serverSeq,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockMovement &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.productId == this.productId &&
          other.qtyBaseDelta == this.qtyBaseDelta &&
          other.type == this.type &&
          other.refType == this.refType &&
          other.refId == this.refId &&
          other.costPerBase == this.costPerBase &&
          other.occurredAt == this.occurredAt &&
          other.note == this.note &&
          other.deviceId == this.deviceId &&
          other.serverSeq == this.serverSeq);
}

class StockMovementsCompanion extends UpdateCompanion<StockMovement> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<String> productId;
  final Value<int> qtyBaseDelta;
  final Value<MovementType> type;
  final Value<String?> refType;
  final Value<String?> refId;
  final Value<double?> costPerBase;
  final Value<DateTime> occurredAt;
  final Value<String?> note;
  final Value<String?> deviceId;
  final Value<int?> serverSeq;
  final Value<int> rowid;
  const StockMovementsCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.productId = const Value.absent(),
    this.qtyBaseDelta = const Value.absent(),
    this.type = const Value.absent(),
    this.refType = const Value.absent(),
    this.refId = const Value.absent(),
    this.costPerBase = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.note = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockMovementsCompanion.insert({
    required String id,
    required String storeId,
    required String productId,
    required int qtyBaseDelta,
    required MovementType type,
    this.refType = const Value.absent(),
    this.refId = const Value.absent(),
    this.costPerBase = const Value.absent(),
    required DateTime occurredAt,
    this.note = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       productId = Value(productId),
       qtyBaseDelta = Value(qtyBaseDelta),
       type = Value(type),
       occurredAt = Value(occurredAt);
  static Insertable<StockMovement> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<String>? productId,
    Expression<int>? qtyBaseDelta,
    Expression<String>? type,
    Expression<String>? refType,
    Expression<String>? refId,
    Expression<double>? costPerBase,
    Expression<DateTime>? occurredAt,
    Expression<String>? note,
    Expression<String>? deviceId,
    Expression<int>? serverSeq,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (productId != null) 'product_id': productId,
      if (qtyBaseDelta != null) 'qty_base_delta': qtyBaseDelta,
      if (type != null) 'type': type,
      if (refType != null) 'ref_type': refType,
      if (refId != null) 'ref_id': refId,
      if (costPerBase != null) 'cost_per_base': costPerBase,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (note != null) 'note': note,
      if (deviceId != null) 'device_id': deviceId,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockMovementsCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<String>? productId,
    Value<int>? qtyBaseDelta,
    Value<MovementType>? type,
    Value<String?>? refType,
    Value<String?>? refId,
    Value<double?>? costPerBase,
    Value<DateTime>? occurredAt,
    Value<String?>? note,
    Value<String?>? deviceId,
    Value<int?>? serverSeq,
    Value<int>? rowid,
  }) {
    return StockMovementsCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      productId: productId ?? this.productId,
      qtyBaseDelta: qtyBaseDelta ?? this.qtyBaseDelta,
      type: type ?? this.type,
      refType: refType ?? this.refType,
      refId: refId ?? this.refId,
      costPerBase: costPerBase ?? this.costPerBase,
      occurredAt: occurredAt ?? this.occurredAt,
      note: note ?? this.note,
      deviceId: deviceId ?? this.deviceId,
      serverSeq: serverSeq ?? this.serverSeq,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (qtyBaseDelta.present) {
      map['qty_base_delta'] = Variable<int>(qtyBaseDelta.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $StockMovementsTable.$convertertype.toSql(type.value),
      );
    }
    if (refType.present) {
      map['ref_type'] = Variable<String>(refType.value);
    }
    if (refId.present) {
      map['ref_id'] = Variable<String>(refId.value);
    }
    if (costPerBase.present) {
      map['cost_per_base'] = Variable<double>(costPerBase.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockMovementsCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('productId: $productId, ')
          ..write('qtyBaseDelta: $qtyBaseDelta, ')
          ..write('type: $type, ')
          ..write('refType: $refType, ')
          ..write('refId: $refId, ')
          ..write('costPerBase: $costPerBase, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('note: $note, ')
          ..write('deviceId: $deviceId, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PutawayLogTable extends PutawayLog
    with TableInfo<$PutawayLogTable, PutawayLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PutawayLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromLocationMeta = const VerificationMeta(
    'fromLocation',
  );
  @override
  late final GeneratedColumn<String> fromLocation = GeneratedColumn<String>(
    'from_location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toLocationMeta = const VerificationMeta(
    'toLocation',
  );
  @override
  late final GeneratedColumn<String> toLocation = GeneratedColumn<String>(
    'to_location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    productId,
    fromLocation,
    toLocation,
    occurredAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'putaway_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<PutawayLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('from_location')) {
      context.handle(
        _fromLocationMeta,
        fromLocation.isAcceptableOrUnknown(
          data['from_location']!,
          _fromLocationMeta,
        ),
      );
    }
    if (data.containsKey('to_location')) {
      context.handle(
        _toLocationMeta,
        toLocation.isAcceptableOrUnknown(data['to_location']!, _toLocationMeta),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PutawayLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PutawayLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      fromLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_location'],
      ),
      toLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_location'],
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
    );
  }

  @override
  $PutawayLogTable createAlias(String alias) {
    return $PutawayLogTable(attachedDatabase, alias);
  }
}

class PutawayLogData extends DataClass implements Insertable<PutawayLogData> {
  final String id;
  final String storeId;
  final String productId;
  final String? fromLocation;
  final String? toLocation;
  final DateTime occurredAt;
  final String? deviceId;
  const PutawayLogData({
    required this.id,
    required this.storeId,
    required this.productId,
    this.fromLocation,
    this.toLocation,
    required this.occurredAt,
    this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['product_id'] = Variable<String>(productId);
    if (!nullToAbsent || fromLocation != null) {
      map['from_location'] = Variable<String>(fromLocation);
    }
    if (!nullToAbsent || toLocation != null) {
      map['to_location'] = Variable<String>(toLocation);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    return map;
  }

  PutawayLogCompanion toCompanion(bool nullToAbsent) {
    return PutawayLogCompanion(
      id: Value(id),
      storeId: Value(storeId),
      productId: Value(productId),
      fromLocation: fromLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(fromLocation),
      toLocation: toLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(toLocation),
      occurredAt: Value(occurredAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
    );
  }

  factory PutawayLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PutawayLogData(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      productId: serializer.fromJson<String>(json['productId']),
      fromLocation: serializer.fromJson<String?>(json['fromLocation']),
      toLocation: serializer.fromJson<String?>(json['toLocation']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'productId': serializer.toJson<String>(productId),
      'fromLocation': serializer.toJson<String?>(fromLocation),
      'toLocation': serializer.toJson<String?>(toLocation),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'deviceId': serializer.toJson<String?>(deviceId),
    };
  }

  PutawayLogData copyWith({
    String? id,
    String? storeId,
    String? productId,
    Value<String?> fromLocation = const Value.absent(),
    Value<String?> toLocation = const Value.absent(),
    DateTime? occurredAt,
    Value<String?> deviceId = const Value.absent(),
  }) => PutawayLogData(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    productId: productId ?? this.productId,
    fromLocation: fromLocation.present ? fromLocation.value : this.fromLocation,
    toLocation: toLocation.present ? toLocation.value : this.toLocation,
    occurredAt: occurredAt ?? this.occurredAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
  );
  PutawayLogData copyWithCompanion(PutawayLogCompanion data) {
    return PutawayLogData(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      productId: data.productId.present ? data.productId.value : this.productId,
      fromLocation: data.fromLocation.present
          ? data.fromLocation.value
          : this.fromLocation,
      toLocation: data.toLocation.present
          ? data.toLocation.value
          : this.toLocation,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PutawayLogData(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('productId: $productId, ')
          ..write('fromLocation: $fromLocation, ')
          ..write('toLocation: $toLocation, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    productId,
    fromLocation,
    toLocation,
    occurredAt,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PutawayLogData &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.productId == this.productId &&
          other.fromLocation == this.fromLocation &&
          other.toLocation == this.toLocation &&
          other.occurredAt == this.occurredAt &&
          other.deviceId == this.deviceId);
}

class PutawayLogCompanion extends UpdateCompanion<PutawayLogData> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<String> productId;
  final Value<String?> fromLocation;
  final Value<String?> toLocation;
  final Value<DateTime> occurredAt;
  final Value<String?> deviceId;
  final Value<int> rowid;
  const PutawayLogCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.productId = const Value.absent(),
    this.fromLocation = const Value.absent(),
    this.toLocation = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PutawayLogCompanion.insert({
    required String id,
    required String storeId,
    required String productId,
    this.fromLocation = const Value.absent(),
    this.toLocation = const Value.absent(),
    required DateTime occurredAt,
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       productId = Value(productId),
       occurredAt = Value(occurredAt);
  static Insertable<PutawayLogData> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<String>? productId,
    Expression<String>? fromLocation,
    Expression<String>? toLocation,
    Expression<DateTime>? occurredAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (productId != null) 'product_id': productId,
      if (fromLocation != null) 'from_location': fromLocation,
      if (toLocation != null) 'to_location': toLocation,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PutawayLogCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<String>? productId,
    Value<String?>? fromLocation,
    Value<String?>? toLocation,
    Value<DateTime>? occurredAt,
    Value<String?>? deviceId,
    Value<int>? rowid,
  }) {
    return PutawayLogCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      productId: productId ?? this.productId,
      fromLocation: fromLocation ?? this.fromLocation,
      toLocation: toLocation ?? this.toLocation,
      occurredAt: occurredAt ?? this.occurredAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (fromLocation.present) {
      map['from_location'] = Variable<String>(fromLocation.value);
    }
    if (toLocation.present) {
      map['to_location'] = Variable<String>(toLocation.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PutawayLogCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('productId: $productId, ')
          ..write('fromLocation: $fromLocation, ')
          ..write('toLocation: $toLocation, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creditLimitMeta = const VerificationMeta(
    'creditLimit',
  );
  @override
  late final GeneratedColumn<int> creditLimit = GeneratedColumn<int>(
    'credit_limit',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    name,
    phone,
    note,
    creditLimit,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Customer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('credit_limit')) {
      context.handle(
        _creditLimitMeta,
        creditLimit.isAcceptableOrUnknown(
          data['credit_limit']!,
          _creditLimitMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      creditLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credit_limit'],
      ),
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final String id;
  final String storeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? deviceId;
  final String name;
  final String? phone;
  final String? note;
  final int? creditLimit;
  const Customer({
    required this.id,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.deviceId,
    required this.name,
    this.phone,
    this.note,
    this.creditLimit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || creditLimit != null) {
      map['credit_limit'] = Variable<int>(creditLimit);
    }
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      storeId: Value(storeId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      creditLimit: creditLimit == null && nullToAbsent
          ? const Value.absent()
          : Value(creditLimit),
    );
  }

  factory Customer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      note: serializer.fromJson<String?>(json['note']),
      creditLimit: serializer.fromJson<int?>(json['creditLimit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'note': serializer.toJson<String?>(note),
      'creditLimit': serializer.toJson<int?>(creditLimit),
    };
  }

  Customer copyWith({
    String? id,
    String? storeId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    String? name,
    Value<String?> phone = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<int?> creditLimit = const Value.absent(),
  }) => Customer(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    note: note.present ? note.value : this.note,
    creditLimit: creditLimit.present ? creditLimit.value : this.creditLimit,
  );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      note: data.note.present ? data.note.value : this.note,
      creditLimit: data.creditLimit.present
          ? data.creditLimit.value
          : this.creditLimit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('note: $note, ')
          ..write('creditLimit: $creditLimit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    name,
    phone,
    note,
    creditLimit,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.note == this.note &&
          other.creditLimit == this.creditLimit);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> deviceId;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> note;
  final Value<int?> creditLimit;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.note = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    required String id,
    required String storeId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.note = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       name = Value(name);
  static Insertable<Customer> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? note,
    Expression<int>? creditLimit,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (note != null) 'note': note,
      if (creditLimit != null) 'credit_limit': creditLimit,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? deviceId,
    Value<String>? name,
    Value<String?>? phone,
    Value<String?>? note,
    Value<int?>? creditLimit,
    Value<int>? rowid,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      note: note ?? this.note,
      creditLimit: creditLimit ?? this.creditLimit,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (creditLimit.present) {
      map['credit_limit'] = Variable<int>(creditLimit.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('note: $note, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DebtLedgerTable extends DebtLedger
    with TableInfo<$DebtLedgerTable, DebtLedgerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtLedgerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deltaMeta = const VerificationMeta('delta');
  @override
  late final GeneratedColumn<int> delta = GeneratedColumn<int>(
    'delta',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DebtType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DebtType>($DebtLedgerTable.$convertertype);
  static const VerificationMeta _refIdMeta = const VerificationMeta('refId');
  @override
  late final GeneratedColumn<String> refId = GeneratedColumn<String>(
    'ref_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PayMethod?, String> method =
      GeneratedColumn<String>(
        'method',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<PayMethod?>($DebtLedgerTable.$convertermethodn);
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    customerId,
    delta,
    type,
    refId,
    method,
    occurredAt,
    note,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debt_ledger';
  @override
  VerificationContext validateIntegrity(
    Insertable<DebtLedgerData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('delta')) {
      context.handle(
        _deltaMeta,
        delta.isAcceptableOrUnknown(data['delta']!, _deltaMeta),
      );
    } else if (isInserting) {
      context.missing(_deltaMeta);
    }
    if (data.containsKey('ref_id')) {
      context.handle(
        _refIdMeta,
        refId.isAcceptableOrUnknown(data['ref_id']!, _refIdMeta),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DebtLedgerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DebtLedgerData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      delta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}delta'],
      )!,
      type: $DebtLedgerTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      refId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref_id'],
      ),
      method: $DebtLedgerTable.$convertermethodn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}method'],
        ),
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
    );
  }

  @override
  $DebtLedgerTable createAlias(String alias) {
    return $DebtLedgerTable(attachedDatabase, alias);
  }

  static TypeConverter<DebtType, String> $convertertype =
      const DebtTypeConverter();
  static TypeConverter<PayMethod, String> $convertermethod =
      const PayMethodConverter();
  static TypeConverter<PayMethod?, String?> $convertermethodn =
      NullAwareTypeConverter.wrap($convertermethod);
}

class DebtLedgerData extends DataClass implements Insertable<DebtLedgerData> {
  final String id;
  final String storeId;
  final String customerId;
  final int delta;
  final DebtType type;
  final String? refId;
  final PayMethod? method;
  final DateTime occurredAt;
  final String? note;
  final String? deviceId;
  const DebtLedgerData({
    required this.id,
    required this.storeId,
    required this.customerId,
    required this.delta,
    required this.type,
    this.refId,
    this.method,
    required this.occurredAt,
    this.note,
    this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['customer_id'] = Variable<String>(customerId);
    map['delta'] = Variable<int>(delta);
    {
      map['type'] = Variable<String>(
        $DebtLedgerTable.$convertertype.toSql(type),
      );
    }
    if (!nullToAbsent || refId != null) {
      map['ref_id'] = Variable<String>(refId);
    }
    if (!nullToAbsent || method != null) {
      map['method'] = Variable<String>(
        $DebtLedgerTable.$convertermethodn.toSql(method),
      );
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    return map;
  }

  DebtLedgerCompanion toCompanion(bool nullToAbsent) {
    return DebtLedgerCompanion(
      id: Value(id),
      storeId: Value(storeId),
      customerId: Value(customerId),
      delta: Value(delta),
      type: Value(type),
      refId: refId == null && nullToAbsent
          ? const Value.absent()
          : Value(refId),
      method: method == null && nullToAbsent
          ? const Value.absent()
          : Value(method),
      occurredAt: Value(occurredAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
    );
  }

  factory DebtLedgerData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DebtLedgerData(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      customerId: serializer.fromJson<String>(json['customerId']),
      delta: serializer.fromJson<int>(json['delta']),
      type: serializer.fromJson<DebtType>(json['type']),
      refId: serializer.fromJson<String?>(json['refId']),
      method: serializer.fromJson<PayMethod?>(json['method']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      note: serializer.fromJson<String?>(json['note']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'customerId': serializer.toJson<String>(customerId),
      'delta': serializer.toJson<int>(delta),
      'type': serializer.toJson<DebtType>(type),
      'refId': serializer.toJson<String?>(refId),
      'method': serializer.toJson<PayMethod?>(method),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'note': serializer.toJson<String?>(note),
      'deviceId': serializer.toJson<String?>(deviceId),
    };
  }

  DebtLedgerData copyWith({
    String? id,
    String? storeId,
    String? customerId,
    int? delta,
    DebtType? type,
    Value<String?> refId = const Value.absent(),
    Value<PayMethod?> method = const Value.absent(),
    DateTime? occurredAt,
    Value<String?> note = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
  }) => DebtLedgerData(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    customerId: customerId ?? this.customerId,
    delta: delta ?? this.delta,
    type: type ?? this.type,
    refId: refId.present ? refId.value : this.refId,
    method: method.present ? method.value : this.method,
    occurredAt: occurredAt ?? this.occurredAt,
    note: note.present ? note.value : this.note,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
  );
  DebtLedgerData copyWithCompanion(DebtLedgerCompanion data) {
    return DebtLedgerData(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      delta: data.delta.present ? data.delta.value : this.delta,
      type: data.type.present ? data.type.value : this.type,
      refId: data.refId.present ? data.refId.value : this.refId,
      method: data.method.present ? data.method.value : this.method,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      note: data.note.present ? data.note.value : this.note,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DebtLedgerData(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('customerId: $customerId, ')
          ..write('delta: $delta, ')
          ..write('type: $type, ')
          ..write('refId: $refId, ')
          ..write('method: $method, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('note: $note, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    customerId,
    delta,
    type,
    refId,
    method,
    occurredAt,
    note,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DebtLedgerData &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.customerId == this.customerId &&
          other.delta == this.delta &&
          other.type == this.type &&
          other.refId == this.refId &&
          other.method == this.method &&
          other.occurredAt == this.occurredAt &&
          other.note == this.note &&
          other.deviceId == this.deviceId);
}

class DebtLedgerCompanion extends UpdateCompanion<DebtLedgerData> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<String> customerId;
  final Value<int> delta;
  final Value<DebtType> type;
  final Value<String?> refId;
  final Value<PayMethod?> method;
  final Value<DateTime> occurredAt;
  final Value<String?> note;
  final Value<String?> deviceId;
  final Value<int> rowid;
  const DebtLedgerCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.delta = const Value.absent(),
    this.type = const Value.absent(),
    this.refId = const Value.absent(),
    this.method = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.note = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DebtLedgerCompanion.insert({
    required String id,
    required String storeId,
    required String customerId,
    required int delta,
    required DebtType type,
    this.refId = const Value.absent(),
    this.method = const Value.absent(),
    required DateTime occurredAt,
    this.note = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       customerId = Value(customerId),
       delta = Value(delta),
       type = Value(type),
       occurredAt = Value(occurredAt);
  static Insertable<DebtLedgerData> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<String>? customerId,
    Expression<int>? delta,
    Expression<String>? type,
    Expression<String>? refId,
    Expression<String>? method,
    Expression<DateTime>? occurredAt,
    Expression<String>? note,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (customerId != null) 'customer_id': customerId,
      if (delta != null) 'delta': delta,
      if (type != null) 'type': type,
      if (refId != null) 'ref_id': refId,
      if (method != null) 'method': method,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (note != null) 'note': note,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DebtLedgerCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<String>? customerId,
    Value<int>? delta,
    Value<DebtType>? type,
    Value<String?>? refId,
    Value<PayMethod?>? method,
    Value<DateTime>? occurredAt,
    Value<String?>? note,
    Value<String?>? deviceId,
    Value<int>? rowid,
  }) {
    return DebtLedgerCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      customerId: customerId ?? this.customerId,
      delta: delta ?? this.delta,
      type: type ?? this.type,
      refId: refId ?? this.refId,
      method: method ?? this.method,
      occurredAt: occurredAt ?? this.occurredAt,
      note: note ?? this.note,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (delta.present) {
      map['delta'] = Variable<int>(delta.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $DebtLedgerTable.$convertertype.toSql(type.value),
      );
    }
    if (refId.present) {
      map['ref_id'] = Variable<String>(refId.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(
        $DebtLedgerTable.$convertermethodn.toSql(method.value),
      );
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtLedgerCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('customerId: $customerId, ')
          ..write('delta: $delta, ')
          ..write('type: $type, ')
          ..write('refId: $refId, ')
          ..write('method: $method, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('note: $note, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, Sale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptNoMeta = const VerificationMeta(
    'receiptNo',
  );
  @override
  late final GeneratedColumn<String> receiptNo = GeneratedColumn<String>(
    'receipt_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cashierIdMeta = const VerificationMeta(
    'cashierId',
  );
  @override
  late final GeneratedColumn<String> cashierId = GeneratedColumn<String>(
    'cashier_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _soldAtMeta = const VerificationMeta('soldAt');
  @override
  late final GeneratedColumn<DateTime> soldAt = GeneratedColumn<DateTime>(
    'sold_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<int> subtotal = GeneratedColumn<int>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountTotalMeta = const VerificationMeta(
    'discountTotal',
  );
  @override
  late final GeneratedColumn<int> discountTotal = GeneratedColumn<int>(
    'discount_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidTotalMeta = const VerificationMeta(
    'paidTotal',
  );
  @override
  late final GeneratedColumn<int> paidTotal = GeneratedColumn<int>(
    'paid_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changeAmountMeta = const VerificationMeta(
    'changeAmount',
  );
  @override
  late final GeneratedColumn<int> changeAmount = GeneratedColumn<int>(
    'change_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SaleStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('completed'),
      ).withConverter<SaleStatus>($SalesTable.$converterstatus);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    receiptNo,
    cashierId,
    customerId,
    soldAt,
    subtotal,
    discountTotal,
    total,
    paidTotal,
    changeAmount,
    status,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(
    Insertable<Sale> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('receipt_no')) {
      context.handle(
        _receiptNoMeta,
        receiptNo.isAcceptableOrUnknown(data['receipt_no']!, _receiptNoMeta),
      );
    } else if (isInserting) {
      context.missing(_receiptNoMeta);
    }
    if (data.containsKey('cashier_id')) {
      context.handle(
        _cashierIdMeta,
        cashierId.isAcceptableOrUnknown(data['cashier_id']!, _cashierIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cashierIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('sold_at')) {
      context.handle(
        _soldAtMeta,
        soldAt.isAcceptableOrUnknown(data['sold_at']!, _soldAtMeta),
      );
    } else if (isInserting) {
      context.missing(_soldAtMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('discount_total')) {
      context.handle(
        _discountTotalMeta,
        discountTotal.isAcceptableOrUnknown(
          data['discount_total']!,
          _discountTotalMeta,
        ),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('paid_total')) {
      context.handle(
        _paidTotalMeta,
        paidTotal.isAcceptableOrUnknown(data['paid_total']!, _paidTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_paidTotalMeta);
    }
    if (data.containsKey('change_amount')) {
      context.handle(
        _changeAmountMeta,
        changeAmount.isAcceptableOrUnknown(
          data['change_amount']!,
          _changeAmountMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {storeId, receiptNo},
  ];
  @override
  Sale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sale(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      receiptNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_no'],
      )!,
      cashierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cashier_id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      soldAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sold_at'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal'],
      )!,
      discountTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_total'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      paidTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paid_total'],
      )!,
      changeAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}change_amount'],
      )!,
      status: $SalesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }

  static TypeConverter<SaleStatus, String> $converterstatus =
      const SaleStatusConverter();
}

class Sale extends DataClass implements Insertable<Sale> {
  final String id;
  final String storeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? deviceId;
  final String receiptNo;
  final String cashierId;
  final String? customerId;
  final DateTime soldAt;
  final int subtotal;
  final int discountTotal;
  final int total;
  final int paidTotal;
  final int changeAmount;
  final SaleStatus status;
  final String? note;
  const Sale({
    required this.id,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.deviceId,
    required this.receiptNo,
    required this.cashierId,
    this.customerId,
    required this.soldAt,
    required this.subtotal,
    required this.discountTotal,
    required this.total,
    required this.paidTotal,
    required this.changeAmount,
    required this.status,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['receipt_no'] = Variable<String>(receiptNo);
    map['cashier_id'] = Variable<String>(cashierId);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    map['sold_at'] = Variable<DateTime>(soldAt);
    map['subtotal'] = Variable<int>(subtotal);
    map['discount_total'] = Variable<int>(discountTotal);
    map['total'] = Variable<int>(total);
    map['paid_total'] = Variable<int>(paidTotal);
    map['change_amount'] = Variable<int>(changeAmount);
    {
      map['status'] = Variable<String>(
        $SalesTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      storeId: Value(storeId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      receiptNo: Value(receiptNo),
      cashierId: Value(cashierId),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      soldAt: Value(soldAt),
      subtotal: Value(subtotal),
      discountTotal: Value(discountTotal),
      total: Value(total),
      paidTotal: Value(paidTotal),
      changeAmount: Value(changeAmount),
      status: Value(status),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Sale.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sale(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      receiptNo: serializer.fromJson<String>(json['receiptNo']),
      cashierId: serializer.fromJson<String>(json['cashierId']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      soldAt: serializer.fromJson<DateTime>(json['soldAt']),
      subtotal: serializer.fromJson<int>(json['subtotal']),
      discountTotal: serializer.fromJson<int>(json['discountTotal']),
      total: serializer.fromJson<int>(json['total']),
      paidTotal: serializer.fromJson<int>(json['paidTotal']),
      changeAmount: serializer.fromJson<int>(json['changeAmount']),
      status: serializer.fromJson<SaleStatus>(json['status']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'receiptNo': serializer.toJson<String>(receiptNo),
      'cashierId': serializer.toJson<String>(cashierId),
      'customerId': serializer.toJson<String?>(customerId),
      'soldAt': serializer.toJson<DateTime>(soldAt),
      'subtotal': serializer.toJson<int>(subtotal),
      'discountTotal': serializer.toJson<int>(discountTotal),
      'total': serializer.toJson<int>(total),
      'paidTotal': serializer.toJson<int>(paidTotal),
      'changeAmount': serializer.toJson<int>(changeAmount),
      'status': serializer.toJson<SaleStatus>(status),
      'note': serializer.toJson<String?>(note),
    };
  }

  Sale copyWith({
    String? id,
    String? storeId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    String? receiptNo,
    String? cashierId,
    Value<String?> customerId = const Value.absent(),
    DateTime? soldAt,
    int? subtotal,
    int? discountTotal,
    int? total,
    int? paidTotal,
    int? changeAmount,
    SaleStatus? status,
    Value<String?> note = const Value.absent(),
  }) => Sale(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    receiptNo: receiptNo ?? this.receiptNo,
    cashierId: cashierId ?? this.cashierId,
    customerId: customerId.present ? customerId.value : this.customerId,
    soldAt: soldAt ?? this.soldAt,
    subtotal: subtotal ?? this.subtotal,
    discountTotal: discountTotal ?? this.discountTotal,
    total: total ?? this.total,
    paidTotal: paidTotal ?? this.paidTotal,
    changeAmount: changeAmount ?? this.changeAmount,
    status: status ?? this.status,
    note: note.present ? note.value : this.note,
  );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      receiptNo: data.receiptNo.present ? data.receiptNo.value : this.receiptNo,
      cashierId: data.cashierId.present ? data.cashierId.value : this.cashierId,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      soldAt: data.soldAt.present ? data.soldAt.value : this.soldAt,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      discountTotal: data.discountTotal.present
          ? data.discountTotal.value
          : this.discountTotal,
      total: data.total.present ? data.total.value : this.total,
      paidTotal: data.paidTotal.present ? data.paidTotal.value : this.paidTotal,
      changeAmount: data.changeAmount.present
          ? data.changeAmount.value
          : this.changeAmount,
      status: data.status.present ? data.status.value : this.status,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sale(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('receiptNo: $receiptNo, ')
          ..write('cashierId: $cashierId, ')
          ..write('customerId: $customerId, ')
          ..write('soldAt: $soldAt, ')
          ..write('subtotal: $subtotal, ')
          ..write('discountTotal: $discountTotal, ')
          ..write('total: $total, ')
          ..write('paidTotal: $paidTotal, ')
          ..write('changeAmount: $changeAmount, ')
          ..write('status: $status, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    receiptNo,
    cashierId,
    customerId,
    soldAt,
    subtotal,
    discountTotal,
    total,
    paidTotal,
    changeAmount,
    status,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.receiptNo == this.receiptNo &&
          other.cashierId == this.cashierId &&
          other.customerId == this.customerId &&
          other.soldAt == this.soldAt &&
          other.subtotal == this.subtotal &&
          other.discountTotal == this.discountTotal &&
          other.total == this.total &&
          other.paidTotal == this.paidTotal &&
          other.changeAmount == this.changeAmount &&
          other.status == this.status &&
          other.note == this.note);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> deviceId;
  final Value<String> receiptNo;
  final Value<String> cashierId;
  final Value<String?> customerId;
  final Value<DateTime> soldAt;
  final Value<int> subtotal;
  final Value<int> discountTotal;
  final Value<int> total;
  final Value<int> paidTotal;
  final Value<int> changeAmount;
  final Value<SaleStatus> status;
  final Value<String?> note;
  final Value<int> rowid;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.receiptNo = const Value.absent(),
    this.cashierId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.soldAt = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discountTotal = const Value.absent(),
    this.total = const Value.absent(),
    this.paidTotal = const Value.absent(),
    this.changeAmount = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalesCompanion.insert({
    required String id,
    required String storeId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String receiptNo,
    required String cashierId,
    this.customerId = const Value.absent(),
    required DateTime soldAt,
    required int subtotal,
    this.discountTotal = const Value.absent(),
    required int total,
    required int paidTotal,
    this.changeAmount = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       receiptNo = Value(receiptNo),
       cashierId = Value(cashierId),
       soldAt = Value(soldAt),
       subtotal = Value(subtotal),
       total = Value(total),
       paidTotal = Value(paidTotal);
  static Insertable<Sale> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? receiptNo,
    Expression<String>? cashierId,
    Expression<String>? customerId,
    Expression<DateTime>? soldAt,
    Expression<int>? subtotal,
    Expression<int>? discountTotal,
    Expression<int>? total,
    Expression<int>? paidTotal,
    Expression<int>? changeAmount,
    Expression<String>? status,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (receiptNo != null) 'receipt_no': receiptNo,
      if (cashierId != null) 'cashier_id': cashierId,
      if (customerId != null) 'customer_id': customerId,
      if (soldAt != null) 'sold_at': soldAt,
      if (subtotal != null) 'subtotal': subtotal,
      if (discountTotal != null) 'discount_total': discountTotal,
      if (total != null) 'total': total,
      if (paidTotal != null) 'paid_total': paidTotal,
      if (changeAmount != null) 'change_amount': changeAmount,
      if (status != null) 'status': status,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalesCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? deviceId,
    Value<String>? receiptNo,
    Value<String>? cashierId,
    Value<String?>? customerId,
    Value<DateTime>? soldAt,
    Value<int>? subtotal,
    Value<int>? discountTotal,
    Value<int>? total,
    Value<int>? paidTotal,
    Value<int>? changeAmount,
    Value<SaleStatus>? status,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return SalesCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      receiptNo: receiptNo ?? this.receiptNo,
      cashierId: cashierId ?? this.cashierId,
      customerId: customerId ?? this.customerId,
      soldAt: soldAt ?? this.soldAt,
      subtotal: subtotal ?? this.subtotal,
      discountTotal: discountTotal ?? this.discountTotal,
      total: total ?? this.total,
      paidTotal: paidTotal ?? this.paidTotal,
      changeAmount: changeAmount ?? this.changeAmount,
      status: status ?? this.status,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (receiptNo.present) {
      map['receipt_no'] = Variable<String>(receiptNo.value);
    }
    if (cashierId.present) {
      map['cashier_id'] = Variable<String>(cashierId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (soldAt.present) {
      map['sold_at'] = Variable<DateTime>(soldAt.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<int>(subtotal.value);
    }
    if (discountTotal.present) {
      map['discount_total'] = Variable<int>(discountTotal.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (paidTotal.present) {
      map['paid_total'] = Variable<int>(paidTotal.value);
    }
    if (changeAmount.present) {
      map['change_amount'] = Variable<int>(changeAmount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $SalesTable.$converterstatus.toSql(status.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('receiptNo: $receiptNo, ')
          ..write('cashierId: $cashierId, ')
          ..write('customerId: $customerId, ')
          ..write('soldAt: $soldAt, ')
          ..write('subtotal: $subtotal, ')
          ..write('discountTotal: $discountTotal, ')
          ..write('total: $total, ')
          ..write('paidTotal: $paidTotal, ')
          ..write('changeAmount: $changeAmount, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SaleItemsTable extends SaleItems
    with TableInfo<$SaleItemsTable, SaleItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<String> unitId = GeneratedColumn<String>(
    'unit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyBaseMeta = const VerificationMeta(
    'qtyBase',
  );
  @override
  late final GeneratedColumn<int> qtyBase = GeneratedColumn<int>(
    'qty_base',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<int> unitPrice = GeneratedColumn<int>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountMeta = const VerificationMeta(
    'discount',
  );
  @override
  late final GeneratedColumn<int> discount = GeneratedColumn<int>(
    'discount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lineTotalMeta = const VerificationMeta(
    'lineTotal',
  );
  @override
  late final GeneratedColumn<int> lineTotal = GeneratedColumn<int>(
    'line_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costPerBaseMeta = const VerificationMeta(
    'costPerBase',
  );
  @override
  late final GeneratedColumn<double> costPerBase = GeneratedColumn<double>(
    'cost_per_base',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    saleId,
    productId,
    unitId,
    qty,
    qtyBase,
    unitPrice,
    discount,
    lineTotal,
    costPerBase,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('qty_base')) {
      context.handle(
        _qtyBaseMeta,
        qtyBase.isAcceptableOrUnknown(data['qty_base']!, _qtyBaseMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyBaseMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(
        _discountMeta,
        discount.isAcceptableOrUnknown(data['discount']!, _discountMeta),
      );
    }
    if (data.containsKey('line_total')) {
      context.handle(
        _lineTotalMeta,
        lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_lineTotalMeta);
    }
    if (data.containsKey('cost_per_base')) {
      context.handle(
        _costPerBaseMeta,
        costPerBase.isAcceptableOrUnknown(
          data['cost_per_base']!,
          _costPerBaseMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_id'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty'],
      )!,
      qtyBase: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty_base'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price'],
      )!,
      discount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount'],
      )!,
      lineTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_total'],
      )!,
      costPerBase: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost_per_base'],
      ),
    );
  }

  @override
  $SaleItemsTable createAlias(String alias) {
    return $SaleItemsTable(attachedDatabase, alias);
  }
}

class SaleItem extends DataClass implements Insertable<SaleItem> {
  final String id;
  final String storeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? deviceId;
  final String saleId;
  final String productId;
  final String unitId;
  final int qty;
  final int qtyBase;
  final int unitPrice;
  final int discount;
  final int lineTotal;

  /// Snapshot HPP per satuan dasar saat penjualan (SPEC §6.10).
  final double? costPerBase;
  const SaleItem({
    required this.id,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.deviceId,
    required this.saleId,
    required this.productId,
    required this.unitId,
    required this.qty,
    required this.qtyBase,
    required this.unitPrice,
    required this.discount,
    required this.lineTotal,
    this.costPerBase,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['sale_id'] = Variable<String>(saleId);
    map['product_id'] = Variable<String>(productId);
    map['unit_id'] = Variable<String>(unitId);
    map['qty'] = Variable<int>(qty);
    map['qty_base'] = Variable<int>(qtyBase);
    map['unit_price'] = Variable<int>(unitPrice);
    map['discount'] = Variable<int>(discount);
    map['line_total'] = Variable<int>(lineTotal);
    if (!nullToAbsent || costPerBase != null) {
      map['cost_per_base'] = Variable<double>(costPerBase);
    }
    return map;
  }

  SaleItemsCompanion toCompanion(bool nullToAbsent) {
    return SaleItemsCompanion(
      id: Value(id),
      storeId: Value(storeId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      saleId: Value(saleId),
      productId: Value(productId),
      unitId: Value(unitId),
      qty: Value(qty),
      qtyBase: Value(qtyBase),
      unitPrice: Value(unitPrice),
      discount: Value(discount),
      lineTotal: Value(lineTotal),
      costPerBase: costPerBase == null && nullToAbsent
          ? const Value.absent()
          : Value(costPerBase),
    );
  }

  factory SaleItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleItem(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      saleId: serializer.fromJson<String>(json['saleId']),
      productId: serializer.fromJson<String>(json['productId']),
      unitId: serializer.fromJson<String>(json['unitId']),
      qty: serializer.fromJson<int>(json['qty']),
      qtyBase: serializer.fromJson<int>(json['qtyBase']),
      unitPrice: serializer.fromJson<int>(json['unitPrice']),
      discount: serializer.fromJson<int>(json['discount']),
      lineTotal: serializer.fromJson<int>(json['lineTotal']),
      costPerBase: serializer.fromJson<double?>(json['costPerBase']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'saleId': serializer.toJson<String>(saleId),
      'productId': serializer.toJson<String>(productId),
      'unitId': serializer.toJson<String>(unitId),
      'qty': serializer.toJson<int>(qty),
      'qtyBase': serializer.toJson<int>(qtyBase),
      'unitPrice': serializer.toJson<int>(unitPrice),
      'discount': serializer.toJson<int>(discount),
      'lineTotal': serializer.toJson<int>(lineTotal),
      'costPerBase': serializer.toJson<double?>(costPerBase),
    };
  }

  SaleItem copyWith({
    String? id,
    String? storeId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    String? saleId,
    String? productId,
    String? unitId,
    int? qty,
    int? qtyBase,
    int? unitPrice,
    int? discount,
    int? lineTotal,
    Value<double?> costPerBase = const Value.absent(),
  }) => SaleItem(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    saleId: saleId ?? this.saleId,
    productId: productId ?? this.productId,
    unitId: unitId ?? this.unitId,
    qty: qty ?? this.qty,
    qtyBase: qtyBase ?? this.qtyBase,
    unitPrice: unitPrice ?? this.unitPrice,
    discount: discount ?? this.discount,
    lineTotal: lineTotal ?? this.lineTotal,
    costPerBase: costPerBase.present ? costPerBase.value : this.costPerBase,
  );
  SaleItem copyWithCompanion(SaleItemsCompanion data) {
    return SaleItem(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      productId: data.productId.present ? data.productId.value : this.productId,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      qty: data.qty.present ? data.qty.value : this.qty,
      qtyBase: data.qtyBase.present ? data.qtyBase.value : this.qtyBase,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      discount: data.discount.present ? data.discount.value : this.discount,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
      costPerBase: data.costPerBase.present
          ? data.costPerBase.value
          : this.costPerBase,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleItem(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('unitId: $unitId, ')
          ..write('qty: $qty, ')
          ..write('qtyBase: $qtyBase, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('discount: $discount, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('costPerBase: $costPerBase')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    saleId,
    productId,
    unitId,
    qty,
    qtyBase,
    unitPrice,
    discount,
    lineTotal,
    costPerBase,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleItem &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.saleId == this.saleId &&
          other.productId == this.productId &&
          other.unitId == this.unitId &&
          other.qty == this.qty &&
          other.qtyBase == this.qtyBase &&
          other.unitPrice == this.unitPrice &&
          other.discount == this.discount &&
          other.lineTotal == this.lineTotal &&
          other.costPerBase == this.costPerBase);
}

class SaleItemsCompanion extends UpdateCompanion<SaleItem> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> deviceId;
  final Value<String> saleId;
  final Value<String> productId;
  final Value<String> unitId;
  final Value<int> qty;
  final Value<int> qtyBase;
  final Value<int> unitPrice;
  final Value<int> discount;
  final Value<int> lineTotal;
  final Value<double?> costPerBase;
  final Value<int> rowid;
  const SaleItemsCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.saleId = const Value.absent(),
    this.productId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.qty = const Value.absent(),
    this.qtyBase = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.discount = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.costPerBase = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SaleItemsCompanion.insert({
    required String id,
    required String storeId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String saleId,
    required String productId,
    required String unitId,
    required int qty,
    required int qtyBase,
    required int unitPrice,
    this.discount = const Value.absent(),
    required int lineTotal,
    this.costPerBase = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       saleId = Value(saleId),
       productId = Value(productId),
       unitId = Value(unitId),
       qty = Value(qty),
       qtyBase = Value(qtyBase),
       unitPrice = Value(unitPrice),
       lineTotal = Value(lineTotal);
  static Insertable<SaleItem> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? saleId,
    Expression<String>? productId,
    Expression<String>? unitId,
    Expression<int>? qty,
    Expression<int>? qtyBase,
    Expression<int>? unitPrice,
    Expression<int>? discount,
    Expression<int>? lineTotal,
    Expression<double>? costPerBase,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (saleId != null) 'sale_id': saleId,
      if (productId != null) 'product_id': productId,
      if (unitId != null) 'unit_id': unitId,
      if (qty != null) 'qty': qty,
      if (qtyBase != null) 'qty_base': qtyBase,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (discount != null) 'discount': discount,
      if (lineTotal != null) 'line_total': lineTotal,
      if (costPerBase != null) 'cost_per_base': costPerBase,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SaleItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? deviceId,
    Value<String>? saleId,
    Value<String>? productId,
    Value<String>? unitId,
    Value<int>? qty,
    Value<int>? qtyBase,
    Value<int>? unitPrice,
    Value<int>? discount,
    Value<int>? lineTotal,
    Value<double?>? costPerBase,
    Value<int>? rowid,
  }) {
    return SaleItemsCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      unitId: unitId ?? this.unitId,
      qty: qty ?? this.qty,
      qtyBase: qtyBase ?? this.qtyBase,
      unitPrice: unitPrice ?? this.unitPrice,
      discount: discount ?? this.discount,
      lineTotal: lineTotal ?? this.lineTotal,
      costPerBase: costPerBase ?? this.costPerBase,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<String>(unitId.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (qtyBase.present) {
      map['qty_base'] = Variable<int>(qtyBase.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<int>(unitPrice.value);
    }
    if (discount.present) {
      map['discount'] = Variable<int>(discount.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<int>(lineTotal.value);
    }
    if (costPerBase.present) {
      map['cost_per_base'] = Variable<double>(costPerBase.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleItemsCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('unitId: $unitId, ')
          ..write('qty: $qty, ')
          ..write('qtyBase: $qtyBase, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('discount: $discount, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('costPerBase: $costPerBase, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PayMethod, String> method =
      GeneratedColumn<String>(
        'method',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PayMethod>($PaymentsTable.$convertermethod);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PaymentStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('confirmed'),
      ).withConverter<PaymentStatus>($PaymentsTable.$converterstatus);
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
    'paid_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    saleId,
    method,
    amount,
    status,
    reference,
    paidAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Payment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    }
    if (data.containsKey('paid_at')) {
      context.handle(
        _paidAtMeta,
        paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta),
      );
    } else if (isInserting) {
      context.missing(_paidAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_id'],
      )!,
      method: $PaymentsTable.$convertermethod.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}method'],
        )!,
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      status: $PaymentsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      ),
      paidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_at'],
      )!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }

  static TypeConverter<PayMethod, String> $convertermethod =
      const PayMethodConverter();
  static TypeConverter<PaymentStatus, String> $converterstatus =
      const PaymentStatusConverter();
}

class Payment extends DataClass implements Insertable<Payment> {
  final String id;
  final String storeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? deviceId;
  final String saleId;
  final PayMethod method;
  final int amount;
  final PaymentStatus status;
  final String? reference;
  final DateTime paidAt;
  const Payment({
    required this.id,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.deviceId,
    required this.saleId,
    required this.method,
    required this.amount,
    required this.status,
    this.reference,
    required this.paidAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['sale_id'] = Variable<String>(saleId);
    {
      map['method'] = Variable<String>(
        $PaymentsTable.$convertermethod.toSql(method),
      );
    }
    map['amount'] = Variable<int>(amount);
    {
      map['status'] = Variable<String>(
        $PaymentsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    map['paid_at'] = Variable<DateTime>(paidAt);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      storeId: Value(storeId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      saleId: Value(saleId),
      method: Value(method),
      amount: Value(amount),
      status: Value(status),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      paidAt: Value(paidAt),
    );
  }

  factory Payment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      saleId: serializer.fromJson<String>(json['saleId']),
      method: serializer.fromJson<PayMethod>(json['method']),
      amount: serializer.fromJson<int>(json['amount']),
      status: serializer.fromJson<PaymentStatus>(json['status']),
      reference: serializer.fromJson<String?>(json['reference']),
      paidAt: serializer.fromJson<DateTime>(json['paidAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'saleId': serializer.toJson<String>(saleId),
      'method': serializer.toJson<PayMethod>(method),
      'amount': serializer.toJson<int>(amount),
      'status': serializer.toJson<PaymentStatus>(status),
      'reference': serializer.toJson<String?>(reference),
      'paidAt': serializer.toJson<DateTime>(paidAt),
    };
  }

  Payment copyWith({
    String? id,
    String? storeId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    String? saleId,
    PayMethod? method,
    int? amount,
    PaymentStatus? status,
    Value<String?> reference = const Value.absent(),
    DateTime? paidAt,
  }) => Payment(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    saleId: saleId ?? this.saleId,
    method: method ?? this.method,
    amount: amount ?? this.amount,
    status: status ?? this.status,
    reference: reference.present ? reference.value : this.reference,
    paidAt: paidAt ?? this.paidAt,
  );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      method: data.method.present ? data.method.value : this.method,
      amount: data.amount.present ? data.amount.value : this.amount,
      status: data.status.present ? data.status.value : this.status,
      reference: data.reference.present ? data.reference.value : this.reference,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('saleId: $saleId, ')
          ..write('method: $method, ')
          ..write('amount: $amount, ')
          ..write('status: $status, ')
          ..write('reference: $reference, ')
          ..write('paidAt: $paidAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    saleId,
    method,
    amount,
    status,
    reference,
    paidAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.saleId == this.saleId &&
          other.method == this.method &&
          other.amount == this.amount &&
          other.status == this.status &&
          other.reference == this.reference &&
          other.paidAt == this.paidAt);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> deviceId;
  final Value<String> saleId;
  final Value<PayMethod> method;
  final Value<int> amount;
  final Value<PaymentStatus> status;
  final Value<String?> reference;
  final Value<DateTime> paidAt;
  final Value<int> rowid;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.saleId = const Value.absent(),
    this.method = const Value.absent(),
    this.amount = const Value.absent(),
    this.status = const Value.absent(),
    this.reference = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentsCompanion.insert({
    required String id,
    required String storeId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String saleId,
    required PayMethod method,
    required int amount,
    this.status = const Value.absent(),
    this.reference = const Value.absent(),
    required DateTime paidAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       saleId = Value(saleId),
       method = Value(method),
       amount = Value(amount),
       paidAt = Value(paidAt);
  static Insertable<Payment> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? saleId,
    Expression<String>? method,
    Expression<int>? amount,
    Expression<String>? status,
    Expression<String>? reference,
    Expression<DateTime>? paidAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (saleId != null) 'sale_id': saleId,
      if (method != null) 'method': method,
      if (amount != null) 'amount': amount,
      if (status != null) 'status': status,
      if (reference != null) 'reference': reference,
      if (paidAt != null) 'paid_at': paidAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentsCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? deviceId,
    Value<String>? saleId,
    Value<PayMethod>? method,
    Value<int>? amount,
    Value<PaymentStatus>? status,
    Value<String?>? reference,
    Value<DateTime>? paidAt,
    Value<int>? rowid,
  }) {
    return PaymentsCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      saleId: saleId ?? this.saleId,
      method: method ?? this.method,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      reference: reference ?? this.reference,
      paidAt: paidAt ?? this.paidAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(
        $PaymentsTable.$convertermethod.toSql(method.value),
      );
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $PaymentsTable.$converterstatus.toSql(status.value),
      );
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('saleId: $saleId, ')
          ..write('method: $method, ')
          ..write('amount: $amount, ')
          ..write('status: $status, ')
          ..write('reference: $reference, ')
          ..write('paidAt: $paidAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReturnsTable extends Returns with TableInfo<$ReturnsTable, Return> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReturnsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ReturnKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ReturnKind>($ReturnsTable.$converterkind);
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
    'sale_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchaseIdMeta = const VerificationMeta(
    'purchaseId',
  );
  @override
  late final GeneratedColumn<String> purchaseId = GeneratedColumn<String>(
    'purchase_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _returnedAtMeta = const VerificationMeta(
    'returnedAt',
  );
  @override
  late final GeneratedColumn<DateTime> returnedAt = GeneratedColumn<DateTime>(
    'returned_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PayMethod?, String> refundMethod =
      GeneratedColumn<String>(
        'refund_method',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<PayMethod?>($ReturnsTable.$converterrefundMethodn);
  static const VerificationMeta _refundTotalMeta = const VerificationMeta(
    'refundTotal',
  );
  @override
  late final GeneratedColumn<int> refundTotal = GeneratedColumn<int>(
    'refund_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    kind,
    saleId,
    purchaseId,
    customerId,
    returnedAt,
    refundMethod,
    refundTotal,
    reason,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'returns';
  @override
  VerificationContext validateIntegrity(
    Insertable<Return> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
        _purchaseIdMeta,
        purchaseId.isAcceptableOrUnknown(data['purchase_id']!, _purchaseIdMeta),
      );
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('returned_at')) {
      context.handle(
        _returnedAtMeta,
        returnedAt.isAcceptableOrUnknown(data['returned_at']!, _returnedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_returnedAtMeta);
    }
    if (data.containsKey('refund_total')) {
      context.handle(
        _refundTotalMeta,
        refundTotal.isAcceptableOrUnknown(
          data['refund_total']!,
          _refundTotalMeta,
        ),
      );
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Return map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Return(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      kind: $ReturnsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_id'],
      ),
      purchaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_id'],
      ),
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      returnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}returned_at'],
      )!,
      refundMethod: $ReturnsTable.$converterrefundMethodn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}refund_method'],
        ),
      ),
      refundTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}refund_total'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
    );
  }

  @override
  $ReturnsTable createAlias(String alias) {
    return $ReturnsTable(attachedDatabase, alias);
  }

  static TypeConverter<ReturnKind, String> $converterkind =
      const ReturnKindConverter();
  static TypeConverter<PayMethod, String> $converterrefundMethod =
      const PayMethodConverter();
  static TypeConverter<PayMethod?, String?> $converterrefundMethodn =
      NullAwareTypeConverter.wrap($converterrefundMethod);
}

class Return extends DataClass implements Insertable<Return> {
  final String id;
  final String storeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? deviceId;
  final ReturnKind kind;
  final String? saleId;
  final String? purchaseId;
  final String? customerId;
  final DateTime returnedAt;
  final PayMethod? refundMethod;
  final int refundTotal;
  final String? reason;
  const Return({
    required this.id,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.deviceId,
    required this.kind,
    this.saleId,
    this.purchaseId,
    this.customerId,
    required this.returnedAt,
    this.refundMethod,
    required this.refundTotal,
    this.reason,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    {
      map['kind'] = Variable<String>($ReturnsTable.$converterkind.toSql(kind));
    }
    if (!nullToAbsent || saleId != null) {
      map['sale_id'] = Variable<String>(saleId);
    }
    if (!nullToAbsent || purchaseId != null) {
      map['purchase_id'] = Variable<String>(purchaseId);
    }
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    map['returned_at'] = Variable<DateTime>(returnedAt);
    if (!nullToAbsent || refundMethod != null) {
      map['refund_method'] = Variable<String>(
        $ReturnsTable.$converterrefundMethodn.toSql(refundMethod),
      );
    }
    map['refund_total'] = Variable<int>(refundTotal);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    return map;
  }

  ReturnsCompanion toCompanion(bool nullToAbsent) {
    return ReturnsCompanion(
      id: Value(id),
      storeId: Value(storeId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      kind: Value(kind),
      saleId: saleId == null && nullToAbsent
          ? const Value.absent()
          : Value(saleId),
      purchaseId: purchaseId == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseId),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      returnedAt: Value(returnedAt),
      refundMethod: refundMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(refundMethod),
      refundTotal: Value(refundTotal),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
    );
  }

  factory Return.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Return(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      kind: serializer.fromJson<ReturnKind>(json['kind']),
      saleId: serializer.fromJson<String?>(json['saleId']),
      purchaseId: serializer.fromJson<String?>(json['purchaseId']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      returnedAt: serializer.fromJson<DateTime>(json['returnedAt']),
      refundMethod: serializer.fromJson<PayMethod?>(json['refundMethod']),
      refundTotal: serializer.fromJson<int>(json['refundTotal']),
      reason: serializer.fromJson<String?>(json['reason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'kind': serializer.toJson<ReturnKind>(kind),
      'saleId': serializer.toJson<String?>(saleId),
      'purchaseId': serializer.toJson<String?>(purchaseId),
      'customerId': serializer.toJson<String?>(customerId),
      'returnedAt': serializer.toJson<DateTime>(returnedAt),
      'refundMethod': serializer.toJson<PayMethod?>(refundMethod),
      'refundTotal': serializer.toJson<int>(refundTotal),
      'reason': serializer.toJson<String?>(reason),
    };
  }

  Return copyWith({
    String? id,
    String? storeId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    ReturnKind? kind,
    Value<String?> saleId = const Value.absent(),
    Value<String?> purchaseId = const Value.absent(),
    Value<String?> customerId = const Value.absent(),
    DateTime? returnedAt,
    Value<PayMethod?> refundMethod = const Value.absent(),
    int? refundTotal,
    Value<String?> reason = const Value.absent(),
  }) => Return(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    kind: kind ?? this.kind,
    saleId: saleId.present ? saleId.value : this.saleId,
    purchaseId: purchaseId.present ? purchaseId.value : this.purchaseId,
    customerId: customerId.present ? customerId.value : this.customerId,
    returnedAt: returnedAt ?? this.returnedAt,
    refundMethod: refundMethod.present ? refundMethod.value : this.refundMethod,
    refundTotal: refundTotal ?? this.refundTotal,
    reason: reason.present ? reason.value : this.reason,
  );
  Return copyWithCompanion(ReturnsCompanion data) {
    return Return(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      kind: data.kind.present ? data.kind.value : this.kind,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      purchaseId: data.purchaseId.present
          ? data.purchaseId.value
          : this.purchaseId,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      returnedAt: data.returnedAt.present
          ? data.returnedAt.value
          : this.returnedAt,
      refundMethod: data.refundMethod.present
          ? data.refundMethod.value
          : this.refundMethod,
      refundTotal: data.refundTotal.present
          ? data.refundTotal.value
          : this.refundTotal,
      reason: data.reason.present ? data.reason.value : this.reason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Return(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('kind: $kind, ')
          ..write('saleId: $saleId, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('customerId: $customerId, ')
          ..write('returnedAt: $returnedAt, ')
          ..write('refundMethod: $refundMethod, ')
          ..write('refundTotal: $refundTotal, ')
          ..write('reason: $reason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    kind,
    saleId,
    purchaseId,
    customerId,
    returnedAt,
    refundMethod,
    refundTotal,
    reason,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Return &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.kind == this.kind &&
          other.saleId == this.saleId &&
          other.purchaseId == this.purchaseId &&
          other.customerId == this.customerId &&
          other.returnedAt == this.returnedAt &&
          other.refundMethod == this.refundMethod &&
          other.refundTotal == this.refundTotal &&
          other.reason == this.reason);
}

class ReturnsCompanion extends UpdateCompanion<Return> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> deviceId;
  final Value<ReturnKind> kind;
  final Value<String?> saleId;
  final Value<String?> purchaseId;
  final Value<String?> customerId;
  final Value<DateTime> returnedAt;
  final Value<PayMethod?> refundMethod;
  final Value<int> refundTotal;
  final Value<String?> reason;
  final Value<int> rowid;
  const ReturnsCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.kind = const Value.absent(),
    this.saleId = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.returnedAt = const Value.absent(),
    this.refundMethod = const Value.absent(),
    this.refundTotal = const Value.absent(),
    this.reason = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReturnsCompanion.insert({
    required String id,
    required String storeId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    required ReturnKind kind,
    this.saleId = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.customerId = const Value.absent(),
    required DateTime returnedAt,
    this.refundMethod = const Value.absent(),
    this.refundTotal = const Value.absent(),
    this.reason = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       kind = Value(kind),
       returnedAt = Value(returnedAt);
  static Insertable<Return> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? kind,
    Expression<String>? saleId,
    Expression<String>? purchaseId,
    Expression<String>? customerId,
    Expression<DateTime>? returnedAt,
    Expression<String>? refundMethod,
    Expression<int>? refundTotal,
    Expression<String>? reason,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (kind != null) 'kind': kind,
      if (saleId != null) 'sale_id': saleId,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (customerId != null) 'customer_id': customerId,
      if (returnedAt != null) 'returned_at': returnedAt,
      if (refundMethod != null) 'refund_method': refundMethod,
      if (refundTotal != null) 'refund_total': refundTotal,
      if (reason != null) 'reason': reason,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReturnsCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? deviceId,
    Value<ReturnKind>? kind,
    Value<String?>? saleId,
    Value<String?>? purchaseId,
    Value<String?>? customerId,
    Value<DateTime>? returnedAt,
    Value<PayMethod?>? refundMethod,
    Value<int>? refundTotal,
    Value<String?>? reason,
    Value<int>? rowid,
  }) {
    return ReturnsCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      kind: kind ?? this.kind,
      saleId: saleId ?? this.saleId,
      purchaseId: purchaseId ?? this.purchaseId,
      customerId: customerId ?? this.customerId,
      returnedAt: returnedAt ?? this.returnedAt,
      refundMethod: refundMethod ?? this.refundMethod,
      refundTotal: refundTotal ?? this.refundTotal,
      reason: reason ?? this.reason,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $ReturnsTable.$converterkind.toSql(kind.value),
      );
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<String>(purchaseId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (returnedAt.present) {
      map['returned_at'] = Variable<DateTime>(returnedAt.value);
    }
    if (refundMethod.present) {
      map['refund_method'] = Variable<String>(
        $ReturnsTable.$converterrefundMethodn.toSql(refundMethod.value),
      );
    }
    if (refundTotal.present) {
      map['refund_total'] = Variable<int>(refundTotal.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReturnsCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('kind: $kind, ')
          ..write('saleId: $saleId, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('customerId: $customerId, ')
          ..write('returnedAt: $returnedAt, ')
          ..write('refundMethod: $refundMethod, ')
          ..write('refundTotal: $refundTotal, ')
          ..write('reason: $reason, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReturnItemsTable extends ReturnItems
    with TableInfo<$ReturnItemsTable, ReturnItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReturnItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _returnIdMeta = const VerificationMeta(
    'returnId',
  );
  @override
  late final GeneratedColumn<String> returnId = GeneratedColumn<String>(
    'return_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<String> unitId = GeneratedColumn<String>(
    'unit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyBaseMeta = const VerificationMeta(
    'qtyBase',
  );
  @override
  late final GeneratedColumn<int> qtyBase = GeneratedColumn<int>(
    'qty_base',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costPerBaseMeta = const VerificationMeta(
    'costPerBase',
  );
  @override
  late final GeneratedColumn<double> costPerBase = GeneratedColumn<double>(
    'cost_per_base',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    returnId,
    productId,
    unitId,
    qty,
    qtyBase,
    amount,
    costPerBase,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'return_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReturnItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('return_id')) {
      context.handle(
        _returnIdMeta,
        returnId.isAcceptableOrUnknown(data['return_id']!, _returnIdMeta),
      );
    } else if (isInserting) {
      context.missing(_returnIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('qty_base')) {
      context.handle(
        _qtyBaseMeta,
        qtyBase.isAcceptableOrUnknown(data['qty_base']!, _qtyBaseMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyBaseMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('cost_per_base')) {
      context.handle(
        _costPerBaseMeta,
        costPerBase.isAcceptableOrUnknown(
          data['cost_per_base']!,
          _costPerBaseMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReturnItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReturnItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      returnId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}return_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_id'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty'],
      )!,
      qtyBase: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty_base'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      costPerBase: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost_per_base'],
      ),
    );
  }

  @override
  $ReturnItemsTable createAlias(String alias) {
    return $ReturnItemsTable(attachedDatabase, alias);
  }
}

class ReturnItem extends DataClass implements Insertable<ReturnItem> {
  final String id;
  final String storeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? deviceId;
  final String returnId;
  final String productId;
  final String unitId;
  final int qty;
  final int qtyBase;
  final int amount;
  final double? costPerBase;
  const ReturnItem({
    required this.id,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.deviceId,
    required this.returnId,
    required this.productId,
    required this.unitId,
    required this.qty,
    required this.qtyBase,
    required this.amount,
    this.costPerBase,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['return_id'] = Variable<String>(returnId);
    map['product_id'] = Variable<String>(productId);
    map['unit_id'] = Variable<String>(unitId);
    map['qty'] = Variable<int>(qty);
    map['qty_base'] = Variable<int>(qtyBase);
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || costPerBase != null) {
      map['cost_per_base'] = Variable<double>(costPerBase);
    }
    return map;
  }

  ReturnItemsCompanion toCompanion(bool nullToAbsent) {
    return ReturnItemsCompanion(
      id: Value(id),
      storeId: Value(storeId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      returnId: Value(returnId),
      productId: Value(productId),
      unitId: Value(unitId),
      qty: Value(qty),
      qtyBase: Value(qtyBase),
      amount: Value(amount),
      costPerBase: costPerBase == null && nullToAbsent
          ? const Value.absent()
          : Value(costPerBase),
    );
  }

  factory ReturnItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReturnItem(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      returnId: serializer.fromJson<String>(json['returnId']),
      productId: serializer.fromJson<String>(json['productId']),
      unitId: serializer.fromJson<String>(json['unitId']),
      qty: serializer.fromJson<int>(json['qty']),
      qtyBase: serializer.fromJson<int>(json['qtyBase']),
      amount: serializer.fromJson<int>(json['amount']),
      costPerBase: serializer.fromJson<double?>(json['costPerBase']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'returnId': serializer.toJson<String>(returnId),
      'productId': serializer.toJson<String>(productId),
      'unitId': serializer.toJson<String>(unitId),
      'qty': serializer.toJson<int>(qty),
      'qtyBase': serializer.toJson<int>(qtyBase),
      'amount': serializer.toJson<int>(amount),
      'costPerBase': serializer.toJson<double?>(costPerBase),
    };
  }

  ReturnItem copyWith({
    String? id,
    String? storeId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    String? returnId,
    String? productId,
    String? unitId,
    int? qty,
    int? qtyBase,
    int? amount,
    Value<double?> costPerBase = const Value.absent(),
  }) => ReturnItem(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    returnId: returnId ?? this.returnId,
    productId: productId ?? this.productId,
    unitId: unitId ?? this.unitId,
    qty: qty ?? this.qty,
    qtyBase: qtyBase ?? this.qtyBase,
    amount: amount ?? this.amount,
    costPerBase: costPerBase.present ? costPerBase.value : this.costPerBase,
  );
  ReturnItem copyWithCompanion(ReturnItemsCompanion data) {
    return ReturnItem(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      returnId: data.returnId.present ? data.returnId.value : this.returnId,
      productId: data.productId.present ? data.productId.value : this.productId,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      qty: data.qty.present ? data.qty.value : this.qty,
      qtyBase: data.qtyBase.present ? data.qtyBase.value : this.qtyBase,
      amount: data.amount.present ? data.amount.value : this.amount,
      costPerBase: data.costPerBase.present
          ? data.costPerBase.value
          : this.costPerBase,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReturnItem(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('returnId: $returnId, ')
          ..write('productId: $productId, ')
          ..write('unitId: $unitId, ')
          ..write('qty: $qty, ')
          ..write('qtyBase: $qtyBase, ')
          ..write('amount: $amount, ')
          ..write('costPerBase: $costPerBase')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    returnId,
    productId,
    unitId,
    qty,
    qtyBase,
    amount,
    costPerBase,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReturnItem &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.returnId == this.returnId &&
          other.productId == this.productId &&
          other.unitId == this.unitId &&
          other.qty == this.qty &&
          other.qtyBase == this.qtyBase &&
          other.amount == this.amount &&
          other.costPerBase == this.costPerBase);
}

class ReturnItemsCompanion extends UpdateCompanion<ReturnItem> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> deviceId;
  final Value<String> returnId;
  final Value<String> productId;
  final Value<String> unitId;
  final Value<int> qty;
  final Value<int> qtyBase;
  final Value<int> amount;
  final Value<double?> costPerBase;
  final Value<int> rowid;
  const ReturnItemsCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.returnId = const Value.absent(),
    this.productId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.qty = const Value.absent(),
    this.qtyBase = const Value.absent(),
    this.amount = const Value.absent(),
    this.costPerBase = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReturnItemsCompanion.insert({
    required String id,
    required String storeId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String returnId,
    required String productId,
    required String unitId,
    required int qty,
    required int qtyBase,
    required int amount,
    this.costPerBase = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       returnId = Value(returnId),
       productId = Value(productId),
       unitId = Value(unitId),
       qty = Value(qty),
       qtyBase = Value(qtyBase),
       amount = Value(amount);
  static Insertable<ReturnItem> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? returnId,
    Expression<String>? productId,
    Expression<String>? unitId,
    Expression<int>? qty,
    Expression<int>? qtyBase,
    Expression<int>? amount,
    Expression<double>? costPerBase,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (returnId != null) 'return_id': returnId,
      if (productId != null) 'product_id': productId,
      if (unitId != null) 'unit_id': unitId,
      if (qty != null) 'qty': qty,
      if (qtyBase != null) 'qty_base': qtyBase,
      if (amount != null) 'amount': amount,
      if (costPerBase != null) 'cost_per_base': costPerBase,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReturnItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? deviceId,
    Value<String>? returnId,
    Value<String>? productId,
    Value<String>? unitId,
    Value<int>? qty,
    Value<int>? qtyBase,
    Value<int>? amount,
    Value<double?>? costPerBase,
    Value<int>? rowid,
  }) {
    return ReturnItemsCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      returnId: returnId ?? this.returnId,
      productId: productId ?? this.productId,
      unitId: unitId ?? this.unitId,
      qty: qty ?? this.qty,
      qtyBase: qtyBase ?? this.qtyBase,
      amount: amount ?? this.amount,
      costPerBase: costPerBase ?? this.costPerBase,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (returnId.present) {
      map['return_id'] = Variable<String>(returnId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<String>(unitId.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (qtyBase.present) {
      map['qty_base'] = Variable<int>(qtyBase.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (costPerBase.present) {
      map['cost_per_base'] = Variable<double>(costPerBase.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReturnItemsCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('returnId: $returnId, ')
          ..write('productId: $productId, ')
          ..write('unitId: $unitId, ')
          ..write('qty: $qty, ')
          ..write('qtyBase: $qtyBase, ')
          ..write('amount: $amount, ')
          ..write('costPerBase: $costPerBase, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockOpnamesTable extends StockOpnames
    with TableInfo<$StockOpnamesTable, StockOpname> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockOpnamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<OpnameStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('open'),
      ).withConverter<OpnameStatus>($StockOpnamesTable.$converterstatus);
  static const VerificationMeta _scopeMeta = const VerificationMeta('scope');
  @override
  late final GeneratedColumn<String> scope = GeneratedColumn<String>(
    'scope',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    startedAt,
    finishedAt,
    status,
    scope,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_opnames';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockOpname> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    if (data.containsKey('scope')) {
      context.handle(
        _scopeMeta,
        scope.isAcceptableOrUnknown(data['scope']!, _scopeMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockOpname map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockOpname(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
      status: $StockOpnamesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      scope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $StockOpnamesTable createAlias(String alias) {
    return $StockOpnamesTable(attachedDatabase, alias);
  }

  static TypeConverter<OpnameStatus, String> $converterstatus =
      const OpnameStatusConverter();
}

class StockOpname extends DataClass implements Insertable<StockOpname> {
  final String id;
  final String storeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? deviceId;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final OpnameStatus status;
  final String? scope;
  final String? note;
  const StockOpname({
    required this.id,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.deviceId,
    required this.startedAt,
    this.finishedAt,
    required this.status,
    this.scope,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    {
      map['status'] = Variable<String>(
        $StockOpnamesTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || scope != null) {
      map['scope'] = Variable<String>(scope);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  StockOpnamesCompanion toCompanion(bool nullToAbsent) {
    return StockOpnamesCompanion(
      id: Value(id),
      storeId: Value(storeId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      startedAt: Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
      status: Value(status),
      scope: scope == null && nullToAbsent
          ? const Value.absent()
          : Value(scope),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory StockOpname.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockOpname(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
      status: serializer.fromJson<OpnameStatus>(json['status']),
      scope: serializer.fromJson<String?>(json['scope']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
      'status': serializer.toJson<OpnameStatus>(status),
      'scope': serializer.toJson<String?>(scope),
      'note': serializer.toJson<String?>(note),
    };
  }

  StockOpname copyWith({
    String? id,
    String? storeId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    DateTime? startedAt,
    Value<DateTime?> finishedAt = const Value.absent(),
    OpnameStatus? status,
    Value<String?> scope = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => StockOpname(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    startedAt: startedAt ?? this.startedAt,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
    status: status ?? this.status,
    scope: scope.present ? scope.value : this.scope,
    note: note.present ? note.value : this.note,
  );
  StockOpname copyWithCompanion(StockOpnamesCompanion data) {
    return StockOpname(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
      status: data.status.present ? data.status.value : this.status,
      scope: data.scope.present ? data.scope.value : this.scope,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockOpname(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('status: $status, ')
          ..write('scope: $scope, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    startedAt,
    finishedAt,
    status,
    scope,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockOpname &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.status == this.status &&
          other.scope == this.scope &&
          other.note == this.note);
}

class StockOpnamesCompanion extends UpdateCompanion<StockOpname> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> deviceId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<OpnameStatus> status;
  final Value<String?> scope;
  final Value<String?> note;
  final Value<int> rowid;
  const StockOpnamesCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.scope = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockOpnamesCompanion.insert({
    required String id,
    required String storeId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    required DateTime startedAt,
    this.finishedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.scope = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       startedAt = Value(startedAt);
  static Insertable<StockOpname> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? deviceId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<String>? status,
    Expression<String>? scope,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (status != null) 'status': status,
      if (scope != null) 'scope': scope,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockOpnamesCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? deviceId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? finishedAt,
    Value<OpnameStatus>? status,
    Value<String?>? scope,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return StockOpnamesCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      status: status ?? this.status,
      scope: scope ?? this.scope,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $StockOpnamesTable.$converterstatus.toSql(status.value),
      );
    }
    if (scope.present) {
      map['scope'] = Variable<String>(scope.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockOpnamesCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('status: $status, ')
          ..write('scope: $scope, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockOpnameItemsTable extends StockOpnameItems
    with TableInfo<$StockOpnameItemsTable, StockOpnameItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockOpnameItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _opnameIdMeta = const VerificationMeta(
    'opnameId',
  );
  @override
  late final GeneratedColumn<String> opnameId = GeneratedColumn<String>(
    'opname_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expectedBaseMeta = const VerificationMeta(
    'expectedBase',
  );
  @override
  late final GeneratedColumn<int> expectedBase = GeneratedColumn<int>(
    'expected_base',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countedBaseMeta = const VerificationMeta(
    'countedBase',
  );
  @override
  late final GeneratedColumn<int> countedBase = GeneratedColumn<int>(
    'counted_base',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diffBaseMeta = const VerificationMeta(
    'diffBase',
  );
  @override
  late final GeneratedColumn<int> diffBase = GeneratedColumn<int>(
    'diff_base',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    opnameId,
    productId,
    expectedBase,
    countedBase,
    diffBase,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_opname_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockOpnameItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('opname_id')) {
      context.handle(
        _opnameIdMeta,
        opnameId.isAcceptableOrUnknown(data['opname_id']!, _opnameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_opnameIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('expected_base')) {
      context.handle(
        _expectedBaseMeta,
        expectedBase.isAcceptableOrUnknown(
          data['expected_base']!,
          _expectedBaseMeta,
        ),
      );
    }
    if (data.containsKey('counted_base')) {
      context.handle(
        _countedBaseMeta,
        countedBase.isAcceptableOrUnknown(
          data['counted_base']!,
          _countedBaseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_countedBaseMeta);
    }
    if (data.containsKey('diff_base')) {
      context.handle(
        _diffBaseMeta,
        diffBase.isAcceptableOrUnknown(data['diff_base']!, _diffBaseMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockOpnameItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockOpnameItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      opnameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opname_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      expectedBase: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expected_base'],
      ),
      countedBase: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}counted_base'],
      )!,
      diffBase: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diff_base'],
      ),
    );
  }

  @override
  $StockOpnameItemsTable createAlias(String alias) {
    return $StockOpnameItemsTable(attachedDatabase, alias);
  }
}

class StockOpnameItem extends DataClass implements Insertable<StockOpnameItem> {
  final String id;
  final String storeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? deviceId;
  final String opnameId;
  final String productId;
  final int? expectedBase;
  final int countedBase;
  final int? diffBase;
  const StockOpnameItem({
    required this.id,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.deviceId,
    required this.opnameId,
    required this.productId,
    this.expectedBase,
    required this.countedBase,
    this.diffBase,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['opname_id'] = Variable<String>(opnameId);
    map['product_id'] = Variable<String>(productId);
    if (!nullToAbsent || expectedBase != null) {
      map['expected_base'] = Variable<int>(expectedBase);
    }
    map['counted_base'] = Variable<int>(countedBase);
    if (!nullToAbsent || diffBase != null) {
      map['diff_base'] = Variable<int>(diffBase);
    }
    return map;
  }

  StockOpnameItemsCompanion toCompanion(bool nullToAbsent) {
    return StockOpnameItemsCompanion(
      id: Value(id),
      storeId: Value(storeId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      opnameId: Value(opnameId),
      productId: Value(productId),
      expectedBase: expectedBase == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedBase),
      countedBase: Value(countedBase),
      diffBase: diffBase == null && nullToAbsent
          ? const Value.absent()
          : Value(diffBase),
    );
  }

  factory StockOpnameItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockOpnameItem(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      opnameId: serializer.fromJson<String>(json['opnameId']),
      productId: serializer.fromJson<String>(json['productId']),
      expectedBase: serializer.fromJson<int?>(json['expectedBase']),
      countedBase: serializer.fromJson<int>(json['countedBase']),
      diffBase: serializer.fromJson<int?>(json['diffBase']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'opnameId': serializer.toJson<String>(opnameId),
      'productId': serializer.toJson<String>(productId),
      'expectedBase': serializer.toJson<int?>(expectedBase),
      'countedBase': serializer.toJson<int>(countedBase),
      'diffBase': serializer.toJson<int?>(diffBase),
    };
  }

  StockOpnameItem copyWith({
    String? id,
    String? storeId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    String? opnameId,
    String? productId,
    Value<int?> expectedBase = const Value.absent(),
    int? countedBase,
    Value<int?> diffBase = const Value.absent(),
  }) => StockOpnameItem(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    opnameId: opnameId ?? this.opnameId,
    productId: productId ?? this.productId,
    expectedBase: expectedBase.present ? expectedBase.value : this.expectedBase,
    countedBase: countedBase ?? this.countedBase,
    diffBase: diffBase.present ? diffBase.value : this.diffBase,
  );
  StockOpnameItem copyWithCompanion(StockOpnameItemsCompanion data) {
    return StockOpnameItem(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      opnameId: data.opnameId.present ? data.opnameId.value : this.opnameId,
      productId: data.productId.present ? data.productId.value : this.productId,
      expectedBase: data.expectedBase.present
          ? data.expectedBase.value
          : this.expectedBase,
      countedBase: data.countedBase.present
          ? data.countedBase.value
          : this.countedBase,
      diffBase: data.diffBase.present ? data.diffBase.value : this.diffBase,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockOpnameItem(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('opnameId: $opnameId, ')
          ..write('productId: $productId, ')
          ..write('expectedBase: $expectedBase, ')
          ..write('countedBase: $countedBase, ')
          ..write('diffBase: $diffBase')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    opnameId,
    productId,
    expectedBase,
    countedBase,
    diffBase,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockOpnameItem &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.opnameId == this.opnameId &&
          other.productId == this.productId &&
          other.expectedBase == this.expectedBase &&
          other.countedBase == this.countedBase &&
          other.diffBase == this.diffBase);
}

class StockOpnameItemsCompanion extends UpdateCompanion<StockOpnameItem> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> deviceId;
  final Value<String> opnameId;
  final Value<String> productId;
  final Value<int?> expectedBase;
  final Value<int> countedBase;
  final Value<int?> diffBase;
  final Value<int> rowid;
  const StockOpnameItemsCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.opnameId = const Value.absent(),
    this.productId = const Value.absent(),
    this.expectedBase = const Value.absent(),
    this.countedBase = const Value.absent(),
    this.diffBase = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockOpnameItemsCompanion.insert({
    required String id,
    required String storeId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String opnameId,
    required String productId,
    this.expectedBase = const Value.absent(),
    required int countedBase,
    this.diffBase = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       opnameId = Value(opnameId),
       productId = Value(productId),
       countedBase = Value(countedBase);
  static Insertable<StockOpnameItem> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? opnameId,
    Expression<String>? productId,
    Expression<int>? expectedBase,
    Expression<int>? countedBase,
    Expression<int>? diffBase,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (opnameId != null) 'opname_id': opnameId,
      if (productId != null) 'product_id': productId,
      if (expectedBase != null) 'expected_base': expectedBase,
      if (countedBase != null) 'counted_base': countedBase,
      if (diffBase != null) 'diff_base': diffBase,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockOpnameItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? deviceId,
    Value<String>? opnameId,
    Value<String>? productId,
    Value<int?>? expectedBase,
    Value<int>? countedBase,
    Value<int?>? diffBase,
    Value<int>? rowid,
  }) {
    return StockOpnameItemsCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      opnameId: opnameId ?? this.opnameId,
      productId: productId ?? this.productId,
      expectedBase: expectedBase ?? this.expectedBase,
      countedBase: countedBase ?? this.countedBase,
      diffBase: diffBase ?? this.diffBase,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (opnameId.present) {
      map['opname_id'] = Variable<String>(opnameId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (expectedBase.present) {
      map['expected_base'] = Variable<int>(expectedBase.value);
    }
    if (countedBase.present) {
      map['counted_base'] = Variable<int>(countedBase.value);
    }
    if (diffBase.present) {
      map['diff_base'] = Variable<int>(diffBase.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockOpnameItemsCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('opnameId: $opnameId, ')
          ..write('productId: $productId, ')
          ..write('expectedBase: $expectedBase, ')
          ..write('countedBase: $countedBase, ')
          ..write('diffBase: $diffBase, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spentAtMeta = const VerificationMeta(
    'spentAt',
  );
  @override
  late final GeneratedColumn<DateTime> spentAt = GeneratedColumn<DateTime>(
    'spent_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    category,
    amount,
    spentAt,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('spent_at')) {
      context.handle(
        _spentAtMeta,
        spentAt.isAcceptableOrUnknown(data['spent_at']!, _spentAtMeta),
      );
    } else if (isInserting) {
      context.missing(_spentAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      spentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}spent_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final String id;
  final String storeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? deviceId;
  final String category;
  final int amount;
  final DateTime spentAt;
  final String? note;
  const Expense({
    required this.id,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.deviceId,
    required this.category,
    required this.amount,
    required this.spentAt,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['category'] = Variable<String>(category);
    map['amount'] = Variable<int>(amount);
    map['spent_at'] = Variable<DateTime>(spentAt);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      storeId: Value(storeId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      category: Value(category),
      amount: Value(amount),
      spentAt: Value(spentAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      category: serializer.fromJson<String>(json['category']),
      amount: serializer.fromJson<int>(json['amount']),
      spentAt: serializer.fromJson<DateTime>(json['spentAt']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'category': serializer.toJson<String>(category),
      'amount': serializer.toJson<int>(amount),
      'spentAt': serializer.toJson<DateTime>(spentAt),
      'note': serializer.toJson<String?>(note),
    };
  }

  Expense copyWith({
    String? id,
    String? storeId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> deviceId = const Value.absent(),
    String? category,
    int? amount,
    DateTime? spentAt,
    Value<String?> note = const Value.absent(),
  }) => Expense(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    category: category ?? this.category,
    amount: amount ?? this.amount,
    spentAt: spentAt ?? this.spentAt,
    note: note.present ? note.value : this.note,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      category: data.category.present ? data.category.value : this.category,
      amount: data.amount.present ? data.amount.value : this.amount,
      spentAt: data.spentAt.present ? data.spentAt.value : this.spentAt,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('spentAt: $spentAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    category,
    amount,
    spentAt,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.category == this.category &&
          other.amount == this.amount &&
          other.spentAt == this.spentAt &&
          other.note == this.note);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> deviceId;
  final Value<String> category;
  final Value<int> amount;
  final Value<DateTime> spentAt;
  final Value<String?> note;
  final Value<int> rowid;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.category = const Value.absent(),
    this.amount = const Value.absent(),
    this.spentAt = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpensesCompanion.insert({
    required String id,
    required String storeId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String category,
    required int amount,
    required DateTime spentAt,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       category = Value(category),
       amount = Value(amount),
       spentAt = Value(spentAt);
  static Insertable<Expense> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? category,
    Expression<int>? amount,
    Expression<DateTime>? spentAt,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (category != null) 'category': category,
      if (amount != null) 'amount': amount,
      if (spentAt != null) 'spent_at': spentAt,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpensesCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? deviceId,
    Value<String>? category,
    Value<int>? amount,
    Value<DateTime>? spentAt,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      spentAt: spentAt ?? this.spentAt,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (spentAt.present) {
      map['spent_at'] = Variable<DateTime>(spentAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('spentAt: $spentAt, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
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
  @override
  List<GeneratedColumn> get $columns => [storeId, key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
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
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {storeId, key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String storeId;
  final String key;
  final String value;
  final DateTime updatedAt;
  const AppSetting({
    required this.storeId,
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['store_id'] = Variable<String>(storeId);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      storeId: Value(storeId),
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      storeId: serializer.fromJson<String>(json['storeId']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'storeId': serializer.toJson<String>(storeId),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSetting copyWith({
    String? storeId,
    String? key,
    String? value,
    DateTime? updatedAt,
  }) => AppSetting(
    storeId: storeId ?? this.storeId,
    key: key ?? this.key,
    value: value ?? this.value,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('storeId: $storeId, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(storeId, key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.storeId == this.storeId &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> storeId;
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.storeId = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String storeId,
    required String key,
    required String value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : storeId = Value(storeId),
       key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<AppSetting> custom({
    Expression<String>? storeId,
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (storeId != null) 'store_id': storeId,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? storeId,
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      storeId: storeId ?? this.storeId,
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('storeId: $storeId, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxTable extends Outbox with TableInfo<$OutboxTable, OutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _opIdMeta = const VerificationMeta('opId');
  @override
  late final GeneratedColumn<String> opId = GeneratedColumn<String>(
    'op_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetTableMeta = const VerificationMeta(
    'targetTable',
  );
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
    'table_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<String> rowId = GeneratedColumn<String>(
    'row_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
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
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastAttemptAtMeta = const VerificationMeta(
    'lastAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>(
        'last_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
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
    opId,
    targetTable,
    rowId,
    op,
    payload,
    createdAt,
    attempts,
    lastError,
    lastAttemptAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('op_id')) {
      context.handle(
        _opIdMeta,
        opId.isAcceptableOrUnknown(data['op_id']!, _opIdMeta),
      );
    } else if (isInserting) {
      context.missing(_opIdMeta);
    }
    if (data.containsKey('table_name')) {
      context.handle(
        _targetTableMeta,
        targetTable.isAcceptableOrUnknown(
          data['table_name']!,
          _targetTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rowIdMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
        _lastAttemptAtMeta,
        lastAttemptAt.isAcceptableOrUnknown(
          data['last_attempt_at']!,
          _lastAttemptAtMeta,
        ),
      );
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
  Set<GeneratedColumn> get $primaryKey => {opId};
  @override
  OutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxData(
      opId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op_id'],
      )!,
      targetTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_name'],
      )!,
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}row_id'],
      )!,
      op: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      lastAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_attempt_at'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $OutboxTable createAlias(String alias) {
    return $OutboxTable(attachedDatabase, alias);
  }
}

class OutboxData extends DataClass implements Insertable<OutboxData> {
  final String opId;
  final String targetTable;
  final String rowId;
  final String op;
  final String payload;
  final DateTime createdAt;
  final int attempts;
  final String? lastError;
  final DateTime? lastAttemptAt;
  final DateTime? syncedAt;
  const OutboxData({
    required this.opId,
    required this.targetTable,
    required this.rowId,
    required this.op,
    required this.payload,
    required this.createdAt,
    required this.attempts,
    this.lastError,
    this.lastAttemptAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['op_id'] = Variable<String>(opId);
    map['table_name'] = Variable<String>(targetTable);
    map['row_id'] = Variable<String>(rowId);
    map['op'] = Variable<String>(op);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  OutboxCompanion toCompanion(bool nullToAbsent) {
    return OutboxCompanion(
      opId: Value(opId),
      targetTable: Value(targetTable),
      rowId: Value(rowId),
      op: Value(op),
      payload: Value(payload),
      createdAt: Value(createdAt),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory OutboxData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxData(
      opId: serializer.fromJson<String>(json['opId']),
      targetTable: serializer.fromJson<String>(json['targetTable']),
      rowId: serializer.fromJson<String>(json['rowId']),
      op: serializer.fromJson<String>(json['op']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'opId': serializer.toJson<String>(opId),
      'targetTable': serializer.toJson<String>(targetTable),
      'rowId': serializer.toJson<String>(rowId),
      'op': serializer.toJson<String>(op),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  OutboxData copyWith({
    String? opId,
    String? targetTable,
    String? rowId,
    String? op,
    String? payload,
    DateTime? createdAt,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
    Value<DateTime?> lastAttemptAt = const Value.absent(),
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => OutboxData(
    opId: opId ?? this.opId,
    targetTable: targetTable ?? this.targetTable,
    rowId: rowId ?? this.rowId,
    op: op ?? this.op,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
    lastAttemptAt: lastAttemptAt.present
        ? lastAttemptAt.value
        : this.lastAttemptAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  OutboxData copyWithCompanion(OutboxCompanion data) {
    return OutboxData(
      opId: data.opId.present ? data.opId.value : this.opId,
      targetTable: data.targetTable.present
          ? data.targetTable.value
          : this.targetTable,
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      op: data.op.present ? data.op.value : this.op,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxData(')
          ..write('opId: $opId, ')
          ..write('targetTable: $targetTable, ')
          ..write('rowId: $rowId, ')
          ..write('op: $op, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    opId,
    targetTable,
    rowId,
    op,
    payload,
    createdAt,
    attempts,
    lastError,
    lastAttemptAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxData &&
          other.opId == this.opId &&
          other.targetTable == this.targetTable &&
          other.rowId == this.rowId &&
          other.op == this.op &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.lastAttemptAt == this.lastAttemptAt &&
          other.syncedAt == this.syncedAt);
}

class OutboxCompanion extends UpdateCompanion<OutboxData> {
  final Value<String> opId;
  final Value<String> targetTable;
  final Value<String> rowId;
  final Value<String> op;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<DateTime?> lastAttemptAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const OutboxCompanion({
    this.opId = const Value.absent(),
    this.targetTable = const Value.absent(),
    this.rowId = const Value.absent(),
    this.op = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutboxCompanion.insert({
    required String opId,
    required String targetTable,
    required String rowId,
    required String op,
    required String payload,
    required DateTime createdAt,
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : opId = Value(opId),
       targetTable = Value(targetTable),
       rowId = Value(rowId),
       op = Value(op),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<OutboxData> custom({
    Expression<String>? opId,
    Expression<String>? targetTable,
    Expression<String>? rowId,
    Expression<String>? op,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<DateTime>? lastAttemptAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (opId != null) 'op_id': opId,
      if (targetTable != null) 'table_name': targetTable,
      if (rowId != null) 'row_id': rowId,
      if (op != null) 'op': op,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutboxCompanion copyWith({
    Value<String>? opId,
    Value<String>? targetTable,
    Value<String>? rowId,
    Value<String>? op,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<DateTime?>? lastAttemptAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return OutboxCompanion(
      opId: opId ?? this.opId,
      targetTable: targetTable ?? this.targetTable,
      rowId: rowId ?? this.rowId,
      op: op ?? this.op,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (opId.present) {
      map['op_id'] = Variable<String>(opId.value);
    }
    if (targetTable.present) {
      map['table_name'] = Variable<String>(targetTable.value);
    }
    if (rowId.present) {
      map['row_id'] = Variable<String>(rowId.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
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
    return (StringBuffer('OutboxCompanion(')
          ..write('opId: $opId, ')
          ..write('targetTable: $targetTable, ')
          ..write('rowId: $rowId, ')
          ..write('op: $op, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncStateTable extends SyncState
    with TableInfo<$SyncStateTable, SyncStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStateTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'sync_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncStateData> instance, {
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
  SyncStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStateData(
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
  $SyncStateTable createAlias(String alias) {
    return $SyncStateTable(attachedDatabase, alias);
  }
}

class SyncStateData extends DataClass implements Insertable<SyncStateData> {
  final String key;
  final String value;
  const SyncStateData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SyncStateCompanion toCompanion(bool nullToAbsent) {
    return SyncStateCompanion(key: Value(key), value: Value(value));
  }

  factory SyncStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStateData(
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

  SyncStateData copyWith({String? key, String? value}) =>
      SyncStateData(key: key ?? this.key, value: value ?? this.value);
  SyncStateData copyWithCompanion(SyncStateCompanion data) {
    return SyncStateData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateData(')
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
      (other is SyncStateData &&
          other.key == this.key &&
          other.value == this.value);
}

class SyncStateCompanion extends UpdateCompanion<SyncStateData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SyncStateCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncStateCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SyncStateData> custom({
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

  SyncStateCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SyncStateCompanion(
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
    return (StringBuffer('SyncStateCompanion(')
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
  late final $StoresTable stores = $StoresTable(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $DevicesTable devices = $DevicesTable(this);
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $ProductUnitsTable productUnits = $ProductUnitsTable(this);
  late final $PriceHistoryTable priceHistory = $PriceHistoryTable(this);
  late final $PurchasesTable purchases = $PurchasesTable(this);
  late final $PurchaseItemsTable purchaseItems = $PurchaseItemsTable(this);
  late final $StockMovementsTable stockMovements = $StockMovementsTable(this);
  late final $PutawayLogTable putawayLog = $PutawayLogTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $DebtLedgerTable debtLedger = $DebtLedgerTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $SaleItemsTable saleItems = $SaleItemsTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $ReturnsTable returns = $ReturnsTable(this);
  late final $ReturnItemsTable returnItems = $ReturnItemsTable(this);
  late final $StockOpnamesTable stockOpnames = $StockOpnamesTable(this);
  late final $StockOpnameItemsTable stockOpnameItems = $StockOpnameItemsTable(
    this,
  );
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $OutboxTable outbox = $OutboxTable(this);
  late final $SyncStateTable syncState = $SyncStateTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    stores,
    profiles,
    devices,
    suppliers,
    categories,
    products,
    productUnits,
    priceHistory,
    purchases,
    purchaseItems,
    stockMovements,
    putawayLog,
    customers,
    debtLedger,
    sales,
    saleItems,
    payments,
    returns,
    returnItems,
    stockOpnames,
    stockOpnameItems,
    expenses,
    appSettings,
    outbox,
    syncState,
  ];
}

typedef $$StoresTableCreateCompanionBuilder = StoresCompanion Function({
  required String id,
  required String name,
  required String code2,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  Value<int> rowid,
});
typedef $$StoresTableUpdateCompanionBuilder = StoresCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> code2,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  Value<int> rowid,
});

class $$StoresTableFilterComposer
    extends Composer<_$AppDatabase, $StoresTable> {
  $$StoresTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code2 => $composableBuilder(
    column: $table.code2,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StoresTableOrderingComposer
    extends Composer<_$AppDatabase, $StoresTable> {
  $$StoresTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code2 => $composableBuilder(
    column: $table.code2,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoresTable> {
  $$StoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code2 =>
      $composableBuilder(column: $table.code2, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);
}

class $$StoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoresTable,
          Store,
          $$StoresTableFilterComposer,
          $$StoresTableOrderingComposer,
          $$StoresTableAnnotationComposer,
          $$StoresTableCreateCompanionBuilder,
          $$StoresTableUpdateCompanionBuilder,
          (Store, BaseReferences<_$AppDatabase, $StoresTable, Store>),
          Store,
          PrefetchHooks Function()
        > {
  $$StoresTableTableManager(_$AppDatabase db, $StoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> code2 = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoresCompanion(
                id: id,
                name: name,
                code2: code2,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String code2,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoresCompanion.insert(
                id: id,
                name: name,
                code2: code2,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StoresTable, Store>(table),
                  BaseReferences<_$AppDatabase, $StoresTable, Store>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoresTable,
      Store,
      $$StoresTableFilterComposer,
      $$StoresTableOrderingComposer,
      $$StoresTableAnnotationComposer,
      $$StoresTableCreateCompanionBuilder,
      $$StoresTableUpdateCompanionBuilder,
      (Store, BaseReferences<_$AppDatabase, $StoresTable, Store>),
      Store,
      PrefetchHooks Function()
    >;
typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  required String userId,
  required String storeId,
  required UserRole role,
  Value<String?> displayName,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  Value<int> rowid,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<String> userId,
  Value<String> storeId,
  Value<UserRole> role,
  Value<String?> displayName,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  Value<int> rowid,
});

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<UserRole, UserRole, String> get role =>
      $composableBuilder(
        column: $table.role,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<UserRole, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
          Profile,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<UserRole> role = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                userId: userId,
                storeId: storeId,
                role: role,
                displayName: displayName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String storeId,
                required UserRole role,
                Value<String?> displayName = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                userId: userId,
                storeId: storeId,
                role: role,
                displayName: displayName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, Profile>(table),
                  BaseReferences<_$AppDatabase, $ProfilesTable, Profile>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
      Profile,
      PrefetchHooks Function()
    >;
typedef $$DevicesTableCreateCompanionBuilder = DevicesCompanion Function({
  required String id,
  required String storeId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  required String code,
  Value<String?> name,
  Value<int> rowid,
});
typedef $$DevicesTableUpdateCompanionBuilder = DevicesCompanion Function({
  Value<String> id,
  Value<String> storeId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  Value<String> code,
  Value<String?> name,
  Value<int> rowid,
});

class $$DevicesTableFilterComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableFilterComposer({
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

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DevicesTableOrderingComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableOrderingComposer({
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

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DevicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$DevicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DevicesTable,
          Device,
          $$DevicesTableFilterComposer,
          $$DevicesTableOrderingComposer,
          $$DevicesTableAnnotationComposer,
          $$DevicesTableCreateCompanionBuilder,
          $$DevicesTableUpdateCompanionBuilder,
          (Device, BaseReferences<_$AppDatabase, $DevicesTable, Device>),
          Device,
          PrefetchHooks Function()
        > {
  $$DevicesTableTableManager(_$AppDatabase db, $DevicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DevicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DevicesCompanion(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                code: code,
                name: name,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required String code,
                Value<String?> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DevicesCompanion.insert(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                code: code,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DevicesTable, Device>(table),
                  BaseReferences<_$AppDatabase, $DevicesTable, Device>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DevicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DevicesTable,
      Device,
      $$DevicesTableFilterComposer,
      $$DevicesTableOrderingComposer,
      $$DevicesTableAnnotationComposer,
      $$DevicesTableCreateCompanionBuilder,
      $$DevicesTableUpdateCompanionBuilder,
      (Device, BaseReferences<_$AppDatabase, $DevicesTable, Device>),
      Device,
      PrefetchHooks Function()
    >;
typedef $$SuppliersTableCreateCompanionBuilder = SuppliersCompanion Function({
  required String id,
  required String storeId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  required String name,
  Value<String?> phone,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$SuppliersTableUpdateCompanionBuilder = SuppliersCompanion Function({
  Value<String> id,
  Value<String> storeId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  Value<String> name,
  Value<String?> phone,
  Value<String?> note,
  Value<int> rowid,
});

class $$SuppliersTableFilterComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer({
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

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SuppliersTableOrderingComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer({
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

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SuppliersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$SuppliersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SuppliersTable,
          Supplier,
          $$SuppliersTableFilterComposer,
          $$SuppliersTableOrderingComposer,
          $$SuppliersTableAnnotationComposer,
          $$SuppliersTableCreateCompanionBuilder,
          $$SuppliersTableUpdateCompanionBuilder,
          (Supplier, BaseReferences<_$AppDatabase, $SuppliersTable, Supplier>),
          Supplier,
          PrefetchHooks Function()
        > {
  $$SuppliersTableTableManager(_$AppDatabase db, $SuppliersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SuppliersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SuppliersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SuppliersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SuppliersCompanion(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                name: name,
                phone: phone,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SuppliersCompanion.insert(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                name: name,
                phone: phone,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SuppliersTable, Supplier>(table),
                  BaseReferences<_$AppDatabase, $SuppliersTable, Supplier>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SuppliersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SuppliersTable,
      Supplier,
      $$SuppliersTableFilterComposer,
      $$SuppliersTableOrderingComposer,
      $$SuppliersTableAnnotationComposer,
      $$SuppliersTableCreateCompanionBuilder,
      $$SuppliersTableUpdateCompanionBuilder,
      (Supplier, BaseReferences<_$AppDatabase, $SuppliersTable, Supplier>),
      Supplier,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  required String storeId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  required String name,
  Value<double?> defaultMarginPct,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String> storeId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  Value<String> name,
  Value<double?> defaultMarginPct,
  Value<int> rowid,
});

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
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

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get defaultMarginPct => $composableBuilder(
    column: $table.defaultMarginPct,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
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

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get defaultMarginPct => $composableBuilder(
    column: $table.defaultMarginPct,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get defaultMarginPct => $composableBuilder(
    column: $table.defaultMarginPct,
    builder: (column) => column,
  );
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double?> defaultMarginPct = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                name: name,
                defaultMarginPct: defaultMarginPct,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required String name,
                Value<double?> defaultMarginPct = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                name: name,
                defaultMarginPct: defaultMarginPct,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, Category>(table),
                  BaseReferences<_$AppDatabase, $CategoriesTable, Category>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
      Category,
      PrefetchHooks Function()
    >;
typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  required String id,
  required String storeId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  required String name,
  Value<String?> brand,
  Value<String?> variant,
  Value<String?> categoryId,
  required String baseUnit,
  Value<int> minStockBase,
  Value<String?> shelfLocation,
  Value<String?> mainSupplierId,
  Value<bool> needsPriceReview,
  Value<bool> isActive,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<String> id,
  Value<String> storeId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  Value<String> name,
  Value<String?> brand,
  Value<String?> variant,
  Value<String?> categoryId,
  Value<String> baseUnit,
  Value<int> minStockBase,
  Value<String?> shelfLocation,
  Value<String?> mainSupplierId,
  Value<bool> needsPriceReview,
  Value<bool> isActive,
  Value<String?> note,
  Value<int> rowid,
});

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
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

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variant => $composableBuilder(
    column: $table.variant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseUnit => $composableBuilder(
    column: $table.baseUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minStockBase => $composableBuilder(
    column: $table.minStockBase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shelfLocation => $composableBuilder(
    column: $table.shelfLocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mainSupplierId => $composableBuilder(
    column: $table.mainSupplierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsPriceReview => $composableBuilder(
    column: $table.needsPriceReview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
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

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variant => $composableBuilder(
    column: $table.variant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseUnit => $composableBuilder(
    column: $table.baseUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minStockBase => $composableBuilder(
    column: $table.minStockBase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shelfLocation => $composableBuilder(
    column: $table.shelfLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mainSupplierId => $composableBuilder(
    column: $table.mainSupplierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsPriceReview => $composableBuilder(
    column: $table.needsPriceReview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get variant =>
      $composableBuilder(column: $table.variant, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get baseUnit =>
      $composableBuilder(column: $table.baseUnit, builder: (column) => column);

  GeneratedColumn<int> get minStockBase => $composableBuilder(
    column: $table.minStockBase,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shelfLocation => $composableBuilder(
    column: $table.shelfLocation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mainSupplierId => $composableBuilder(
    column: $table.mainSupplierId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get needsPriceReview => $composableBuilder(
    column: $table.needsPriceReview,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
          Product,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> variant = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> baseUnit = const Value.absent(),
                Value<int> minStockBase = const Value.absent(),
                Value<String?> shelfLocation = const Value.absent(),
                Value<String?> mainSupplierId = const Value.absent(),
                Value<bool> needsPriceReview = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                name: name,
                brand: brand,
                variant: variant,
                categoryId: categoryId,
                baseUnit: baseUnit,
                minStockBase: minStockBase,
                shelfLocation: shelfLocation,
                mainSupplierId: mainSupplierId,
                needsPriceReview: needsPriceReview,
                isActive: isActive,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required String name,
                Value<String?> brand = const Value.absent(),
                Value<String?> variant = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                required String baseUnit,
                Value<int> minStockBase = const Value.absent(),
                Value<String?> shelfLocation = const Value.absent(),
                Value<String?> mainSupplierId = const Value.absent(),
                Value<bool> needsPriceReview = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                name: name,
                brand: brand,
                variant: variant,
                categoryId: categoryId,
                baseUnit: baseUnit,
                minStockBase: minStockBase,
                shelfLocation: shelfLocation,
                mainSupplierId: mainSupplierId,
                needsPriceReview: needsPriceReview,
                isActive: isActive,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProductsTable, Product>(table),
                  BaseReferences<_$AppDatabase, $ProductsTable, Product>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
      Product,
      PrefetchHooks Function()
    >;
typedef $$ProductUnitsTableCreateCompanionBuilder =
    ProductUnitsCompanion Function({
      required String id,
      required String storeId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> deviceId,
      required String productId,
      required String unitName,
      required int factorToBase,
      Value<String?> barcode,
      Value<BarcodeSource?> barcodeSource,
      Value<int?> sellPrice,
      Value<bool> isDefaultSale,
      Value<bool> isDefaultPurchase,
      Value<int> rowid,
    });
typedef $$ProductUnitsTableUpdateCompanionBuilder =
    ProductUnitsCompanion Function({
      Value<String> id,
      Value<String> storeId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> deviceId,
      Value<String> productId,
      Value<String> unitName,
      Value<int> factorToBase,
      Value<String?> barcode,
      Value<BarcodeSource?> barcodeSource,
      Value<int?> sellPrice,
      Value<bool> isDefaultSale,
      Value<bool> isDefaultPurchase,
      Value<int> rowid,
    });

class $$ProductUnitsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductUnitsTable> {
  $$ProductUnitsTableFilterComposer({
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

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitName => $composableBuilder(
    column: $table.unitName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get factorToBase => $composableBuilder(
    column: $table.factorToBase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BarcodeSource?, BarcodeSource, String>
  get barcodeSource => $composableBuilder(
    column: $table.barcodeSource,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get sellPrice => $composableBuilder(
    column: $table.sellPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefaultSale => $composableBuilder(
    column: $table.isDefaultSale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefaultPurchase => $composableBuilder(
    column: $table.isDefaultPurchase,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductUnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductUnitsTable> {
  $$ProductUnitsTableOrderingComposer({
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

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitName => $composableBuilder(
    column: $table.unitName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get factorToBase => $composableBuilder(
    column: $table.factorToBase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcodeSource => $composableBuilder(
    column: $table.barcodeSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sellPrice => $composableBuilder(
    column: $table.sellPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefaultSale => $composableBuilder(
    column: $table.isDefaultSale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefaultPurchase => $composableBuilder(
    column: $table.isDefaultPurchase,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductUnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductUnitsTable> {
  $$ProductUnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get unitName =>
      $composableBuilder(column: $table.unitName, builder: (column) => column);

  GeneratedColumn<int> get factorToBase => $composableBuilder(
    column: $table.factorToBase,
    builder: (column) => column,
  );

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BarcodeSource?, String> get barcodeSource =>
      $composableBuilder(
        column: $table.barcodeSource,
        builder: (column) => column,
      );

  GeneratedColumn<int> get sellPrice =>
      $composableBuilder(column: $table.sellPrice, builder: (column) => column);

  GeneratedColumn<bool> get isDefaultSale => $composableBuilder(
    column: $table.isDefaultSale,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDefaultPurchase => $composableBuilder(
    column: $table.isDefaultPurchase,
    builder: (column) => column,
  );
}

class $$ProductUnitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductUnitsTable,
          ProductUnit,
          $$ProductUnitsTableFilterComposer,
          $$ProductUnitsTableOrderingComposer,
          $$ProductUnitsTableAnnotationComposer,
          $$ProductUnitsTableCreateCompanionBuilder,
          $$ProductUnitsTableUpdateCompanionBuilder,
          (
            ProductUnit,
            BaseReferences<_$AppDatabase, $ProductUnitsTable, ProductUnit>,
          ),
          ProductUnit,
          PrefetchHooks Function()
        > {
  $$ProductUnitsTableTableManager(_$AppDatabase db, $ProductUnitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductUnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductUnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductUnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> unitName = const Value.absent(),
                Value<int> factorToBase = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<BarcodeSource?> barcodeSource = const Value.absent(),
                Value<int?> sellPrice = const Value.absent(),
                Value<bool> isDefaultSale = const Value.absent(),
                Value<bool> isDefaultPurchase = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductUnitsCompanion(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                productId: productId,
                unitName: unitName,
                factorToBase: factorToBase,
                barcode: barcode,
                barcodeSource: barcodeSource,
                sellPrice: sellPrice,
                isDefaultSale: isDefaultSale,
                isDefaultPurchase: isDefaultPurchase,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required String productId,
                required String unitName,
                required int factorToBase,
                Value<String?> barcode = const Value.absent(),
                Value<BarcodeSource?> barcodeSource = const Value.absent(),
                Value<int?> sellPrice = const Value.absent(),
                Value<bool> isDefaultSale = const Value.absent(),
                Value<bool> isDefaultPurchase = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductUnitsCompanion.insert(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                productId: productId,
                unitName: unitName,
                factorToBase: factorToBase,
                barcode: barcode,
                barcodeSource: barcodeSource,
                sellPrice: sellPrice,
                isDefaultSale: isDefaultSale,
                isDefaultPurchase: isDefaultPurchase,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProductUnitsTable, ProductUnit>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ProductUnitsTable,
                    ProductUnit
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductUnitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductUnitsTable,
      ProductUnit,
      $$ProductUnitsTableFilterComposer,
      $$ProductUnitsTableOrderingComposer,
      $$ProductUnitsTableAnnotationComposer,
      $$ProductUnitsTableCreateCompanionBuilder,
      $$ProductUnitsTableUpdateCompanionBuilder,
      (
        ProductUnit,
        BaseReferences<_$AppDatabase, $ProductUnitsTable, ProductUnit>,
      ),
      ProductUnit,
      PrefetchHooks Function()
    >;
typedef $$PriceHistoryTableCreateCompanionBuilder =
    PriceHistoryCompanion Function({
      required String id,
      required String storeId,
      required String productUnitId,
      required PriceKind kind,
      required int price,
      required DateTime effectiveAt,
      Value<String?> sourceRef,
      required DateTime createdAt,
      Value<String?> deviceId,
      Value<int> rowid,
    });
typedef $$PriceHistoryTableUpdateCompanionBuilder =
    PriceHistoryCompanion Function({
      Value<String> id,
      Value<String> storeId,
      Value<String> productUnitId,
      Value<PriceKind> kind,
      Value<int> price,
      Value<DateTime> effectiveAt,
      Value<String?> sourceRef,
      Value<DateTime> createdAt,
      Value<String?> deviceId,
      Value<int> rowid,
    });

class $$PriceHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $PriceHistoryTable> {
  $$PriceHistoryTableFilterComposer({
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

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productUnitId => $composableBuilder(
    column: $table.productUnitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PriceKind, PriceKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get effectiveAt => $composableBuilder(
    column: $table.effectiveAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceRef => $composableBuilder(
    column: $table.sourceRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PriceHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $PriceHistoryTable> {
  $$PriceHistoryTableOrderingComposer({
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

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productUnitId => $composableBuilder(
    column: $table.productUnitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get effectiveAt => $composableBuilder(
    column: $table.effectiveAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceRef => $composableBuilder(
    column: $table.sourceRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PriceHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $PriceHistoryTable> {
  $$PriceHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get productUnitId => $composableBuilder(
    column: $table.productUnitId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PriceKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<DateTime> get effectiveAt => $composableBuilder(
    column: $table.effectiveAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceRef =>
      $composableBuilder(column: $table.sourceRef, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);
}

class $$PriceHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PriceHistoryTable,
          PriceHistoryData,
          $$PriceHistoryTableFilterComposer,
          $$PriceHistoryTableOrderingComposer,
          $$PriceHistoryTableAnnotationComposer,
          $$PriceHistoryTableCreateCompanionBuilder,
          $$PriceHistoryTableUpdateCompanionBuilder,
          (
            PriceHistoryData,
            BaseReferences<_$AppDatabase, $PriceHistoryTable, PriceHistoryData>,
          ),
          PriceHistoryData,
          PrefetchHooks Function()
        > {
  $$PriceHistoryTableTableManager(_$AppDatabase db, $PriceHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PriceHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PriceHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PriceHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<String> productUnitId = const Value.absent(),
                Value<PriceKind> kind = const Value.absent(),
                Value<int> price = const Value.absent(),
                Value<DateTime> effectiveAt = const Value.absent(),
                Value<String?> sourceRef = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PriceHistoryCompanion(
                id: id,
                storeId: storeId,
                productUnitId: productUnitId,
                kind: kind,
                price: price,
                effectiveAt: effectiveAt,
                sourceRef: sourceRef,
                createdAt: createdAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required String productUnitId,
                required PriceKind kind,
                required int price,
                required DateTime effectiveAt,
                Value<String?> sourceRef = const Value.absent(),
                required DateTime createdAt,
                Value<String?> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PriceHistoryCompanion.insert(
                id: id,
                storeId: storeId,
                productUnitId: productUnitId,
                kind: kind,
                price: price,
                effectiveAt: effectiveAt,
                sourceRef: sourceRef,
                createdAt: createdAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PriceHistoryTable, PriceHistoryData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PriceHistoryTable,
                    PriceHistoryData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PriceHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PriceHistoryTable,
      PriceHistoryData,
      $$PriceHistoryTableFilterComposer,
      $$PriceHistoryTableOrderingComposer,
      $$PriceHistoryTableAnnotationComposer,
      $$PriceHistoryTableCreateCompanionBuilder,
      $$PriceHistoryTableUpdateCompanionBuilder,
      (
        PriceHistoryData,
        BaseReferences<_$AppDatabase, $PriceHistoryTable, PriceHistoryData>,
      ),
      PriceHistoryData,
      PrefetchHooks Function()
    >;
typedef $$PurchasesTableCreateCompanionBuilder = PurchasesCompanion Function({
  required String id,
  required String storeId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  Value<String?> supplierId,
  Value<String?> docNo,
  required DateTime purchasedAt,
  required int total,
  Value<String?> note,
  Value<String> status,
  Value<int> rowid,
});
typedef $$PurchasesTableUpdateCompanionBuilder = PurchasesCompanion Function({
  Value<String> id,
  Value<String> storeId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  Value<String?> supplierId,
  Value<String?> docNo,
  Value<DateTime> purchasedAt,
  Value<int> total,
  Value<String?> note,
  Value<String> status,
  Value<int> rowid,
});

class $$PurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableFilterComposer({
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

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get docNo => $composableBuilder(
    column: $table.docNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableOrderingComposer({
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

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get docNo => $composableBuilder(
    column: $table.docNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get docNo =>
      $composableBuilder(column: $table.docNo, builder: (column) => column);

  GeneratedColumn<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$PurchasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchasesTable,
          Purchase,
          $$PurchasesTableFilterComposer,
          $$PurchasesTableOrderingComposer,
          $$PurchasesTableAnnotationComposer,
          $$PurchasesTableCreateCompanionBuilder,
          $$PurchasesTableUpdateCompanionBuilder,
          (Purchase, BaseReferences<_$AppDatabase, $PurchasesTable, Purchase>),
          Purchase,
          PrefetchHooks Function()
        > {
  $$PurchasesTableTableManager(_$AppDatabase db, $PurchasesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String?> supplierId = const Value.absent(),
                Value<String?> docNo = const Value.absent(),
                Value<DateTime> purchasedAt = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchasesCompanion(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                supplierId: supplierId,
                docNo: docNo,
                purchasedAt: purchasedAt,
                total: total,
                note: note,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String?> supplierId = const Value.absent(),
                Value<String?> docNo = const Value.absent(),
                required DateTime purchasedAt,
                required int total,
                Value<String?> note = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchasesCompanion.insert(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                supplierId: supplierId,
                docNo: docNo,
                purchasedAt: purchasedAt,
                total: total,
                note: note,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PurchasesTable, Purchase>(table),
                  BaseReferences<_$AppDatabase, $PurchasesTable, Purchase>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PurchasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchasesTable,
      Purchase,
      $$PurchasesTableFilterComposer,
      $$PurchasesTableOrderingComposer,
      $$PurchasesTableAnnotationComposer,
      $$PurchasesTableCreateCompanionBuilder,
      $$PurchasesTableUpdateCompanionBuilder,
      (Purchase, BaseReferences<_$AppDatabase, $PurchasesTable, Purchase>),
      Purchase,
      PrefetchHooks Function()
    >;
typedef $$PurchaseItemsTableCreateCompanionBuilder =
    PurchaseItemsCompanion Function({
      required String id,
      required String storeId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> deviceId,
      required String purchaseId,
      required String productId,
      required String unitId,
      required int qty,
      required int unitCost,
      required int qtyBase,
      required double costPerBase,
      Value<int> rowid,
    });
typedef $$PurchaseItemsTableUpdateCompanionBuilder =
    PurchaseItemsCompanion Function({
      Value<String> id,
      Value<String> storeId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> deviceId,
      Value<String> purchaseId,
      Value<String> productId,
      Value<String> unitId,
      Value<int> qty,
      Value<int> unitCost,
      Value<int> qtyBase,
      Value<double> costPerBase,
      Value<int> rowid,
    });

class $$PurchaseItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableFilterComposer({
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

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitId => $composableBuilder(
    column: $table.unitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitCost => $composableBuilder(
    column: $table.unitCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qtyBase => $composableBuilder(
    column: $table.qtyBase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get costPerBase => $composableBuilder(
    column: $table.costPerBase,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PurchaseItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableOrderingComposer({
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

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitId => $composableBuilder(
    column: $table.unitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitCost => $composableBuilder(
    column: $table.unitCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qtyBase => $composableBuilder(
    column: $table.qtyBase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get costPerBase => $composableBuilder(
    column: $table.costPerBase,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PurchaseItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<int> get unitCost =>
      $composableBuilder(column: $table.unitCost, builder: (column) => column);

  GeneratedColumn<int> get qtyBase =>
      $composableBuilder(column: $table.qtyBase, builder: (column) => column);

  GeneratedColumn<double> get costPerBase => $composableBuilder(
    column: $table.costPerBase,
    builder: (column) => column,
  );
}

class $$PurchaseItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseItemsTable,
          PurchaseItem,
          $$PurchaseItemsTableFilterComposer,
          $$PurchaseItemsTableOrderingComposer,
          $$PurchaseItemsTableAnnotationComposer,
          $$PurchaseItemsTableCreateCompanionBuilder,
          $$PurchaseItemsTableUpdateCompanionBuilder,
          (
            PurchaseItem,
            BaseReferences<_$AppDatabase, $PurchaseItemsTable, PurchaseItem>,
          ),
          PurchaseItem,
          PrefetchHooks Function()
        > {
  $$PurchaseItemsTableTableManager(_$AppDatabase db, $PurchaseItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> purchaseId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> unitId = const Value.absent(),
                Value<int> qty = const Value.absent(),
                Value<int> unitCost = const Value.absent(),
                Value<int> qtyBase = const Value.absent(),
                Value<double> costPerBase = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseItemsCompanion(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                purchaseId: purchaseId,
                productId: productId,
                unitId: unitId,
                qty: qty,
                unitCost: unitCost,
                qtyBase: qtyBase,
                costPerBase: costPerBase,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required String purchaseId,
                required String productId,
                required String unitId,
                required int qty,
                required int unitCost,
                required int qtyBase,
                required double costPerBase,
                Value<int> rowid = const Value.absent(),
              }) => PurchaseItemsCompanion.insert(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                purchaseId: purchaseId,
                productId: productId,
                unitId: unitId,
                qty: qty,
                unitCost: unitCost,
                qtyBase: qtyBase,
                costPerBase: costPerBase,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PurchaseItemsTable, PurchaseItem>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PurchaseItemsTable,
                    PurchaseItem
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PurchaseItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseItemsTable,
      PurchaseItem,
      $$PurchaseItemsTableFilterComposer,
      $$PurchaseItemsTableOrderingComposer,
      $$PurchaseItemsTableAnnotationComposer,
      $$PurchaseItemsTableCreateCompanionBuilder,
      $$PurchaseItemsTableUpdateCompanionBuilder,
      (
        PurchaseItem,
        BaseReferences<_$AppDatabase, $PurchaseItemsTable, PurchaseItem>,
      ),
      PurchaseItem,
      PrefetchHooks Function()
    >;
typedef $$StockMovementsTableCreateCompanionBuilder =
    StockMovementsCompanion Function({
      required String id,
      required String storeId,
      required String productId,
      required int qtyBaseDelta,
      required MovementType type,
      Value<String?> refType,
      Value<String?> refId,
      Value<double?> costPerBase,
      required DateTime occurredAt,
      Value<String?> note,
      Value<String?> deviceId,
      Value<int?> serverSeq,
      Value<int> rowid,
    });
typedef $$StockMovementsTableUpdateCompanionBuilder =
    StockMovementsCompanion Function({
      Value<String> id,
      Value<String> storeId,
      Value<String> productId,
      Value<int> qtyBaseDelta,
      Value<MovementType> type,
      Value<String?> refType,
      Value<String?> refId,
      Value<double?> costPerBase,
      Value<DateTime> occurredAt,
      Value<String?> note,
      Value<String?> deviceId,
      Value<int?> serverSeq,
      Value<int> rowid,
    });

class $$StockMovementsTableFilterComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableFilterComposer({
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

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qtyBaseDelta => $composableBuilder(
    column: $table.qtyBaseDelta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MovementType, MovementType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get refType => $composableBuilder(
    column: $table.refType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get costPerBase => $composableBuilder(
    column: $table.costPerBase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverSeq => $composableBuilder(
    column: $table.serverSeq,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StockMovementsTableOrderingComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableOrderingComposer({
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

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qtyBaseDelta => $composableBuilder(
    column: $table.qtyBaseDelta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refType => $composableBuilder(
    column: $table.refType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get costPerBase => $composableBuilder(
    column: $table.costPerBase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverSeq => $composableBuilder(
    column: $table.serverSeq,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StockMovementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get qtyBaseDelta => $composableBuilder(
    column: $table.qtyBaseDelta,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<MovementType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get refType =>
      $composableBuilder(column: $table.refType, builder: (column) => column);

  GeneratedColumn<String> get refId =>
      $composableBuilder(column: $table.refId, builder: (column) => column);

  GeneratedColumn<double> get costPerBase => $composableBuilder(
    column: $table.costPerBase,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);
}

class $$StockMovementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockMovementsTable,
          StockMovement,
          $$StockMovementsTableFilterComposer,
          $$StockMovementsTableOrderingComposer,
          $$StockMovementsTableAnnotationComposer,
          $$StockMovementsTableCreateCompanionBuilder,
          $$StockMovementsTableUpdateCompanionBuilder,
          (
            StockMovement,
            BaseReferences<_$AppDatabase, $StockMovementsTable, StockMovement>,
          ),
          StockMovement,
          PrefetchHooks Function()
        > {
  $$StockMovementsTableTableManager(
    _$AppDatabase db,
    $StockMovementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockMovementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockMovementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockMovementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int> qtyBaseDelta = const Value.absent(),
                Value<MovementType> type = const Value.absent(),
                Value<String?> refType = const Value.absent(),
                Value<String?> refId = const Value.absent(),
                Value<double?> costPerBase = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int?> serverSeq = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockMovementsCompanion(
                id: id,
                storeId: storeId,
                productId: productId,
                qtyBaseDelta: qtyBaseDelta,
                type: type,
                refType: refType,
                refId: refId,
                costPerBase: costPerBase,
                occurredAt: occurredAt,
                note: note,
                deviceId: deviceId,
                serverSeq: serverSeq,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required String productId,
                required int qtyBaseDelta,
                required MovementType type,
                Value<String?> refType = const Value.absent(),
                Value<String?> refId = const Value.absent(),
                Value<double?> costPerBase = const Value.absent(),
                required DateTime occurredAt,
                Value<String?> note = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int?> serverSeq = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockMovementsCompanion.insert(
                id: id,
                storeId: storeId,
                productId: productId,
                qtyBaseDelta: qtyBaseDelta,
                type: type,
                refType: refType,
                refId: refId,
                costPerBase: costPerBase,
                occurredAt: occurredAt,
                note: note,
                deviceId: deviceId,
                serverSeq: serverSeq,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StockMovementsTable, StockMovement>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $StockMovementsTable,
                    StockMovement
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StockMovementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockMovementsTable,
      StockMovement,
      $$StockMovementsTableFilterComposer,
      $$StockMovementsTableOrderingComposer,
      $$StockMovementsTableAnnotationComposer,
      $$StockMovementsTableCreateCompanionBuilder,
      $$StockMovementsTableUpdateCompanionBuilder,
      (
        StockMovement,
        BaseReferences<_$AppDatabase, $StockMovementsTable, StockMovement>,
      ),
      StockMovement,
      PrefetchHooks Function()
    >;
typedef $$PutawayLogTableCreateCompanionBuilder = PutawayLogCompanion Function({
  required String id,
  required String storeId,
  required String productId,
  Value<String?> fromLocation,
  Value<String?> toLocation,
  required DateTime occurredAt,
  Value<String?> deviceId,
  Value<int> rowid,
});
typedef $$PutawayLogTableUpdateCompanionBuilder = PutawayLogCompanion Function({
  Value<String> id,
  Value<String> storeId,
  Value<String> productId,
  Value<String?> fromLocation,
  Value<String?> toLocation,
  Value<DateTime> occurredAt,
  Value<String?> deviceId,
  Value<int> rowid,
});

class $$PutawayLogTableFilterComposer
    extends Composer<_$AppDatabase, $PutawayLogTable> {
  $$PutawayLogTableFilterComposer({
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

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromLocation => $composableBuilder(
    column: $table.fromLocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toLocation => $composableBuilder(
    column: $table.toLocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PutawayLogTableOrderingComposer
    extends Composer<_$AppDatabase, $PutawayLogTable> {
  $$PutawayLogTableOrderingComposer({
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

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromLocation => $composableBuilder(
    column: $table.fromLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toLocation => $composableBuilder(
    column: $table.toLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PutawayLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $PutawayLogTable> {
  $$PutawayLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get fromLocation => $composableBuilder(
    column: $table.fromLocation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toLocation => $composableBuilder(
    column: $table.toLocation,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);
}

class $$PutawayLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PutawayLogTable,
          PutawayLogData,
          $$PutawayLogTableFilterComposer,
          $$PutawayLogTableOrderingComposer,
          $$PutawayLogTableAnnotationComposer,
          $$PutawayLogTableCreateCompanionBuilder,
          $$PutawayLogTableUpdateCompanionBuilder,
          (
            PutawayLogData,
            BaseReferences<_$AppDatabase, $PutawayLogTable, PutawayLogData>,
          ),
          PutawayLogData,
          PrefetchHooks Function()
        > {
  $$PutawayLogTableTableManager(_$AppDatabase db, $PutawayLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PutawayLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PutawayLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PutawayLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String?> fromLocation = const Value.absent(),
                Value<String?> toLocation = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PutawayLogCompanion(
                id: id,
                storeId: storeId,
                productId: productId,
                fromLocation: fromLocation,
                toLocation: toLocation,
                occurredAt: occurredAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required String productId,
                Value<String?> fromLocation = const Value.absent(),
                Value<String?> toLocation = const Value.absent(),
                required DateTime occurredAt,
                Value<String?> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PutawayLogCompanion.insert(
                id: id,
                storeId: storeId,
                productId: productId,
                fromLocation: fromLocation,
                toLocation: toLocation,
                occurredAt: occurredAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PutawayLogTable, PutawayLogData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PutawayLogTable,
                    PutawayLogData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PutawayLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PutawayLogTable,
      PutawayLogData,
      $$PutawayLogTableFilterComposer,
      $$PutawayLogTableOrderingComposer,
      $$PutawayLogTableAnnotationComposer,
      $$PutawayLogTableCreateCompanionBuilder,
      $$PutawayLogTableUpdateCompanionBuilder,
      (
        PutawayLogData,
        BaseReferences<_$AppDatabase, $PutawayLogTable, PutawayLogData>,
      ),
      PutawayLogData,
      PrefetchHooks Function()
    >;
typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  required String id,
  required String storeId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  required String name,
  Value<String?> phone,
  Value<String?> note,
  Value<int?> creditLimit,
  Value<int> rowid,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<String> id,
  Value<String> storeId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  Value<String> name,
  Value<String?> phone,
  Value<String?> note,
  Value<int?> creditLimit,
  Value<int> rowid,
});

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
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

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
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

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => column,
  );
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          Customer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
          Customer,
          PrefetchHooks Function()
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int?> creditLimit = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                name: name,
                phone: phone,
                note: note,
                creditLimit: creditLimit,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int?> creditLimit = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                name: name,
                phone: phone,
                note: note,
                creditLimit: creditLimit,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CustomersTable, Customer>(table),
                  BaseReferences<_$AppDatabase, $CustomersTable, Customer>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      Customer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
      Customer,
      PrefetchHooks Function()
    >;
typedef $$DebtLedgerTableCreateCompanionBuilder = DebtLedgerCompanion Function({
  required String id,
  required String storeId,
  required String customerId,
  required int delta,
  required DebtType type,
  Value<String?> refId,
  Value<PayMethod?> method,
  required DateTime occurredAt,
  Value<String?> note,
  Value<String?> deviceId,
  Value<int> rowid,
});
typedef $$DebtLedgerTableUpdateCompanionBuilder = DebtLedgerCompanion Function({
  Value<String> id,
  Value<String> storeId,
  Value<String> customerId,
  Value<int> delta,
  Value<DebtType> type,
  Value<String?> refId,
  Value<PayMethod?> method,
  Value<DateTime> occurredAt,
  Value<String?> note,
  Value<String?> deviceId,
  Value<int> rowid,
});

class $$DebtLedgerTableFilterComposer
    extends Composer<_$AppDatabase, $DebtLedgerTable> {
  $$DebtLedgerTableFilterComposer({
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

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get delta => $composableBuilder(
    column: $table.delta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DebtType, DebtType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PayMethod?, PayMethod, String> get method =>
      $composableBuilder(
        column: $table.method,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DebtLedgerTableOrderingComposer
    extends Composer<_$AppDatabase, $DebtLedgerTable> {
  $$DebtLedgerTableOrderingComposer({
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

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get delta => $composableBuilder(
    column: $table.delta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DebtLedgerTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebtLedgerTable> {
  $$DebtLedgerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get delta =>
      $composableBuilder(column: $table.delta, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DebtType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get refId =>
      $composableBuilder(column: $table.refId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PayMethod?, String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);
}

class $$DebtLedgerTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DebtLedgerTable,
          DebtLedgerData,
          $$DebtLedgerTableFilterComposer,
          $$DebtLedgerTableOrderingComposer,
          $$DebtLedgerTableAnnotationComposer,
          $$DebtLedgerTableCreateCompanionBuilder,
          $$DebtLedgerTableUpdateCompanionBuilder,
          (
            DebtLedgerData,
            BaseReferences<_$AppDatabase, $DebtLedgerTable, DebtLedgerData>,
          ),
          DebtLedgerData,
          PrefetchHooks Function()
        > {
  $$DebtLedgerTableTableManager(_$AppDatabase db, $DebtLedgerTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebtLedgerTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebtLedgerTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebtLedgerTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<int> delta = const Value.absent(),
                Value<DebtType> type = const Value.absent(),
                Value<String?> refId = const Value.absent(),
                Value<PayMethod?> method = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DebtLedgerCompanion(
                id: id,
                storeId: storeId,
                customerId: customerId,
                delta: delta,
                type: type,
                refId: refId,
                method: method,
                occurredAt: occurredAt,
                note: note,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required String customerId,
                required int delta,
                required DebtType type,
                Value<String?> refId = const Value.absent(),
                Value<PayMethod?> method = const Value.absent(),
                required DateTime occurredAt,
                Value<String?> note = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DebtLedgerCompanion.insert(
                id: id,
                storeId: storeId,
                customerId: customerId,
                delta: delta,
                type: type,
                refId: refId,
                method: method,
                occurredAt: occurredAt,
                note: note,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DebtLedgerTable, DebtLedgerData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DebtLedgerTable,
                    DebtLedgerData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DebtLedgerTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DebtLedgerTable,
      DebtLedgerData,
      $$DebtLedgerTableFilterComposer,
      $$DebtLedgerTableOrderingComposer,
      $$DebtLedgerTableAnnotationComposer,
      $$DebtLedgerTableCreateCompanionBuilder,
      $$DebtLedgerTableUpdateCompanionBuilder,
      (
        DebtLedgerData,
        BaseReferences<_$AppDatabase, $DebtLedgerTable, DebtLedgerData>,
      ),
      DebtLedgerData,
      PrefetchHooks Function()
    >;
typedef $$SalesTableCreateCompanionBuilder = SalesCompanion Function({
  required String id,
  required String storeId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  required String receiptNo,
  required String cashierId,
  Value<String?> customerId,
  required DateTime soldAt,
  required int subtotal,
  Value<int> discountTotal,
  required int total,
  required int paidTotal,
  Value<int> changeAmount,
  Value<SaleStatus> status,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$SalesTableUpdateCompanionBuilder = SalesCompanion Function({
  Value<String> id,
  Value<String> storeId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  Value<String> receiptNo,
  Value<String> cashierId,
  Value<String?> customerId,
  Value<DateTime> soldAt,
  Value<int> subtotal,
  Value<int> discountTotal,
  Value<int> total,
  Value<int> paidTotal,
  Value<int> changeAmount,
  Value<SaleStatus> status,
  Value<String?> note,
  Value<int> rowid,
});

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
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

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptNo => $composableBuilder(
    column: $table.receiptNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cashierId => $composableBuilder(
    column: $table.cashierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get soldAt => $composableBuilder(
    column: $table.soldAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountTotal => $composableBuilder(
    column: $table.discountTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paidTotal => $composableBuilder(
    column: $table.paidTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get changeAmount => $composableBuilder(
    column: $table.changeAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SaleStatus, SaleStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
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

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptNo => $composableBuilder(
    column: $table.receiptNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cashierId => $composableBuilder(
    column: $table.cashierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get soldAt => $composableBuilder(
    column: $table.soldAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountTotal => $composableBuilder(
    column: $table.discountTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paidTotal => $composableBuilder(
    column: $table.paidTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get changeAmount => $composableBuilder(
    column: $table.changeAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get receiptNo =>
      $composableBuilder(column: $table.receiptNo, builder: (column) => column);

  GeneratedColumn<String> get cashierId =>
      $composableBuilder(column: $table.cashierId, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get soldAt =>
      $composableBuilder(column: $table.soldAt, builder: (column) => column);

  GeneratedColumn<int> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<int> get discountTotal => $composableBuilder(
    column: $table.discountTotal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get paidTotal =>
      $composableBuilder(column: $table.paidTotal, builder: (column) => column);

  GeneratedColumn<int> get changeAmount => $composableBuilder(
    column: $table.changeAmount,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SaleStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$SalesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalesTable,
          Sale,
          $$SalesTableFilterComposer,
          $$SalesTableOrderingComposer,
          $$SalesTableAnnotationComposer,
          $$SalesTableCreateCompanionBuilder,
          $$SalesTableUpdateCompanionBuilder,
          (Sale, BaseReferences<_$AppDatabase, $SalesTable, Sale>),
          Sale,
          PrefetchHooks Function()
        > {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> receiptNo = const Value.absent(),
                Value<String> cashierId = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<DateTime> soldAt = const Value.absent(),
                Value<int> subtotal = const Value.absent(),
                Value<int> discountTotal = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<int> paidTotal = const Value.absent(),
                Value<int> changeAmount = const Value.absent(),
                Value<SaleStatus> status = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesCompanion(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                receiptNo: receiptNo,
                cashierId: cashierId,
                customerId: customerId,
                soldAt: soldAt,
                subtotal: subtotal,
                discountTotal: discountTotal,
                total: total,
                paidTotal: paidTotal,
                changeAmount: changeAmount,
                status: status,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required String receiptNo,
                required String cashierId,
                Value<String?> customerId = const Value.absent(),
                required DateTime soldAt,
                required int subtotal,
                Value<int> discountTotal = const Value.absent(),
                required int total,
                required int paidTotal,
                Value<int> changeAmount = const Value.absent(),
                Value<SaleStatus> status = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesCompanion.insert(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                receiptNo: receiptNo,
                cashierId: cashierId,
                customerId: customerId,
                soldAt: soldAt,
                subtotal: subtotal,
                discountTotal: discountTotal,
                total: total,
                paidTotal: paidTotal,
                changeAmount: changeAmount,
                status: status,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SalesTable, Sale>(table),
                  BaseReferences<_$AppDatabase, $SalesTable, Sale>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SalesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalesTable,
      Sale,
      $$SalesTableFilterComposer,
      $$SalesTableOrderingComposer,
      $$SalesTableAnnotationComposer,
      $$SalesTableCreateCompanionBuilder,
      $$SalesTableUpdateCompanionBuilder,
      (Sale, BaseReferences<_$AppDatabase, $SalesTable, Sale>),
      Sale,
      PrefetchHooks Function()
    >;
typedef $$SaleItemsTableCreateCompanionBuilder = SaleItemsCompanion Function({
  required String id,
  required String storeId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  required String saleId,
  required String productId,
  required String unitId,
  required int qty,
  required int qtyBase,
  required int unitPrice,
  Value<int> discount,
  required int lineTotal,
  Value<double?> costPerBase,
  Value<int> rowid,
});
typedef $$SaleItemsTableUpdateCompanionBuilder = SaleItemsCompanion Function({
  Value<String> id,
  Value<String> storeId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  Value<String> saleId,
  Value<String> productId,
  Value<String> unitId,
  Value<int> qty,
  Value<int> qtyBase,
  Value<int> unitPrice,
  Value<int> discount,
  Value<int> lineTotal,
  Value<double?> costPerBase,
  Value<int> rowid,
});

class $$SaleItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableFilterComposer({
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

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitId => $composableBuilder(
    column: $table.unitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qtyBase => $composableBuilder(
    column: $table.qtyBase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get costPerBase => $composableBuilder(
    column: $table.costPerBase,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SaleItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableOrderingComposer({
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

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitId => $composableBuilder(
    column: $table.unitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qtyBase => $composableBuilder(
    column: $table.qtyBase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get costPerBase => $composableBuilder(
    column: $table.costPerBase,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SaleItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<int> get qtyBase =>
      $composableBuilder(column: $table.qtyBase, builder: (column) => column);

  GeneratedColumn<int> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<int> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<int> get lineTotal =>
      $composableBuilder(column: $table.lineTotal, builder: (column) => column);

  GeneratedColumn<double> get costPerBase => $composableBuilder(
    column: $table.costPerBase,
    builder: (column) => column,
  );
}

class $$SaleItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SaleItemsTable,
          SaleItem,
          $$SaleItemsTableFilterComposer,
          $$SaleItemsTableOrderingComposer,
          $$SaleItemsTableAnnotationComposer,
          $$SaleItemsTableCreateCompanionBuilder,
          $$SaleItemsTableUpdateCompanionBuilder,
          (SaleItem, BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem>),
          SaleItem,
          PrefetchHooks Function()
        > {
  $$SaleItemsTableTableManager(_$AppDatabase db, $SaleItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> saleId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> unitId = const Value.absent(),
                Value<int> qty = const Value.absent(),
                Value<int> qtyBase = const Value.absent(),
                Value<int> unitPrice = const Value.absent(),
                Value<int> discount = const Value.absent(),
                Value<int> lineTotal = const Value.absent(),
                Value<double?> costPerBase = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SaleItemsCompanion(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                saleId: saleId,
                productId: productId,
                unitId: unitId,
                qty: qty,
                qtyBase: qtyBase,
                unitPrice: unitPrice,
                discount: discount,
                lineTotal: lineTotal,
                costPerBase: costPerBase,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required String saleId,
                required String productId,
                required String unitId,
                required int qty,
                required int qtyBase,
                required int unitPrice,
                Value<int> discount = const Value.absent(),
                required int lineTotal,
                Value<double?> costPerBase = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SaleItemsCompanion.insert(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                saleId: saleId,
                productId: productId,
                unitId: unitId,
                qty: qty,
                qtyBase: qtyBase,
                unitPrice: unitPrice,
                discount: discount,
                lineTotal: lineTotal,
                costPerBase: costPerBase,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SaleItemsTable, SaleItem>(table),
                  BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SaleItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SaleItemsTable,
      SaleItem,
      $$SaleItemsTableFilterComposer,
      $$SaleItemsTableOrderingComposer,
      $$SaleItemsTableAnnotationComposer,
      $$SaleItemsTableCreateCompanionBuilder,
      $$SaleItemsTableUpdateCompanionBuilder,
      (SaleItem, BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem>),
      SaleItem,
      PrefetchHooks Function()
    >;
typedef $$PaymentsTableCreateCompanionBuilder = PaymentsCompanion Function({
  required String id,
  required String storeId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  required String saleId,
  required PayMethod method,
  required int amount,
  Value<PaymentStatus> status,
  Value<String?> reference,
  required DateTime paidAt,
  Value<int> rowid,
});
typedef $$PaymentsTableUpdateCompanionBuilder = PaymentsCompanion Function({
  Value<String> id,
  Value<String> storeId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  Value<String> saleId,
  Value<PayMethod> method,
  Value<int> amount,
  Value<PaymentStatus> status,
  Value<String?> reference,
  Value<DateTime> paidAt,
  Value<int> rowid,
});

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
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

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PayMethod, PayMethod, String> get method =>
      $composableBuilder(
        column: $table.method,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentStatus, PaymentStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
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

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PayMethod, String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PaymentStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);
}

class $$PaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentsTable,
          Payment,
          $$PaymentsTableFilterComposer,
          $$PaymentsTableOrderingComposer,
          $$PaymentsTableAnnotationComposer,
          $$PaymentsTableCreateCompanionBuilder,
          $$PaymentsTableUpdateCompanionBuilder,
          (Payment, BaseReferences<_$AppDatabase, $PaymentsTable, Payment>),
          Payment,
          PrefetchHooks Function()
        > {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> saleId = const Value.absent(),
                Value<PayMethod> method = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<PaymentStatus> status = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                Value<DateTime> paidAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentsCompanion(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                saleId: saleId,
                method: method,
                amount: amount,
                status: status,
                reference: reference,
                paidAt: paidAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required String saleId,
                required PayMethod method,
                required int amount,
                Value<PaymentStatus> status = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                required DateTime paidAt,
                Value<int> rowid = const Value.absent(),
              }) => PaymentsCompanion.insert(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                saleId: saleId,
                method: method,
                amount: amount,
                status: status,
                reference: reference,
                paidAt: paidAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PaymentsTable, Payment>(table),
                  BaseReferences<_$AppDatabase, $PaymentsTable, Payment>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentsTable,
      Payment,
      $$PaymentsTableFilterComposer,
      $$PaymentsTableOrderingComposer,
      $$PaymentsTableAnnotationComposer,
      $$PaymentsTableCreateCompanionBuilder,
      $$PaymentsTableUpdateCompanionBuilder,
      (Payment, BaseReferences<_$AppDatabase, $PaymentsTable, Payment>),
      Payment,
      PrefetchHooks Function()
    >;
typedef $$ReturnsTableCreateCompanionBuilder = ReturnsCompanion Function({
  required String id,
  required String storeId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  required ReturnKind kind,
  Value<String?> saleId,
  Value<String?> purchaseId,
  Value<String?> customerId,
  required DateTime returnedAt,
  Value<PayMethod?> refundMethod,
  Value<int> refundTotal,
  Value<String?> reason,
  Value<int> rowid,
});
typedef $$ReturnsTableUpdateCompanionBuilder = ReturnsCompanion Function({
  Value<String> id,
  Value<String> storeId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  Value<ReturnKind> kind,
  Value<String?> saleId,
  Value<String?> purchaseId,
  Value<String?> customerId,
  Value<DateTime> returnedAt,
  Value<PayMethod?> refundMethod,
  Value<int> refundTotal,
  Value<String?> reason,
  Value<int> rowid,
});

class $$ReturnsTableFilterComposer
    extends Composer<_$AppDatabase, $ReturnsTable> {
  $$ReturnsTableFilterComposer({
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

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ReturnKind, ReturnKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PayMethod?, PayMethod, String>
  get refundMethod => $composableBuilder(
    column: $table.refundMethod,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get refundTotal => $composableBuilder(
    column: $table.refundTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReturnsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReturnsTable> {
  $$ReturnsTableOrderingComposer({
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

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refundMethod => $composableBuilder(
    column: $table.refundMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get refundTotal => $composableBuilder(
    column: $table.refundTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReturnsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReturnsTable> {
  $$ReturnsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ReturnKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PayMethod?, String> get refundMethod =>
      $composableBuilder(
        column: $table.refundMethod,
        builder: (column) => column,
      );

  GeneratedColumn<int> get refundTotal => $composableBuilder(
    column: $table.refundTotal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);
}

class $$ReturnsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReturnsTable,
          Return,
          $$ReturnsTableFilterComposer,
          $$ReturnsTableOrderingComposer,
          $$ReturnsTableAnnotationComposer,
          $$ReturnsTableCreateCompanionBuilder,
          $$ReturnsTableUpdateCompanionBuilder,
          (Return, BaseReferences<_$AppDatabase, $ReturnsTable, Return>),
          Return,
          PrefetchHooks Function()
        > {
  $$ReturnsTableTableManager(_$AppDatabase db, $ReturnsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReturnsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReturnsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReturnsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<ReturnKind> kind = const Value.absent(),
                Value<String?> saleId = const Value.absent(),
                Value<String?> purchaseId = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<DateTime> returnedAt = const Value.absent(),
                Value<PayMethod?> refundMethod = const Value.absent(),
                Value<int> refundTotal = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReturnsCompanion(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                kind: kind,
                saleId: saleId,
                purchaseId: purchaseId,
                customerId: customerId,
                returnedAt: returnedAt,
                refundMethod: refundMethod,
                refundTotal: refundTotal,
                reason: reason,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required ReturnKind kind,
                Value<String?> saleId = const Value.absent(),
                Value<String?> purchaseId = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                required DateTime returnedAt,
                Value<PayMethod?> refundMethod = const Value.absent(),
                Value<int> refundTotal = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReturnsCompanion.insert(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                kind: kind,
                saleId: saleId,
                purchaseId: purchaseId,
                customerId: customerId,
                returnedAt: returnedAt,
                refundMethod: refundMethod,
                refundTotal: refundTotal,
                reason: reason,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReturnsTable, Return>(table),
                  BaseReferences<_$AppDatabase, $ReturnsTable, Return>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReturnsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReturnsTable,
      Return,
      $$ReturnsTableFilterComposer,
      $$ReturnsTableOrderingComposer,
      $$ReturnsTableAnnotationComposer,
      $$ReturnsTableCreateCompanionBuilder,
      $$ReturnsTableUpdateCompanionBuilder,
      (Return, BaseReferences<_$AppDatabase, $ReturnsTable, Return>),
      Return,
      PrefetchHooks Function()
    >;
typedef $$ReturnItemsTableCreateCompanionBuilder =
    ReturnItemsCompanion Function({
      required String id,
      required String storeId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> deviceId,
      required String returnId,
      required String productId,
      required String unitId,
      required int qty,
      required int qtyBase,
      required int amount,
      Value<double?> costPerBase,
      Value<int> rowid,
    });
typedef $$ReturnItemsTableUpdateCompanionBuilder =
    ReturnItemsCompanion Function({
      Value<String> id,
      Value<String> storeId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> deviceId,
      Value<String> returnId,
      Value<String> productId,
      Value<String> unitId,
      Value<int> qty,
      Value<int> qtyBase,
      Value<int> amount,
      Value<double?> costPerBase,
      Value<int> rowid,
    });

class $$ReturnItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ReturnItemsTable> {
  $$ReturnItemsTableFilterComposer({
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

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get returnId => $composableBuilder(
    column: $table.returnId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitId => $composableBuilder(
    column: $table.unitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qtyBase => $composableBuilder(
    column: $table.qtyBase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get costPerBase => $composableBuilder(
    column: $table.costPerBase,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReturnItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReturnItemsTable> {
  $$ReturnItemsTableOrderingComposer({
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

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get returnId => $composableBuilder(
    column: $table.returnId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitId => $composableBuilder(
    column: $table.unitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qtyBase => $composableBuilder(
    column: $table.qtyBase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get costPerBase => $composableBuilder(
    column: $table.costPerBase,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReturnItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReturnItemsTable> {
  $$ReturnItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get returnId =>
      $composableBuilder(column: $table.returnId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<int> get qtyBase =>
      $composableBuilder(column: $table.qtyBase, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get costPerBase => $composableBuilder(
    column: $table.costPerBase,
    builder: (column) => column,
  );
}

class $$ReturnItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReturnItemsTable,
          ReturnItem,
          $$ReturnItemsTableFilterComposer,
          $$ReturnItemsTableOrderingComposer,
          $$ReturnItemsTableAnnotationComposer,
          $$ReturnItemsTableCreateCompanionBuilder,
          $$ReturnItemsTableUpdateCompanionBuilder,
          (
            ReturnItem,
            BaseReferences<_$AppDatabase, $ReturnItemsTable, ReturnItem>,
          ),
          ReturnItem,
          PrefetchHooks Function()
        > {
  $$ReturnItemsTableTableManager(_$AppDatabase db, $ReturnItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReturnItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReturnItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReturnItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> returnId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> unitId = const Value.absent(),
                Value<int> qty = const Value.absent(),
                Value<int> qtyBase = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<double?> costPerBase = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReturnItemsCompanion(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                returnId: returnId,
                productId: productId,
                unitId: unitId,
                qty: qty,
                qtyBase: qtyBase,
                amount: amount,
                costPerBase: costPerBase,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required String returnId,
                required String productId,
                required String unitId,
                required int qty,
                required int qtyBase,
                required int amount,
                Value<double?> costPerBase = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReturnItemsCompanion.insert(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                returnId: returnId,
                productId: productId,
                unitId: unitId,
                qty: qty,
                qtyBase: qtyBase,
                amount: amount,
                costPerBase: costPerBase,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReturnItemsTable, ReturnItem>(table),
                  BaseReferences<_$AppDatabase, $ReturnItemsTable, ReturnItem>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReturnItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReturnItemsTable,
      ReturnItem,
      $$ReturnItemsTableFilterComposer,
      $$ReturnItemsTableOrderingComposer,
      $$ReturnItemsTableAnnotationComposer,
      $$ReturnItemsTableCreateCompanionBuilder,
      $$ReturnItemsTableUpdateCompanionBuilder,
      (
        ReturnItem,
        BaseReferences<_$AppDatabase, $ReturnItemsTable, ReturnItem>,
      ),
      ReturnItem,
      PrefetchHooks Function()
    >;
typedef $$StockOpnamesTableCreateCompanionBuilder =
    StockOpnamesCompanion Function({
      required String id,
      required String storeId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> deviceId,
      required DateTime startedAt,
      Value<DateTime?> finishedAt,
      Value<OpnameStatus> status,
      Value<String?> scope,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$StockOpnamesTableUpdateCompanionBuilder =
    StockOpnamesCompanion Function({
      Value<String> id,
      Value<String> storeId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> deviceId,
      Value<DateTime> startedAt,
      Value<DateTime?> finishedAt,
      Value<OpnameStatus> status,
      Value<String?> scope,
      Value<String?> note,
      Value<int> rowid,
    });

class $$StockOpnamesTableFilterComposer
    extends Composer<_$AppDatabase, $StockOpnamesTable> {
  $$StockOpnamesTableFilterComposer({
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

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<OpnameStatus, OpnameStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StockOpnamesTableOrderingComposer
    extends Composer<_$AppDatabase, $StockOpnamesTable> {
  $$StockOpnamesTableOrderingComposer({
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

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StockOpnamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockOpnamesTable> {
  $$StockOpnamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<OpnameStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$StockOpnamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockOpnamesTable,
          StockOpname,
          $$StockOpnamesTableFilterComposer,
          $$StockOpnamesTableOrderingComposer,
          $$StockOpnamesTableAnnotationComposer,
          $$StockOpnamesTableCreateCompanionBuilder,
          $$StockOpnamesTableUpdateCompanionBuilder,
          (
            StockOpname,
            BaseReferences<_$AppDatabase, $StockOpnamesTable, StockOpname>,
          ),
          StockOpname,
          PrefetchHooks Function()
        > {
  $$StockOpnamesTableTableManager(_$AppDatabase db, $StockOpnamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockOpnamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockOpnamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockOpnamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<OpnameStatus> status = const Value.absent(),
                Value<String?> scope = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockOpnamesCompanion(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                startedAt: startedAt,
                finishedAt: finishedAt,
                status: status,
                scope: scope,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<OpnameStatus> status = const Value.absent(),
                Value<String?> scope = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockOpnamesCompanion.insert(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                startedAt: startedAt,
                finishedAt: finishedAt,
                status: status,
                scope: scope,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StockOpnamesTable, StockOpname>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $StockOpnamesTable,
                    StockOpname
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StockOpnamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockOpnamesTable,
      StockOpname,
      $$StockOpnamesTableFilterComposer,
      $$StockOpnamesTableOrderingComposer,
      $$StockOpnamesTableAnnotationComposer,
      $$StockOpnamesTableCreateCompanionBuilder,
      $$StockOpnamesTableUpdateCompanionBuilder,
      (
        StockOpname,
        BaseReferences<_$AppDatabase, $StockOpnamesTable, StockOpname>,
      ),
      StockOpname,
      PrefetchHooks Function()
    >;
typedef $$StockOpnameItemsTableCreateCompanionBuilder =
    StockOpnameItemsCompanion Function({
      required String id,
      required String storeId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> deviceId,
      required String opnameId,
      required String productId,
      Value<int?> expectedBase,
      required int countedBase,
      Value<int?> diffBase,
      Value<int> rowid,
    });
typedef $$StockOpnameItemsTableUpdateCompanionBuilder =
    StockOpnameItemsCompanion Function({
      Value<String> id,
      Value<String> storeId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> deviceId,
      Value<String> opnameId,
      Value<String> productId,
      Value<int?> expectedBase,
      Value<int> countedBase,
      Value<int?> diffBase,
      Value<int> rowid,
    });

class $$StockOpnameItemsTableFilterComposer
    extends Composer<_$AppDatabase, $StockOpnameItemsTable> {
  $$StockOpnameItemsTableFilterComposer({
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

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get opnameId => $composableBuilder(
    column: $table.opnameId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expectedBase => $composableBuilder(
    column: $table.expectedBase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get countedBase => $composableBuilder(
    column: $table.countedBase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diffBase => $composableBuilder(
    column: $table.diffBase,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StockOpnameItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $StockOpnameItemsTable> {
  $$StockOpnameItemsTableOrderingComposer({
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

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get opnameId => $composableBuilder(
    column: $table.opnameId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expectedBase => $composableBuilder(
    column: $table.expectedBase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get countedBase => $composableBuilder(
    column: $table.countedBase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diffBase => $composableBuilder(
    column: $table.diffBase,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StockOpnameItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockOpnameItemsTable> {
  $$StockOpnameItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get opnameId =>
      $composableBuilder(column: $table.opnameId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get expectedBase => $composableBuilder(
    column: $table.expectedBase,
    builder: (column) => column,
  );

  GeneratedColumn<int> get countedBase => $composableBuilder(
    column: $table.countedBase,
    builder: (column) => column,
  );

  GeneratedColumn<int> get diffBase =>
      $composableBuilder(column: $table.diffBase, builder: (column) => column);
}

class $$StockOpnameItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockOpnameItemsTable,
          StockOpnameItem,
          $$StockOpnameItemsTableFilterComposer,
          $$StockOpnameItemsTableOrderingComposer,
          $$StockOpnameItemsTableAnnotationComposer,
          $$StockOpnameItemsTableCreateCompanionBuilder,
          $$StockOpnameItemsTableUpdateCompanionBuilder,
          (
            StockOpnameItem,
            BaseReferences<
              _$AppDatabase,
              $StockOpnameItemsTable,
              StockOpnameItem
            >,
          ),
          StockOpnameItem,
          PrefetchHooks Function()
        > {
  $$StockOpnameItemsTableTableManager(
    _$AppDatabase db,
    $StockOpnameItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockOpnameItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockOpnameItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockOpnameItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> opnameId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int?> expectedBase = const Value.absent(),
                Value<int> countedBase = const Value.absent(),
                Value<int?> diffBase = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockOpnameItemsCompanion(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                opnameId: opnameId,
                productId: productId,
                expectedBase: expectedBase,
                countedBase: countedBase,
                diffBase: diffBase,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required String opnameId,
                required String productId,
                Value<int?> expectedBase = const Value.absent(),
                required int countedBase,
                Value<int?> diffBase = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockOpnameItemsCompanion.insert(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                opnameId: opnameId,
                productId: productId,
                expectedBase: expectedBase,
                countedBase: countedBase,
                diffBase: diffBase,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StockOpnameItemsTable, StockOpnameItem>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $StockOpnameItemsTable,
                    StockOpnameItem
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StockOpnameItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockOpnameItemsTable,
      StockOpnameItem,
      $$StockOpnameItemsTableFilterComposer,
      $$StockOpnameItemsTableOrderingComposer,
      $$StockOpnameItemsTableAnnotationComposer,
      $$StockOpnameItemsTableCreateCompanionBuilder,
      $$StockOpnameItemsTableUpdateCompanionBuilder,
      (
        StockOpnameItem,
        BaseReferences<_$AppDatabase, $StockOpnameItemsTable, StockOpnameItem>,
      ),
      StockOpnameItem,
      PrefetchHooks Function()
    >;
typedef $$ExpensesTableCreateCompanionBuilder = ExpensesCompanion Function({
  required String id,
  required String storeId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  required String category,
  required int amount,
  required DateTime spentAt,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<String> id,
  Value<String> storeId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> deviceId,
  Value<String> category,
  Value<int> amount,
  Value<DateTime> spentAt,
  Value<String?> note,
  Value<int> rowid,
});

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
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

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get spentAt => $composableBuilder(
    column: $table.spentAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
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

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get spentAt => $composableBuilder(
    column: $table.spentAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get spentAt =>
      $composableBuilder(column: $table.spentAt, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
          Expense,
          PrefetchHooks Function()
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<DateTime> spentAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                category: category,
                amount: amount,
                spentAt: spentAt,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required String category,
                required int amount,
                required DateTime spentAt,
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                storeId: storeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                category: category,
                amount: amount,
                spentAt: spentAt,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExpensesTable, Expense>(table),
                  BaseReferences<_$AppDatabase, $ExpensesTable, Expense>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
      Expense,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String storeId,
      required String key,
      required String value,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> storeId,
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> storeId = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                storeId: storeId,
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String storeId,
                required String key,
                required String value,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                storeId: storeId,
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$OutboxTableCreateCompanionBuilder = OutboxCompanion Function({
  required String opId,
  required String targetTable,
  required String rowId,
  required String op,
  required String payload,
  required DateTime createdAt,
  Value<int> attempts,
  Value<String?> lastError,
  Value<DateTime?> lastAttemptAt,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});
typedef $$OutboxTableUpdateCompanionBuilder = OutboxCompanion Function({
  Value<String> opId,
  Value<String> targetTable,
  Value<String> rowId,
  Value<String> op,
  Value<String> payload,
  Value<DateTime> createdAt,
  Value<int> attempts,
  Value<String?> lastError,
  Value<DateTime?> lastAttemptAt,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});

class $$OutboxTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get opId => $composableBuilder(
    column: $table.opId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get opId => $composableBuilder(
    column: $table.opId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get opId =>
      $composableBuilder(column: $table.opId, builder: (column) => column);

  GeneratedColumn<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$OutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxTable,
          OutboxData,
          $$OutboxTableFilterComposer,
          $$OutboxTableOrderingComposer,
          $$OutboxTableAnnotationComposer,
          $$OutboxTableCreateCompanionBuilder,
          $$OutboxTableUpdateCompanionBuilder,
          (OutboxData, BaseReferences<_$AppDatabase, $OutboxTable, OutboxData>),
          OutboxData,
          PrefetchHooks Function()
        > {
  $$OutboxTableTableManager(_$AppDatabase db, $OutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> opId = const Value.absent(),
                Value<String> targetTable = const Value.absent(),
                Value<String> rowId = const Value.absent(),
                Value<String> op = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxCompanion(
                opId: opId,
                targetTable: targetTable,
                rowId: rowId,
                op: op,
                payload: payload,
                createdAt: createdAt,
                attempts: attempts,
                lastError: lastError,
                lastAttemptAt: lastAttemptAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String opId,
                required String targetTable,
                required String rowId,
                required String op,
                required String payload,
                required DateTime createdAt,
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxCompanion.insert(
                opId: opId,
                targetTable: targetTable,
                rowId: rowId,
                op: op,
                payload: payload,
                createdAt: createdAt,
                attempts: attempts,
                lastError: lastError,
                lastAttemptAt: lastAttemptAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OutboxTable, OutboxData>(table),
                  BaseReferences<_$AppDatabase, $OutboxTable, OutboxData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxTable,
      OutboxData,
      $$OutboxTableFilterComposer,
      $$OutboxTableOrderingComposer,
      $$OutboxTableAnnotationComposer,
      $$OutboxTableCreateCompanionBuilder,
      $$OutboxTableUpdateCompanionBuilder,
      (OutboxData, BaseReferences<_$AppDatabase, $OutboxTable, OutboxData>),
      OutboxData,
      PrefetchHooks Function()
    >;
typedef $$SyncStateTableCreateCompanionBuilder = SyncStateCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SyncStateTableUpdateCompanionBuilder = SyncStateCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SyncStateTableFilterComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableFilterComposer({
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

class $$SyncStateTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableOrderingComposer({
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

class $$SyncStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableAnnotationComposer({
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

class $$SyncStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncStateTable,
          SyncStateData,
          $$SyncStateTableFilterComposer,
          $$SyncStateTableOrderingComposer,
          $$SyncStateTableAnnotationComposer,
          $$SyncStateTableCreateCompanionBuilder,
          $$SyncStateTableUpdateCompanionBuilder,
          (
            SyncStateData,
            BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateData>,
          ),
          SyncStateData,
          PrefetchHooks Function()
        > {
  $$SyncStateTableTableManager(_$AppDatabase db, $SyncStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SyncStateCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SyncStateCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncStateTable, SyncStateData>(table),
                  BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncStateTable,
      SyncStateData,
      $$SyncStateTableFilterComposer,
      $$SyncStateTableOrderingComposer,
      $$SyncStateTableAnnotationComposer,
      $$SyncStateTableCreateCompanionBuilder,
      $$SyncStateTableUpdateCompanionBuilder,
      (
        SyncStateData,
        BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateData>,
      ),
      SyncStateData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StoresTableTableManager get stores =>
      $$StoresTableTableManager(_db, _db.stores);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$DevicesTableTableManager get devices =>
      $$DevicesTableTableManager(_db, _db.devices);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$ProductUnitsTableTableManager get productUnits =>
      $$ProductUnitsTableTableManager(_db, _db.productUnits);
  $$PriceHistoryTableTableManager get priceHistory =>
      $$PriceHistoryTableTableManager(_db, _db.priceHistory);
  $$PurchasesTableTableManager get purchases =>
      $$PurchasesTableTableManager(_db, _db.purchases);
  $$PurchaseItemsTableTableManager get purchaseItems =>
      $$PurchaseItemsTableTableManager(_db, _db.purchaseItems);
  $$StockMovementsTableTableManager get stockMovements =>
      $$StockMovementsTableTableManager(_db, _db.stockMovements);
  $$PutawayLogTableTableManager get putawayLog =>
      $$PutawayLogTableTableManager(_db, _db.putawayLog);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$DebtLedgerTableTableManager get debtLedger =>
      $$DebtLedgerTableTableManager(_db, _db.debtLedger);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SaleItemsTableTableManager get saleItems =>
      $$SaleItemsTableTableManager(_db, _db.saleItems);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$ReturnsTableTableManager get returns =>
      $$ReturnsTableTableManager(_db, _db.returns);
  $$ReturnItemsTableTableManager get returnItems =>
      $$ReturnItemsTableTableManager(_db, _db.returnItems);
  $$StockOpnamesTableTableManager get stockOpnames =>
      $$StockOpnamesTableTableManager(_db, _db.stockOpnames);
  $$StockOpnameItemsTableTableManager get stockOpnameItems =>
      $$StockOpnameItemsTableTableManager(_db, _db.stockOpnameItems);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$OutboxTableTableManager get outbox =>
      $$OutboxTableTableManager(_db, _db.outbox);
  $$SyncStateTableTableManager get syncState =>
      $$SyncStateTableTableManager(_db, _db.syncState);
}
